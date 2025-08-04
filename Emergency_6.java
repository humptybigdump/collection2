package brickcontroller;

public class Emergency {
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
}