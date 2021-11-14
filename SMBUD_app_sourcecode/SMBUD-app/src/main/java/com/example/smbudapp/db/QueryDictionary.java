package com.example.smbudapp.db;

import java.util.HashMap;
import java.util.Map;

public class QueryDictionary {


	private static String queryAvgInfected = "WITH    apoc.date.convert(timestamp(), \"ms\", \"d\") AS now\r\n" + 
			"MATCH   (pc:Person)\r\n" + 
			"WHERE   pc.contagion_date IS NOT NULL AND\r\n" + 
			"        NOT EXISTS((pc)-[:IS_HOSPITALIZED_IN]->(:Location {type:\"Hospital\"}))\r\n" + 
			"WITH    apoc.date.parse(toString(pc.birthdate), \"d\", \"yyyy-MM-dd\") AS pc_birth,\r\n" + 
			"        now\r\n" + 
			"MATCH   (ph:Person)\r\n" + 
			"WHERE   EXISTS((ph)-[:IS_HOSPITALIZED_IN]->(:Location {type:\"Hospital\"}))\r\n" + 
			"WITH    apoc.date.parse(toString(ph.birthdate), \"d\", \"yyyy-MM-dd\") AS ph_birth,\r\n" + 
			"        now, pc_birth\r\n" + 
			"\r\n" + 
			"RETURN  avg((now-pc_birth)/365) AS avg_age_nothospitalized, \r\n" + 
			"        avg((now-ph_birth)/365) AS avg_age_hospitalized";
	private static String queryInfectedCities = "MATCH (cities:City)<-[:LIVES_IN]-(person:Person) WHERE person.contagion_date >= date($date1) AND person.contagion_date <= date($date2) WITH cities, count(*) AS infected ORDER BY infected DESC RETURN cities.name, infected";
	private static String queryDevice = "MATCH   (p1:Person)-[met:HAS_MET]->(p2:Person)\r\n" + 
			"WITH    apoc.date.parse(toString(p1.contagion_date), \"ms\", \"yyyy-MM-dd\") AS p1_contagion_date,\r\n" + 
			"        apoc.date.parse(toString(p1.healing_date), \"ms\", \"yyyy-MM-dd\") AS p1_healing_date,\r\n" + 
			"        apoc.date.parse(toString(p2.contagion_date), \"ms\", \"yyyy-MM-dd\") AS p2_contagion_date,\r\n" + 
			"        met\r\n" + 
			"WHERE   p1_contagion_date IS NOT NULL AND\r\n" + 
			"        (p2_contagion_date IS NULL OR p2_contagion_date > p1_contagion_date)\r\n" + 
			"WITH    apoc.date.add(p1_contagion_date, \"ms\", -14, \"d\") AS contagion_l,\r\n" + 
			"        met, p1_healing_date\r\n" + 
			"WHERE   met.date.EpochMillis >= contagion_l AND\r\n" + 
			"        (p1_healing_date IS NULL OR met.date.EpochMillis < p1_healing_date)\r\n" + 
			"RETURN  met.device, count(DISTINCT met) AS infected_contacts";
	private static String queryHealed = "MATCH   (p:Person)\r\n" + 
			"WHERE   p.contagion_date IS NOT NULL AND p.healing_date IS NOT NULL AND\r\n" + 
			"        p.healing_date >= date($date1) AND p.healing_date <= date($date2)\r\n" +
			"RETURN  count(p);";
	private static String queryHospitalized = "MATCH (p:Person)-[r:IS_HOSPITALIZED_IN]->(h:Location)\r\n" + 
			"WITH collect(p) as patients, h, r\r\n" + 
			"WHERE r.recovery_date >= date($date1) and r.recovery_date <= date($date2)\r\n" +
			"RETURN h.name, count(patients)\r\n" + 
			"ORDER BY count(patients) DESC;";
	private static String queryHospitalizedV2 = "MATCH (p:Person)-[r:IS_HOSPITALIZED_IN]->(h:Location)\r\n" +
			"WHERE r.recovery_date >= date($date1) and r.recovery_date <= date($date2)\r\n" +
			"RETURN count(*);";
	private static String queryNumInfected = "MATCH   (p:Person)\r\n" + 
			"WHERE   p.contagion_date IS NOT NULL AND\r\n" + 
			"        p.contagion_date >= date($date1) AND p.contagion_date <= date($date2)\r\n" + 
			"RETURN  count(p)";
	private static String queryLocation = "MATCH (places:Location)<-[r:WENT_TO]-(person:Person)\r\n" + 
			"WHERE datetime($date1) <= r.date AND r.date <= datetime($date2)\r\n" + 
			"WITH places, count(*) AS infected\r\n" + 
			"ORDER BY infected DESC\r\n" + 
			"RETURN places.name, infected";
	private static String queryNotifications = "MATCH   (p:Person {ssn:$ssn})\r\n" + 
			"WHERE   p.contagion_date IS NOT NULL\r\n" + 
			"CALL {\r\n" + 
			"        WITH    p\r\n" + 
			"        CALL    apoc.path.expandConfig(p, {\r\n" + 
			"                        relationshipFilter: \"FAMILY>\",\r\n" + 
			"                        minLevel: 1,\r\n" + 
			"                        maxLevel: -1,\r\n" + 
			"                        labelFilter: \"+Person\",\r\n" + 
			"                        uniqueness:\"NODE_GLOBAL\",\r\n" + 
			"                        bfs:true\r\n" + 
			"        }) YIELD path AS path\r\n" + 
			"        UNWIND tail(nodes(path)) AS x\r\n" + 
			"        WITH DISTINCT x AS contact\r\n" + 
			"        RETURN  contact, \"family\" AS tracing, null AS time\r\n" + 
			"\r\n" + 
			"        UNION\r\n" + 
			"\r\n" + 
			"        WITH    p\r\n" + 
			"        MATCH   (p)-[met:HAS_MET]->(pc:Person)\r\n" + 
			"        WITH    apoc.date.parse(toString(p.contagion_date), \"ms\", \"yyyy-MM-dd\") AS contagion_date,\r\n" + 
			"                apoc.date.parse(toString(p.healing_date), \"ms\", \"yyyy-MM-dd\") AS healing_date,\r\n" + 
			"                pc, met\r\n" + 
			"        WITH    apoc.date.add(contagion_date, \"ms\", -14, \"d\") AS contagion_l,\r\n" + 
			"                pc, met, healing_date\r\n" + 
			"        WHERE   (met.date.EpochMillis >= contagion_l) AND \r\n" + 
			"                (met.date.EpochMillis < healing_date OR healing_date IS NULL)\r\n" + 
			"        RETURN  pc AS contact, met.device AS tracing, met.date AS time\r\n" + 
			"\r\n" + 
			"        UNION\r\n" + 
			"\r\n" + 
			"        WITH    p\r\n" + 
			"        MATCH   (p)-[go1:WENT_TO]->(loc:Location)<-[go2:WENT_TO]-(pl:Person)\r\n" + 
			"        WITH    apoc.date.parse(toString(p.contagion_date), \"ms\", \"yyyy-MM-dd\") AS contagion_date,\r\n" + 
			"                apoc.date.parse(toString(p.healing_date), \"ms\", \"yyyy-MM-dd\") AS healing_date,\r\n" + 
			"                pl, go1, go2, loc\r\n" + 
			"        WITH    apoc.date.add(contagion_date, \"ms\", -14, \"d\") AS contagion_l,\r\n" + 
			"                apoc.date.add(go1.date.EpochMillis, \"ms\", -2, \"h\") AS go1_l,\r\n" + 
			"                apoc.date.add(go1.date.EpochMillis, \"ms\", 2, \"h\") AS go1_u,\r\n" + 
			"                pl, go1, go2, loc, healing_date\r\n" + 
			"        WHERE   (go2.date.EpochMillis >= go1_l AND go2.date.EpochMillis <= go1_u) AND\r\n" + 
			"                (go1.date.EpochMillis >= contagion_l) AND \r\n" + 
			"                (go1.date.EpochMillis < healing_date OR healing_date IS NULL)\r\n" + 
			"        RETURN  pl AS contact, loc.name AS tracing, go1.date AS time\r\n" + 
			"}\r\n" + 
			"RETURN DISTINCT contact, collect({tracing:tracing, time:time}) AS info";
	private static String queryVaccinatedInf = "MATCH (p:Person)\r\n" + 
			"WHERE p.contagion_date >= p.vaccine_date\r\n" + 
			"RETURN count(*)";
	private static String queryVaccinated = "MATCH(p:Person) WHERE p.vaccine_date IS NOT NULL RETURN COUNT(*)";
	private static String queryVaccinatedInfPercentage = "MATCH (p:Person)\r\n" + 
			"WHERE p.contagion_date >= p.vaccine_date\r\n" + 
			"WITH count(*) AS vaccinated\r\n" + 
			"MATCH (p1: Person)\r\n" + 
			"WHERE p1.contagion_date IS NOT NULL\r\n" + 
			"RETURN (toFloat(vaccinated)/count(*))*100";

	public static  Map<String, String> QueryList() {

		Map<String, String> Queries = new HashMap<String, String>();
		Queries.put("queryAvgInfected", queryAvgInfected);
		Queries.put("queryDevice", queryDevice);
		Queries.put("queryInfectedCities", queryInfectedCities);
		Queries.put("queryHealed", queryHealed);
		Queries.put("queryHospitalized", queryHospitalized);
		Queries.put("queryHospitalizedV2", queryHospitalizedV2);
		Queries.put("queryNumInfected", queryNumInfected);
		Queries.put("queryLocation", queryLocation);
		Queries.put("queryNotifications", queryNotifications);
		Queries.put("queryVaccinated", queryVaccinated);
		Queries.put("queryVaccinatedInf", queryVaccinatedInf);
		Queries.put("queryVaccinatedInfPercentage", queryVaccinatedInfPercentage);

		return Queries;
	}


}
