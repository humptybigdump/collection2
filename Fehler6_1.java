package Felder03_TypischeFehler;

/**
 * 
 * @author Hans Wiwi
 *
 */
public class Fehler6 {
	public static void main(String[] args) {
		int[] feld1 = new int[5];
		byte[] feld2 = new byte[3];

		// Keine Zuweisung möglich, da sich die Datentypen der Komponenten eines Feldes
		// nicht implizit in einen anderen Datentypen konvertieren lassen. int[]-Felder
		// sind nur mit int[]-Feldern zuweisungskompatibel. Derselbe Fall gilt auch für
		// alle anderen Arten von Feldern.
		feld1 = feld2;

	}
}
