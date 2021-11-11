// Delete a person node

// :param ssn => "id";

MATCH(n {ssn: $ssn}) 
DETACH DELETE n;