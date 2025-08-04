package Felder03_TypischeFehler;

/**
 * 
 * @author Hans Wiwi
 *
 */
public class Fehler3 {
	public static void main(String[] args) {
		char[] array = { 'z', 'e', 'i', 'c', 'h', 'e', 'n' };

		// Zähler läuft bis i = array.length, das Feld besitzt aber nur die
		// Indizes von 0 bis array.length-1. Der Zugriff auf array[7] führt
		// zu einer java.lang.ArrayIndexOutOfBoundsException.
		for (int i = 0; i <= array.length; i++)
			System.out.println(array[i]);

		// Ein korrekt arbeitender Schleifenkopf sieht folgendermaßen aus
		for (int i = 0; i < array.length; i++)
			System.out.println(array[i]);

	}

}
