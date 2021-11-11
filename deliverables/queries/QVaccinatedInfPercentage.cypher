// Returns the percentage of vaccinated infected compared to the total number of infected (considering also the non-vaccinated)

MATCH (p:Person)
WHERE p.contagion_date >= p.vaccine_date
WITH count(*) AS vaccinated
MATCH (p1: Person)
WHERE p1.contagion_date IS NOT NULL
RETURN (toFloat(vaccinated)/count(*))*100;