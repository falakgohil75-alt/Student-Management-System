<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String ctx = request.getContextPath();
   if (request.getAttribute("course") == null) { response.sendRedirect(ctx + "/courses"); return; } %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Edit Course - Student Management System</title>
  <link rel="stylesheet" href="<%=ctx%>/css/style.css">
</head>
<body>
<div class="layout">
  <jsp:include page="_sidebar.jsp"><jsp:param name="active" value="courses"/></jsp:include>
  <main class="content">
    <div class="page-head"><div><h1>Edit course</h1><p>Update the course details.</p></div></div>
    <jsp:include page="_alerts.jsp"/>
    <div class="card"><jsp:include page="_course-form.jsp"><jsp:param name="mode" value="edit"/></jsp:include></div>
  </main>
</div>
<script src="<%=ctx%>/js/script.js"></script>
</body>
</html>
