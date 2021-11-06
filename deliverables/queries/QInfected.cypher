// People infected in a span of time
// TODO: check dates, implement healing

:param date1 => date("x");
:param date2 => date("y");
MATCH   (p:Person)
WHERE   p.contagion_date >= $date1 AND
        p.contagion_date < $date2
RETURN  p;
