// People that have been in contact with an infected "p"
// TODO: change propagation from infected->family->contacts and infected->contacts to
//	 infected->family and infected->contacts->families, check dates, implement healing 

:param name => "p";
MATCH   (p:Person {name:$name})-[fam:FAMILY *1..]-(pf:Person)
RETURN  pf AS contacts
UNION
MATCH   (p:Person {name:$name})-[met:HAS_MET]-(pc:Person)
WITH    apoc.date.parse(toString(p.contagion_date), "ms", "yyyy-MM-dd") AS contagion_date,
        apoc.date.parse(toString(met.date), "ms", "yyyy-MM-dd") AS met_date,
        pc
WITH    apoc.date.add(contagion_date, "ms", -14, "d") AS contagion_l,
        apoc.date.add(contagion_date, "ms", 14, "d") AS contagion_u,
        met_date, pc
WHERE   met_date >= contagion_l AND met_date < contagion_u
RETURN  pc AS contacts
UNION
// MATCH   (p:Person {name:$name})-[con:CONTACT]-(pc:Person)
// WITH    apoc.date.add(p.contagion_date.EpochMillis, "ms", -14, "d") AS contagion_l,
//         apoc.date.add(p.contagion_date.EpochMillis, "ms", 14, "d") AS contagion_u,
//         pc, con
// WHERE   con.date.EpochMillis >= contagion_l AND
//         con.date.EpochMillis < contagion_u
// RETURN  pc AS contacts
// UNION
MATCH   (p:Person {name:$name})-[go1:WENT_IN]->(plc:Location)<-[go2:WENT_IN]-(pp:Person)
WITH    apoc.date.parse(toString(p.contagion_date), "ms", "yyyy-MM-dd") AS contagion_date,
        apoc.date.parse(toString(go1.date), "ms", "yyyy-MM-dd") AS go_date,
        pp, go1, go2
WITH    apoc.date.add(contagion_date, "ms", -14, "d") AS contagion_l,
        apoc.date.add(contagion_date, "ms", 14, "d") AS contagion_u,
        pp, go1, go2
WHERE   (go1.date = go2.date) AND
        (go_date >= contagion_l AND go_date  < contagion_u)
RETURN  pp AS contacts;
// MATCH   (p:Person {name:$name})-[go1:WENT_IN]->(plc:Place)<-[go2:WENT_IN]-(pp:Person)
// WITH    apoc.date.add(p.contagion.EpochMillis, "ms", -14, "d") AS contagion_l,
//         apoc.date.add(p.contagion.EpochMillis, "ms", 14, "d") AS contagion_u,
//         pp, go1, go2
// WHERE   ((go2.start.EpochMillis >= go1.start.EpochMillis AND go2.start.EpochMillis <= go1.end.EpochMillis) OR
//         (go2.end.EpochMillis >= go1.start.EpochMillis AND go2.end.EpochMillis <= go1.end.EpochMillis) OR
//         (go2.start.EpochMillis <= go1.start.EpochMillis AND go2.end.EpochMillis >= go1.end.EpochMillis)) AND
//         (go1.end.EpochMillis >= contagion_l AND go1.start.EpochMillis < contagion_u)     
// RETURN  pp AS contacts;
