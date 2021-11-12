// Registration of an access in a given location 

// :param ssn => "s";
// :param location => "loc";
// :param date => datetime("d");

MATCH   (a:Person {ssn:$ssn}),
        (b:Location {name:$location})
CREATE  (a)-[r:WENT_TO {date:$date}]->(b);        
