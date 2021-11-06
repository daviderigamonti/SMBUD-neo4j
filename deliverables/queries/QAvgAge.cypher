// Return the average age for infected and hospitalized people

WITH    apoc.date.convert(timestamp(), "ms", "d") AS now
MATCH   (pc:Person)
WHERE   pc.contagion_date IS NOT NULL AND
        NOT EXISTS((pc)-[:IS_HOSPITALIZED_IN]->(:Location {type:"Hospital"}))
WITH    apoc.date.parse(toString(pc.birthdate), "d", "yyyy-MM-dd") AS pc_birth,
        now
MATCH   (ph:Person)
WHERE   EXISTS((ph)-[:IS_HOSPITALIZED_IN]->(:Location {type:"Hospital"}))
WITH    apoc.date.parse(toString(ph.birthdate), "d", "yyyy-MM-dd") AS ph_birth,
        now, pc_birth

RETURN  avg((now-pc_birth)/365) AS infected, 
        avg((now-ph_birth)/365) AS hospitalized;
