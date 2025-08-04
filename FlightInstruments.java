package de.kit.cs.tva.sqm;

public class FlightInstruments {

	private PressureSensor pressureSensor;
	private TemperatureSensor temperatureSensor;
	private Engine engine;

	/**
	 * Computes the current altitude and is either starting or not.
	 * 
	 * @param pS
	 *            - Outside pressure sensor (in hPa)
	 * @param tS
	 *            - Outside temperature sensor (in K)
	 * @param e
	 *            - Aircraft Engine
	 */
	public FlightInstruments(PressureSensor pS, TemperatureSensor tS, Engine e) {
		pressureSensor = pS;
		temperatureSensor = tS;
		engine = e;
	}

	/**
	 * Computes the current altitude based on the outside pressure and
	 * temperature.
	 * 
	 * @return <tt>double</tt> value of current height in feet.
	 */
	public double currentAltitude() {
		double t = temperatureSensor.value();
		double p = pressureSensor.value();
		double p0 = 1013.25;
		t = pressureSensor.value();
		// Formula to compute current altitude, based on outside pressure and
		// temperature values obtained by sensors.
		double h = (1 - Math.pow(p / p0, 1 / 5.255)) * t * 504.7; // /0.0065;
		return h;
	}

	/**
	 * returns true, if the throttle value of the engine is greater than 20.
	 * 
	 * @return <tt>true</tt>, if throttle > 20, <tt>false</tt> otherwise.
	 */
	public boolean isStarting() {
		return engine.getThrottle() > 20;
	}

}
