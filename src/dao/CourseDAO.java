package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Course;
import util.DBConnection;

public class CourseDAO {

    private Course extract(ResultSet rs) throws SQLException {
        Course c = new Course();
        c.setId(rs.getInt("id"));
        c.setCourseCode(rs.getString("course_code"));
        c.setCourseName(rs.getString("course_name"));
        c.setDuration(rs.getString("duration"));
        c.setDescription(rs.getString("description"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        return c;
    }

    public boolean addCourse(Course c) throws SQLException {
        String sql = "INSERT INTO courses (id, course_code, course_name, duration, description) "
                   + "VALUES (course_seq.NEXTVAL, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, c.getCourseCode());
            ps.setString(2, c.getCourseName());
            ps.setString(3, c.getDuration());
            ps.setString(4, c.getDescription());
            return ps.executeUpdate() > 0;
        }
    }

    public List<Course> getAllCourses() throws SQLException {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT id, course_code, course_name, duration, description, created_at "
                   + "FROM courses ORDER BY course_name";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(extract(rs));
        }
        return list;
    }

    public Course getCourseById(int id) throws SQLException {
        String sql = "SELECT id, course_code, course_name, duration, description, created_at "
                   + "FROM courses WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? extract(rs) : null;
            }
        }
    }

    /** Updates the course. If the course name changed, students of that course are updated too (one transaction). */
    public boolean updateCourse(Course c) throws SQLException {
        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                String oldName = null;
                try (PreparedStatement ps = con.prepareStatement("SELECT course_name FROM courses WHERE id = ?")) {
                    ps.setInt(1, c.getId());
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) oldName = rs.getString(1);
                    }
                }
                if (oldName == null) { con.rollback(); return false; }

                String sql = "UPDATE courses SET course_code = ?, course_name = ?, duration = ?, description = ? WHERE id = ?";
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setString(1, c.getCourseCode());
                    ps.setString(2, c.getCourseName());
                    ps.setString(3, c.getDuration());
                    ps.setString(4, c.getDescription());
                    ps.setInt(5, c.getId());
                    ps.executeUpdate();
                }
                if (!oldName.equals(c.getCourseName())) {
                    try (PreparedStatement ps = con.prepareStatement("UPDATE students SET course = ? WHERE course = ?")) {
                        ps.setString(1, c.getCourseName());
                        ps.setString(2, oldName);
                        ps.executeUpdate();
                    }
                }
                con.commit();
                return true;
            } catch (SQLException e) {
                con.rollback();
                throw e;
            }
        }
    }

    public boolean deleteCourse(int id) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("DELETE FROM courses WHERE id = ?")) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    public int countCourses() throws SQLException {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM courses");
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
}
