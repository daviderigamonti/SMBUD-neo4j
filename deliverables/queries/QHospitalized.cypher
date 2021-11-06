// Find the the number of hospitalized patiens during a given time

:param date => datetime("x");

MATCH (p:Person)-[r:HOSPITALIZED_IN]->(h:Hospital)
WHERE $date >= r.date AND $date <= p.healing_date
RETURN count(*)
