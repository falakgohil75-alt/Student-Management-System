package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.CourseDAO;
import dao.StudentDAO;
import model.Student;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final StudentDAO studentDAO = new StudentDAO();
    private final CourseDAO courseDAO = new CourseDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            req.setAttribute("totalStudents", studentDAO.countStudents());
            req.setAttribute("totalCourses", courseDAO.countCourses());
            req.setAttribute("activeStudents", studentDAO.countActiveStudents());
            req.setAttribute("recentStudents", studentDAO.getRecentStudents(5));
        } catch (SQLException e) {
            req.setAttribute("error", "Database error: " + e.getMessage());
            req.setAttribute("totalStudents", 0);
            req.setAttribute("totalCourses", 0);
            req.setAttribute("activeStudents", 0);
            req.setAttribute("recentStudents", new ArrayList<Student>());
        }
        req.getRequestDispatcher("/dashboard.jsp").forward(req, resp);
    }
}
