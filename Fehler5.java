package Felder03_TypischeFehler;

/**
 * 
 * @author Hans Wiwi
 *
 */
public class Fehler5 {
	public static void main(String[] args) {
		// Bei kleineren Werten kein Problem mit Arbeitsspeichergröße
		short[] s = new short[10000];

		// Bei sehr großen Feldern kommt es zu einem java.lang.OutOfMemoryError. Die
		// zulässige Größe ist vom verfügbaren Arbeitsspeicher und den Einstellungen der
		// Java Virtual Machine abhängig.
		short[] t = new short[Integer.MAX_VALUE];
	}
}
