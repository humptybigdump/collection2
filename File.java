// Diese Lösung folgt nicht den Bewertungsrichtlinien!

public class File {

    private static final String FILE_ALREADY_IN_STRUCTURE = "File is already part of a File Structure";
    private static final String FILE_NOT_IN_STRUCTURE = "File is not part of a File Structure";
    private static final String NAME_CONTENT_SPERATOR = ": ";
    private static final String PATH_SEPARATOR = "/";

    private String name;
    private String content;
    private Folder parent;

    public File(String name, String content) {
        this.name = name;
        this.content = content;
        this.parent = null;
    }

    public String getName() {
        return name;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setParent(Folder parent) {
        if (this.parent != null) {
            throw new IllegalArgumentException(FILE_ALREADY_IN_STRUCTURE);
        }
        this.parent = parent;
    }

    public void removeParent() {
        if (this.parent != null) {
            this.parent = null;
        } else {
            throw new IllegalArgumentException(FILE_NOT_IN_STRUCTURE);
        }
    }

    public String getPath() {
        if (parent != null) {
            return parent.getPath() + PATH_SEPARATOR + name;
        } else {
            return name;
        }
    }

    @Override
    public String toString() {
        return name + NAME_CONTENT_SPERATOR + content;
    }
}
