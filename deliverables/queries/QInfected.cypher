// Number of people infected in a span of time

// :param date1 => date("x");
// :param date2 => date("y");

MATCH   (p:Person)
WHERE   p.contagion_date IS NOT NULL AND
        p.contagion_date >= $date1 AND p.contagion_date <= $date2
RETURN  count(p);
