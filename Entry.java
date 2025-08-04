package codefight.command.util;

import codefight.model.memory.MemoryCell;

import java.util.List;

/**
 * Represents an entry in {@link Table}.
 * @author ugmom
 */
public class Entry {
    private final String representation;
    private final String id;
    private final String commandName;
    private final String valueA;
    private final String valueB;

    private final List<String> values;

    /**
     * Constructs an entry.
     * @param id is the id
     * @param memoryCell is the memory cell
     */
    public Entry(int id, MemoryCell memoryCell) {
        this.representation = memoryCell.getRepresentation();
        this.id = String.valueOf(id);
        this.commandName = memoryCell.getMemoryCommand().getAiCommand().name();
        this.valueA = String.valueOf(memoryCell.getMemoryCommand().getValueA());
        this.valueB = String.valueOf(memoryCell.getMemoryCommand().getValueB());

        values = List.of(this.representation, this.id, this.commandName, this.valueA, this.valueB);
    }

    /**
     * Gets the representation.
     * @return the representation
     */
    public String representation() {
        return representation;
    }

    /**
     * Gets the id.
     * @return the id
     */
    public String id() {
        return id;
    }

    /**
     * Gets the command name.
     * @return the command name
     */
    public String commandName() {
        return commandName;
    }

    /**
     * Gets value A.
     * @return value A
     */
    public String valueA() {
        return valueA;
    }

    /**
     * Gets value B.
     * @return value B
     */
    public String valueB() {
        return valueB;
    }

    /**
     * Gets the amount of features.
     * @return the amount of features
     */
    protected int length() {
        return values.size();
    }

    /**
     * Gets one particular feature.
     * @param index is the feature number
     * @return the feature
     */
    protected String get(int index) {
        return values.get(index);
    }
}
