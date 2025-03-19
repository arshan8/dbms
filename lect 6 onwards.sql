#6th
#subqueries
#subquery is a query nested inside a another query, it can be used with selecct, update, insert and delete

 -- ip: How to Answer Subquery Questions
-- Start with a Definition

-- "A subquery is a query nested inside another query, used to filter, aggregate, or modify data dynamically."
-- Mention Use Cases with Examples

-- "For example, to find employees earning above the average salary, we can use a subquery inside WHERE."
-- Compare with JOIN (if relevant)

-- "While subqueries can sometimes replace JOIN, JOIN is usually more efficient for retrieving related data."
-- Mention Performance Considerations

-- "Subqueries may be less efficient than JOIN because they run independently, but indexing and optimization can help."
-- 💡 Bonus: If asked "When should we use JOIN instead of a subquery?", you can say:

-- Use JOIN when retrieving related data from multiple tables (better performance).
-- Use a subquery when filtering, computing aggregates, or dealing with non-trivial conditions.
-- Would you like a deeper dive into performance differences? 🚀

create database companydb;

use companydb;

create table employee(
  fname varchar(30),
  minit char(1),
  lname varchar(30),
  ssn char(9),
  bdate date,
  address varchar(30),
  sex char(1),
  salary float(10, 2),
  super_ssn char(9),
  dno smallint(6),
  constraint pk_employee PRIMARY KEY (ssn)
);


create table department(
  dname varchar(30),
  dnumber smallint primary key,
  mgr_ssn char(9),
  mgr_start_date date
);

create table dept_locations(
  dnumber smallint,
  dlocation varchar(20),
  constraint composite_pk_dept_loc PRIMARY KEY (dnumber, dlocation)
);

create table project(
  pname varchar(30),
  pnumber smallint,
  plocation varchar(30),
  dnum smallint,
  constraint pk_project PRIMARY KEY (pnumber)
);

create table works_on(
  essn char(9),
  pno smallint,
  hours float(4, 2),
  constraint pk_works_on PRIMARY KEY (essn, pno)
);

create table dependent(
  essn char(9),
  dependent_name varchar(30),
  sex char(1),
  bdate date,
  relationship varchar(20),
  constraint pk_dependent PRIMARY KEY (essn, dependent_name)
);



insert into employee(
    fname,
    minit,
    lname,
    ssn,
    bdate,
    address,
    sex,
    salary,
    super_ssn,
    dno
  )
VALUES
  (
    'John',
    'B',
    'Smith',
    '123456789',
    '1965-01-09',
    '731 Fondren, Houston, TX',
    'M',
    30000,
    '333445555',
    5
  ),
  (
    'Franklin',
    'T',
    'Wong',
    '333445555',
    '1955-01-09',
    '638 Fondren, Houston, TX',
    'M',
    40000,
    '888665555',
    5
  ),
  (
    'Alicia',
    'J',
    'Zelaya',
    '999887777',
    '1968-01-09',
    '3321 Fondren, Houston, TX',
    'F',
    25000,
    '987654321',
    4
  ),
  (
    'Jennifer',
    'S',
    'Wallace',
    '987654321',
    '1941-01-09',
    '21 Fondren, Houston, TX',
    'F',
    43000,
    '888665555',
    4
  ),
  (
    'Ramesh',
    'K',
    'Narayan',
    '666884444',
    '1962-01-09',
    '975 Fondren, Houston, TX',
    'M',
    38000,
    '333445555',
    5
  ),
  (
    'Joyce',
    'A',
    'English',
    '453453453',
    '1972-01-09',
    '5631 Fondren, Houston, TX',
    'F',
    25000,
    '333445555',
    5
  ),
  (
    'Ahmad',
    'V',
    'Jabbar',
    '987987987',
    '1969-01-09',
    '980 Fondren, Houston, TX',
    'M',
    25000,
    '987654321',
    4
  ),
  (
    'James',
    'E',
    'Borg',
    '888665555',
    '1937-01-09',
    '450 Fondren, Houston, TX',
    'M',
    55000,
    NULL,
    1
  );

select * from employee;

insert into department(dname, dnumber, mgr_ssn, mgr_start_date)
VALUES
  ('Research', 5, 333445555, '1988-05-22'),
  ('Administration', 4, 987654321, '1995-05-22'),
  ('Headquarters', 1, 888665555, '1981-05-22');

insert into dept_locations(dnumber, dlocation)
values
  (1, 'Houston'),
  (4, 'Stafford'),
  (5, 'Bellaire'),
  (5, 'Sugarland'),
  (5, 'Houston');

insert into works_on (essn, pno, hours)
values
  ('123456789', 1, 32.5),
  ('123456789', 2, 7.5),
  ('666884444', 3, 40.0),
  ('453453453', 1, 20.0),
  ('453453453', 2, 20.0),
  ('333445555', 2, 10.0),
  ('333445555', 3, 10.0),
  ('333445555', 10, 10.0),
  ('333445555', 20, 10.0),
  ('999887777', 30, 30.0),
  ('999887777', 10, 10.0),
  ('987987987', 10, 35.0),
  ('987987987', 30, 5.0),
  ('987654321', 30, 20.0),
  ('987654321', 20, 15.0),
  ('888665555', 20, NULL);

insert into project(pname, pnumber, plocation, dnum)
values
  ('ProductX', 1, 'Bellaire', 5),
  ('ProductY', 2, 'Sugarland', 5),
  ('ProductZ', 3, 'Houston', 5),
  ('Computerization', 10, 'Stafford', 4),
  ('Reorganization', 20, 'Houston', 1),
  ('Newbenefits', 30, 'Stafford', 4);

insert into dependent(essn, dependent_name, sex, bdate, relationship)
values
  (
    '333445555',
    'Alice',
    'F',
    '1986-04-05',
    'Daughter'
  ),
  (
    '333445555',
    'Theodore',
    'M',
    '1983-04-05',
    'Son'
  ),
  ('333445555', 'Joy', 'F', '1958-04-05', 'Spouse'),
  (
    '987654321',
    'Abner',
    'M',
    '1942-04-05',
    'Spouse'
  ),
  ('123456789', 'Michael', 'M', '1988-04-05', 'Son'),
  (
    '123456789',
    'Alice',
    'M',
    '1988-04-05',
    'Daughter'
  ),
  (
    '123456789',
    'Elizabeth',
    'M',
    '1967-04-05',
    'Spouse'
  );


alter table employee
add
  constraint fk_super_ssn FOREIGN KEY (super_ssn) REFERENCES employee(ssn);

alter table employee
add
  constraint fk_dno FOREIGN KEY (dno) REFERENCES department(dnumber);

alter table dept_locations
add
  constraint fk_dnumber FOREIGN KEY (dnumber) REFERENCES department(dnumber);

alter table project
add
  constraint fk_dnum FOREIGN KEY (dnum) REFERENCES department(dnumber);

alter table works_on
add
  constraint fk_essn FOREIGN KEY (essn) REFERENCES employee(ssn);

alter table works_on
add
  constraint fk_pno FOREIGN KEY (pno) REFERENCES project(pnumber);

alter table dependent
add
  constraint fk_dep_essn FOREIGN KEY (essn) REFERENCES employee(ssn);
  
  
#subquery typpe 1, using where and in clause()
#select details of all managers from employee table
select * from employee;

select * from employee where ssn in ( 
select distinct super_ssn from employee where super_ssn is not null);

#select details fo employee whpo are working on some project
select * from works_on;

select * from employee where ssn in (
select distinct essn from works_on where essn is not null);

#subquyery Type 2, inline 
#aliases is must, in this type outer query works on the result of inner query 
#select min and max of avg of salareis accross departmetnts

select min(avg_salary), max(avg_salary) from(
select avg(salary) as avg_salary, dno from employee group by dno) as temp_table;

#subquery 3
#sclar subquery # eeasy
select * from employee where salary > (select avg(salary) from  employee);



#4 CTE A Common Table Expression (CTE) is a temporary result set that
 -- you can reference within a SELECT, INSERT, UPDATE, or DELETE statement. It is 
 -- defined using the WITH keyword and exists only for the duration of the query execution.-- 
--  CTE vs views
--  cte exists only for the duration of the query while viewsPersistent, stored in the database
--  cte supports recursive queries while views dont

#query wont end unless u put ;, once query is completed, CTE is deleted

#print name and total hours each employee has workd

WITH employee_work_hours AS (
    SELECT essn, SUM(hours) AS total 
    FROM works_on 
    GROUP BY essn 
    HAVING SUM(hours) IS NOT NULL  #cannot use alias with having
)
SELECT e.fname, w.total 
FROM employee e
INNER JOIN employee_work_hours w 
ON e.ssn = w.essn;




#lecture 4
-- A dependent subquery (also called a correlated subquery) is a subquery that 
-- executes once for each row of the outer query. Unlike regular subqueries, which execute independently,
--  correlated subqueries use values from the outer query in their execution.


#avoid correlated query, because xecution time is porpotional to no. of rows, which can be very heigh
select fname, salary, dno from
employee as outer_table
where salary > (select avg(salary) from employee
					where dno = outer_table.dno
                    group by dno);

select ssn, fname, super_ssn 		#retrieve all employees who have a valid manager (i.e.,
									#employees whose super_ssn exists in the employee table as an ssn).
from employee as outer_table
where exists (select "x" from employee
where ssn = outer_table.ssn)
 
 
 
 