package Felder03_TypischeFehler;

/**
 * 
 * @author Lukas Struppek
 *
 */
public class Fehler2 {
	public static void main(String[] args) {
		int[] feld = { 1, 2, 3, 4, 5 };

		// Bei Aufruf von println mit einem Referenzdatentyp wird implizit die
		// toString-Methode aufgerufen. Diese liefert einen Hash-Wert des Feldes zurück,
		// nicht aber seine Komponenten.
		System.out.println(feld);
		
		// Besser: Feld durchlaufen mit for-Schleife
		for(int i = 0; i < feld.length; i++)
			System.out.println(feld[i]);

	}
}
