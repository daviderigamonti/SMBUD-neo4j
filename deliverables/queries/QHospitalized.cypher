// Find the the number of hospitalized patients during a given time

// :param date1 => date("x");
// :param date2 => date("y");

MATCH (p:Person)-[r:IS_HOSPITALIZED_IN]->(h:Location)
WHERE r.date >= $date1 and r.date <= $date2
RETURN count(*);
