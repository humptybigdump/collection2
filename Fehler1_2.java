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

		// Kein Zugriff m�glich auf einzelne Komponenten, da Feld noch nicht erzeugt
		// worden ist
		feld[0] = 55;

		// Ebenfalls kein Zugriff m�glich auf die Referenzvariable, da sie nicht erzeugt
		// worden ist. Lokale Variablen werden nicht automatisch mit default Werten
		// belegt.
		System.out.println(feld);
	}
}
