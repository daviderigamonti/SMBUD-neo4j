package com.example.smbudapp;

import org.neo4j.driver.Record;
import org.neo4j.driver.Result;

public class DBValues {

    private int totInf;
    private int totHosp;
    private double infAvg;
    private int hosAvg;
    private int totVacc;
    private int infVacc;
    private int healedCOV;

    private static DBValues instance = null;

    public static DBValues get() {
        if (instance == null) instance = new DBValues();
        return instance;
    }

    public DBValues() {

    }

    public void setResult(Result result) {
        setTotInf(result);
    }

    public void setTotInf(Result result) {
        totInf = Integer.parseInt(result.next().get(0).toString());
    }

    public void setTotHosp(Result result) {
        this.totHosp = Integer.parseInt(result.next().get(0).toString());
    }

    public void setInfAvg(Result result) {
        this.infAvg = Double.parseDouble(result.next().get(0).toString());
    }

    public void setHosAvg(Result result) {
        this.hosAvg = Integer.parseInt(result.next().get(0).toString());
    }

    public void setTotVacc(Result result) {
        totVacc = Integer.parseInt(result.next().get(0).toString());
    }

    public void setInfVacc(Result result) {
        infVacc = Integer.parseInt(result.next().get(0).toString());
    }

    public void setHealedCOV(Result result) {
        this.healedCOV = Integer.parseInt(result.next().get(0).toString());
    }

    public int getTotInf() {
        return totInf;
    }

    public int getTotHosp() {
        return totHosp;
    }

    public double getInfAvg() {
        return infAvg;
    }

    public int getHosAvg() {
        return hosAvg;
    }

    public int getTotVacc() {
        return totVacc;
    }

    public int getInfVacc() {
        return infVacc;
    }

    public int getHealedCOV() {
        return healedCOV;
    }
}
