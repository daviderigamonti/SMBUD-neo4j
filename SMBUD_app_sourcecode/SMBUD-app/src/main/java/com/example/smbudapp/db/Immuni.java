package com.example.smbudapp.db;

import com.example.smbudapp.DBValues;
import com.example.smbudapp.queryOutput.tableRecord;
import com.example.smbudapp.queryOutput.tableTripleRecord;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import org.neo4j.driver.AuthTokens;
import org.neo4j.driver.Driver;
import org.neo4j.driver.GraphDatabase;
import org.neo4j.driver.Record;
import org.neo4j.driver.Result;
import org.neo4j.driver.Session;
import org.neo4j.driver.Transaction;
import org.neo4j.driver.TransactionWork;
import org.neo4j.driver.Value;

import org.neo4j.driver.Values;

import java.util.*;


public class Immuni implements AutoCloseable {

	private static Driver neo4jDriver;
	private static Map<String, String> queries;
	private static Map<String, String> commands;
	private static Immuni immuni;
	private static Session session;
	
	public Immuni(String uri, String user, String password) {
		neo4jDriver = GraphDatabase.driver(uri, AuthTokens.basic(user, password));
		queries = QueryDictionary.QueryList();
		commands = CommandDictionary.CommandList();
	}
	

	@Override
	public void close() throws Exception {
		neo4jDriver.close();
	}

	public static void update() {
		Immuni.getTotInf();
		Immuni.getTotVaccInf();
		Immuni.getTotVaccInf();
		Immuni.getTotHealed();
		Immuni.getAvgAge();
		Immuni.getHos();
		Immuni.getTotVacc();
	}

	private Result executeTransaction(final Transaction tx, Value params, String query) {
		Result result;
		if (params.isEmpty()) {
			result = tx.run(query);
		}
		else {
			result = tx.run(query, params);
		}
		/*
		while ((result).hasNext()) {
			Record record = (result).next();
			System.out.println(record);
		}*/
		return result;
		
	}
	
	private Result executeTransaction(final Transaction tx, String query) {
		return executeTransaction(tx, Values.parameters(), query);
	}

	public static void start() {
		immuni = new Immuni("bolt://localhost:7687", "neo4j", "immuni");
		session = neo4jDriver.session();

	}

	public static void getTotInf(){
		session.readTransaction(new TransactionWork<Result>() {
			@Override
			public Result execute(Transaction tx) {
				Result result = immuni.executeTransaction(tx, Values.parameters("date1", "2020-01-01", "date2", "2023-11-11"), queries.get("queryNumInfected"));
				DBValues.get().setTotInf(result);
				return result;
			}
		});
	}

	public static void getTotVaccInf(){
		session.readTransaction(new TransactionWork<Result>() {
			@Override
			public Result execute(Transaction tx) {
				Result result = immuni.executeTransaction(tx, queries.get("queryVaccinatedInf"));
				DBValues.get().setInfVacc(result);
				return result;
			}
		});
	}

	public static void getTotHealed(){
		session.readTransaction(new TransactionWork<Result>() {
			@Override
			public Result execute(Transaction tx) {
				Result result = immuni.executeTransaction(tx, Values.parameters("date1", "2000-01-01", "date2", "2050-11-11"), queries.get("queryHealed"));
				DBValues.get().setHealedCOV(result);
				return result;
			}
		});
	}

	public static void getAvgAge(){
		session.readTransaction(new TransactionWork<Result>() {
			@Override
			public Result execute(Transaction tx) {
				Result result = immuni.executeTransaction(tx, queries.get("queryAvgInfected"));
				DBValues.get().setInfAvg(result);
				return result;
			}
		});
	}

	public static void getTotVacc(){
		session.readTransaction(new TransactionWork<Result>() {
			@Override
			public Result execute(Transaction tx) {
				Result result = immuni.executeTransaction(tx, queries.get("queryVaccinated"));
				DBValues.get().setTotVacc(result);
				return result;
			}
		});
	}

	public static void getHos(){
		session.readTransaction(new TransactionWork<Result>() {
			@Override
			public Result execute(Transaction tx) {
				Result result = immuni.executeTransaction(tx, Values.parameters("date1", "2020-01-01", "date2", "2023-11-11"), queries.get("queryHospitalizedV2"));
				DBValues.get().setTotHosp(result);
				return result;
			}
		});
	}

	public static void createAccess(String ssn, String loc, String datetime) {
		session.writeTransaction(new TransactionWork<Result>() {
			@Override
			public Result execute(Transaction tx) {
				Result result = immuni.executeTransaction(tx, Values.parameters("ssn", ssn, "date", datetime, "location", loc), commands.get("creationAccess"));
				return result;
			}
		});
	}

	public static void createContact(String ssn1, String ssn2, String date, String device) {
		session.writeTransaction(new TransactionWork<Result>() {
			@Override
			public Result execute(Transaction tx) {
				Result result = immuni.executeTransaction(tx, Values.parameters("ssn1", ssn1, "ssn2", ssn2, "date", date, "device", device), commands.get("creationContact"));
				return result;
			}
		});
	}

	public static void negativeTest(String ssn, String date) {
		session.writeTransaction(new TransactionWork<Result>() {
			@Override
			public Result execute(Transaction tx) {
				Result result = immuni.executeTransaction(tx, Values.parameters("ssn", ssn, "test_date", date), commands.get("registrationNegativeTest"));
				return result;
			}
		});
	}

	public static void positiveTest(String ssn, String date) {
		session.writeTransaction(new TransactionWork<Result>() {
			@Override
			public Result execute(Transaction tx) {
				Result result = immuni.executeTransaction(tx, Values.parameters("ssn", ssn, "test_date", date), commands.get("registrationPositiveTest"));
				return result;
			}
		});
	}

	public static ObservableList<tableRecord> infectedCities(String date1, String date2){
		List<tableRecord> cities = new ArrayList<>();
		session.readTransaction(new TransactionWork<Result>() {
			@Override
			public Result execute(Transaction tx) {
				Result result = immuni.executeTransaction(tx, Values.parameters("date1", date1, "date2", date2), queries.get("queryInfectedCities"));
				while ((result).hasNext()) {
					Record record = (result).next();
					cities.add(new tableRecord(record.get(0).toString(), Integer.parseInt(record.get(1).toString())));
				}
				return result;
			}
		});

		return FXCollections.observableArrayList(cities);
	}

	public static ObservableList<tableRecord> infectedLocations(String date1, String date2){
		List<tableRecord> loc = new ArrayList<>();
		session.readTransaction(new TransactionWork<Result>() {
			@Override
			public Result execute(Transaction tx) {
				Result result = immuni.executeTransaction(tx, Values.parameters("date1", date1, "date2", date2), queries.get("queryLocation"));
				while ((result).hasNext()) {
					Record record = (result).next();
					loc.add(new tableRecord(record.get(0).toString(), Integer.parseInt(record.get(1).toString())));
				}
				return result;
			}
		});

		return FXCollections.observableArrayList(loc);
	}

	public static ObservableList<tableRecord> hospitals(String date1, String date2){
		List<tableRecord> loc = new ArrayList<>();
		session.readTransaction(new TransactionWork<Result>() {
			@Override
			public Result execute(Transaction tx) {
				Result result = immuni.executeTransaction(tx, Values.parameters("date1", date1, "date2", date2), queries.get("queryHospitalized"));
				while ((result).hasNext()) {
					Record record = (result).next();
					loc.add(new tableRecord(record.get(0).toString(), Integer.parseInt(record.get(1).toString())));
				}
				return result;
			}
		});

		return FXCollections.observableArrayList(loc);
	}

	public static int infected(String date1, String date2){
		final Integer[] num = new Integer[1];
		session.readTransaction(new TransactionWork<Result>() {
			@Override
			public Result execute(Transaction tx) {
				Result result = immuni.executeTransaction(tx, Values.parameters("date1", date1, "date2", date2), queries.get("queryNumInfected"));
				Record record = result.next();
				num[0] = Integer.parseInt(record.get(0).toString());
				return result;
			}
		});

		return num[0];
	}




	/*
	public static void main( String... args ) throws Exception {
		try (Immuni immuniTest = new Immuni("bolt://localhost:7687", "neo4j", "immuni")) {

			try (Session session = neo4jDriver.session()) {

				System.out.println("Ranking of infected cities: ");
				session.readTransaction(new TransactionWork<Result>() {
					@Override
					public Result execute(Transaction tx) {
						Result result = immuniTest.executeTransaction(tx, Values.parameters("date1", "2021-01-01", "date2", "2021-11-11"), queries.get("queryInfectedCities"));
						DBValues.get().setResult(result);
						return result;


					}
				});


				System.out.println("Number of vaccinated people that are infected: ");
				session.readTransaction(new TransactionWork<Result>() {
					@Override
					public Result execute(Transaction tx) {
						Result result = immuniTest.executeTransaction(tx, queries.get("queryVaccinatedInf"));
						DBValues.get().setResult(result);
						return result;
					}
				});

				System.out.println("Hospitalized: ");
				session.readTransaction(new TransactionWork<Result>() {
					@Override
					public Result execute(Transaction tx) {
						return immuniTest.executeTransaction(tx, Values.parameters("date1", "2021-01-01", "date2", "2021-11-11"), queries.get("queryHospitalized"));
					}
				});
			} catch (Exception e) {
				System.err.println(e);
				e.printStackTrace();
			}
			;

		}
	} */
}
