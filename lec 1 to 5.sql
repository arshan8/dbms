#lec 1



create database new_db;
show databases;
use sakila;
select * from actor;
use new_db;




#lecture 2


create table `student data`(
roll_no int not null primary key,
`name` varchar(30),
age int,
gender char(1), 
hobbies varchar(89)
);

#add columns, u can add at anyhwre using after key word or add at beginningusing first

alter table `student data` 
add column hometown varchar(50);


#use change to rename and replace it to new place, basically copies it to new location, and then deletes old column
ALTER TABLE `student data` 
CHANGE COLUMN hometown new_relocated_place varchar(80) AFTER age;  


#use rename to rename table, not column
alter table `student data` 
rename to Students;

select * from Students;



#lecture 3

use new_db;
select * from students;
truncate table students;
INSERT INTO students 
VALUES 
(101, 'Alice Johnson', 22, 'New York', 'F', 'Reading, Painting'),
(102, 'Bob Smith', 24, 'Los Angeles', 'M', 'Cycling, Chess'),
(103, 'Charlie Brown', 23, 'Chicago', 'M', 'Gaming, Football'),
(104, 'Diana White', 21, 'San Francisco', 'F', 'Singing, Hiking'),
(105, 'Eva Adams', 25, 'Seattle', 'F', 'Dancing, Cooking');
select * from students;
select roll_no, 'name' from students;
select name from students where age = 25;
select * from students where new_relocated_place like 's%'; # represents zero or more chars, whereas, _ represents 1 char
select * from students where age between 23 and 25;


select * from students order by age;
select * from students where gender = 'F' order by age desc;

INSERT INTO students (roll_no, name, age, new_relocated_place, gender, hobbies) 
VALUES 
(113, 'Charlie', 23, 'Chicago', 'M', 'Swimming, Chess'),
(114, 'Diana', 21, 'Boston', 'F', 'Dancing, Traveling'),
(115, 'Ethan', 24, 'Seattle', 'M', 'Photography, Coding');


update students set hobbies = "only gooning" where gender = "M";
select * from students;

delete from students where roll_no = 101;




#lecture 4
#normalization and joins

#there are many ways u can declar primary key, the above one is simple
#below ill show a bettrer wayinm which u can even have composite primary key

create table employee(
ssn char(3) ,
bdate date,
name varchar(40),
super_ssn varchar(40),
dno smallint,
constraint p_k_employee primary key (ssn)
);

-- alter employee   #referring to itself , manages, realtionship
-- add
--   constraint fk_manges FOREIGN KEY (super_ssn) REFERENCES employee(ssn);

create table works_on(
  essn char(9),
  pno smallint,
  hours float(4, 2), #depreciated
  constraint pk_works_on PRIMARY KEY (essn, pno),
  constraint fk_work_emplpyee foreign key(essn) references employee(ssn)
);

-- alter table works_on   #if u forget to add at creation
-- add
--   constraint fk_essn FOREIGN KEY (essn) REFERENCES employee(ssn);



#aliases

#cannot implement outer join inmysql
#es, you absolutely can do JOINS using non-primary and non-foreign keys — and it will still work!
#practice
--  inner,
--  right and 
--  left
--  cross
-- self join in mysql please


#lecture 4
#nulls and aggregation

#count
#COUNT() only counts non null values
#if u want to find nulls in columns pno : then count(*) -count(pno) will give u number of nulls in pno

#sum
#sum(salary) from employee where gender = 'm'

#group by
#order by
#Distinct

select count(distinct gender) from students;   #haha 2 genders onlyin the dataset

# why use havinginstead of where when we are dealing with aggregate function?
#because of control flow, avg(age) will noy be created only na think
#control flow
SELECT new_relocated_place, AVG(age) 
FROM students 
WHERE AVG(age) > 23  -- ❌ Error! `WHERE` cannot be used with aggregate functions
GROUP BY new_relocated_place;

#works
SELECT new_relocated_place, AVG(age) AS avg_age 
FROM students 
GROUP BY new_relocated_place
HAVING avg_age > 23;  -- ✅ Correct! `HAVING` filters grouped results


#control flow:n execution flow:
-- SELECT new_relocated_place, AVG(age) AS avg_age  ⬅ ❺ SELECT (Choose columns & aggregates)
-- FROM students                                    ⬅ ❶ FROM (Get data from table)
-- WHERE age > 20                                   ⬅ ❷ WHERE (Filter individual rows)
-- GROUP BY new_relocated_place                     ⬅ ❸ GROUP BY (Group into sets)
-- HAVING AVG(age) > 23                             ⬅ ❹ HAVING (Filter aggregated results)
-- ORDER BY avg_age DESC                            ⬅ ❻ ORDER BY (Sort results)
-- LIMIT 3;                                         ⬅ ❼ LIMIT (Restrict output rows)


#extract 
-- The EXTRACT() function is used to retrieve a specific part of a date or time value.
-- SELECT order id, customer_name, 
--        EXTRACT(YEAR FROM order_date) AS Year, 
--        EXTRACT(MONTH FROM order_date) AS Month, 
--        EXTRACT(DAY FROM order_date) AS Day
-- FROM orders;

#case
SELECT roll_no, name, age,
       CASE 
           WHEN age < (SELECT AVG(age) FROM students) THEN 'Less than Average'
           WHEN age = (SELECT AVG(age) FROM students) THEN 'Equal to Average'
           ELSE 'More than Average'
       END AS age_category
FROM students;



#lecture 6
