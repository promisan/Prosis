import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.util.*;
import java.util.regex.*;

public class CheckAuthors {

    private static final Set<String> TEXT_EXTENSIONS = new HashSet<>(Arrays.asList(
            ".cfm", ".cfc", ".txt", ".java", ".xml", ".html", ".htm", ".css", ".js", ".json",
            ".md", ".yml", ".sh", ".php", ".csv", ".log", ".cfm06162008", ".cfm_01_27_2010",
            ".backcfm", ".cfmold", ".copycfm", ".newcfm"
    ));

    private static final List<Pattern> AUTHOR_PATTERNS = Arrays.asList(
            Pattern.compile("[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+"), // general email
            Pattern.compile("[a-zA-Z0-9_.+-]+@promisan.com"),
            Pattern.compile("[a-zA-Z0-9_.+-]+@un.org"),
            Pattern.compile("info@promisan.com"),
            Pattern.compile("noreply@promisan.com"),
            Pattern.compile("information@promisan.com"),
            Pattern.compile("(?i)(jmazariegos|jorge|mazariegos|armin|jbatres|nery|hvanpelt|bvpromisa|oppba|kyriacou|barreiro|vanpelt|eybi('|s)?|dr\\.\\s*jorge\\s*manuel\\s*aldana\\s*saenz)")
    );

    private static final Pattern KNOWN_USERS_PATTERN = Pattern.compile(
            "(?i)(jmazariegos|jorge|mazariegos|armin|jbatres|nery|hvanpelt|bvpromisa|oppba|kyriacou|barreiro|vanpelt|eybi('|s)?|dr\\.\\s*jorge\\s*manuel\\s*aldana\\s*saenz)"
    );

    private static final List<String> IGNORED_PATTERNS = Arrays.asList(
            "username=\"#SESSION.logi", "ById"
    );

    private static final List<String> IGNORED_PATHS = Arrays.asList(
            "/Users/kulbilal/promi-universe/git/Prosis/Scripts/ammap/plugins/export/libs",
            "/Users/kulbilal/promi-universe/git/Prosis/OSS",
            "/Users/kulbilal/promi-universe/git/Prosis/System/Parameter/FunctionClass/dccom/components/dcFileManagerV3/actions",
            "/Users/kulbilal/promi-universe/git/Prosis/Scripts/Mobile/Resources/vendor/jquery-ui/",
            "/Users/kulbilal/promi-universe/git/Prosis/Scripts/Mobile/Resources/vendor/jquery-flot/examples/axes-time-zones/",
            "/Users/kulbilal/promi-universe/git/Prosis/Scripts/Mobile/Resources/vendor/datatables_plugins/pagination/jPaginator/",
            "/Users/kulbilal/promi-universe/git/Prosis/Scripts/Mobile/Resources/vendor/chartjs/",
            "/Users/kulbilal/promi-universe/git/Prosis/Scripts/Mobile/Resources/vendor/select2-3.5.2/",
            "/Users/kulbilal/promi-universe/git/Prosis/Scripts/TextArea/CK/basic",
            "/Users/kulbilal/promi-universe/git/Prosis/Scripts/Mobile/Resources/vendor/sweetalert/",
            "/Users/kulbilal/promi-universe/git/Prosis/Scripts/TextArea/CK/full/plugins/exportpdf/",
            "/Users/kulbilal/promi-universe/git/Prosis/Scripts/TextArea/CK/full",
            "/Users/kulbilal/promi-universe/git/Prosis/Scripts/jQuery/",
            "/Users/kulbilal/promi-universe/git/Prosis/Scripts/Mobile/Resources/vendor/summernote",
            "/Users/kulbilal/promi-universe/git/Prosis/Scripts/Mobile/Resources/vendor/moment/min/",
            "/Users/kulbilal/promi-universe/git/Prosis/Scripts/Mobile/Resources/vendor/moment/locale",
            "/Users/kulbilal/promi-universe/git/Prosis/Scripts/Mobile/Resources/vendor/bootstrap-star-rating",
            "/Users/kulbilal/promi-universe/git/Prosis/Scripts/TextArea/CK/standard/",
            "/Users/kulbilal/promi-universe/git/Prosis/Scripts/TextArea/CK/standard",
            "/Users/kulbilal/promi-universe/git/Prosis/Scripts/Mobile/Resources/vendor/iCheck/",
            "/Users/kulbilal/promi-universe/git/Prosis/Scripts/ammap/plugins/export/",
            "/Users/kulbilal/promi-universe/git/Prosis/Scripts/ammap/plugins/"

    );

    public static void main(String[] args) {
        if (args.length == 0 || args.length > 2) {
            System.out.println("Usage: java CheckAuthors <path> [--fix]");
            System.exit(1);
        }

        boolean fixMode = args.length == 2 && args[1].equals("--fix");
        Path rootPath = Paths.get(args[0]);

        if (!Files.exists(rootPath)) {
            System.err.println("Path does not exist: " + rootPath);
            System.exit(1);
        }

        try {
            Files.walk(rootPath)
                    .filter(Files::isRegularFile)
                    .filter(CheckAuthors::isTextFile)
                    .filter(CheckAuthors::isNotInIgnoredPaths)
                    .forEach(file -> {
                        try {
                            boolean found = scanFile(file, fixMode);
                            if (!fixMode && found) {
                                System.out.println();
                            }
                        } catch (IOException e) {
                            System.err.println("Failed to process " + file + ": " + e.getMessage());
                        }
                    });
        } catch (IOException e) {
            System.err.println("Error walking directory: " + e.getMessage());
        }
    }

    private static boolean isTextFile(Path filePath) {
        String name = filePath.getFileName().toString().toLowerCase();
        return TEXT_EXTENSIONS.stream().anyMatch(name::endsWith);
    }

    private static boolean isNotInIgnoredPaths(Path filePath) {
        String path = filePath.toAbsolutePath().toString().replace('\\', '/');
        return IGNORED_PATHS.stream().noneMatch(path::startsWith);
    }

    private static boolean scanFile(Path filePath, boolean fixMode) throws IOException {
        List<String> lines = Files.readAllLines(filePath, StandardCharsets.ISO_8859_1);
        List<String> updatedLines = new ArrayList<>();
        boolean found = false;

        for (int i = 0; i < lines.size(); i++) {
            String line = lines.get(i);
            String updated = line;

            if (filePath.toString().toLowerCase().endsWith(".css")) {
                updatedLines.add(line);
                continue;
            }

            boolean ignoredLine = IGNORED_PATTERNS.stream().anyMatch(line::contains);
            if (ignoredLine) {
                updatedLines.add(line);
                continue;
            }

            for (Pattern pattern : AUTHOR_PATTERNS) {
                Matcher matcher = pattern.matcher(updated);
                StringBuffer sb = new StringBuffer();

                while (matcher.find()) {
                    String match = matcher.group().trim();
                    found = true;
                    System.out.println(filePath + " [line " + (i + 1) + "] match: \"" + match + "\"");

                    if (fixMode) {
                        if (match.contains("@")) {
                            matcher.appendReplacement(sb, "dev@email");
                        } else if (KNOWN_USERS_PATTERN.matcher(match).find()) {
                            matcher.appendReplacement(sb, "dev");
                        } else {
                            matcher.appendReplacement(sb, "developer-id");
                        }
                    }
                }

                if (fixMode && found) {
                    matcher.appendTail(sb);
                    updated = sb.toString();
                }
            }

            updatedLines.add(updated);
        }

        if (fixMode && found) {
            Path backup = filePath.resolveSibling(filePath.getFileName() + ".bak");
            Files.copy(filePath, backup, StandardCopyOption.REPLACE_EXISTING);
            Files.write(filePath, updatedLines, StandardCharsets.ISO_8859_1);
            System.out.println("→ Updated: " + filePath + " (Backup: " + backup + ")");
        }

        return found;
    }
}
