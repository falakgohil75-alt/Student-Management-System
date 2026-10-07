<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String ctx = request.getContextPath();
   if (request.getAttribute("student") == null) { response.sendRedirect(ctx + "/students"); return; } %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Edit Student - Student Management System</title>
  <link rel="stylesheet" href="<%=ctx%>/css/style.css">
</head>
<body>
<div class="layout">
  <jsp:include page="_sidebar.jsp"><jsp:param name="active" value="students"/></jsp:include>
  <main class="content">
    <div class="page-head"><div><h1>Edit student</h1><p>Update the details and save your changes.</p></div></div>
    <jsp:include page="_alerts.jsp"/>
    <div class="card"><jsp:include page="_student-form.jsp"><jsp:param name="mode" value="edit"/></jsp:include></div>
  </main>
</div>
<script src="<%=ctx%>/js/script.js"></script>
</body>
</html>
