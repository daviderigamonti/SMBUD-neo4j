// Number of healed people in a span of time

// :param date1 => datetime("x");
// :param date2 => datetime("y");

MATCH   (p:Person)
WHERE   p.contagion_date IS NOT NULL AND p.healing_date IS NOT NULL AND
        p.healing_date >= $date1 AND p.healing_date <= $date2
RETURN  count(p);
