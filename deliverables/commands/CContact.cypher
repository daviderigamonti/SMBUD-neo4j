// Registration of a contact via contact application

// :param ssn1 => "s1";
// :param ssn2 => "s2";
// :param date => "date";
// :param device => "d";

MATCH   (a:Person {ssn:$ssn1}), (b:Person {ssn:$ssn2})
CREATE  (a)-[r:HAS_MET {date:datetime($date), device:$device}]->(b), 
        (b)-[r:HAS_MET {date:datetime($date), device:$device}]->(a);
        
