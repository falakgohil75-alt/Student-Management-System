<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, model.Student, util.Util" %>
<%
    String ctx = request.getContextPath();
    @SuppressWarnings("unchecked")
    List<Student> students = (List<Student>) request.getAttribute("students");
    if (students == null) students = new ArrayList<Student>();
%>
<div class="table-wrap">
  <table>
    <thead>
      <tr><th>ID</th><th>Name</th><th>Email</th><th>Phone</th><th>Gender</th><th>Course</th><th>Semester</th><th>Actions</th></tr>
    </thead>
    <tbody>
    <% if (students.isEmpty()) { %>
      <tr><td colspan="8" class="empty">No students found.</td></tr>
    <% } else { for (Student s : students) { %>
      <tr>
        <td><%= Util.esc(s.getStudentId()) %></td>
        <td><%= Util.esc(s.getFullName()) %></td>
        <td><%= Util.esc(s.getEmail()) %></td>
        <td><%= Util.esc(s.getPhone()) %></td>
        <td><%= Util.esc(s.getGender()) %></td>
        <td><%= Util.esc(s.getCourse()) %></td>
        <td><%= s.getSemester() %></td>
        <td>
          <div class="actions">
            <a class="btn btn-sm btn-info" href="<%=ctx%>/students?action=view&id=<%= s.getId() %>">View</a>
            <a class="btn btn-sm btn-warn" href="<%=ctx%>/students?action=edit&id=<%= s.getId() %>">Edit</a>
            <form method="post" action="<%=ctx%>/students" data-name="<%= Util.esc(s.getFullName()) %>"
                  onsubmit="return confirmDelete('student', this.dataset.name);">
              <input type="hidden" name="action" value="delete">
              <input type="hidden" name="id" value="<%= s.getId() %>">
              <button type="submit" class="btn btn-sm btn-danger">Delete</button>
            </form>
          </div>
        </td>
      </tr>
    <% } } %>
    </tbody>
  </table>
</div>
