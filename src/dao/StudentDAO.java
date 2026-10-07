package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Student;
import util.DBConnection;

public class StudentDAO {

    private static final String COLUMNS =
        "id, student_id, full_name, email, phone, gender, dob, course, semester, address, enrollment_date, status, created_at";

    /** Converts one row of the ResultSet into a Student JavaBean. */
    private Student extract(ResultSet rs) throws SQLException {
        Student s = new Student();
        s.setId(rs.getInt("id"));
        s.setStudentId(rs.getString("student_id"));
        s.setFullName(rs.getString("full_name"));
        s.setEmail(rs.getString("email"));
        s.setPhone(rs.getString("phone"));
        s.setGender(rs.getString("gender"));
        s.setDob(rs.getDate("dob"));
        s.setCourse(rs.getString("course"));
        s.setSemester(rs.getInt("semester"));
        s.setAddress(rs.getString("address"));
        s.setEnrollmentDate(rs.getDate("enrollment_date"));
        s.setStatus(rs.getString("status"));
        s.setCreatedAt(rs.getTimestamp("created_at"));
        return s;
    }

    /** Sets the 11 common parameters used by INSERT and UPDATE. */
    private void setParams(PreparedStatement ps, Student s) throws SQLException {
        ps.setString(1, s.getStudentId());
        ps.setString(2, s.getFullName());
        ps.setString(3, s.getEmail());
        ps.setString(4, s.getPhone());
        ps.setString(5, s.getGender());
        ps.setDate(6, s.getDob());
        ps.setString(7, s.getCourse());
        ps.setInt(8, s.getSemester());
        ps.setString(9, s.getAddress());
        ps.setDate(10, s.getEnrollmentDate());
        ps.setString(11, s.getStatus());
    }

    /** Runs a SELECT that returns students; params are bound with PreparedStatement. */
    private List<Student> query(String sql, Object... params) throws SQLException {
        List<Student> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) ps.setObject(i + 1, params[i]);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(extract(rs));
            }
        }
        return list;
    }

    private int count(String sql) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // ---------- CREATE ----------
    public boolean addStudent(Student s) throws SQLException {
        String sql = "INSERT INTO students (id, student_id, full_name, email, phone, gender, dob, course, "
                   + "semester, address, enrollment_date, status) "
                   + "VALUES (student_seq.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            setParams(ps, s);
            return ps.executeUpdate() > 0;
        }
    }

    // ---------- READ ----------
    public List<Student> getAllStudents() throws SQLException {
        return query("SELECT " + COLUMNS + " FROM students ORDER BY id DESC");
    }

    public Student getStudentById(int id) throws SQLException {
        List<Student> list = query("SELECT " + COLUMNS + " FROM students WHERE id = ?", id);
        return list.isEmpty() ? null : list.get(0);
    }

    /** Latest n students (ROWNUM works on every Oracle version). */
    public List<Student> getRecentStudents(int n) throws SQLException {
        return query("SELECT * FROM (SELECT " + COLUMNS + " FROM students ORDER BY id DESC) WHERE ROWNUM <= ?", n);
    }

    // ---------- UPDATE ----------
    public boolean updateStudent(Student s) throws SQLException {
        String sql = "UPDATE students SET student_id = ?, full_name = ?, email = ?, phone = ?, gender = ?, "
                   + "dob = ?, course = ?, semester = ?, address = ?, enrollment_date = ?, status = ? WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            setParams(ps, s);
            ps.setInt(12, s.getId());
            return ps.executeUpdate() > 0;
        }
    }

    // ---------- DELETE ----------
    public boolean deleteStudent(int id) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("DELETE FROM students WHERE id = ?")) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    // ---------- SEARCH ----------
    /** type = student_id | name | email | course | all. Column names come from a fixed list (never from user input). */
    public List<Student> searchStudents(String type, String keyword) throws SQLException {
        String like = "%" + keyword.toLowerCase() + "%";
        String column;
        switch (type == null ? "all" : type) {
            case "student_id": column = "student_id"; break;
            case "name":       column = "full_name";  break;
            case "email":      column = "email";      break;
            case "course":     column = "course";     break;
            default:           column = null;
        }
        if (column != null) {
            return query("SELECT " + COLUMNS + " FROM students WHERE LOWER(" + column + ") LIKE ? ORDER BY id DESC", like);
        }
        return query("SELECT " + COLUMNS + " FROM students WHERE LOWER(student_id) LIKE ? OR LOWER(full_name) LIKE ? "
                   + "OR LOWER(email) LIKE ? OR LOWER(course) LIKE ? ORDER BY id DESC", like, like, like, like);
    }

    // ---------- DASHBOARD COUNTS ----------
    public int countStudents() throws SQLException {
        return count("SELECT COUNT(*) FROM students");
    }

    public int countActiveStudents() throws SQLException {
        return count("SELECT COUNT(*) FROM students WHERE status = 'Active'");
    }
}
