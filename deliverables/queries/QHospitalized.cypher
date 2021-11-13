// Find the the number of hospitalized patients during a given time

// :param date1 => "date1";
// :param date2 => "date2";

MATCH (p:Person)-[r:IS_HOSPITALIZED_IN]->(h:Location)
WHERE r.date >= date($date1) and r.date <= date($date2)
RETURN count(*);
