// PEOPLE:
LOAD CSV WITH HEADERS FROM "file:///people.csv" AS row CREATE (:Person {name:row.first_name+ ' '+row.last_name,email:row.email,ssn:row.ssn,birthdate:date(row.birthdate),vaccine_date:date(row.vaccine_date),contagion_date:date(row.contagion_date),negative_test_date:date(row.negative_test_date),healing_date:date(row.healing_date)});

// LOCATION:
LOAD CSV WITH HEADERS FROM "file:///locations.csv" AS row CREATE (:Location {name:row.Name, type:row.Type});

// CITY
LOAD CSV WITH HEADERS FROM "file:///cities.csv" AS row CREATE (:City {name:row.name});

// ASSEGNA A OGNI PERSONA UNA CITTà
call apoc.periodic.iterate("
WITH range(1,1) as contactsRange
MATCH (h:City)
WITH collect(h) as contacts, contactsRange
MATCH (p:Person)
WITH p, apoc.coll.randomItems(contacts, apoc.coll.randomItem(contactsRange)) as contacts
// create relationships
    RETURN p,contacts", 
"FOREACH (contact in contacts|  CREATE (p)-[:LIVES_IN]->(contact) )", 
{batchSize: 1000, parallel: false});

// FAMILY CREATION 
MATCH (p:Person),(c:City) where (p)-[:LIVES_IN]->(c)
WITH collect(p) as people,c
MATCH (p1:Person) where (p1)-[:LIVES_IN]->(c)
WITH  p1,apoc.coll.randomItems(people, 3) as people
where not p1 in people
FOREACH (person in people | CREATE (p1)-[:FAMILY]->(person) CREATE (person)-[:FAMILY]->(p1) );

// QUERIES PER TROVARE DOPPIE RELAZIONI ED ELIMINARLE
//match  (p)-[r:FAMILY]->(p1),(p)-[s:FAMILY]->(p1) where r<>s return p
match  (p)-[r:FAMILY]->(p1),(p)-[s:FAMILY]->(p1) where r<>s delete r;

// DELETE SELF-RELATION HAS_MET
Match (p:Person)-[r:HAS_MET]->(p) delete r;

// PEOPLE WHO MET BETWEEN 28/10/2021 AND 10/11/2021 (data coming from the application)
call apoc.periodic.iterate("
MATCH (h:Person)
WITH collect(h) as contacts
MATCH (p:Person)
WITH p, apoc.coll.randomItems(contacts, toInteger(rand()*3.5)) as contacts,toInteger(1635458800+rand()*1066000) as sec,  toInteger(rand()*3) as device,['smartphone','wearable','other']as devices
RETURN p,contacts,sec,device,devices", 
"FOREACH (contact in contacts|  CREATE (p)-[:HAS_MET {date:datetime({epochSeconds:sec}), device:devices[device]}]->(contact) CREATE (contact)-[:HAS_MET {date:datetime({epochSeconds:sec}), device:devices[device]}]->(p))", 
{batchSize: 1000, parallel: false});


//Relazione Ristoranti --> Città:

call apoc.periodic.iterate("
MATCH (c:City) where NOT ()-[:IS_IN]->(:c)
WITH collect(c) as cities
MATCH (l:Location {type: 'Restaurant'})
WITH l, apoc.coll.randomItems(cities, 1) as cities
// create relationships
    RETURN l,cities", 
"FOREACH (city in cities|  CREATE (l)-[:IS_IN]->(city))", 
{batchSize: 1000, parallel: false});

//Relazione Ospedali --> Città:

call apoc.periodic.iterate("
MATCH (c:City) where NOT ()-[:IS_IN]->(:c)
WITH collect(c) as cities
MATCH (l:Location {type: 'Hospital'})
WITH l, apoc.coll.randomItems(cities, 1) as cities
// create relationships
    RETURN l,cities", 
"FOREACH (city in cities|  CREATE (l)-[:IS_IN]->(city))", 
{batchSize: 1000, parallel: false});

//Relazione Teatri --> Città:

call apoc.periodic.iterate("
MATCH (c:City) where NOT ()-[:IS_IN]->(:c)
WITH collect(c) as cities
MATCH (l:Location {type: 'Theater'})
WITH l, apoc.coll.randomItems(cities, 1) as cities
// create relationships
    RETURN l,cities", 
"FOREACH (city in cities|  CREATE (l)-[:IS_IN]->(city))", 
{batchSize: 1000, parallel: false});

//Relazione Persone --> Edifici:

WITH range(6,10) as peopleRange
MATCH (p:Person) where p.contagion_date >= date({year: 2021, month:10, day:17})
WITH collect(p) as people, peopleRange
MATCH (l:Location)
WITH l, people, peopleRange
WITH l, apoc.coll.randomItems(people, apoc.coll.randomItem(peopleRange)) as people
// create relationships
FOREACH (person IN people | CREATE (person)-[:WENT_TO {date: datetime({epochSeconds:toInteger(1631923200+rand()*2591940)})}]->(l));

//Relazione Persone guarite --> Edifici:

WITH range(6,10) as peopleRange
MATCH (p:Person) where p.contagion_date < date({year: 2021, month:10, day:17})
WITH collect(p) as people, peopleRange
MATCH (l:Location) 
WITH l, people, peopleRange
WITH l, apoc.coll.randomItems(people, apoc.coll.randomItem(peopleRange)) as people
// create relationships
FOREACH (person IN people | CREATE (person)-[:WENT_TO {date: datetime({epochSeconds:toInteger(1631923200+rand()*5270340)})}]->(l));

//RECOVERY RELATIONS

call apoc.periodic.iterate("
MATCH (h:Location {type: 'Hospital'}) where NOT ()-[:IS_HOSPITALIZED_IN]->(:h)
WITH collect(h) as hospitals
MATCH (p:Person)
WHERE p.contagion_date IS NOT NULL AND p.healing_date IS NULL and rand()<0.7
WITH p, apoc.coll.randomItems(hospitals, 1) as hospitals
// create relationships
    RETURN p,hospitals", 
"FOREACH (hospital in hospitals|  CREATE (p)-[:IS_HOSPITALIZED_IN{recovery_date:p.contagion_date}]->(hospital))", 
{batchSize: 1000, parallel: false});
