import java.io.*;
import java.nio.charset.*;
import java.nio.file.*;
import java.util.*;

public class CheckFileEncodings {
    private static final Set<String> TEXT_EXTENSIONS = new HashSet<>(Arrays.asList(
            ".cfm", ".cfc", ".txt", ".java", ".xml", ".html", ".htm", ".css",
            ".js", ".json", ".md", ".yml", ".sh", ".php", ".csv", ".log",
            ".cfm06162008", ".cfm_01_27_2010", ".backcfm", ".cfmold",
            ".copycfm", ".newcfm"
    ));

    public static void main(String[] args) {
        if (args.length == 0 || args.length > 2) {
            System.out.println("Usage: java CheckFileEncodings <path> [--fix]");
            System.exit(1);
        }

        boolean fixMode = args.length == 2 && args[1].equals("--fix");
        Path startPath = Paths.get(args[0]);

        if (!Files.exists(startPath)) {
            System.err.println("Path does not exist: " + startPath);
            System.exit(1);
        }

        try {
            if (Files.isDirectory(startPath)) {
                // Directory mode
                List<Path> filesToFix = new ArrayList<>();
                Files.walk(startPath)
                        .filter(Files::isRegularFile)
                        .filter(path -> isTextFile(path))
                        .forEach(file -> {
                            boolean hasIssue = checkFile(file, false);
                            if (hasIssue && fixMode) {
                                filesToFix.add(file);
                            }
                        });

                if (fixMode && !filesToFix.isEmpty()) {
                    System.out.println("\nFixing " + filesToFix.size() + " files...");
                    filesToFix.forEach(file -> fixFile(file));

                    System.out.println("\nVerifying fixed files...");
                    filesToFix.forEach(file -> checkFile(file, false));
                }
            } else {
                // Single file mode
                boolean hasIssue = checkFile(startPath, true);
                if (hasIssue && fixMode) {
                    System.out.println("\nAttempting to fix the file...");
                    fixFile(startPath);
                    System.out.println("\nVerifying fixed file...");
                    checkFile(startPath, true);
                }
            }
        } catch (IOException e) {
            System.err.println("Error processing path: " + e.getMessage());
        }
    }

    private static boolean isTextFile(Path path) {
        String fileName = path.getFileName().toString().toLowerCase();
        return TEXT_EXTENSIONS.stream()
                .anyMatch(ext -> fileName.endsWith(ext));
    }

    private static boolean checkFile(Path file, boolean verbose) {
        try {
            long fileSize = Files.size(file);
            if (fileSize <= 1) {
                System.out.println(file.toAbsolutePath() + " (Empty or too small: " + fileSize + " bytes)");
                return true;
            }

            byte[] bytes = Files.readAllBytes(file);
            boolean hasIssue = false;

            // Try UTF-8 decoding
            try {
                CharsetDecoder decoder = StandardCharsets.UTF_8.newDecoder()
                        .onMalformedInput(CodingErrorAction.REPORT)
                        .onUnmappableCharacter(CodingErrorAction.REPORT);
                decoder.decode(java.nio.ByteBuffer.wrap(bytes));
            } catch (CharacterCodingException e) {
                hasIssue = true;
                System.out.println(file.toAbsolutePath() + " (Not UTF-8 encoded)");
                if (verbose) {
                    String isoContent = new String(bytes, StandardCharsets.ISO_8859_1);
                    System.out.println("First 100 characters as ISO-8859-1:");
                    System.out.println(isoContent.substring(0, Math.min(100, isoContent.length())));
                }
            }

            // Additional binary content check
            String content = new String(bytes, StandardCharsets.ISO_8859_1);
            if (containsBinaryContent(content)) {
                System.out.println(file.toAbsolutePath() + " (Possible binary content)");
                hasIssue = true;
            }

            return hasIssue;

        } catch (IOException e) {
            System.out.println(file.toAbsolutePath() + " (Error: " + e.getMessage() + ")");
            return true;
        }
    }

    private static void fixFile(Path file) {
        try {
            byte[] bytes = Files.readAllBytes(file);

            // Create backup
            Path backupPath = Paths.get(file.toString() + ".bak");
            Files.copy(file, backupPath, StandardCopyOption.REPLACE_EXISTING);
            System.out.println("Created backup at: " + backupPath);

            // Convert from ISO-8859-1 to UTF-8
            String content = new String(bytes, StandardCharsets.ISO_8859_1);
            Files.write(file, content.getBytes(StandardCharsets.UTF_8));
            System.out.println("Converted to UTF-8: " + file);

        } catch (IOException e) {
            System.err.println("Error fixing file " + file + ": " + e.getMessage());
        }
    }

    private static boolean containsBinaryContent(String content) {
        int nonPrintable = 0;
        for (char c : content.toCharArray()) {
            if (c == 0) return true;
            if (c < 32 && c != 9 && c != 10 && c != 13) {
                nonPrintable++;
                if (nonPrintable > content.length() * 0.1) return true;
            }
        }
        return false;
    }
}