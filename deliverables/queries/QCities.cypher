// Return the cities in order of number of infected in a given span of time
    
// :param date1 => date("x");
// :param date2 => date("y");

MATCH (cities:City)<-[:LIVES_IN]-(person:Person) 
WHERE person.contagion_date >= $date1 AND person.contagion_date <= $date2
WITH cities, count(*) AS infected
ORDER BY infected DESC
RETURN cities.name, infected;
