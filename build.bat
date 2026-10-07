@echo off
REM ================================================================
REM  Build + deploy Student Management System to Tomcat 9 (Windows)
REM  1) Set TOMCAT_HOME below to YOUR Tomcat folder
REM  2) Put the Oracle JDBC jar (ojdbc8.jar / ojdbc11.jar) in WebContent\WEB-INF\lib
REM  3) Stop Tomcat -> run build.bat -> start Tomcat
REM ================================================================
set TOMCAT_HOME=C:\apache-tomcat-9.0.118
set APP_NAME=StudentMS

if not exist "%TOMCAT_HOME%\lib\servlet-api.jar" (
  echo [ERROR] servlet-api.jar not found. Edit TOMCAT_HOME in build.bat
  pause & exit /b 1
)
if not exist WebContent\WEB-INF\lib\ojdbc*.jar (
  echo [ERROR] Copy ojdbc jar into WebContent\WEB-INF\lib first
  pause & exit /b 1
)

if not exist WebContent\WEB-INF\classes mkdir WebContent\WEB-INF\classes

echo Compiling Java files...
javac -encoding UTF-8 -cp "%TOMCAT_HOME%\lib\servlet-api.jar;WebContent\WEB-INF\lib\*" -d WebContent\WEB-INF\classes src\util\*.java src\model\*.java src\dao\*.java src\controller\*.java
if errorlevel 1 (
  echo [ERROR] Compilation failed. Read the errors above.
  pause & exit /b 1
)

echo Deploying to Tomcat...
xcopy /e /i /y WebContent "%TOMCAT_HOME%\webapps\%APP_NAME%" >nul

echo.
echo SUCCESS. Start Tomcat (bin\startup.bat) and open:
echo    http://localhost:8080/%APP_NAME%/
pause
