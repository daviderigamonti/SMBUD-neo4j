// Locations with the most infected in a span of time

:param date1 => datetime("x");
:param date2 => datetime("y");

MATCH (places:Location)<-[r:WENT_IN]-(person:Person)
WHERE $date1 <= r.date AND r.date <= $date2
WITH places, count(*) AS infected
ORDER BY infected DESC
RETURN places.name, infected
