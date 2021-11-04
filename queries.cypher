// QUERIES

// Return the cities in order of number of infected in a given span of time
    
    :param date1 => datetime("x");
    :param date2 => datetime("y");

    MATCH (cities:City)<-[LIVES_IN]-(person:Person) 
    WHERE person.contagion_date >= $date1 AND person.contagion_date <= $date2
    WITH cities, count(*) AS infected
    ORDER BY infected DESC
    RETURN cities.name, infected


// People infected in a span of time
// TODO: check dates, implement healing

:param date1 => date("x");
:param date2 => date("y");
MATCH   (p:Person)
WHERE   p.contagion_date >= $date1 AND
        p.contagion_date < $date2
RETURN  p;


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
    

// Healed people in a span of time
// TODO: check dates

:param date1 => date("x");
:param date2 => date("y");
MATCH   (p:Person)
WITH    apoc.date.parse(toString(p.contagion_date), "ms", "yyyy-MM-dd") AS contagion_date,
        apoc.date.parse(toString(p.healing_date), "ms", "yyyy-MM-dd") AS healing_date,
        p
WITH    apoc.date.add($date1.EpochMillis, "ms", -14, "d") AS date1_l,
        apoc.date.add(p.contagion.EpochMillis, "ms", 14, "d") AS contagion_u,
        p
WHERE   (healing_date >= $date1 AND healing_date < $date2) OR
        (contagion_date <= date1_l AND contagion_u <= $date2)
RETURN  p;


// Find the the number of hospitalized patiens during a given time

    :param date => datetime("x");

    MATCH (p:Person)-[r:HOSPITALIZED_IN]->(h:Hospital)
    WHERE $date >= r.date AND $date <= p.healing_date
    RETURN count(*)


// Number of vaccinated people that have been infected (after the vaccination)
    
    MATCH (p:Person)
    WHERE p.contagion_date >= p.vaccine_date
    RETURN count(*)
    

// Locations with the most infected in a span of time

    :param date1 => datetime("x");
    :param date2 => datetime("y");

    MATCH (places:Place)<-[r:WENT_IN]-(person:Person)
    WHERE $date1 <= r.date AND r.date <= $date2
    WITH places, count(*) AS infected
    ORDER BY infected DESC
    RETURN places.name, infected


// COMMANDS

// Registration of a COVID test
// TODO


// Registration of a contact via contact application

    :param name1 => "p1";
    :param name2 => "p2";
    :param date => datetime("d");
    :param place => "p";
    MATCH   (a:Person {name:$p1}), (b:Person {name:$p2})
    CREATE  (a)-[r:contact {date:$date, place:$place}]->(b);


// Registration of an access in a given location 

    :param name => "prs";
    :param place => "plc";
    :param type => "t";
    :param start => datetime("x");
    :param end => datetime("y");
    MATCH   (a:Person {name:$prs}),
            (b:Place {name:$place, type:$type})
    CREATE  (a)-[r:goes {start:$start, end:$end}]->(b);
