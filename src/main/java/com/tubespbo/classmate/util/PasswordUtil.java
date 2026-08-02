package com.tubespbo.classmate.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public final class PasswordUtil {

    private static final SecureRandom RNG = new SecureRandom();

    private PasswordUtil() {
    }

    // Format: pbkdf2$<iters>$<base64salt>$<base64hash>
    public static String hashPbkdf2(String password) {
        int iters = 120_000;
        byte[] salt = new byte[16];
        RNG.nextBytes(salt);
        byte[] dk = pbkdf2(password, salt, iters, 32);
        return "pbkdf2$" + iters + "$" + Base64.getEncoder().encodeToString(salt) + "$" + Base64.getEncoder().encodeToString(dk);
    }

    public static boolean verify(String password, String stored) {
        if (stored == null) {
            return false;
        }
        if (!stored.startsWith("pbkdf2$")) {
            // fallback: treat as plaintext (for legacy), but compare safely
            return MessageDigest.isEqual(
                    password.getBytes(StandardCharsets.UTF_8),
                    stored.getBytes(StandardCharsets.UTF_8)
            );
        }

        String[] parts = stored.split("\\$");
        if (parts.length != 4) {
            return false;
        }

        int iters;
        try {
            iters = Integer.parseInt(parts[1]);
        } catch (NumberFormatException e) {
            return false;
        }

        byte[] salt;
        byte[] expected;
        try {
            salt = Base64.getDecoder().decode(parts[2]);
            expected = Base64.getDecoder().decode(parts[3]);
        } catch (IllegalArgumentException e) {
            return false;
        }

        byte[] actual = pbkdf2(password, salt, iters, expected.length);
        return MessageDigest.isEqual(expected, actual);
    }

    private static byte[] pbkdf2(String password, byte[] salt, int iterations, int dkLen) {
        try {
            PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, iterations, dkLen * 8);
            SecretKeyFactory skf = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
            return skf.generateSecret(spec).getEncoded();
        } catch (Exception e) {
            throw new IllegalStateException("PBKDF2 gagal", e);
        }
    }
}
