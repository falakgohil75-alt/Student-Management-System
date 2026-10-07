<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Student, util.Util" %>
<%
    String ctx = request.getContextPath();
    Student s = (Student) request.getAttribute("student");
    if (s == null) { response.sendRedirect(ctx + "/students"); return; }
    String initial = s.getFullName() != null && !s.getFullName().isEmpty() ? s.getFullName().substring(0, 1).toUpperCase() : "?";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Student Details - Student Management System</title>
  <link rel="stylesheet" href="<%=ctx%>/css/style.css">
</head>
<body>
<div class="layout">
  <jsp:include page="_sidebar.jsp"><jsp:param name="active" value="students"/></jsp:include>
  <main class="content">
    <div class="page-head">
      <div><h1>Student details</h1><p>Complete profile.</p></div>
      <div class="actions">
        <a class="btn btn-light" href="<%=ctx%>/students">Back to students</a>
        <a class="btn btn-warn" href="<%=ctx%>/students?action=edit&id=<%= s.getId() %>">Edit</a>
      </div>
    </div>
    <jsp:include page="_alerts.jsp"/>
    <div class="card">
      <div class="profile-head">
        <div class="avatar"><%= Util.esc(initial) %></div>
        <div>
          <h2><%= Util.esc(s.getFullName()) %></h2>
          <span class="badge <%= Util.esc(s.getStatus()) %>"><%= Util.esc(s.getStatus()) %></span>
          &nbsp; <%= Util.esc(s.getCourse()) %>, semester <%= s.getSemester() %>
        </div>
      </div>
      <div class="detail-grid">
        <div class="detail"><small>Student ID</small><span><%= Util.esc(s.getStudentId()) %></span></div>
        <div class="detail"><small>Email</small><span><%= Util.esc(s.getEmail()) %></span></div>
        <div class="detail"><small>Phone</small><span><%= Util.esc(s.getPhone()) %></span></div>
        <div class="detail"><small>Gender</small><span><%= Util.esc(s.getGender()) %></span></div>
        <div class="detail"><small>Date of birth</small><span><%= s.getDob() %></span></div>
        <div class="detail"><small>Course</small><span><%= Util.esc(s.getCourse()) %></span></div>
        <div class="detail"><small>Semester</small><span><%= s.getSemester() %></span></div>
        <div class="detail"><small>Enrollment date</small><span><%= s.getEnrollmentDate() %></span></div>
        <div class="detail"><small>Record created</small><span><%= s.getCreatedAt() == null ? "" : s.getCreatedAt().toString().substring(0, 16) %></span></div>
        <div class="detail" style="grid-column: 1 / -1;"><small>Address</small><span><%= Util.esc(s.getAddress()) %></span></div>
      </div>
    </div>
  </main>
</div>
<script src="<%=ctx%>/js/script.js"></script>
</body>
</html>
