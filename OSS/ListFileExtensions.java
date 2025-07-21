import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.*;

public class ListFileExtensions {

    private static final Set<String> knownTextExtensions = Set.of(
            "txt", "java", "xml", "html", "htm", "css", "js", "json", "yml", "yaml",
            "md", "mdown", "markdown", "cfm", "cfc", "sh", "csv", "ts", "scss", "less",
            "php", "csslintrc", "jshintrc", "lock", "nuspec", "ini", "properties", "log",
            "lang"
    );

    public static void main(String[] args) {
        if (args.length < 1 || args.length > 3) {
            System.err.println("Usage: java ListFileExtensions <directory_path> [summary] [text-only]");
            System.exit(1);
        }

        File root = new File(args[0]);
        if (!root.isDirectory()) {
            System.err.println("The provided path is not a directory.");
            System.exit(1);
        }

        boolean summaryMode = Arrays.asList(args).contains("summary");
        boolean textOnlyMode = Arrays.asList(args).contains("text-only");

        if (summaryMode || textOnlyMode) {
            Set<String> allExtensions = new TreeSet<>();
            Map<String, Boolean> extensionTextStatus = new TreeMap<>();

            collectExtensionsWithTextCheck(root, allExtensions, extensionTextStatus);

            if (textOnlyMode) {
                Set<String> textExtensions = new TreeSet<>();
                Set<String> binaryExtensions = new TreeSet<>();

                for (String ext : allExtensions) {
                    if (extensionTextStatus.getOrDefault(ext, false)) {
                        textExtensions.add(ext);
                    } else {
                        binaryExtensions.add(ext);
                    }
                }

                System.out.println("✅ Text-based file extensions (alphabetically):");
                textExtensions.forEach(System.out::println);
                System.out.println("\n❌ Non-text file extensions (alphabetically):");
                binaryExtensions.forEach(System.out::println);

            } else {
                System.out.println("Unique file extensions (alphabetically):");
                allExtensions.forEach(System.out::println);
            }
        } else {
            Map<String, List<String>> extToFiles = new TreeMap<>();
            collectExtensionsWithPaths(root, extToFiles);

            System.out.println("File extensions and example files:\n");
            for (Map.Entry<String, List<String>> entry : extToFiles.entrySet()) {
                String ext = entry.getKey();
                List<String> files = entry.getValue();
                System.out.println(ext + " (" + files.size() + "):");
                files.forEach(path -> System.out.println("  " + path));
                System.out.println();
            }
        }
    }

    private static void collectExtensionsWithTextCheck(File dir, Set<String> extensions, Map<String, Boolean> extTextStatus) {
        File[] files = dir.listFiles();
        if (files == null) return;

        for (File file : files) {
            if (file.isDirectory()) {
                collectExtensionsWithTextCheck(file, extensions, extTextStatus);
            } else {
                String ext = getFileExtension(file.getName()).toLowerCase();
                if (!ext.isEmpty()) {
                    extensions.add(ext);
                    extTextStatus.putIfAbsent(ext, isTextFile(file));
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
                String ext = getFileExtension(file.getName()).toLowerCase();
                if (!ext.isEmpty()) {
                    extToFiles.computeIfAbsent(ext, k -> new ArrayList<>()).add(file.getAbsolutePath());
                }
            }
        }
    }

    private static boolean isTextFile(File file) {
        String ext = getFileExtension(file.getName()).toLowerCase();

        // 1. Whitelist extension
        if (knownTextExtensions.contains(ext)) {
            return true;
        }

        // 2. Check MIME type
        try {
            String mimeType = Files.probeContentType(file.toPath());
            if (mimeType != null && mimeType.startsWith("text")) {
                return true;
            }
        } catch (IOException ignored) {}

        // 3. Fallback: check for non-printable characters
        try {
            byte[] bytes = Files.readAllBytes(file.toPath());
            for (byte b : bytes) {
                if (b < 0x09 || (b > 0x0D && b < 0x20)) {
                    return false;
                }
            }
            return true;
        } catch (IOException e) {
            return false;
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
