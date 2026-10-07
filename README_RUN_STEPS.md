# Student Management System - Run Guide (VS Code + Tomcat 9 + Oracle)

Stack: Java, JSP, Servlets (javax.servlet - Tomcat 9), JDBC, Oracle XE, JavaBeans, DAO, MVC.
Login: **admin / admin123**

## 0. What you need
- JDK 8, 11 or 17 (check: `javac -version`). Set `JAVA_HOME` (Tomcat needs it).
- Apache Tomcat 9 (unzipped, e.g. `C:\apache-tomcat-9.0.98`)
- Oracle Database XE (services must be running: OracleService... and ...TNSListener)
- VS Code + "Extension Pack for Java" (only for editing; the build uses build.bat)

## 1. Oracle: create user and tables
Open Command Prompt.

Oracle XE 18c/21c (connect directly to the pluggable DB):
```
sqlplus system/YOUR_SYSTEM_PASSWORD@localhost:1521/XEPDB1
SQL> @"C:\path\to\StudentMS\sql\01_create_user.sql"
SQL> exit
sqlplus student_mgmt/student123@localhost:1521/XEPDB1
SQL> @"C:\path\to\StudentMS\sql\02_tables.sql"
SQL> SELECT * FROM admin;      -- must show admin / admin123
```
Oracle XE 11g: same commands but use `@localhost:1521/XE` instead of `XEPDB1`,
and in `DBConnection.java` use the 11g URL line (`jdbc:oracle:thin:@localhost:1521:XE`).

## 2. Add the Oracle JDBC driver (Connector)
Copy the jar from your Oracle installation into `WebContent\WEB-INF\lib\`:
- XE 21c: `C:\app\<username>\product\21c\dbhomeXE\jdbc\lib\ojdbc8.jar`
- XE 11g: `C:\oraclexe\app\oracle\product\11.2.0\server\jdbc\lib\ojdbc6.jar`
(Or search your PC for `ojdbc*.jar`, or download ojdbc8.jar from oracle.com/maven central.)

## 3. Update settings
- `src/util/DBConnection.java` -> URL, USER (student_mgmt), PASSWORD (student123).
- `build.bat` -> `TOMCAT_HOME` = your Tomcat folder.

## 4. Build and deploy
1. VS Code -> File -> Open Folder -> `StudentMS`.
2. Terminal -> `build.bat` (compiles Java and copies the app to `Tomcat\webapps\StudentMS`).
3. Start Tomcat: `"C:\apache-tomcat-9.0.98\bin\startup.bat"` (a Tomcat window opens; wait for "Server startup in ...").
4. Open **http://localhost:8080/StudentMS/**
   - Port 8080 busy (Oracle 11g XE uses 8080 for Apex)? Edit `Tomcat\conf\server.xml`, change Connector port `8080` to `8081`, restart, use `:8081`.
5. After changing Java code: run `build.bat` again (Tomcat auto-reloads). Changed JSP/CSS: just run build.bat too (it copies files).
6. Stop Tomcat: `bin\shutdown.bat`.

## 5. Test everything
1. LOGIN: admin / admin123 -> dashboard opens. Wrong password -> error message.
   Open `/StudentMS/students` in a new private window -> redirected to login (protected).
2. CREATE: Add Student -> fill all fields -> "Add student" -> success message; row appears in Students.
   Try invalid phone (9 digits) -> red error, nothing saved. Try same Student ID again -> "already exists".
3. READ: Students page shows table; click View -> profile card.
4. UPDATE: Edit -> change phone/course -> Save changes -> success; check the table.
5. DELETE: Delete -> confirm popup -> OK -> student removed; Cancel -> nothing happens.
6. SEARCH: Search Student -> choose Name / ID / Email / Course, type "riya" -> results table.
7. COURSES: Courses -> Add / Edit / Delete (same as above). New courses appear in the student form dropdown.
8. LOGOUT: Logout -> login page; Back button does not reopen the dashboard.

## 6. Troubleshooting
| Error | Cause / fix |
|---|---|
| `ClassNotFoundException: oracle.jdbc.OracleDriver` (or "driver not found") | ojdbc jar missing. Put it in `WebContent\WEB-INF\lib`, run build.bat again. |
| `ORA-01017 invalid username/password` | Wrong USER/PASSWORD in DBConnection.java, or user not created (step 1). |
| `ORA-12541 no listener` | Start the Oracle TNS Listener service (services.msc). |
| `ORA-12514 / ORA-12505 service/SID not known` | Wrong URL. 21c/18c: `//localhost:1521/XEPDB1`. 11g: `localhost:1521:XE`. Check with `lsnrctl status`. |
| `ORA-00942 table or view does not exist` | 02_tables.sql not run as student_mgmt, or run in a different container (XEPDB1 vs CDB). |
| `ORA-00001 unique constraint` | Duplicate Student ID / Email / Course code (app shows a friendly message). |
| "Database connection failed" message in page | Oracle service stopped or wrong credentials. Test with sqlplus first. |
| 404 on `/StudentMS/` | App not copied: run build.bat; check `Tomcat\webapps\StudentMS\WEB-INF\web.xml` exists; correct port. |
| 404 on `/students` | URL must include the context: `/StudentMS/students`. |
| 500 error | Read `Tomcat\logs\catalina.<date>.log` and `localhost.<date>.log` - the real exception is there. |
| `javac is not recognized` | Install JDK (not only JRE) and add its `bin` to PATH. |
| `package javax.servlet does not exist` | `TOMCAT_HOME` wrong in build.bat. You must use Tomcat **9** (javax.*), not Tomcat 10 (jakarta.*). |
| Tomcat window closes immediately | `JAVA_HOME` not set. Set it to the JDK folder. |
| Port 8080 already in use | Change Connector port in `conf\server.xml` (see step 4). |
| JSP compilation error | The 500 page/log shows line number of the generated servlet; check `%>` / missing imports in that JSP. Never mix Tomcat 10 with this code. |

## 7. Project structure
```
StudentMS/
 build.bat  README_RUN_STEPS.md  VIVA_GUIDE.md
 sql/ 01_create_user.sql  02_tables.sql
 src/
   controller/ AuthFilter, LoginServlet, LogoutServlet, DashboardServlet, StudentServlet, CourseServlet
   model/      Student, Course, Admin          (JavaBeans)
   dao/        StudentDAO, CourseDAO, AdminDAO (all SQL here, PreparedStatement)
   util/       DBConnection, Util
 WebContent/
   login.jsp dashboard.jsp students.jsp add-student.jsp edit-student.jsp student-details.jsp
   search-student.jsp courses.jsp add-course.jsp edit-course.jsp error.jsp index.jsp
   _sidebar.jsp _alerts.jsp _student-table.jsp _student-form.jsp _course-form.jsp   (reusable parts)
   css/style.css  js/script.js  WEB-INF/web.xml  WEB-INF/lib/ (put ojdbc jar here)
```
URL map: `/login` `/logout` `/dashboard` `/students[?action=add|edit|view|search]` `/courses[?action=add|edit]`
