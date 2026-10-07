<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Course, util.Util" %>
<%
    String ctx = request.getContextPath();
    @SuppressWarnings("unchecked")
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    if (courses == null) { response.sendRedirect(ctx + "/courses"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Courses - Student Management System</title>
  <link rel="stylesheet" href="<%=ctx%>/css/style.css">
</head>
<body>
<div class="layout">
  <jsp:include page="_sidebar.jsp"><jsp:param name="active" value="courses"/></jsp:include>
  <main class="content">
    <div class="page-head">
      <div><h1>Courses</h1><p>Manage the courses offered.</p></div>
      <a class="btn" href="<%=ctx%>/courses?action=add">Add course</a>
    </div>
    <jsp:include page="_alerts.jsp"/>
    <div class="card">
      <div class="table-wrap">
        <table>
          <thead><tr><th>Code</th><th>Course name</th><th>Duration</th><th>Description</th><th>Actions</th></tr></thead>
          <tbody>
          <% if (courses.isEmpty()) { %>
            <tr><td colspan="5" class="empty">No courses yet. Add your first course.</td></tr>
          <% } else { for (Course c : courses) { %>
            <tr>
              <td><b><%= Util.esc(c.getCourseCode()) %></b></td>
              <td><%= Util.esc(c.getCourseName()) %></td>
              <td><%= Util.esc(c.getDuration()) %></td>
              <td class="wrap"><%= Util.esc(c.getDescription()) %></td>
              <td>
                <div class="actions">
                  <a class="btn btn-sm btn-warn" href="<%=ctx%>/courses?action=edit&id=<%= c.getId() %>">Edit</a>
                  <form method="post" action="<%=ctx%>/courses" data-name="<%= Util.esc(c.getCourseName()) %>"
                        onsubmit="return confirmDelete('course', this.dataset.name);">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" value="<%= c.getId() %>">
                    <button type="submit" class="btn btn-sm btn-danger">Delete</button>
                  </form>
                </div>
              </td>
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
