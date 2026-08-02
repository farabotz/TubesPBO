package com.tubespbo.classmate.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public final class Db {

    private static final String PROPS_PATH = "/db.properties";

    private static final Properties PROPS = new Properties();

    static {
        try (InputStream in = Db.class.getResourceAsStream(PROPS_PATH)) {
            if (in != null) {
                PROPS.load(in);
            }
        } catch (Exception ignored) {
            // keep defaults empty; connection will fail with clear message
        }

        // ensure driver is loaded (works for older JDBC environments)
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException ignored) {
        }
    }

    private Db() {
    }

    public static Connection getConnection() throws SQLException {
        String url = getenvOrProp("DB_URL", "db.url");
        String user = getenvOrProp("DB_USER", "db.user");
        String pass = getenvOrProp("DB_PASS", "db.pass");

        if (url == null || url.trim().isEmpty()) {
            throw new SQLException("DB URL tidak ditemukan. Set db.url di src/main/resources/db.properties atau env var DB_URL");
        }

        return DriverManager.getConnection(url, user, pass);
    }

    private static String getenvOrProp(String envName, String propName) {
        String env = System.getenv(envName);
        if (env != null && !env.trim().isEmpty()) {
            return env;
        }
        return PROPS.getProperty(propName);
    }
}
