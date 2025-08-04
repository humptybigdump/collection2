package Felder03_TypischeFehler;

/**
 * 
 * @author Hans Wiwi
 *
 */
public class Fehler5 {
	public static void main(String[] args) {
		// Bei kleineren Werten kein Problem mit Arbeitsspeichergr��e
		short[] s = new short[10000];

		// Bei sehr gro�en Feldern kommt es zu einem java.lang.OutOfMemoryError. Die
		// zul�ssige Gr��e ist vom verf�gbaren Arbeitsspeicher und den Einstellungen der
		// Java Virtual Machine abh�ngig.
		short[] t = new short[Integer.MAX_VALUE];
	}
}
