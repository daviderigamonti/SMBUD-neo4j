// Delete a City

// :param name => "n";

MATCH(n:City {name: $name}) 
DETACH DELETE n;