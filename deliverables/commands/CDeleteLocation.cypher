// Delete a location

:param name => "n";

MATCH(n:Location {name: $name}) 
DETACH DELETE n