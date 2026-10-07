<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Add Student - Student Management System</title>
  <link rel="stylesheet" href="<%=ctx%>/css/style.css">
</head>
<body>
<div class="layout">
  <jsp:include page="_sidebar.jsp"><jsp:param name="active" value="add"/></jsp:include>
  <main class="content">
    <div class="page-head"><div><h1>Add student</h1><p>Fill in the details and save.</p></div></div>
    <jsp:include page="_alerts.jsp"/>
    <div class="card"><jsp:include page="_student-form.jsp"><jsp:param name="mode" value="add"/></jsp:include></div>
  </main>
</div>
<script src="<%=ctx%>/js/script.js"></script>
</body>
</html>
