<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.Course, util.Util" %>
<%
    String ctx = request.getContextPath();
    boolean edit = "edit".equals(request.getParameter("mode"));
    Course c = (Course) request.getAttribute("course");
    if (c == null) c = new Course();
%>
<form class="needs-validation" method="post" action="<%=ctx%>/courses" novalidate>
  <input type="hidden" name="action" value="<%= edit ? "update" : "insert" %>">
  <% if (edit) { %><input type="hidden" name="id" value="<%= c.getId() %>"><% } %>
  <div class="form-grid">
    <div class="form-group">
      <label for="courseCode">Course code</label>
      <input type="text" id="courseCode" name="courseCode" value="<%= Util.esc(c.getCourseCode()) %>"
             required pattern="[A-Za-z0-9\-]{2,20}" maxlength="20" title="2-20 letters, digits or hyphens (e.g. BCA)">
      <small class="field-error"></small>
    </div>
    <div class="form-group">
      <label for="duration">Duration</label>
      <input type="text" id="duration" name="duration" value="<%= Util.esc(c.getDuration()) %>"
             required maxlength="50" placeholder="e.g. 3 Years" title="Duration is required (e.g. 3 Years)">
      <small class="field-error"></small>
    </div>
    <div class="form-group full">
      <label for="courseName">Course name</label>
      <input type="text" id="courseName" name="courseName" value="<%= Util.esc(c.getCourseName()) %>"
             required minlength="3" maxlength="100" title="Course name must be 3-100 characters">
      <small class="field-error"></small>
    </div>
    <div class="form-group full">
      <label for="description">Description</label>
      <textarea id="description" name="description" maxlength="500" title="Maximum 500 characters"><%= Util.esc(c.getDescription()) %></textarea>
      <small class="field-error"></small>
    </div>
  </div>
  <div class="form-actions">
    <button type="submit" class="btn"><%= edit ? "Save changes" : "Add course" %></button>
    <a class="btn btn-light" href="<%=ctx%>/courses">Cancel</a>
  </div>
</form>
