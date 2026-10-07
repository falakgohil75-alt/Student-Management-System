# Viva Guide - Student Management System

## Project explanation (say this first)
"This is a web application for a college admin to manage students and courses. It is built with the MVC pattern:
JSP pages are the View, Servlets are the Controller, and JavaBeans + DAO classes are the Model. DAO classes use JDBC
with PreparedStatement to talk to an Oracle database. The admin logs in, the servlet stores the username in an HttpSession,
and a filter blocks every page if there is no session. The admin can Create, Read, Update, Delete and Search students
and can do CRUD on courses."

Request flow: `Browser -> Servlet (controller) -> DAO -> JDBC -> Oracle -> DAO -> Servlet -> JSP -> Browser`

## Concepts in simple words
- **Why JSP:** to build the HTML page dynamically. It is HTML with Java code (`<% %>`) so it can print data from the database. Only display code is in JSP - no SQL.
- **Why Servlet:** a Java class that receives the HTTP request, calls the DAO, puts data in the request, and forwards to a JSP. It is the controller.
- **JDBC:** Java Database Connectivity - standard API (Connection, PreparedStatement, ResultSet) to run SQL from Java. The Oracle driver (ojdbc jar) implements it.
- **DAO (Data Access Object):** a class that holds all database code for one entity (StudentDAO). Servlets never write SQL; if the DB changes only the DAO changes.
- **JavaBean:** a plain Java class with private fields, a no-argument constructor and public getters/setters (Student, Course). It carries data between layers.
- **MVC:** splits the app in Model (data + DB), View (JSP), Controller (Servlet). Easy to maintain and explain.
- **CRUD:** Create = INSERT (addStudent), Read = SELECT (getAllStudents, getStudentById), Update = UPDATE (updateStudent), Delete = DELETE (deleteStudent).
- **DB connection:** `DBConnection.getConnection()` loads the driver class, then `DriverManager.getConnection(URL, user, password)` returns a Connection. try-with-resources closes Connection/Statement/ResultSet automatically.
- **PreparedStatement:** SQL with `?` placeholders; values are bound separately, so user input is never treated as SQL (stops SQL injection) and it is faster for repeated queries.
- **Session authentication:** on correct login `session.setAttribute("admin", username)`. `AuthFilter` runs before every request; if the session has no "admin" it redirects to login. Logout calls `session.invalidate()`.

## 20 likely viva questions
1. **What is your project about?** A student and course management system for an admin with login, CRUD and search.
2. **Which technologies did you use?** Java, JSP, Servlets, JDBC, Oracle, HTML, CSS, JavaScript, Tomcat 9.
3. **Which design pattern?** MVC, plus the DAO pattern.
4. **What is a servlet?** A Java class running on the server that handles HTTP requests and responses.
5. **Servlet vs JSP?** Servlet = Java code for logic (controller); JSP = HTML with Java for display (view). A JSP is converted into a servlet by Tomcat.
6. **doGet vs doPost?** doGet reads data (URL parameters, visible); doPost sends form data in the request body (add/update/delete/login).
7. **forward vs sendRedirect?** forward is inside the server (same request, URL unchanged); sendRedirect tells the browser to make a new request (URL changes). I redirect after saving so a refresh does not resubmit the form.
8. **What is JDBC and its steps?** Load driver, get Connection, create PreparedStatement, execute, process ResultSet, close resources.
9. **Why PreparedStatement over Statement?** Prevents SQL injection, handles data types, precompiled.
10. **What is SQL injection?** Attacker types SQL in an input (`' OR '1'='1`) to change the query. PreparedStatement blocks it.
11. **What is a DAO?** A class that contains all SQL/database operations for one table/entity.
12. **What is a JavaBean?** A class with private fields, no-arg constructor, getters and setters.
13. **How does login work?** LoginServlet checks username/password through AdminDAO; if valid it creates a session attribute and redirects to the dashboard.
14. **How do you stop access without login?** AuthFilter (`@WebFilter("/*")`) redirects to /login when the session has no admin attribute.
15. **What does logout do?** `session.invalidate()` destroys the session, then redirect to login.
16. **What is a session?** Server-side memory for one user, identified by the JSESSIONID cookie.
17. **How does SEARCH work?** `searchStudents(type, keyword)` runs `WHERE LOWER(column) LIKE ?` with `%keyword%`; the column is chosen from a fixed list, not from user input.
18. **How do you validate data?** Client side with HTML5 attributes + JavaScript (fast feedback); server side in StudentServlet.validate() (because JavaScript can be bypassed).
19. **How are primary keys generated in Oracle?** With sequences: `student_seq.NEXTVAL` in the INSERT.
20. **Why did you use Tomcat 9?** It supports `javax.servlet` (Servlet 4.0) which this code uses; Tomcat 10 uses `jakarta.servlet` and would need code changes.

Bonus: *What is web.xml?* Deployment descriptor: welcome file, session timeout, error pages. Servlets are mapped by annotations (`@WebServlet`).
*Why escape output (Util.esc)?* Prevents XSS - data with `<script>` is shown as text, not executed.
