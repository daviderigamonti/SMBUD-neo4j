package com.example.smbudapp.db;

import java.util.HashMap;
import java.util.Map;

public class CommandDictionary {

	private static String creationAccess = "MATCH   (a:Person {ssn:$ssn}),\r\n" + 
			"        (b:Location {name:$location})\r\n" + 
			"CREATE  (a)-[r:WENT_TO {date:datetime($date)}]->(b);";
	private static String creationContact = "MATCH   (a:Person {ssn:$ssn1}), (b:Person {ssn1:$ssn2})\r\n" + 
			"CREATE  (a)-[r:HAS_MET {date:datetime($date), device:$device}]->(b), \r\n" + 
			"        (b)-[r:HAS_MET {date:datetime($date), device:$device}]->(a);";
	private static String deleteAllRelations = "MATCH (n {name: $name})-[r:$relation]->()\r\n" + 
			"DELETE r;";
	private static String deleteCity = "MATCH(n:City {name: $name}) \r\n" + 
			"DETACH DELETE n;";
	private static String deleteSingleRelation = "MATCH (n1 {name: $name1})-[r:$relation]->(n2 {name: $name2})\r\n" + 
			"DELETE r;";
	private static String deleteLocation = "MATCH(n:Location {name: $name}) \r\n" + 
			"DETACH DELETE n;";
	private static String deletePerson = "MATCH(n {ssn: $ssn}) \r\n" + 
			"DETACH DELETE n;";
	private static String registrationNegativeTest = "MATCH (p {ssn: $ssn})\r\n" + 
			"WITH p,\r\n" + 
			"    CASE \r\n" + 
			"        WHEN p.healing_date IS NULL AND p.contagion_date IS NOT NULL THEN date($test_date)\r\n" + 
			"        ELSE p.healing_date\r\n" + 
			"    END \r\n" + 
			"    AS healing\r\n" + 
			"\r\n" + 
			"SET p.negative_test_date = date($test_date), p.healing_date = healing;";
	private static String registrationPositiveTest = "MATCH (p {ssn: $ssn})\r\n" + 
			"WITH p,\r\n" + 
			"    CASE \r\n" + 
			"        WHEN p.contagion_date IS NOT NULL THEN p.contagion_date\r\n" + 
			"        ELSE date($test_date)\r\n" + 
			"    END \r\n" + 
			"    AS infection\r\n" + 
			"SET p.contagion_date = infection;";
	
	
	public static  Map<String, String> CommandList() {

		Map<String, String> Commands = new HashMap<String, String>();
		Commands.put("creationAccess", creationAccess);
		Commands.put("creationContact", creationContact);
		Commands.put("deleteAllRelations", deleteAllRelations);
		Commands.put("deleteCity", deleteCity);
		Commands.put("deleteSingleRelation", deleteSingleRelation);
		Commands.put("deleteLocation", deleteLocation);
		Commands.put("deletePerson", deletePerson);
		Commands.put("registrationNegativeTest", registrationNegativeTest);
		Commands.put("registrationPositiveTest", registrationPositiveTest);

		return Commands;
	}
	
}
