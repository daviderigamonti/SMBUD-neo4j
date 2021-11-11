// Number of vaccinated people that have been infected (after the vaccination)
    
MATCH (p:Person)
WHERE p.contagion_date >= p.vaccine_date
RETURN count(*);
