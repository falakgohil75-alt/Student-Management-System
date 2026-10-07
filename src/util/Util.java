package util;

/** Small helper methods used by servlets and JSP pages. */
public class Util {

    /** Escapes HTML special characters (prevents XSS when printing data in JSP). */
    public static String esc(Object o) {
        if (o == null) return "";
        return String.valueOf(o).replace("&", "&amp;").replace("<", "&lt;")
                .replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    }

    public static String trim(String s) {
        return s == null ? "" : s.trim();
    }
}
