// Return the cities in order of number of infected in a given span of time
    
// :param date1 => "date1";
// :param date2 => "date2";

MATCH (cities:City)<-[:LIVES_IN]-(person:Person) 
WHERE person.contagion_date >= date($date1) AND person.contagion_date <= date($date2)
WITH cities, count(*) AS infected
ORDER BY infected DESC
RETURN cities.name, infected;
