// Number of healed people in a span of time

// :param date1 => date("x");
// :param date2 => date("y");

MATCH   (p:Person)
WHERE   p.contagion_date IS NOT NULL AND p.healing_date IS NOT NULL AND
        healing_date >= $date1 AND healing_date <= $date2
RETURN  count(p);
