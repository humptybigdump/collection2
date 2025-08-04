package brickcontroller.observer.features;

import brickcontroller.observer.BrickController;
import brickcontroller.observer.StartObserver;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.geometry.Pos;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;

public class Emergency implements StartObserver{
	private boolean light = false;
	private boolean siren = false;

	public boolean toggleLight() {
		light = !light;
		return light;
	}

	public boolean toggleSiren() {
		siren = !siren;
		return siren;
	}

	@Override
	public void notifyStart(VBox root) {
		var emergencyLight = new Button("Lights");
		emergencyLight.setOnAction(new EventHandler<ActionEvent>() {
			@Override
			public void handle(ActionEvent event) {
				emergencyLight.setStyle(Emergency.this.toggleLight() ? BrickController.LIGHTSTYLE : "");
			}
		});
		var emergencySiren = new Button("Siren");
		emergencySiren.setOnAction(new EventHandler<ActionEvent>() {
			@Override
			public void handle(ActionEvent event) {
				emergencySiren.setStyle(Emergency.this.toggleSiren() ? BrickController.LIGHTSTYLE : "");
			}
		});
		var hemergency = new HBox(new Label("Emergency:"), emergencyLight, emergencySiren);
		hemergency.setAlignment(Pos.CENTER_LEFT);
		hemergency.setSpacing(10);
		root.getChildren().add(hemergency);
	}
}