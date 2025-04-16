#5th

create database j_db;
use j_db;

-- Creating EMPLOYEE Table first
CREATE TABLE EMPLOYEE (
    SSN INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Address VARCHAR(255),
    Sex CHAR(1),
    Salary DECIMAL(10,2) CHECK (Salary > 0),
    SuperSSN INT NULL,
    DNo INT NULL
);

-- Creating DEPARTMENT Table
CREATE TABLE DEPARTMENT (
    DNo INT PRIMARY KEY,
    DName VARCHAR(100) UNIQUE NOT NULL,
    MgrSSN INT UNIQUE NULL,
    MgrStartDate DATE
);

-- Now add the foreign key constraints after both tables exist
ALTER TABLE EMPLOYEE ADD CONSTRAINT FK_Emp_Dept FOREIGN KEY (DNo) REFERENCES DEPARTMENT(DNo) ON DELETE CASCADE;
ALTER TABLE DEPARTMENT ADD CONSTRAINT FK_Dept_Mgr FOREIGN KEY (MgrSSN) REFERENCES EMPLOYEE(SSN) ON DELETE SET NULL;

-- Creating DLOCATION Table
CREATE TABLE DLOCATION (
    DNo INT,
    DLoc VARCHAR(100),
    PRIMARY KEY (DNo, DLoc),
    FOREIGN KEY (DNo) REFERENCES DEPARTMENT(DNo) ON DELETE CASCADE
);

-- Creating PROJECT Table
CREATE TABLE PROJECT (
    PNo INT PRIMARY KEY,
    PName VARCHAR(100) UNIQUE NOT NULL,
    PLocation VARCHAR(100),
    DNo INT,
    FOREIGN KEY (DNo) REFERENCES DEPARTMENT(DNo) ON DELETE CASCADE
);

-- Creating WORKS_ON Table
CREATE TABLE WORKS_ON (
    SSN INT,
    PNo INT,
    Hours DECIMAL(5,2) CHECK (Hours >= 0),
    PRIMARY KEY (SSN, PNo),
    FOREIGN KEY (SSN) REFERENCES EMPLOYEE(SSN) ON DELETE CASCADE,
    FOREIGN KEY (PNo) REFERENCES PROJECT(PNo) ON DELETE CASCADE
);

-- Inserting Sample Data
INSERT INTO DEPARTMENT (DNo, DName, MgrSSN, MgrStartDate) VALUES
(1, 'Accounts', NULL, '2020-01-01'),
(2, 'IT', NULL, '2021-06-15');

INSERT INTO EMPLOYEE (SSN, Name, Address, Sex, Salary, SuperSSN, DNo) VALUES
(101, 'John Scott', '123 Main St', 'M', 60000, NULL, 1),
(102, 'Alice Brown', '456 Oak St', 'F', 75000, NULL, 2),
(103, 'Michael Scott', '789 Pine St', 'M', 80000, NULL, 1);

UPDATE DEPARTMENT SET MgrSSN = 103 WHERE DNo = 1; -- Assigning Michael Scott as Manager of Accounts

INSERT INTO DLOCATION (DNo, DLoc) VALUES
(1, 'New York'),
(2, 'San Francisco');

INSERT INTO PROJECT (PNo, PName, PLocation, DNo) VALUES
(201, 'IoT', 'New York', 1),
(202, 'AI Research', 'San Francisco', 2);

INSERT INTO WORKS_ON (SSN, PNo, Hours) VALUES
(101, 201, 20),
(102, 202, 25),
(103, 201, 30);


-- 1. Make a list of all project numbers for projects that involve an employee 
-- whose last name is 'Scott', either as a worker or as a manager of the 
-- department that controls the project.
SELECT DISTINCT P.PNo
FROM PROJECT P
WHERE P.DNo IN (
    SELECT D.DNo
    FROM DEPARTMENT D
    JOIN EMPLOYEE E ON D.MgrSSN = E.SSN
    WHERE E.Name LIKE '%Scott'
)
OR P.PNo IN (
    SELECT W.PNo
    FROM WORKS_ON W
    JOIN EMPLOYEE E ON W.SSN = E.SSN
    WHERE E.Name LIKE '%Scott'
);


# Show the resulting salaries if every employee working on the 'IoT' project
-- is given a 10% raise.
#2
select name, salary as current_salary, salary*110 as incremented_salary
from employee
join works_on on works_on.ssn = employee.ssn
join project on works_on.pno = project.pno
where project.pname = "IOT";



#3

select sum(salary), max(salary), min(salary), avg(salary)
from employee
where dno in (select dno from department where dname = "Accounts");




#4

SELECT E.Name
FROM EMPLOYEE E
WHERE NOT EXISTS (
    SELECT P.PNo
    FROM PROJECT P
    WHERE P.DNo = 5
    AND NOT EXISTS (
        SELECT W.PNo
        FROM WORKS_ON W
        WHERE W.PNo = P.PNo AND W.SSN = E.SSN
    )
);

-- Insert a new department (5)
INSERT INTO DEPARTMENT (DNo, DName, MgrSSN, MgrStartDate) VALUES
(5, 'Research', NULL, '2022-01-01');

-- Insert a manager for department 5
INSERT INTO EMPLOYEE (SSN, Name, Address, Sex, Salary, SuperSSN, DNo) VALUES
(201, 'David Johnson', '11 Tech St', 'M', 90000, NULL, 5);

UPDATE DEPARTMENT SET MgrSSN = 201 WHERE DNo = 5;

-- Insert projects controlled by department 5
INSERT INTO PROJECT (PNo, PName, PLocation, DNo) VALUES
(301, 'AI Ethics', 'Boston', 5),
(302, 'Robotics', 'Seattle', 5);

-- Insert an employee who works on all projects of department 5
INSERT INTO EMPLOYEE (SSN, Name, Address, Sex, Salary, SuperSSN, DNo) VALUES
(202, 'Emily Carter', '22 Lake St', 'F', 70000, NULL, 5);

-- Assign Emily Carter to all projects of department 5
INSERT INTO WORKS_ON (SSN, PNo, Hours) VALUES
(202, 301, 10),
(202, 302, 15);
-- Adding more employees to DEPARTMENT 1 (Accounts) to make employees > 5
INSERT INTO EMPLOYEE (SSN, Name, Address, Sex, Salary, SuperSSN, DNo) VALUES
(301, 'Mark Lee', '34 West St', 'M', 650000, NULL, 1),
(302, 'Sophia Green', '77 North St', 'F', 700000, NULL, 1),
(303, 'Lucas White', '99 South St', 'M', 720000, NULL, 1),
(304, 'Emma Watson', '12 East St', 'F', 800000, NULL, 1),
(305, 'Chris Evans', '55 Maple St', 'M', 850000, NULL, 1),
(306, 'Scarlett Rose', '66 Birch St', 'F', 900000, NULL, 1);

# just make below think work by adding some helpful rows
SELECT d.dno AS dept, COUNT(*) AS total_high_pay_employee
FROM department d
JOIN employee e ON d.dno = e.dno
WHERE e.salary > 600000
GROUP BY d.dno
HAVING COUNT(*) > 5;