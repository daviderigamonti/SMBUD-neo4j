package com.example.smbudapp;

import com.example.smbudapp.db.Immuni;
import com.example.smbudapp.queryOutput.tableRecord;
import com.example.smbudapp.queryOutput.tableTripleRecord;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.*;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.StackPane;

public class GUIController {
    @FXML
    private Label welcomeText, totInf, infVac, healedCOV, numVac, infAvg, totHos;
    @FXML
    private TextField ssn1, loc1, dt1, ssna2, ssnb2, dt2, dev2, ssn3, test3, ssn4, test4, textField1, textField2;
    @FXML
    private StackPane output;

    @FXML
    private ComboBox<String> dropdown;

    @FXML
    public void initialize() {

        dropdown.getItems().add("Get the cities with most infected");
        dropdown.getItems().add("Get locations with the most infected");
        dropdown.getItems().add("Get hospitals with most COVID patients");
        dropdown.getItems().add("Get number of infected");

        totInf.setText("Total number of infected: " + DBValues.get().getTotInf());
        infVac.setText("Infected with vaccination: " + DBValues.get().getInfVacc());
        healedCOV.setText("Total healed from COVID: " + DBValues.get().getHealedCOV());
        infAvg.setText("Infected average age: " + String.valueOf(DBValues.get().getInfAvg()).substring(0, 4) + " y. o." );
        totHos.setText("Total hospitalized: " + DBValues.get().getTotHosp());
        numVac.setText("Total vaccinated: " + DBValues.get().getTotVacc() );
    }

    public void createAccess(ActionEvent actionEvent) {
        Immuni.createAccess(ssn1.getText(), loc1.getText(), dt1.getText());
        ssn1.clear();
        loc1.clear();
        dt1.clear();
        update();
    }

    public void createContact(ActionEvent actionEvent) {
        Immuni.createContact(ssna2.getText(), ssnb2.getText(), dt2.getText(), dev2.getText());
        ssna2.clear();
        ssnb2.clear();
        dt2.clear();
        dev2.clear();
        update();
    }


    public void registerNegTest(ActionEvent actionEvent) {
        Immuni.negativeTest(ssn3.getText(), test3.getText());
        ssn3.clear();
        test3.clear();
        update();
    }

    public void registerPosTest(ActionEvent actionEvent) {
        Immuni.positiveTest(ssn4.getText(), test4.getText());
        ssn4.clear();
        test4.clear();
        update();
    }

    private void update() {
        Immuni.update();
        totInf.setText("Total number of infected: " + DBValues.get().getTotInf());
        infVac.setText("Infected with vaccination: " + DBValues.get().getInfVacc());
        healedCOV.setText("Total healed from COVID: " + DBValues.get().getHealedCOV());
        infAvg.setText("Infected average age: " + String.valueOf(DBValues.get().getInfAvg()).substring(0, 4) + " y. o." );
        totHos.setText("Total hospitalized: " + DBValues.get().getTotHosp());
        numVac.setText("Total vaccinated: " + DBValues.get().getTotVacc() );
    }

    private void queryCities(String date1, String date2) {
        var list = Immuni.infectedCities(date1, date2);

        TableView<tableRecord> tableView = new TableView<>();

        TableColumn<tableRecord, String> name = new TableColumn<>("City name");
        name.setCellValueFactory(new PropertyValueFactory<>("name"));
        TableColumn<tableRecord, String> infections = new TableColumn<>("Infections");
        infections.setCellValueFactory(new PropertyValueFactory<>("num"));

        tableView.getColumns().addAll(name, infections);
        tableView.setItems(list);

        output.getChildren().add(tableView);
    }

    private void queryLocation(String date1, String date2) {
        var list = Immuni.infectedLocations(date1, date2);

        TableView<tableRecord> tableView = new TableView<>();

        TableColumn<tableRecord, String> name = new TableColumn<>("Location name");
        name.setCellValueFactory(new PropertyValueFactory<>("name"));
        name.setPrefWidth(280);
        TableColumn<tableRecord, Integer> infections = new TableColumn<>("Infections");
        infections.setCellValueFactory(new PropertyValueFactory<>("num"));

        tableView.getColumns().addAll(name, infections);
        tableView.setItems(list);

        output.getChildren().add(tableView);
    }

    private void queryHospital(String date1, String date2) {
        var list = Immuni.hospitals(date1, date2);

        TableView<tableRecord> tableView = new TableView<>();

        TableColumn<tableRecord, String> name = new TableColumn<>("Hospital name");
        name.setCellValueFactory(new PropertyValueFactory<>("name"));
        name.setPrefWidth(280);
        TableColumn<tableRecord, Integer> infections = new TableColumn<>("Patients");
        infections.setCellValueFactory(new PropertyValueFactory<>("num"));

        tableView.getColumns().addAll(name, infections);
        tableView.setItems(list);

        output.getChildren().add(tableView);
    }
    private void queryInfected(String date1, String date2) {
        var num = Immuni.infected(date1, date2);
        var label = new Label();
        label.setText("Number of infected in the specified time span: " + num);
        label.setStyle("-fx-text-fill: white;");

        output.getChildren().add(label);
    }

    public void execute(ActionEvent actionEvent) {
        output.getChildren().clear();
        switch(dropdown.getValue()) {

            case "Get the cities with most infected":
                queryCities(textField1.getText(), textField2.getText());
                break;

            case "Get locations with the most infected":
                queryLocation(textField1.getText(), textField2.getText());
                break;

            case "Get hospitals with most COVID patients":
                queryHospital(textField1.getText(), textField2.getText());
                break;

            case "Get number of infected":
                queryInfected(textField1.getText(), textField2.getText());
                break;
        }
    }

    public void boxAction(ActionEvent actionEvent) {
    }
}