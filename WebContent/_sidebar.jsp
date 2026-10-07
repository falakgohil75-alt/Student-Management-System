<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="util.Util" %>
<%
    String ctx = request.getContextPath();
    String active = request.getParameter("active");
    if (active == null) active = "";
%>
<button class="menu-btn" id="menuBtn" type="button" aria-label="Menu">&#9776;</button>
<aside class="sidebar" id="sidebar">
  <div class="brand">
    <span class="brand-icon">&#127891;</span>
    <div><h2>StudentMS</h2><small>Admin panel</small></div>
  </div>
  <nav>
    <a href="<%=ctx%>/dashboard" class="<%= active.equals("dashboard") ? "active" : "" %>">Dashboard</a>
    <a href="<%=ctx%>/students" class="<%= active.equals("students") ? "active" : "" %>">Students</a>
    <a href="<%=ctx%>/students?action=add" class="<%= active.equals("add") ? "active" : "" %>">Add Student</a>
    <a href="<%=ctx%>/courses" class="<%= active.equals("courses") ? "active" : "" %>">Courses</a>
    <a href="<%=ctx%>/students?action=search" class="<%= active.equals("search") ? "active" : "" %>">Search Student</a>
    <a href="<%=ctx%>/logout" class="logout">Logout</a>
  </nav>
  <div class="sidebar-footer">Signed in as <b><%= Util.esc(session.getAttribute("admin")) %></b></div>
</aside>
