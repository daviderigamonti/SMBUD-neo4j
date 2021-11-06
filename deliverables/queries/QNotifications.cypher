// People that have been in contact with an infected "p"
// TODO: check dates
// TODO: check times
// TODO: went_in/went_to
// TODO: implement healing???
// TODO: HAS_MET device
// TODO: family loops
// TODO: multiple contacts<->same person

// :param name => "p";

MATCH   (p:Person {name:$name})
CALL {
        WITH p
        MATCH   (p)-[fam:FAMILY *1..]-(pf:Person)
        WHERE   pf <> p
        RETURN  pf AS contact, "Family" AS location, null AS time

        UNION

        WITH p
        MATCH   (p)-[met:HAS_MET]-(pc:Person)
        WITH    apoc.date.parse(toString(p.contagion_date), "ms", "yyyy-MM-dd") AS contagion_date,
                apoc.date.parse(toString(met.date), "ms", "yyyy-MM-dd") AS met_date,
                pc, met
        WITH    apoc.date.add(contagion_date, "ms", -14, "d") AS contagion_l,
                pc, met, contagion_date, met_date
        WHERE   met_date >= contagion_l AND met_date <= contagion_date
        RETURN  pc AS contact, met.device AS location, met.date AS time

        UNION

        WITH p
        MATCH   (p)-[go1:WENT_IN]->(loc:Location)<-[go2:WENT_IN]-(pl:Person)
        WITH    apoc.date.parse(toString(p.contagion_date), "ms", "yyyy-MM-dd") AS contagion_date,
                apoc.date.parse(toString(go1.date), "ms", "yyyy-MM-dd") AS go_date,
                pl, go1, go2, loc
        WITH    apoc.date.add(contagion_date, "ms", -14, "d") AS contagion_l,
                pl, go1, go2, loc
        WHERE   (go1.date = go2.date) AND
                (go_date >= contagion_l AND go_date <= contagion_date)
        RETURN  pl AS contact, loc.name AS location, go1.date AS time
}
RETURN contact, location, time


// Useful stuff 

// MATCH   (p:Person {name:$name})-[go1:WENT_IN]->(plc:Place)<-[go2:WENT_IN]-(pp:Person)
        // WITH    apoc.date.add(p.contagion.EpochMillis, "ms", -14, "d") AS contagion_l,
        //         apoc.date.add(p.contagion.EpochMillis, "ms", 14, "d") AS contagion_u,
        //         pp, go1, go2
        // WHERE   ((go2.start.EpochMillis >= go1.start.EpochMillis AND go2.start.EpochMillis <= go1.end.EpochMillis) OR
        //         (go2.end.EpochMillis >= go1.start.EpochMillis AND go2.end.EpochMillis <= go1.end.EpochMillis) OR
        //         (go2.start.EpochMillis <= go1.start.EpochMillis AND go2.end.EpochMillis >= go1.end.EpochMillis)) AND
        //         (go1.end.EpochMillis >= contagion_l AND go1.start.EpochMillis < contagion_u)     
        // RETURN  pp AS contacts;

// CALL {
//         WITH    apoc.date.convert(timestamp(), "ms", "d") AS now
//         MATCH   (p:Person)
//         WHERE   p.contagion_date IS NOT NULL AND
//                 NOT EXISTS((p)-[:IS_HOSPITALIZED_IN]->(:Location {type:"Hospital"}))
//         WITH    apoc.date.parse(toString(pc.birthdate), "d", "yyyy-MM-dd") AS birth,
//         RETURN  p

//         UNION

//         MATCH   (p:Person)
//         WHERE   EXISTS((p)-[:IS_HOSPITALIZED_IN]->(:Location {type:"Hospital"}))
//         RETURN p
// }
// WITH p
// ORDER BY p.name ASC
// WITH collect(p.name) AS propresult
// RETURN apoc.util.md5(propresult);
