<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="util.Util" %>
<% String ctx = request.getContextPath(); String error = (String) request.getAttribute("error"); %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Login - Student Management System</title>
  <link rel="stylesheet" href="<%=ctx%>/css/style.css">
</head>
<body class="login-page">
  <div class="login-box">
    <div class="login-side">
      <h1>Student Management System</h1>
      <p>Manage students and courses in one place. Sign in with your administrator account to continue.</p>
    </div>
    <form class="login-form needs-validation" method="post" action="<%=ctx%>/login" novalidate>
      <h2>Admin login</h2>
      <p class="sub">Enter your username and password.</p>
      <% if (error != null) { %><div class="alert alert-error"><%= Util.esc(error) %></div><% } %>
      <% if (request.getParameter("logout") != null) { %><div class="alert alert-info">You have been logged out.</div><% } %>
      <div class="form-group">
        <label for="username">Username</label>
        <input type="text" id="username" name="username" required title="Username is required" autocomplete="username" autofocus>
        <small class="field-error"></small>
      </div>
      <div class="form-group">
        <label for="password">Password</label>
        <div class="pw-row">
          <input type="password" id="password" name="password" required title="Password is required" autocomplete="current-password">
          <button type="button" id="togglePw">Show</button>
        </div>
        <small class="field-error"></small>
      </div>
      <button type="submit" class="btn">Log in</button>
      <p class="hint">Default login: admin / admin123</p>
    </form>
  </div>
  <script src="<%=ctx%>/js/script.js"></script>
</body>
</html>
