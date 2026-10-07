<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Student, util.Util" %>
<%
    String ctx = request.getContextPath();
    String type = (String) request.getAttribute("type");
    String keyword = (String) request.getAttribute("keyword");
    if (type == null) type = "all";
    if (keyword == null) keyword = "";
    boolean searched = request.getAttribute("searched") != null;
    @SuppressWarnings("unchecked")
    List<Student> results = (List<Student>) request.getAttribute("students");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Search Student - Student Management System</title>
  <link rel="stylesheet" href="<%=ctx%>/css/style.css">
</head>
<body>
<div class="layout">
  <jsp:include page="_sidebar.jsp"><jsp:param name="active" value="search"/></jsp:include>
  <main class="content">
    <div class="page-head"><div><h1>Search student</h1><p>Find students by ID, name, email or course.</p></div></div>
    <jsp:include page="_alerts.jsp"/>

    <div class="card">
      <form class="search-bar" method="get" action="<%=ctx%>/students">
        <input type="hidden" name="action" value="search">
        <select name="type" aria-label="Search by">
          <option value="all" <%= type.equals("all") ? "selected" : "" %>>All fields</option>
          <option value="student_id" <%= type.equals("student_id") ? "selected" : "" %>>Student ID</option>
          <option value="name" <%= type.equals("name") ? "selected" : "" %>>Name</option>
          <option value="email" <%= type.equals("email") ? "selected" : "" %>>Email</option>
          <option value="course" <%= type.equals("course") ? "selected" : "" %>>Course</option>
        </select>
        <input type="text" name="keyword" value="<%= Util.esc(keyword) %>" placeholder="Type a keyword..." aria-label="Keyword" required>
        <button type="submit" class="btn">Search</button>
      </form>
    </div>

    <% if (searched) { %>
      <div class="card">
        <h3><%= results == null ? 0 : results.size() %> result(s) for "<%= Util.esc(keyword) %>"</h3>
        <jsp:include page="_student-table.jsp"/>
      </div>
    <% } %>
  </main>
</div>
<script src="<%=ctx%>/js/script.js"></script>
</body>
</html>
