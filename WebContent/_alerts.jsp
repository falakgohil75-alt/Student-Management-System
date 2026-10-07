<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="util.Util" %>
<%
    // Flash messages are stored in the session by servlets before a redirect, and shown once.
    String flashMsg = (String) session.getAttribute("msg");
    String flashErr = (String) session.getAttribute("err");
    String reqErr   = (String) request.getAttribute("error");
    session.removeAttribute("msg");
    session.removeAttribute("err");
    if (flashMsg != null) { %><div class="alert alert-success"><%= Util.esc(flashMsg) %></div><% }
    if (flashErr != null) { %><div class="alert alert-error"><%= Util.esc(flashErr) %></div><% }
    if (reqErr != null)   { %><div class="alert alert-error"><%= Util.esc(reqErr) %></div><% }
%>
