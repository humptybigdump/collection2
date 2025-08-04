package de.kit.cs.tva.sqm;

public class FlightInstruments {

	private PressureSensor pressureSensor;
	private TemperatureSensor temperatureSensor;
	private Engine engine;

	public FlightInstruments(PressureSensor pS, TemperatureSensor tS, Engine e) {
		pressureSensor = pS;
		temperatureSensor = tS;
		engine = e;
	}

	/**
	 * Compute the current altitude based on a formula. Requires both current
	 * pressure and outside temperature.
	 * 
	 * @return
	 */
	public double currentAltitude() {
		double p = pressureSensor.value();
		double t = temperatureSensor.value();
		double p0 = 1013.25;
		// Has to be removed!
		// t = pressureSensor.value();
		double h = (1 - Math.pow(p / p0, 1 / 5.255)) * t * 504.7; // /0.0065;
		return h;
	}

	public boolean isStarting() {
		return engine.getThrottle() > 20;
	}

}
