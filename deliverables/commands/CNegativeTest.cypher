// Registration of a negative COVID test

:param name => "p";
:param test_date => datetime("x");

MATCH (p {name: $name})
WITH p,
    CASE 
        WHEN p.healing_date IS NULL AND p.contagion_date IS NOT NULL THEN $test_date
        ELSE p.healing_date
    END 
    AS healing

SET p.negative_test_date = $test_date, p.healing_date = healing
