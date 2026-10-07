package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.regex.Pattern;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.CourseDAO;
import model.Course;
import util.Util;

/**
 * GET  /courses                 -> list courses
 * GET  /courses?action=add      -> add form
 * GET  /courses?action=edit&id= -> edit form
 * POST action=insert | update | delete
 */
@WebServlet("/courses")
public class CourseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final CourseDAO courseDAO = new CourseDAO();
    private static final Pattern CODE = Pattern.compile("^[A-Za-z0-9-]{2,20}$");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";
        try {
            switch (action) {
                case "add":
                    forward(req, resp, "/add-course.jsp");
                    break;
                case "edit": {
                    Course c = courseDAO.getCourseById(parseInt(req.getParameter("id")));
                    if (c == null) {
                        req.getSession().setAttribute("err", "Course not found.");
                        resp.sendRedirect(req.getContextPath() + "/courses");
                        return;
                    }
                    req.setAttribute("course", c);
                    forward(req, resp, "/edit-course.jsp");
                    break;
                }
                default:
                    req.setAttribute("courses", courseDAO.getAllCourses());
                    forward(req, resp, "/courses.jsp");
            }
        } catch (SQLException e) {
            req.setAttribute("error", "Database error: " + e.getMessage());
            req.setAttribute("courses", new ArrayList<Course>());
            forward(req, resp, "/courses.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action") == null ? "" : req.getParameter("action");
        switch (action) {
            case "insert": save(req, resp, false); break;
            case "update": save(req, resp, true); break;
            case "delete": delete(req, resp); break;
            default: resp.sendRedirect(req.getContextPath() + "/courses");
        }
    }

    private void save(HttpServletRequest req, HttpServletResponse resp, boolean update)
            throws ServletException, IOException {
        Course c = new Course();
        c.setCourseCode(Util.trim(req.getParameter("courseCode")).toUpperCase());
        c.setCourseName(Util.trim(req.getParameter("courseName")));
        c.setDuration(Util.trim(req.getParameter("duration")));
        c.setDescription(Util.trim(req.getParameter("description")));
        if (update) c.setId(parseInt(req.getParameter("id")));

        String error = validate(c);
        try {
            if (error == null) {
                boolean ok = update ? courseDAO.updateCourse(c) : courseDAO.addCourse(c);
                if (ok) {
                    req.getSession().setAttribute("msg", update ? "Course updated successfully." : "Course added successfully.");
                    resp.sendRedirect(req.getContextPath() + "/courses");
                    return;
                }
                error = "Nothing was saved. The course may no longer exist.";
            }
        } catch (SQLException e) {
            error = (e.getErrorCode() == 1) ? "Course code already exists." : "Database error: " + e.getMessage();
        }
        req.setAttribute("course", c);
        req.setAttribute("error", error);
        forward(req, resp, update ? "/edit-course.jsp" : "/add-course.jsp");
    }

    private void delete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            boolean ok = courseDAO.deleteCourse(parseInt(req.getParameter("id")));
            req.getSession().setAttribute(ok ? "msg" : "err", ok ? "Course deleted successfully." : "Course not found.");
        } catch (SQLException e) {
            req.getSession().setAttribute("err", "Database error: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/courses");
    }

    private String validate(Course c) {
        if (!CODE.matcher(c.getCourseCode()).matches()) return "Course code must be 2-20 letters, digits or hyphens.";
        if (c.getCourseName().length() < 3 || c.getCourseName().length() > 100) return "Course name must be 3-100 characters.";
        if (c.getDuration().isEmpty() || c.getDuration().length() > 50) return "Duration is required (e.g. 3 Years).";
        if (c.getDescription().length() > 500) return "Description can be at most 500 characters.";
        return null;
    }

    private int parseInt(String v) {
        try { return Integer.parseInt(v.trim()); } catch (Exception e) { return 0; }
    }

    private void forward(HttpServletRequest req, HttpServletResponse resp, String page)
            throws ServletException, IOException {
        req.getRequestDispatcher(page).forward(req, resp);
    }
}
