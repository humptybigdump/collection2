package Felder03_TypischeFehler;

/**
 * 
 * @author Lukas Struppek
 *
 */
public class Fehler1 {
	public static void main(String[] args) {
		// Deklaration der Referenzvariablen feld ohne Erzeugung
		int[] feld;

		// Kein Zugriff möglich auf einzelne Komponenten, da Feld noch nicht erzeugt
		// worden ist
		feld[0] = 55;

		// Ebenfalls kein Zugriff möglich auf die Referenzvariable, da sie nicht erzeugt
		// worden ist. Lokale Variablen werden nicht automatisch mit default Werten
		// belegt.
		System.out.println(feld);
	}
}
