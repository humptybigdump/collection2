package Felder02_EindimensionaleFelder;

/**
 * 
 * @author Lukas Struppek
 *
 */
public class ErweiterteForSchleife {
	public static void main(String[] args) {
		int[] feld = {10, 11, 12, 13};
		
		// Verk�rzte for-Schleife zum Durchlaufen des Feldes
		for(int i : feld)
			System.out.println(i);
		
		// Regul�re for-Schleife mit identischer Funktionalit�t
		for(int i = 0; i < feld.length; i++)
			System.out.println(feld[i]);

	}
}
