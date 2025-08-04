import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.*;

public class LicenseScanner {

    private static final Set<String> THIRD_PARTY_LICENSES = new HashSet<>(Arrays.asList(
            "MIT License",
            "BSD License",
            "Apache License",
            "Apache License, Version 2.0",
            "ISC License",
            "CC0",
            "Public Domain",
            "Unlicense"
    ));

    private static final Set<String> RESTRICTIVE_LICENSES = new HashSet<>(Arrays.asList(
            "GNU General Public License",
            "GNU GPL",
            "GNU Affero General Public License",
            "GNU AGPL",
            "GNU Lesser General Public License",
            "LGPL",
            "Eclipse Public License",
            "MPL",
            "Creative Commons Attribution-NonCommercial",
            "CC BY-NC"
    ));

    private static final Set<String> EXCLUDED_EXTENSIONS = Set.of(
            ".zip", ".bin", ".cfr", ".class", ".eot", ".fla", ".gif", ".ico", ".idx", ".jar", ".jbf",
            ".jpg", ".otf", ".pack", ".pdf", ".png", ".psd", ".rep", ".scssc", ".swf", ".template",
            ".ttf", ".vsd", ".woff", ".woff2"
    );

    private static final Set<String> EXCLUDED_FILENAMES = Set.of(
            "ValidationScript.cfm", "RecordDialog.cfm", ".gitattributes", ".gitignore", ".sdkmanrc", "LicenseScanner.java"
    );

    public static void main(String[] args) {
        if (args.length < 1 || args.length > 3) {
            System.err.println("Usage: java LicenseScanner <directory_path> [--verbose] [--license=\"LICENSE_NAME\"]");
            System.exit(1);
        }

        File root = new File(args[0]);
        if (!root.isDirectory()) {
            System.err.println("The provided path is not a directory.");
            System.exit(1);
        }

        boolean verbose = false;
        String filterLicense = null;

        for (int i = 1; i < args.length; i++) {
            if (args[i].equalsIgnoreCase("--verbose")) {
                verbose = true;
            } else if (args[i].startsWith("--license=")) {
                filterLicense = args[i].substring("--license=".length()).replaceAll("^\"|\"$", "");
            }
        }

        Map<String, Set<String>> thirdPartyMatches = new TreeMap<>();
        Map<String, Set<String>> restrictiveMatches = new TreeMap<>();

        scanDirectory(root, thirdPartyMatches, restrictiveMatches);

        printResults("Third-Party Licenses", thirdPartyMatches, verbose, filterLicense);
        printResults("Restrictive Licenses", restrictiveMatches, verbose, filterLicense);
    }

    private static void scanDirectory(File dir, Map<String, Set<String>> thirdPartyMatches, Map<String, Set<String>> restrictiveMatches) {
        File[] files = dir.listFiles();
        if (files == null) return;

        for (File file : files) {
            if (file.isDirectory()) {
                scanDirectory(file, thirdPartyMatches, restrictiveMatches);
            } else {
                if (shouldExclude(file)) continue;

                try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        for (String license : THIRD_PARTY_LICENSES) {
                            if (line.contains(license)) {
                                thirdPartyMatches.computeIfAbsent(license, k -> new TreeSet<>()).add(file.getAbsolutePath());
                            }
                        }
                        for (String license : RESTRICTIVE_LICENSES) {
                            if (line.contains(license)) {
                                restrictiveMatches.computeIfAbsent(license, k -> new TreeSet<>()).add(file.getAbsolutePath());
                            }
                        }
                    }
                } catch (IOException e) {
                    System.err.println("Error reading file: " + file.getAbsolutePath());
                }
            }
        }
    }

    private static boolean shouldExclude(File file) {
        String name = file.getName();
        String lowerName = name.toLowerCase();

        if (EXCLUDED_FILENAMES.contains(name)) return true;
        for (String ext : EXCLUDED_EXTENSIONS) {
            if (lowerName.endsWith(ext.toLowerCase())) return true;
        }
        return false;
    }

    private static void printResults(String title, Map<String, Set<String>> matches, boolean verbose, String filterLicense) {
        if (filterLicense != null && !matches.containsKey(filterLicense)) return;

        System.out.println(title + ":");
        for (Map.Entry<String, Set<String>> entry : matches.entrySet()) {
            if (filterLicense != null && !entry.getKey().equalsIgnoreCase(filterLicense)) continue;
            System.out.println("- " + entry.getKey());
            if (verbose) {
                for (String file : entry.getValue()) {
                    System.out.println("    " + file);
                }
            }
        }
        System.out.println();
    }
}
