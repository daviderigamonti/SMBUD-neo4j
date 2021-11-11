// Delete single a relation between two nodes

// :param name1 => "x";
// :param name2 => "y";
// :param relation => "rel";

MATCH (n1 {name: $name1})-[r:$relation]->(n2 {name: $name2})
DELETE r;