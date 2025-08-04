package Felder02_EindimensionaleFelder;

/**
 * 
 * @author Lukas Struppek
 *
 */
public class ErweiterteForSchleife {
	public static void main(String[] args) {
		int[] feld = {10, 11, 12, 13};
		
		// Verkürzte for-Schleife zum Durchlaufen des Feldes
		for(int i : feld)
			System.out.println(i);
		
		// Reguläre for-Schleife mit identischer Funktionalität
		for(int i = 0; i < feld.length; i++)
			System.out.println(feld[i]);

	}
}
