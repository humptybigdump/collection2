// Diese Lösung folgt nicht den Bewertungsrichtlinien!

import java.util.ArrayList;
import java.util.List;

public class Folder {

    private static final String FOLDER_ALREADY_IN_STRUCTURE = "Folder is already part of a File Structure";
    private static final String FOLDER_NOT_IN_STRUCTURE = "Folder is not part of a File Structure";
    private static final String FOLDER_SEPERATOR = "/";
    private static final String ITEAM_NAME_EXISTS = "Name already exists";
    private static final String NOT_ABLE_TO_LOOP_FOLDERS = "Not able to loop folders";

    private String name;
    private final List<Folder> folders;
    private final List<File> files;
    private Folder parent;

    public Folder(String name) {
        this.name = name;
        this.folders = new ArrayList<>();
        this.files = new ArrayList<>();
        this.parent = null;
    }

    public void setParent(Folder parent) {
        if (this.parent != null) {
            throw new IllegalArgumentException(FOLDER_ALREADY_IN_STRUCTURE);
        }
        this.parent = parent;
    }

    public void removeParent() {
        if (this.parent != null) {
            this.parent = null;
        } else {
            throw new IllegalArgumentException(FOLDER_NOT_IN_STRUCTURE);
        }
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void addFolder(Folder folder) {
        for (Folder currentFolder : folders) {
            if (currentFolder.getName().equals(folder.getName())) {
                throw new IllegalArgumentException(ITEAM_NAME_EXISTS);
            }
        }
        if (checkIfParent(folder)) {
            throw new IllegalArgumentException(NOT_ABLE_TO_LOOP_FOLDERS);
        }
        folder.setParent(this);
        folders.add(folder);
    }

    public Folder getFolder(String name) {
        for (Folder folder : folders) {
            if (folder.getName().equals(name)) {
                return folder;
            }
        }
        return null;
    }

    public void removeFolder(String name) {
        for (Folder folder : folders) {
            if (folder.getName().equals(name)) {
                removeFolder(folder);
            }
        }
    }

    public void removeFolder(Folder folder) {
        folder.removeParent();
        folders.remove(folder);
    }

    public void addFile(File file) {
        for (File currentFile : files) {
            if (currentFile.getName().equals(file.getName())) {
                throw new IllegalArgumentException(ITEAM_NAME_EXISTS);
            }
        }
        file.setParent(this);
        files.add(file);
    }

    public boolean checkIfParent(Folder folder) {
        if (this.equals(folder)) {
            return true;
        } else if(this.parent == null) {
            return false;
        } else {
            return this.parent.checkIfParent(folder);
        }
    }

    public File getFile(String name) {
        for (File file : files) {
            if (file.getName().equals(name)) {
                return file;
            }
        }
        return null;
    }

    public void removeFile(String name) {
        for (File file : files) {
            if (file.getName().equals(name)) {
                files.remove(file);
            }
        }
    }

    public void removeFile(File file) {
        file.removeParent();
        files.remove(file);
    }

    public String getPath() {
        if (parent != null) {
            return parent.getPath() + FOLDER_SEPERATOR + name;
        } else {
            return name;
        }
    }

    public String getTree() {
        StringBuilder result = new StringBuilder(getPath() + FOLDER_SEPERATOR + System.lineSeparator());
        for (File file : files) {
            result.append(file.getPath()).append(System.lineSeparator());
        }
        for (Folder folder : folders) {
            result.append(folder.getTree());
        }
        return result.toString();
    }

}
