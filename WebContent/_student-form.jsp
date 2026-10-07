<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, model.*, util.Util" %>
<%
    String ctx = request.getContextPath();
    boolean edit = "edit".equals(request.getParameter("mode"));
    Student s = (Student) request.getAttribute("student");
    if (s == null) { s = new Student(); s.setStatus("Active"); }
    @SuppressWarnings("unchecked")
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    if (courses == null) courses = new ArrayList<Course>();

    // Is the student's current course still in the course list? (it may have been deleted)
    boolean courseFound = false;
    for (Course c : courses) { if (c.getCourseName().equals(s.getCourse())) courseFound = true; }
    String g = s.getGender() == null ? "" : s.getGender();
    String st = s.getStatus() == null ? "Active" : s.getStatus();
%>
<form class="needs-validation" method="post" action="<%=ctx%>/students" novalidate>
  <input type="hidden" name="action" value="<%= edit ? "update" : "insert" %>">
  <% if (edit) { %><input type="hidden" name="id" value="<%= s.getId() %>"><% } %>

  <div class="form-grid">
    <div class="form-group">
      <label for="studentId">Student ID</label>
      <input type="text" id="studentId" name="studentId" value="<%= Util.esc(s.getStudentId()) %>"
             required pattern="[A-Za-z0-9\-]{3,20}" maxlength="20" title="3-20 letters, digits or hyphens (e.g. S1003)">
      <small class="field-error"></small>
    </div>
    <div class="form-group">
      <label for="fullName">Full name</label>
      <input type="text" id="fullName" name="fullName" value="<%= Util.esc(s.getFullName()) %>"
             required pattern="[A-Za-z .]{3,100}" maxlength="100" title="3-100 letters (spaces and dots allowed)">
      <small class="field-error"></small>
    </div>
    <div class="form-group">
      <label for="email">Email</label>
      <input type="email" id="email" name="email" value="<%= Util.esc(s.getEmail()) %>"
             required maxlength="100" title="Enter a valid email address">
      <small class="field-error"></small>
    </div>
    <div class="form-group">
      <label for="phone">Phone</label>
      <input type="tel" id="phone" name="phone" value="<%= Util.esc(s.getPhone()) %>"
             required pattern="[0-9]{10}" maxlength="10" title="Phone number must be exactly 10 digits">
      <small class="field-error"></small>
    </div>
    <div class="form-group">
      <label for="gender">Gender</label>
      <select id="gender" name="gender" required title="Select a gender">
        <option value="">Select gender</option>
        <option value="Male" <%= g.equals("Male") ? "selected" : "" %>>Male</option>
        <option value="Female" <%= g.equals("Female") ? "selected" : "" %>>Female</option>
        <option value="Other" <%= g.equals("Other") ? "selected" : "" %>>Other</option>
      </select>
      <small class="field-error"></small>
    </div>
    <div class="form-group">
      <label for="dob">Date of birth</label>
      <input type="date" id="dob" name="dob" value="<%= s.getDob() == null ? "" : s.getDob().toString() %>"
             required title="Select a valid date of birth (not in the future)">
      <small class="field-error"></small>
    </div>
    <div class="form-group">
      <label for="course">Course</label>
      <select id="course" name="course" required title="Select a course">
        <option value="">Select course</option>
        <% for (Course c : courses) { %>
          <option value="<%= Util.esc(c.getCourseName()) %>" <%= c.getCourseName().equals(s.getCourse()) ? "selected" : "" %>><%= Util.esc(c.getCourseName()) %></option>
        <% } %>
        <% if (!courseFound && s.getCourse() != null && !s.getCourse().isEmpty()) { %>
          <option value="<%= Util.esc(s.getCourse()) %>" selected><%= Util.esc(s.getCourse()) %></option>
        <% } %>
      </select>
      <small class="field-error"></small>
      <% if (courses.isEmpty()) { %><small>No courses yet. <a href="<%=ctx%>/courses?action=add"><u>Add a course first</u></a>.</small><% } %>
    </div>
    <div class="form-group">
      <label for="semester">Semester</label>
      <select id="semester" name="semester" required title="Select a semester">
        <option value="">Select semester</option>
        <% for (int i = 1; i <= 8; i++) { %>
          <option value="<%= i %>" <%= s.getSemester() == i ? "selected" : "" %>>Semester <%= i %></option>
        <% } %>
      </select>
      <small class="field-error"></small>
    </div>
    <div class="form-group">
      <label for="enrollmentDate">Enrollment date</label>
      <input type="date" id="enrollmentDate" name="enrollmentDate"
             value="<%= s.getEnrollmentDate() == null ? "" : s.getEnrollmentDate().toString() %>"
             required title="Select the enrollment date">
      <small class="field-error"></small>
    </div>
    <div class="form-group">
      <label for="status">Status</label>
      <select id="status" name="status" required>
        <option value="Active" <%= st.equals("Active") ? "selected" : "" %>>Active</option>
        <option value="Inactive" <%= st.equals("Inactive") ? "selected" : "" %>>Inactive</option>
      </select>
      <small class="field-error"></small>
    </div>
    <div class="form-group full">
      <label for="address">Address</label>
      <textarea id="address" name="address" required maxlength="300" title="Address is required (max 300 characters)"><%= Util.esc(s.getAddress()) %></textarea>
      <small class="field-error"></small>
    </div>
  </div>

  <div class="form-actions">
    <button type="submit" class="btn"><%= edit ? "Save changes" : "Add student" %></button>
    <a class="btn btn-light" href="<%=ctx%>/students">Cancel</a>
  </div>
</form>
