// Delete all relations of a given type froma person

:param ssn => "id";
:param relation => "rel"

MATCH (n {name: $name})-[r:$relation]->()
DELETE r