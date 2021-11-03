// QUERIES

// Locations with the most infected in a span of time 
// TODO


// People infected in a span of time
// TODO: check dates, implement healing

    :param date1 => datetime("x");
    :param date2 => datetime("y");
    MATCH   (p:Person)
    WHERE   p.contagion >= $date1 AND
            p.contagion < $date2
    RETURN  p;


// People that have been in contact with an infected "p"
// TODO: change propagation from infected->family->contacts and infected->contacts to
//	 infected->family and infected->contacts->families, check dates, implement healing 

    :param name => "p";
    MATCH   (p:Person {name:$name})-[fam:family *1..]-(pf:Person)
    RETURN  pf AS contacts
    UNION
    MATCH   (p:Person {name:$name})-[con:contact]-(pc:Person)
    WITH    apoc.date.add(p.contagion.EpochMillis, "ms", -14, "d") AS contagion_l,
            apoc.date.add(p.contagion.EpochMillis, "ms", 14, "d") AS contagion_u,
            pc, con
    WHERE   con.date.EpochMillis >= contagion_l AND
            con.date.EpochMillis < contagion_u
    RETURN  pc AS contacts
    UNION
    MATCH   (p:Person {name:$name})-[go1:goes]->(plc:Place)<-[go2:goes]-(pp:Person)
    WITH    apoc.date.add(p.contagion.EpochMillis, "ms", -14, "d") AS contagion_l,
            apoc.date.add(p.contagion.EpochMillis, "ms", 14, "d") AS contagion_u,
            pp, go1, go2
    WHERE   ((go2.start.EpochMillis >= go1.start.EpochMillis AND go2.start.EpochMillis <= go1.end.EpochMillis) OR
            (go2.end.EpochMillis >= go1.start.EpochMillis AND go2.end.EpochMillis <= go1.end.EpochMillis) OR
            (go2.start.EpochMillis <= go1.start.EpochMillis AND go2.end.EpochMillis >= go1.end.EpochMillis)) AND
            (go1.end.EpochMillis >= contagion_l AND go1.start.EpochMillis < contagion_u)     
    RETURN  pp AS contacts;
    

// Healed people in a span of time
// TODO: check dates

    :param date1 => datetime("x");
    :param date2 => datetime("y");
    MATCH   (p:Person)
    WITH    apoc.date.add($date1.EpochMillis, "ms", -14, "d") AS date1_l,
            apoc.date.add(p.contagion.EpochMillis, "ms", 14, "d") AS contagion_u,
            p
    WHERE   (p.healing >= $date1 AND p.healing < $date2) OR
            (p.contagion <= date1_l AND contagion_u <= $date2)
    RETURN  p;


// Number of COVID hospitalized people in a span of time
// TODO


// Cities with the most infected inhabitants in a span of time
// TODO


// Number of vaccinated people that have been infected (after the vaccination)
// TODO



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
