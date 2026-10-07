package controller;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.regex.Pattern;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.CourseDAO;
import dao.StudentDAO;
import model.Course;
import model.Student;
import util.Util;

/**
 * One controller for all student operations.
 * GET  /students                  -> list all students
 * GET  /students?action=add       -> show add form
 * GET  /students?action=edit&id=  -> show edit form
 * GET  /students?action=view&id=  -> show student profile
 * GET  /students?action=search    -> search page / results
 * POST action=insert | update | delete
 */
@WebServlet("/students")
public class StudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final StudentDAO studentDAO = new StudentDAO();
    private final CourseDAO courseDAO = new CourseDAO();

    private static final Pattern EMAIL = Pattern.compile("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    private static final Pattern PHONE = Pattern.compile("^[0-9]{10}$");
    private static final Pattern SID = Pattern.compile("^[A-Za-z0-9-]{3,20}$");
    private static final Pattern NAME = Pattern.compile("^[A-Za-z .]{3,100}$");

    // ------------------------------------------------------------ GET
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";
        try {
            switch (action) {
                case "add":
                    req.setAttribute("courses", courseDAO.getAllCourses());
                    forward(req, resp, "/add-student.jsp");
                    break;

                case "edit":
                case "view": {
                    Student s = studentDAO.getStudentById(parseInt(req.getParameter("id")));
                    if (s == null) {
                        flash(req, "err", "Student not found.");
                        resp.sendRedirect(req.getContextPath() + "/students");
                        return;
                    }
                    req.setAttribute("student", s);
                    if (action.equals("edit")) {
                        req.setAttribute("courses", courseDAO.getAllCourses());
                        forward(req, resp, "/edit-student.jsp");
                    } else {
                        forward(req, resp, "/student-details.jsp");
                    }
                    break;
                }

                case "search": {
                    String type = Util.trim(req.getParameter("type"));
                    String keyword = Util.trim(req.getParameter("keyword"));
                    req.setAttribute("type", type);
                    req.setAttribute("keyword", keyword);
                    if (!keyword.isEmpty()) {
                        req.setAttribute("students", studentDAO.searchStudents(type, keyword));
                        req.setAttribute("searched", Boolean.TRUE);
                    }
                    forward(req, resp, "/search-student.jsp");
                    break;
                }

                default:
                    req.setAttribute("students", studentDAO.getAllStudents());
                    forward(req, resp, "/students.jsp");
            }
        } catch (SQLException e) {
            req.setAttribute("error", "Database error: " + e.getMessage());
            req.setAttribute("students", new ArrayList<Student>());
            forward(req, resp, "/students.jsp");
        }
    }

    // ------------------------------------------------------------ POST
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action") == null ? "" : req.getParameter("action");
        switch (action) {
            case "insert": save(req, resp, false); break;
            case "update": save(req, resp, true); break;
            case "delete": delete(req, resp); break;
            default: resp.sendRedirect(req.getContextPath() + "/students");
        }
    }

    private void save(HttpServletRequest req, HttpServletResponse resp, boolean update)
            throws ServletException, IOException {
        Student s = readForm(req);
        if (update) s.setId(parseInt(req.getParameter("id")));

        String error = validate(s);
        try {
            if (error == null) {
                boolean ok = update ? studentDAO.updateStudent(s) : studentDAO.addStudent(s);
                if (ok) {
                    flash(req, "msg", update ? "Student updated successfully." : "Student added successfully.");
                    resp.sendRedirect(req.getContextPath() + "/students");
                    return;
                }
                error = "Nothing was saved. The student may no longer exist.";
            }
        } catch (SQLException e) {
            // ORA-00001 = unique constraint violated (student_id or email already used)
            error = (e.getErrorCode() == 1) ? "Student ID or Email already exists."
                                            : "Database error: " + e.getMessage();
        }

        // Show the form again with the error and the values the admin typed
        try {
            req.setAttribute("courses", courseDAO.getAllCourses());
        } catch (SQLException e) {
            req.setAttribute("courses", new ArrayList<Course>());
        }
        req.setAttribute("student", s);
        req.setAttribute("error", error);
        forward(req, resp, update ? "/edit-student.jsp" : "/add-student.jsp");
    }

    private void delete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            boolean ok = studentDAO.deleteStudent(parseInt(req.getParameter("id")));
            if (ok) flash(req, "msg", "Student deleted successfully.");
            else flash(req, "err", "Student not found.");
        } catch (SQLException e) {
            flash(req, "err", "Database error: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/students");
    }

    // ------------------------------------------------------------ helpers
    private Student readForm(HttpServletRequest req) {
        Student s = new Student();
        s.setStudentId(Util.trim(req.getParameter("studentId")));
        s.setFullName(Util.trim(req.getParameter("fullName")));
        s.setEmail(Util.trim(req.getParameter("email")));
        s.setPhone(Util.trim(req.getParameter("phone")));
        s.setGender(Util.trim(req.getParameter("gender")));
        s.setDob(parseDate(req.getParameter("dob")));
        s.setCourse(Util.trim(req.getParameter("course")));
        s.setSemester(parseInt(req.getParameter("semester")));
        s.setAddress(Util.trim(req.getParameter("address")));
        s.setEnrollmentDate(parseDate(req.getParameter("enrollmentDate")));
        String status = Util.trim(req.getParameter("status"));
        s.setStatus(status.isEmpty() ? "Active" : status);
        return s;
    }

    /** Server-side validation. Returns an error message, or null when everything is valid. */
    private String validate(Student s) {
        if (!SID.matcher(s.getStudentId()).matches()) return "Student ID must be 3-20 letters, digits or hyphens.";
        if (!NAME.matcher(s.getFullName()).matches()) return "Full name must be 3-100 letters (spaces and dots allowed).";
        if (s.getEmail().length() > 100 || !EMAIL.matcher(s.getEmail()).matches()) return "Enter a valid email address.";
        if (!PHONE.matcher(s.getPhone()).matches()) return "Phone number must be exactly 10 digits.";
        if (!(s.getGender().equals("Male") || s.getGender().equals("Female") || s.getGender().equals("Other")))
            return "Select a gender.";
        if (s.getDob() == null) return "Enter a valid date of birth.";
        if (s.getDob().after(new java.util.Date())) return "Date of birth cannot be in the future.";
        if (s.getCourse().isEmpty()) return "Select a course.";
        if (s.getSemester() < 1 || s.getSemester() > 8) return "Semester must be between 1 and 8.";
        if (s.getAddress().isEmpty() || s.getAddress().length() > 300) return "Address is required (max 300 characters).";
        if (s.getEnrollmentDate() == null) return "Enter a valid enrollment date.";
        if (!(s.getStatus().equals("Active") || s.getStatus().equals("Inactive"))) return "Invalid status.";
        return null;
    }

    private int parseInt(String v) {
        try { return Integer.parseInt(v.trim()); } catch (Exception e) { return 0; }
    }

    private Date parseDate(String v) {
        try { return Date.valueOf(v.trim()); } catch (Exception e) { return null; }   // expects yyyy-MM-dd
    }

    private void flash(HttpServletRequest req, String key, String value) {
        req.getSession().setAttribute(key, value);
    }

    private void forward(HttpServletRequest req, HttpServletResponse resp, String page)
            throws ServletException, IOException {
        req.getRequestDispatcher(page).forward(req, resp);
    }
}
