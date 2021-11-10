// Registration of an access in a given location 
// TODO: check dates
// TODO: check times

// :param name => "prs";
// :param location => "loc";
// :param type => "t";
// :param date => datetime("d");

MATCH   (a:Person {name:$name}),
        (b:Location {name:$location, type:$type})
CREATE  (a)-[r:WENT_IN {date:$date}]->(b);        
