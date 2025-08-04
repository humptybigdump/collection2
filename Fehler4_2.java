package Felder03_TypischeFehler;

/**
 * 
 * @author Lukas Struppek
 *
 */
public class Fehler4 {
	public static void main(String[] args) {
		char c = 'A';
		long l = 11;
		// Feldl�nge muss vom Typ int sein oder zuweisungskompatibel sein
		// char implizit in int konvertierbar, Erzeugung also zul�ssig
		String[] texte = new String[c];

		// long nicht implizit in int konvertiertbar -> Type mismatch
		String[] nochMehrTexte = new String[l];

		// Keine negativen Feldl�ngen erlaubt -> java.lang.NegativeArraySizeException
		String[] mehrTexte = new String[-5];

		// Felder mit L�nge 0 f�hren zu keiner Fehlermeldung, sind aber wenig sinnvoll
		String[] weitereTexte = new String[0];
	}

}
