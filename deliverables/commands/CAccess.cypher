// Registration of an access in a given location 

:param name => "prs";
:param location => "loc";
:param type => "t";
:param date => date("d");
// :param start => datetime("x");
// :param end => datetime("y");
MATCH   (a:Person {name:$name}),
        (b:Location {name:$location, type:$type})
CREATE  (a)-[r:WENT_IN {date:$date}]->(b);        
// CREATE  (a)-[r:goes {start:$start, end:$end}]->(b);
