import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.util.*;
import java.util.regex.*;

public class CheckDdl {

    private static final Set<String> IGNORED_EXTENSIONS = new HashSet<>(Arrays.asList(
            ".png", ".jpg", ".jpeg", ".gif", ".bmp", ".pdf", ".doc", ".docx", ".xls", ".xlsx",
            ".zip", ".tar", ".gz", ".ico", ".ttf", ".woff", ".svg", ".exe", ".class"
    ));

    private static final List<String> IGNORED_PATHS = Arrays.asList(
            "/Users/cesar/promi-universe/git/Prosis/Scripts/ammap/",
            "/Users/cesar/promi-universe/git/Prosis/OSS/",
            "/Users/cesar/promi-universe/git/Prosis/Scripts/Mobile/Resources/vendor/"
    );

    private static final Set<String> IGNORED_FILES = new HashSet<>(Arrays.asList(
            "example.sql", "sample.txt"
    ));

    private static final List<Pattern> DDL_PATTERNS = Arrays.asList(
            Pattern.compile("(?i)\\bCREATE\\s+TABLE\\b"),
            Pattern.compile("(?i)\\bALTER\\s+TABLE\\b"),
            Pattern.compile("(?i)\\bDROP\\s+TABLE\\b"),
            Pattern.compile("(?i)\\bCREATE\\s+INDEX\\b"),
            Pattern.compile("(?i)\\bCREATE\\s+VIEW\\b"),
            Pattern.compile("(?i)\\bCREATE\\s+DATABASE\\b"),
            Pattern.compile("(?i)\\bDROP\\s+VIEW\\b")
    );

    private static final List<Path> flagged = new ArrayList<>();
    private static final List<Path> clean = new ArrayList<>();

    public static void main(String[] args) {
        if (args.length == 0 || args.length > 2) {
            System.out.println("Usage: java CheckDdl <path> [--fix]");
            System.exit(1);
        }

        boolean fixMode = args.length == 2 && args[1].equals("--fix");
        Path root = Paths.get(args[0]);

        if (!Files.exists(root)) {
            System.err.println("Path does not exist: " + root);
            System.exit(1);
        }

        try {
            Files.walk(root)
                    .filter(Files::isRegularFile)
                    .filter(CheckDdl::isNotInIgnoredPaths)
                    .filter(CheckDdl::isNotIgnoredFile)
                    .filter(CheckDdl::isNotIgnoredExtension)
                    .forEach(file -> {
                        try {
                            boolean found = containsDdl(file);
                            if (fixMode && found) {
                                replaceWithPlaceholder(file);
                            } else {
                                if (found) {
                                    flagged.add(file);
                                } else {
                                    clean.add(file);
                                }
                            }
                        } catch (IOException e) {
                            System.err.println("Error processing: " + file + " – " + e.getMessage());
                        }
                    });

            if (!fixMode) {
//                System.out.println("\n✅ Files without DDL:");
//                clean.forEach(f -> System.out.println("   " + f));

                System.out.println("\n⚠️ Files containing DDL:");
                flagged.forEach(f -> System.out.println("   " + f));

                System.out.println("\nTotal scanned: " + (flagged.size() + clean.size()));
                System.out.println("Files with DDL: " + flagged.size());
            }

        } catch (IOException e) {
            System.err.println("Directory walk error: " + e.getMessage());
        }
    }

    private static boolean isNotInIgnoredPaths(Path filePath) {
        String path = filePath.toAbsolutePath().toString().replace('\\', '/');
        return IGNORED_PATHS.stream().noneMatch(path::startsWith);
    }

    private static boolean isNotIgnoredFile(Path filePath) {
        return IGNORED_FILES.stream().noneMatch(filePath.getFileName().toString()::equalsIgnoreCase);
    }

    private static boolean isNotIgnoredExtension(Path filePath) {
        String name = filePath.getFileName().toString().toLowerCase();
        return IGNORED_EXTENSIONS.stream().noneMatch(name::endsWith);
    }

    private static boolean containsDdl(Path filePath) throws IOException {
        List<String> lines = Files.readAllLines(filePath, StandardCharsets.ISO_8859_1);
        for (String line : lines) {
            for (Pattern pattern : DDL_PATTERNS) {
                if (pattern.matcher(line).find()) {
                    return true;
                }
            }
        }
        return false;
    }

    private static void replaceWithPlaceholder(Path filePath) throws IOException {
        Path backup = Paths.get(filePath.toString() + ".bak");
        Files.copy(filePath, backup, StandardCopyOption.REPLACE_EXISTING);

        String placeholder = "-- This file contained DDL statements.\n"
                + "-- DDL has been removed for open source release.\n"
                + "-- Please contact the project maintainer or provide your own DDL script.\n";

        Files.write(filePath, placeholder.getBytes(StandardCharsets.ISO_8859_1));
        System.out.println("✔ Replaced with placeholder: " + filePath);
    }
}
