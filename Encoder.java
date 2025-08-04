public class Encoder {
	public static void main(String[] args) {
		String clauses = "";
		
		int n=1000;
		int[] squares = new int[n+1];
		int numTriples = 0;
		
		int[] possibleColors = new int[n+1];
		
		for(int i=0; i<n+1; i++) {
			squares[i] = i*i;
			possibleColors[i] = 6;
		}
		
		for(int i=1; i<n+1; i++) {
			if(possibleColors[i] == 6) possibleColors[i] = 2;
			
			for(int j=1; j<n+1; j++) {
				int k = i*i + j*j;
				
				for(int l=0; l<squares.length; l++) {
					if(squares[l] == k) {			
						numTriples++;
						
						clauses += i + " " + j + " " + l + " 0\n";
						clauses += -i + " " + -j + " " + -l + " 0\n";
					}
				}
			}
		}
		
		System.out.println("p cnf " + n + " " + numTriples + "\n" + clauses);
	}
}
