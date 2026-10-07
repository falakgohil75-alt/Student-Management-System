package model;

import java.sql.Date;
import java.sql.Timestamp;

public class Student {
    private int id;                 // column: id
    private String studentId;       // column: student_id
    private String fullName;        // column: full_name
    private String email;           // column: email
    private String phone;           // column: phone
    private String gender;          // column: gender
    private Date dob;               // column: dob
    private String course;          // column: course
    private int semester;           // column: semester
    private String address;         // column: address
    private Date enrollmentDate;    // column: enrollment_date
    private String status;          // column: status
    private Timestamp createdAt;    // column: created_at

    public Student() {}
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getStudentId() { return studentId; }
    public void setStudentId(String studentId) { this.studentId = studentId; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    public Date getDob() { return dob; }
    public void setDob(Date dob) { this.dob = dob; }
    public String getCourse() { return course; }
    public void setCourse(String course) { this.course = course; }
    public int getSemester() { return semester; }
    public void setSemester(int semester) { this.semester = semester; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public Date getEnrollmentDate() { return enrollmentDate; }
    public void setEnrollmentDate(Date enrollmentDate) { this.enrollmentDate = enrollmentDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
