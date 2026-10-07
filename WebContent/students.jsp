<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String ctx = request.getContextPath();
   if (request.getAttribute("students") == null) { response.sendRedirect(ctx + "/students"); return; } %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Students - Student Management System</title>
  <link rel="stylesheet" href="<%=ctx%>/css/style.css">
</head>
<body>
<div class="layout">
  <jsp:include page="_sidebar.jsp"><jsp:param name="active" value="students"/></jsp:include>
  <main class="content">
    <div class="page-head">
      <div><h1>Students</h1><p>All registered students.</p></div>
      <div class="actions">
        <a class="btn btn-light" href="<%=ctx%>/students?action=search">Search</a>
        <a class="btn" href="<%=ctx%>/students?action=add">Add student</a>
      </div>
    </div>
    <jsp:include page="_alerts.jsp"/>
    <div class="card"><jsp:include page="_student-table.jsp"/></div>
  </main>
</div>
<script src="<%=ctx%>/js/script.js"></script>
</body>
</html>
