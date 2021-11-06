// Healed people in a span of time
// TODO: check dates

:param date1 => date("x");
:param date2 => date("y");
MATCH   (p:Person)
WITH    apoc.date.parse(toString(p.contagion_date), "ms", "yyyy-MM-dd") AS contagion_date,
        apoc.date.parse(toString(p.healing_date), "ms", "yyyy-MM-dd") AS healing_date,
        p
WITH    apoc.date.add($date1.EpochMillis, "ms", -14, "d") AS date1_l,
        apoc.date.add(p.contagion.EpochMillis, "ms", 14, "d") AS contagion_u,
        p
WHERE   (healing_date >= $date1 AND healing_date < $date2) OR
        (contagion_date <= date1_l AND contagion_u <= $date2)
RETURN  p;
