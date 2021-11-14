package com.example.smbudapp;

import com.example.smbudapp.db.Immuni;

public class GUIStarter {
    public static void main(String[] args) {

            Immuni.start();
            Immuni.update();
            GUI.run(args);

    }
}
