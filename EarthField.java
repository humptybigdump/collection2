public class EarthField implements Field {
    private final String plant;

    public EarthField(String plant) {
        this.plant = plant;
    }


    @Override
    public String getSymbol() {
        return "E";
    }

    @Override
    public void setAmount(int newAmount) {
        throw new IllegalStateException("Cannot set amount on an earth field");
    }

    @Override
    public boolean isEarthField() {
        return true;
    }

    @Override
    public StorageField asStorageField() {
        return null;
    }
}
