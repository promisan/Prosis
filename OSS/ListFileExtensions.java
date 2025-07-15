import java.io.File;
import java.util.*;

public class ListFileExtensions {

    public static void main(String[] args) {
        if (args.length < 1 || args.length > 2) {
            System.err.println("Usage: java ListFileExtensions <directory_path> [summary]");
            System.exit(1);
        }

        File root = new File(args[0]);
        if (!root.isDirectory()) {
            System.err.println("The provided path is not a directory.");
            System.exit(1);
        }

        boolean summaryMode = args.length == 2 && args[1].equalsIgnoreCase("summary");

        if (summaryMode) {
            Set<String> extensions = new TreeSet<>();
            collectExtensionsOnly(root, extensions);
            System.out.println("Unique file extensions (alphabetically):");
            for (String ext : extensions) {
                System.out.println(ext);
            }
        } else {
            Map<String, List<String>> extToFiles = new TreeMap<>();
            collectExtensionsWithPaths(root, extToFiles);

            System.out.println("File extensions and example files:\n");
            for (Map.Entry<String, List<String>> entry : extToFiles.entrySet()) {
                String ext = entry.getKey();
                List<String> files = entry.getValue();
                System.out.println(ext + " (" + files.size() + "):");
                for (String filePath : files) {
                    System.out.println("  " + filePath);
                }
                System.out.println();
            }
        }
    }

    private static void collectExtensionsOnly(File dir, Set<String> extensions) {
        File[] files = dir.listFiles();
        if (files == null) return;

        for (File file : files) {
            if (file.isDirectory()) {
                collectExtensionsOnly(file, extensions);
            } else {
                String ext = getFileExtension(file.getName());
                if (!ext.isEmpty()) {
                    extensions.add(ext.toLowerCase());
                }
            }
        }
    }

    private static void collectExtensionsWithPaths(File dir, Map<String, List<String>> extToFiles) {
        File[] files = dir.listFiles();
        if (files == null) return;

        for (File file : files) {
            if (file.isDirectory()) {
                collectExtensionsWithPaths(file, extToFiles);
            } else {
                String ext = getFileExtension(file.getName());
                if (!ext.isEmpty()) {
                    ext = ext.toLowerCase();
                    extToFiles.computeIfAbsent(ext, k -> new ArrayList<>()).add(file.getAbsolutePath());
                }
            }
        }
    }

    private static String getFileExtension(String filename) {
        int dotIndex = filename.lastIndexOf('.');
        if (dotIndex > 0 && dotIndex < filename.length() - 1) {
            return filename.substring(dotIndex + 1);
        }
        return "";
    }
}
