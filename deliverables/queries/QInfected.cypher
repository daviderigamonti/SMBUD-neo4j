// Number of people infected in a span of time

// :param date1 => "date1";
// :param date2 => "date2";

MATCH   (p:Person)
WHERE   p.contagion_date IS NOT NULL AND
        p.contagion_date >= date($date1) AND p.contagion_date <= date($date2)
RETURN  count(p) AS n_infected;
