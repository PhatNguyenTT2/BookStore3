import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordGenerator {
  public static void main(String[] args) {
    BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
    String rawPassword = "admin123";
    String encodedPassword = encoder.encode(rawPassword);
    System.out.println("Password: " + rawPassword);
    System.out.println("BCrypt Hash: " + encodedPassword);

    // Test if hash matches
    boolean matches = encoder.matches(rawPassword, encodedPassword);
    System.out.println("Hash matches: " + matches);

    // Test existing hash
    String existingHash = "$2a$10$mfMZmgDH5qBqvwSTRLGQaeMZRWvvRrAzaAEy35uUgPG3JCtHmWzLm";
    boolean existingMatches = encoder.matches(rawPassword, existingHash);
    System.out.println("Existing hash matches admin123: " + existingMatches);
  }
}
