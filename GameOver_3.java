import javax.swing.*;
import java.awt.*;

public class GameOver{
	
	public static JLabel winner; // defines a label that shows which player won at the end of a game
	public static short gameOver = 0; // determines whether the game has finished
	private static int[] win = new int[Backdrop.getPlayers()]; // counts how many tokens each player has
	private static int highest = 0; // tracks which player of those whose tokens have already been counted, has the most tokens

	// initialises this instance of the GameOver class
	public static void setup(){
		winner = new JLabel(Token.green);
		winner.setBounds(910,10,90*8/Backdrop.getHeight(),90*8/Backdrop.getHeight());
		winner.setVisible(false);
		winner.setHorizontalTextPosition(JLabel.CENTER);
		winner.setFont(new Font("plain",Font.PLAIN,30));
	}

	// runs if the player currently playing has no possible moves
	public static void NoMoves(){
		gameOver++;
		if(gameOver < Backdrop.getPlayers()){
			Backdrop.turn();
		}
	}

	// checks if the game is over, and if so, counts the tokens each player has, and shows the colour token of the player with the highest tokens - if there is a tie for first, a green token is shown
	public static void GameOver(){
		if(gameOver == Backdrop.getPlayers()){
			for (int j = 0; j<Backdrop.getPlayers(); j++){
				win[j] = 0;
			}
			for (int j = 0; j<Backdrop.getPlayers(); j++){
				for (int i = 0; i<Backdrop.getHeight()*Backdrop.getWidth();i++){
					if(Backdrop.tokenList[i].getTokenState() == j+1){
						win[j]++;
					}
				}
				if(j == 0){
					winner.setIcon(Token.imageList[j+1]);
					winner.setText("win");
					highest = j;
				}
				else{
					if (win[j] == win[highest]){
						winner.setIcon(Token.green);
						winner.setText("tie");
					}
					else if (win[j] > win[highest]){
						winner.setText("win");
						highest = j;
						winner.setIcon(Token.imageList[highest+1]);
					}
				}
			}
			winner.setVisible(true);
			if (highest == 0){
				winner.setForeground(Color.white);
			}
			else{
				winner.setForeground(Color.black);
			}
		}
	}
}
