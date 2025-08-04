import Prog1Tools.*;
public class Game{
	
	public static void main(String[] args){

		GraphicScreen screen = GraphicScreen.getInstance();
		int number_of_pieces = screen.readInt("Difficulty", "How many pieces? Not more than 10! ");
		while(number_of_pieces > 10 || number_of_pieces < 1){
			number_of_pieces = screen.readInt("Difficulty", "How many pieces? Not more than 10! ");
		}
		
		boolean gewonnen = false;
		
		TowerOfHanoi tower1 = new TowerOfHanoi(number_of_pieces);
		TowerOfHanoi tower2 = new TowerOfHanoi(0);
		TowerOfHanoi tower3 = new TowerOfHanoi(0);

		TowerOfHanoi[] towers = {tower1, tower2, tower3};
		while(!gewonnen){

			screen.clearScreen();
			drawTower(screen, towers[0], 100, 200);
			drawTower(screen, towers[1], 400, 200);
			drawTower(screen, towers[2], 700, 200);

			towers = move(towers, screen);
			if(towers[0].get_top_piece() == null && towers[1].get_top_piece() == null){
				gewonnen = true;
				screen.clearScreen();
				drawTower(screen, towers[0], 100, 200);
				drawTower(screen, towers[1], 400, 200);
				drawTower(screen, towers[2], 700, 200);
			}
		}
		screen.showMessageDialog("VICTORY", "You won the game!");
	}

	public static void drawTower(GraphicScreen screen, TowerOfHanoi tower, int position_x, int position_y){ 
		if(tower.get_top_piece() != null){
			drawPiece(screen, tower.get_top_piece(), position_x, position_y);
		}
		screen.setColor(GraphicScreen.BLACK);
		screen.drawRectangle(position_x - 100, position_y+10, 200, 3, true);
	}

	public static int drawPiece(GraphicScreen screen, Piece piece, int position_x, int position_y){
		int delay = 0;
		if(piece.get_below() != null){
			delay = 10 + drawPiece(screen, piece.get_below(), position_x, position_y);
		}
		java.awt.Color color;
		switch(piece.get_color()){
			case "GREEN": color = GraphicScreen.GREEN; break;
			case "RED": color = GraphicScreen.RED; break;
			case "BLUE": color = GraphicScreen.BLUE; break;
			case "ORANGE": color = GraphicScreen.ORANGE; break;
			default: color = GraphicScreen.BLACK; break;
		}
		screen.setColor(color);
		screen.drawRectangle(position_x - 10*piece.get_size(), position_y-delay, piece.get_size()*20, 10, true);
		return delay;
	}
	
	public static TowerOfHanoi[] move(TowerOfHanoi[] towers, GraphicScreen screen){
		int input = screen.readInt("Move input", "Make a move");
		int firstTower = input/10 - 1;
		int secondTower = input%10 - 1;
		try{
			if(towers[secondTower].get_top_piece() == null || (towers[secondTower].get_top_piece().get_size() > towers[firstTower].get_top_piece().get_size())){
				Piece top_piece = towers[firstTower].get_top_piece();
				towers[firstTower].remove_top_piece();
				towers[secondTower].set_top_piece(top_piece);
			}else{
				throw new Exception("WRONG");
			}
		}catch(Exception e){
			screen.showMessageDialog("Error", "Not a valid move!");
		}
		return towers;
	}
}

