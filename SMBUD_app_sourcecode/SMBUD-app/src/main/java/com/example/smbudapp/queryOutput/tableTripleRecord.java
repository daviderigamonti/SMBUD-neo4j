package com.example.smbudapp.queryOutput;

public class tableTripleRecord {
    private String name;
    private String type;
    private int num;

    public tableTripleRecord(String name, String type, int num) {
        this.name = name;
        this.type = type;
        this.num = num;
    }

    public String getName() {
        return name;
    }

    public String getType(){
        return  type;
    }

    public int getNum() {
        return num;
    }
}
