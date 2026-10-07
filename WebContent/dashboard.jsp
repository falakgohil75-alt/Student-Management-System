<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Student, util.Util" %>
<%
    String ctx = request.getContextPath();
    if (request.getAttribute("totalStudents") == null) { response.sendRedirect(ctx + "/dashboard"); return; }
    int totalStudents = (Integer) request.getAttribute("totalStudents");
    int totalCourses  = (Integer) request.getAttribute("totalCourses");
    int activeStudents = (Integer) request.getAttribute("activeStudents");
    @SuppressWarnings("unchecked")
    List<Student> recent = (List<Student>) request.getAttribute("recentStudents");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dashboard - Student Management System</title>
  <link rel="stylesheet" href="<%=ctx%>/css/style.css">
</head>
<body>
<div class="layout">
  <jsp:include page="_sidebar.jsp"><jsp:param name="active" value="dashboard"/></jsp:include>
  <main class="content">
    <div class="page-head">
      <div><h1>Dashboard</h1><p>Overview of students and courses.</p></div>
      <a class="btn" href="<%=ctx%>/students?action=add">Add student</a>
    </div>
    <jsp:include page="_alerts.jsp"/>

    <div class="stats">
      <div class="stat"><div class="num"><%= totalStudents %></div><div class="label">Total students</div></div>
      <div class="stat blue"><div class="num"><%= totalCourses %></div><div class="label">Total courses</div></div>
      <div class="stat amber"><div class="num"><%= activeStudents %></div><div class="label">Active students</div></div>
    </div>

    <div class="card">
      <h3>Recent students</h3>
      <div class="table-wrap">
        <table>
          <thead><tr><th>ID</th><th>Name</th><th>Course</th><th>Semester</th><th>Enrolled on</th><th>Status</th></tr></thead>
          <tbody>
          <% if (recent == null || recent.isEmpty()) { %>
            <tr><td colspan="6" class="empty">No students yet. Add the first student to see it here.</td></tr>
          <% } else { for (Student s : recent) { %>
            <tr>
              <td><%= Util.esc(s.getStudentId()) %></td>
              <td><a href="<%=ctx%>/students?action=view&id=<%= s.getId() %>"><%= Util.esc(s.getFullName()) %></a></td>
              <td><%= Util.esc(s.getCourse()) %></td>
              <td><%= s.getSemester() %></td>
              <td><%= s.getEnrollmentDate() %></td>
              <td><span class="badge <%= Util.esc(s.getStatus()) %>"><%= Util.esc(s.getStatus()) %></span></td>
            </tr>
          <% } } %>
          </tbody>
        </table>
      </div>
    </div>
  </main>
</div>
<script src="<%=ctx%>/js/script.js"></script>
</body>
</html>
