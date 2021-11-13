// Registration of a positive COVID test

// :param ssn => "id";
// :param test_date => "date";

MATCH (p {ssn: $ssn})
WITH p,
    CASE 
        WHEN p.contagion_date IS NOT NULL THEN p.contagion_date
        ELSE date($test_date)
    END 
    AS infection
SET p.contagion_date = infection;
