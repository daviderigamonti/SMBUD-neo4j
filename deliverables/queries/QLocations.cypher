// Locations with the most infected in a span of time

// :param date1 => string("yyyy-mm-dd");
// :param date2 => string("yyyy-mm-dd");

MATCH (places:Location)<-[r:WENT_TO]-(person:Person)
WHERE datetime($date1) <= r.date AND r.date <= datetime($date2) 
AND person.contagion_date is not null
AND person.contagion_date >= date($date1) and person.contagion_date <= date($date2)
WITH places, count(*) AS infected
ORDER BY infected DESC
RETURN places.name, infected;