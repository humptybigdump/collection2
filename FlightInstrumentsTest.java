package de.kit.cs.tva.sqm;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.*;

import org.junit.Before;
import org.junit.Test;

import de.kit.cs.tva.sqm.Engine;
import de.kit.cs.tva.sqm.FlightInstruments;
import de.kit.cs.tva.sqm.PressureSensor;
import de.kit.cs.tva.sqm.TemperatureSensor;

public class FlightInstrumentsTest {

	FlightInstruments flightInstruments;
	PressureSensor pressureSensor;
	TemperatureSensor temperatureSensor;
	Engine engine;
	
	@Before
	public void setUp() throws Exception {
		engine = mock(Engine.class);
		pressureSensor = mock(PressureSensor.class);
		temperatureSensor = mock(TemperatureSensor.class);
		flightInstruments = new FlightInstruments(pressureSensor, temperatureSensor, engine);
	}
	
	@Test
	public void testIsStarting() {
		when(engine.getThrottle()).thenReturn(100);
		assertTrue(flightInstruments.isStarting());
		when(engine.getThrottle()).thenReturn(0);
		assertFalse(flightInstruments.isStarting());
	}
	
	@Test
	public void testCurrentAltitude() {
		checkAltitude(200.0, 274.0, 36736);
		checkAltitude(500.0, 274.0, 17392);
		checkAltitude(700.0, 274.0, 9398);
		checkAltitude(1000.0, 274.0, 346);
		checkAltitude(200.0, 288.0, 38614);
		checkAltitude(500.0, 288.0, 18281);
		checkAltitude(700.0, 288.0, 9878);
		checkAltitude(1000.0, 288.0, 364);
	}

	private void checkAltitude(double p, double t, double expectedAlt) {
		when(pressureSensor.value()).thenReturn(p);
		when(temperatureSensor.value()).thenReturn(t);
		assertEquals(expectedAlt, flightInstruments.currentAltitude(), 0.5);
	}


}
