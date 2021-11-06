// Registration of a contact via contact application

:param name1 => "p1";
:param name2 => "p2";
:param date => date("d");
MATCH   (a:Person {name:$name1}), (b:Person {name:$name2})
CREATE  (a)-[r:HAS_MET {date:$date}]->(b), 
        (b)-[r:HAS_MET {date:$date}]->(a);
