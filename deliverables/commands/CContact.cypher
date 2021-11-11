// Registration of a contact via contact application

// :param ssn1 => "s1";
// :param ssn2 => "s2";
// :param date => datetime("d");
// :param device => "d";

MATCH   (a:Person {ssn:$ssn1}), (b:Person {ssn1:$ssn2})
CREATE  (a)-[r:HAS_MET {date:$date, device:$device}]->(b), 
        (b)-[r:HAS_MET {date:$date, device:$device}]->(a);
        