// Find the the number of hospitalized patients for each hospital during a given time 

// :param date1 => "date1";
// :param date2 => "date2";

MATCH (p:Person)-[r:IS_HOSPITALIZED_IN]->(h:Location)
WITH collect(p) as patients, h, r
WHERE r.date >= date($date1) and r.date <= date($date2)
RETURN h.name as hospital, count(patients) as patients
ORDER BY count(patients) DESC;
