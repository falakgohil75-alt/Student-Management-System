-- Run as SYSTEM (or SYS) user in SQL*Plus / SQL Developer.
-- Oracle XE 18c/21c (multitenant): first switch to the pluggable database
--   ALTER SESSION SET CONTAINER = XEPDB1;
-- Oracle XE 11g: skip the line above.

CREATE USER student_mgmt IDENTIFIED BY student123;
GRANT CONNECT, RESOURCE TO student_mgmt;
GRANT UNLIMITED TABLESPACE TO student_mgmt;
