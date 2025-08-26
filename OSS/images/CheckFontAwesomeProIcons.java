import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Stream;


/**
 * Helper class to scan a directory for potential Font Awesome Pro usage.
 */
public class CheckFontAwesomeProIcons {

    private static final List<String> FA_PRO_MARKERS = Arrays.asList(
            "Font Awesome Pro",
            "fa-duotone",
            "fa-pro",
            "\"pro.svg\"",
            "Font Awesome 6 Pro",
            "fontawesome-pro",
            "License: Pro"
    );

    private static final List<String> TARGET_EXTENSIONS = Arrays.asList(
            ".svg", ".js", ".json", ".yml", ".css", ".woff", ".woff2", ".ttf"
    );

    public static void main(String[] args) throws IOException {
        if (args.length != 1) {
            System.err.println("Usage: java CheckFontAwesomeProIcons <path>");
            System.exit(1);
        }

        Path root = Paths.get(args[0]);

        if (!Files.exists(root)) {
            System.err.println("The specified path does not exist.");
            System.exit(1);
        }

        System.out.println("Scanning for potential Font Awesome Pro usage in: " + root);

        try (Stream<Path> paths = Files.walk(root)) {
            paths.filter(Files::isRegularFile)
                    .filter(CheckFontAwesomeProIcons::isRelevantFile)
                    .forEach(CheckFontAwesomeProIcons::scanFile);
        }
    }

    private static boolean isRelevantFile(Path file) {
        String fileName = file.getFileName().toString().toLowerCase();
        return TARGET_EXTENSIONS.stream().anyMatch(fileName::endsWith);
    }

    private static void scanFile(Path file) {
        try {
            String content = Files.readString(file, StandardCharsets.UTF_8);
            for (String marker : FA_PRO_MARKERS) {
                if (content.contains(marker)) {
                    System.out.println("⚠️ Possible Font Awesome Pro usage found in: " + file);
                    System.out.println("   → Triggered by marker: \"" + marker + "\"");
                    break;
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading file " + file + ": " + e.getMessage());
        }
    }
}
