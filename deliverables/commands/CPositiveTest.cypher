// Registration of a positive COVID test

:param name => "p";
:param test_date => datetime("x");

MATCH (p {name: $name})
WITH p,
    CASE 
        WHEN p.contagion_date IS NOT NULL THEN p.contagion_date
        ELSE $test_date
    END 
    AS infection
SET p.contagion_date = infection
