// Contacts between an infect and a non-infect for every type of device

MATCH   (p1:Person)-[met:HAS_MET]->(p2:Person)
WITH    apoc.date.parse(toString(p1.contagion_date), "ms", "yyyy-MM-dd") AS p1_contagion_date,
        apoc.date.parse(toString(p1.healing_date), "ms", "yyyy-MM-dd") AS p1_healing_date,
        apoc.date.parse(toString(p2.contagion_date), "ms", "yyyy-MM-dd") AS p2_contagion_date,
        met
WHERE   p1_contagion_date IS NOT NULL AND
        (p2_contagion_date IS NULL OR p2_contagion_date > p1_contagion_date)
WITH    apoc.date.add(p1_contagion_date, "ms", -14, "d") AS contagion_l,
        met, p1_healing_date
WHERE   met.date.EpochMillis >= contagion_l AND
        (p1_healing_date IS NULL OR met.date.EpochMillis < p1_healing_date)
RETURN  met.device, count(DISTINCT met) AS infected_contacts
