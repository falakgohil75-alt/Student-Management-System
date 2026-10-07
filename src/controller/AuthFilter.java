package controller;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;

/** Runs before every request. Only logged-in admins may open protected pages. */
@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String path = request.getRequestURI().substring(request.getContextPath().length());
        boolean publicPage = path.equals("/") || path.equals("/login") || path.equals("/login.jsp")
                || path.equals("/index.jsp") || path.equals("/error.jsp")
                || path.startsWith("/css/") || path.startsWith("/js/");

        HttpSession session = request.getSession(false);
        boolean loggedIn = session != null && session.getAttribute("admin") != null;

        // Stop the browser from showing cached pages after logout (Back button)
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        if (publicPage || loggedIn) {
            chain.doFilter(req, res);
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }
}
