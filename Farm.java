import java.util.HashMap;
import java.util.Map;

public class Farm {
    private final Field[][] board;

    // instead of the above, one could store them separately
    private final Map<Coordinate, StorageField> storageFields = new HashMap<>();
    private final Map<Coordinate, EarthField> earthFields = new HashMap<>();

    public Farm(int size) {
        this.board = new Field[size][size];

        for (int i = 0; i < size; i++) {
            for (int j = 0; j < size; j++) {
                this.board[i][j] = new EarthField("Carrot");
            }
        }

        // or just store them separately.
        // The problem is that this will be a lot more work/code
        for (int i = 0; i < size; i++) {
            for (int j = 0; j < size; j++) {
                this.earthFields.put(new Coordinate(i, j), new EarthField("Carrot"));
            }
        }
    }

    public void plant(int x, int y, String plant) {
        // is at x y a barn?
        if (this.board[x][y] instanceof Barn) {
            throw new IllegalStateException("Cannot plant on a barn");
        }

        this.board[x][y] = new EarthField(plant);
    }

    public void updateAmount(int x, int y, int newAmount) {
        if (this.board[x][y].isEarthField()) {
            throw new IllegalStateException("Cannot set amount on an earth field");
        }

        this.board[x][y].setAmount(newAmount);
    }

    public void storePlant(int x, int y) {
        StorageField storage = this.board[x][y].asStorageField();

        if (storage == null) {
            throw new IllegalStateException("Cannot store on an earth field");
        }

        storage.setAmount(storage.getAmount() + 1);
    }
}
