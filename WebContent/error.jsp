<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<% String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Something went wrong</title><link rel="stylesheet" href="<%=ctx%>/css/style.css"></head>
<body>
  <div class="center-box">
    <h1>Page not available</h1>
    <p>The page you asked for was not found, or something went wrong on the server.</p>
    <a class="btn" href="<%=ctx%>/dashboard">Go to dashboard</a>
  </div>
</body></html>
