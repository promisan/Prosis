import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.nio.file.*;
import java.util.*;
import java.util.List;

public class CheckImages {

    private static final Set<String> IMAGE_EXTENSIONS = new HashSet<>(Arrays.asList(
            "gif", "ico", "jpg", "jpeg", "png", "bmp", "webp", "tiff", "tif", "svg",
            "apng", "heic", "heif", "avif", "jfif"
    ));


    private static final List<String> IGNORED_PATHS = Arrays.asList(
            "/Users/cesar/promi-universe/git/Prosis/Scripts/ammap/plugins/export/libs",
            "/Users/cesar/promi-universe/git/Prosis/OSS",
            "/Users/cesar/promi-universe/git/Prosis/System/Parameter/FunctionClass/dccom/components/dcFileManagerV3/actions"
    );

    private static final Set<String> IGNORED_FILES = new HashSet<>(Arrays.asList(
            "logo.png", "favicon.ico" // Add known safe or needed images
    ));

    public static void main(String[] args) {
        if (args.length == 0 || args.length > 2) {
            System.out.println("Usage: java CheckImages <path> [--fix]");
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
                    .filter(CheckImages::isImageFile)
                    .filter(CheckImages::isNotInIgnoredPaths)
                    .filter(CheckImages::isNotIgnoredFile)
                    .forEach(file -> {
                        try {
                            if (fixMode) {
                                replaceWithPlaceholder(file);
                            } else {
                                System.out.println("Image found: " + file);
                            }
                        } catch (IOException e) {
                            System.err.println("Error handling file: " + file + " – " + e.getMessage());
                        }
                    });
        } catch (IOException e) {
            System.err.println("Error walking directory: " + e.getMessage());
        }
    }

    private static boolean isImageFile(Path filePath) {
        String fileName = filePath.getFileName().toString().toLowerCase();
        return IMAGE_EXTENSIONS.stream().anyMatch(fileName::endsWith);
    }

    private static boolean isNotInIgnoredPaths(Path filePath) {
        String path = filePath.toAbsolutePath().toString().replace('\\', '/');
        return IGNORED_PATHS.stream().noneMatch(path::startsWith);
    }

    private static boolean isNotIgnoredFile(Path filePath) {
        return IGNORED_FILES.stream().noneMatch(filePath.getFileName().toString()::equalsIgnoreCase);
    }

    private static void replaceWithPlaceholder(Path imagePath) throws IOException {
        BufferedImage original;
        try {
            original = ImageIO.read(imagePath.toFile());
            if (original == null) {
                System.err.println("Not a readable image: " + imagePath);
                return;
            }
        } catch (Exception e) {
            System.err.println("Failed to open: " + imagePath);
            return;
        }

        int width = original.getWidth();
        int height = original.getHeight();
        BufferedImage placeholder = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);

        Graphics2D g2d = placeholder.createGraphics();
        g2d.setColor(Color.LIGHT_GRAY);
        g2d.fillRect(0, 0, width, height);
        g2d.setColor(Color.BLACK);
        g2d.setFont(new Font("Arial", Font.PLAIN, Math.max(12, width / 20)));
        g2d.drawString("Image Placeholder", 10, height / 2);
        g2d.dispose();

        File backup = new File(imagePath.toString() + ".bak");
        Files.copy(imagePath, backup.toPath(), StandardCopyOption.REPLACE_EXISTING);
        ImageIO.write(placeholder, getFormatName(imagePath), imagePath.toFile());
        System.out.println("✔ Replaced: " + imagePath);
    }

    private static String getFormatName(Path imagePath) {
        String fileName = imagePath.getFileName().toString().toLowerCase();
        for (String ext : IMAGE_EXTENSIONS) {
            if (fileName.endsWith("." + ext)) return ext;
        }
        return "png"; // fallback
    }
}
