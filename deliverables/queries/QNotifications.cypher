// People that have been in contact with an infected "p"

// :param ssn => "x";

MATCH   (p:Person {ssn:$ssn})
WHERE   p.contagion_date IS NOT NULL
CALL {
        WITH    p
        CALL    apoc.path.expandConfig(p, {
                        relationshipFilter: "FAMILY>",
                        minLevel: 1,
                        maxLevel: -1,
                        labelFilter: "+Person",
                        uniqueness:"NODE_GLOBAL",
                        bfs:true
        }) YIELD path AS path
        UNWIND tail(nodes(path)) AS x
        WITH DISTINCT x AS contact
        RETURN  contact, "family" AS tracing, null AS time

        UNION

        WITH    p
        MATCH   (p)-[met:HAS_MET]->(pc:Person)
        WITH    apoc.date.parse(toString(p.contagion_date), "ms", "yyyy-MM-dd") AS contagion_date,
                apoc.date.parse(toString(p.healing_date), "ms", "yyyy-MM-dd") AS healing_date,
                pc, met
        WITH    apoc.date.add(contagion_date, "ms", -14, "d") AS contagion_l,
                pc, met, healing_date
        WHERE   (met.date.EpochMillis >= contagion_l) AND 
                (met.date.EpochMillis < healing_date OR healing_date IS NULL)
        RETURN  pc AS contact, met.device AS tracing, met.date AS time

        UNION

        WITH    p
        MATCH   (p)-[go1:WENT_TO]->(loc:Location)<-[go2:WENT_TO]-(pl:Person)
        WITH    apoc.date.parse(toString(p.contagion_date), "ms", "yyyy-MM-dd") AS contagion_date,
                apoc.date.parse(toString(p.healing_date), "ms", "yyyy-MM-dd") AS healing_date,
                pl, go1, go2, loc
        WITH    apoc.date.add(contagion_date, "ms", -14, "d") AS contagion_l,
                apoc.date.add(go1.date.EpochMillis, "ms", -2, "h") AS go1_l,
                apoc.date.add(go1.date.EpochMillis, "ms", 2, "h") AS go1_u,
                pl, go1, go2, loc, healing_date
        WHERE   (go2.date.EpochMillis >= go1_l AND go2.date.EpochMillis <= go1_u) AND
                (go1.date.EpochMillis >= contagion_l) AND 
                (go1.date.EpochMillis < healing_date OR healing_date IS NULL)
        RETURN  pl AS contact, loc.name AS tracing, go1.date AS time
}
RETURN DISTINCT contact, collect({tracing:tracing, time:time}) AS info
