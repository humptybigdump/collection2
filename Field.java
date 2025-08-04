
public interface Field {
    String getSymbol();

    void setAmount(int newAmount);


    default boolean isEarthField() {
        return false;
    }

    StorageField asStorageField();
}
