-- Schema Creation (for reference)
create database b_db;
use b_db;
#4th

CREATE TABLE STUDENT (
    USN VARCHAR(20) PRIMARY KEY,
    SName VARCHAR(100),
    Address VARCHAR(255),
    Phone VARCHAR(15),
    Gender VARCHAR(10)
);

CREATE TABLE SEMSEC (
    SSID INT PRIMARY KEY,
    Sem INT,
    Sec VARCHAR(1)
);

CREATE TABLE CLASS (
    USN VARCHAR(20),
    SSID INT,
    PRIMARY KEY (USN, SSID),
    FOREIGN KEY (USN) REFERENCES STUDENT(USN),
    FOREIGN KEY (SSID) REFERENCES SEMSEC(SSID)
);

CREATE TABLE SUBJECT (
    Subcode VARCHAR(10) PRIMARY KEY,
    Title VARCHAR(100),
    Sem INT,
    Credits INT
);

CREATE TABLE IAMARKS (
    USN VARCHAR(20),
    Subcode VARCHAR(10),
    SSID INT,
    Test1 INT,
    Test2 INT,
    Test3 INT,
    PRIMARY KEY (USN, Subcode, SSID),
    FOREIGN KEY (USN) REFERENCES STUDENT(USN),
    FOREIGN KEY (Subcode) REFERENCES SUBJECT(Subcode),
    FOREIGN KEY (SSID) REFERENCES SEMSEC(SSID)
);

-- Sample Data Insertion
-- Insert data into STUDENT table
INSERT INTO STUDENT VALUES 
('1BI15CS101', 'Arun Kumar', 'Bangalore', '9876543210', 'Male'),
('1BI19CS112', 'Sunita Patel', 'Mysore', '9876543212', 'Female'),
('1BI19CS113', 'Vikram Singh', 'Delhi', '9876543213', 'Male'),
('1BI15CS116', 'Sameer Khan', 'Mumbai', '9876543216', 'Male'),
('1BI15CS123', 'Swati Gupta', 'Pune', '9876543223', 'Female');

-- Insert data into SEMSEC table
INSERT INTO SEMSEC VALUES
(1, 1, 'A'),
(12, 4, 'C'),
(22, 8, 'A'),
(23, 8, 'B'),
(24, 8, 'C');

-- Insert data into CLASS table
INSERT INTO CLASS VALUES
('1BI15CS101', 1),
('1BI19CS112', 12),
('1BI19CS113', 12),
('1BI15CS116', 22),
('1BI15CS123', 24);

-- Insert data into SUBJECT table
INSERT INTO SUBJECT VALUES
('CS101', 'Introduction to Programming', 1, 4),
('CS104', 'Database Management Systems', 4, 4),
('CS105', 'Operating Systems', 4, 4),
('CS110', 'Artificial Intelligence', 8, 4),
('CS111', 'Machine Learning', 8, 4);

-- Insert data into IAMARKS table
INSERT INTO IAMARKS VALUES
('1BI15CS101', 'CS101', 1, 18, 19, 17),
('1BI19CS112', 'CS104', 12, 18, 19, 15),
('1BI19CS113', 'CS105', 12, 15, 17, 19),
('1BI15CS116', 'CS110', 22, 19, 18, 20),
('1BI15CS123', 'CS111', 24, 14, 16, 15);

-- Add FinalIA column to IAMARKS table
ALTER TABLE IAMARKS ADD COLUMN FinalIA INT;

-- Update FinalIA values
UPDATE IAMARKS
SET FinalIA = (
    CASE 
        WHEN Test1 <= Test2 AND Test1 <= Test3 THEN (Test2 + Test3) / 2
        WHEN Test2 <= Test1 AND Test2 <= Test3 THEN (Test1 + Test3) / 2
        WHEN Test3 <= Test1 AND Test3 <= Test2 THEN (Test1 + Test2) / 2
    END
);

-- Query 1: List all the student details studying in fourth semester 'C' section
select * from
student
where usn in (select usn
from class
where ssid in
(select ssid from semsec where sem = 4 and sec = "C"))
;


-- Query 2: Compute the total number of male and female students in each semester and in each section
select gender, sec, sem, count(*)
from student
join class on student.usn = class.usn
join semsec on semsec.ssid = class.ssid
group by gender, semsec.sem, semsec.sec
;



-- Query 3: Create a view of Test1 marks of student USN '1BI15CS101' in all subjects
CREATE VIEW Student_1BI15CS101_Test1 AS
SELECT S.Subcode, S.Title, IA.Test1
FROM IAMARKS IA
JOIN SUBJECT S ON IA.Subcode = S.Subcode
WHERE IA.USN = '1BI15CS101';
select * from Student_1BI15CS101_Test1 ;

-- Query 4: Calculate the FinalIA (average of best two test marks) and update the corresponding table for all students
-- This is already handled with the ALTER TABLE and UPDATE statements above

-- Query 5: Categorize students based on FinalIA criteria for 8th semester A, B, and C section students
ALTER TABLE IAMARKS ADD COLUMN category varchar(40);

-- Update FinalIA values
UPDATE IAMARKS
SET category = (
    CASE 
        WHEN finalia between 17 and 20 then "Outstanding"
          WHEN finalia between 12 and 14 then "avg"
          WHEN finalia between 14 and 20 then "weak"
    END
);
select * from iamarks
where ssid in 
(select ssid from semsec where sec in ('A','B','C') and sem = 8);
-- Additional diagnostic queries to check data integrity

-- Check if the FinalIA column exists and has values
SELECT * FROM IAMARKS;

-- Check 8th semester students with test marks
SELECT S.USN, SS.Sem, SS.Sec, IA.Subcode, IA.FinalIA
FROM STUDENT S
JOIN CLASS C ON S.USN = C.USN
JOIN SEMSEC SS ON C.SSID = SS.SSID
JOIN IAMARKS IA ON S.USN = IA.USN
WHERE SS.Sem = 8;