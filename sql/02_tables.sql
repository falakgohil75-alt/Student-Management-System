-- Run while connected as student_mgmt/student123 (same container as step 1)
-- "Database" in this project = Oracle schema student_mgmt

-- Sequences (work on all Oracle versions, used for primary keys)
CREATE SEQUENCE admin_seq   START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE course_seq  START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE student_seq START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE admin (
    id        NUMBER        PRIMARY KEY,
    username  VARCHAR2(50)  NOT NULL UNIQUE,
    password  VARCHAR2(100) NOT NULL
);

CREATE TABLE courses (
    id           NUMBER         PRIMARY KEY,
    course_code  VARCHAR2(20)   NOT NULL UNIQUE,
    course_name  VARCHAR2(100)  NOT NULL,
    duration     VARCHAR2(50)   NOT NULL,
    description  VARCHAR2(500),
    created_at   TIMESTAMP      DEFAULT SYSTIMESTAMP
);

CREATE TABLE students (
    id               NUMBER         PRIMARY KEY,
    student_id       VARCHAR2(20)   NOT NULL UNIQUE,
    full_name        VARCHAR2(100)  NOT NULL,
    email            VARCHAR2(100)  NOT NULL UNIQUE,
    phone            VARCHAR2(15)   NOT NULL,
    gender           VARCHAR2(10)   NOT NULL,
    dob              DATE           NOT NULL,
    course           VARCHAR2(100)  NOT NULL,
    semester         NUMBER(2)      NOT NULL,
    address          VARCHAR2(300)  NOT NULL,
    enrollment_date  DATE           NOT NULL,
    status           VARCHAR2(10)   DEFAULT 'Active' NOT NULL
                     CHECK (status IN ('Active','Inactive')),
    created_at       TIMESTAMP      DEFAULT SYSTIMESTAMP
);

-- Default admin
INSERT INTO admin (id, username, password) VALUES (admin_seq.NEXTVAL, 'admin', 'admin123');

-- Sample courses
INSERT INTO courses (id, course_code, course_name, duration, description)
VALUES (course_seq.NEXTVAL, 'BCA', 'Bachelor of Computer Applications', '3 Years', 'Undergraduate program in computer applications.');
INSERT INTO courses (id, course_code, course_name, duration, description)
VALUES (course_seq.NEXTVAL, 'MCA', 'Master of Computer Applications', '2 Years', 'Postgraduate program in computer applications.');
INSERT INTO courses (id, course_code, course_name, duration, description)
VALUES (course_seq.NEXTVAL, 'BSCIT', 'B.Sc Information Technology', '3 Years', 'Undergraduate program in information technology.');

-- Sample students
INSERT INTO students (id, student_id, full_name, email, phone, gender, dob, course, semester, address, enrollment_date, status)
VALUES (student_seq.NEXTVAL, 'S1001', 'Riya Patel', 'riya.patel@example.com', '9876543210', 'Female',
        TO_DATE('2004-05-14','YYYY-MM-DD'), 'Bachelor of Computer Applications', 3, 'Navrangpura, Ahmedabad', TO_DATE('2024-07-01','YYYY-MM-DD'), 'Active');
INSERT INTO students (id, student_id, full_name, email, phone, gender, dob, course, semester, address, enrollment_date, status)
VALUES (student_seq.NEXTVAL, 'S1002', 'Aarav Shah', 'aarav.shah@example.com', '9123456780', 'Male',
        TO_DATE('2003-11-02','YYYY-MM-DD'), 'Master of Computer Applications', 1, 'Maninagar, Ahmedabad', TO_DATE('2025-07-01','YYYY-MM-DD'), 'Active');

COMMIT;
