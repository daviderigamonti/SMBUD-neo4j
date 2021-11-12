// Find the the number of hospitalized patients for each hospital during a given time 

// :param date1 => date("x");
// :param date2 => date("y");

MATCH (p:Person)-[r:IS_HOSPITALIZED_IN]->(h:Location)
WITH collect(p) as patients, h, r
WHERE r.date >= $date1 and r.date <= $date2
RETURN h.name, count(patients)
ORDER BY count(patients) DESC;
