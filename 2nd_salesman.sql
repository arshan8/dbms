#2


use p2 ;
-- CREATE TABLES
CREATE TABLE SALESMAN (
    Salesman_id INT PRIMARY KEY,
    Name VARCHAR(50),
    City VARCHAR(50),
    Commission FLOAT
);

CREATE TABLE CUSTOMER (
    Customer_id INT PRIMARY KEY,
    Cust_Name VARCHAR(50),
    City VARCHAR(50),
    Grade INT,
    Salesman_id INT,
    FOREIGN KEY (Salesman_id) REFERENCES SALESMAN(Salesman_id)
);

CREATE TABLE ORDERS (
    Ord_No INT PRIMARY KEY,
    Purchase_Amt FLOAT,
    Ord_Date DATE,
    Customer_id INT,
    Salesman_id INT,
    FOREIGN KEY (Customer_id) REFERENCES CUSTOMER(Customer_id),
    FOREIGN KEY (Salesman_id) REFERENCES SALESMAN(Salesman_id)
);

-- INSERT INTO SALESMAN
INSERT INTO SALESMAN VALUES
(1000, 'John', 'Bangalore', 0.15),
(1001, 'Alice', 'Delhi', 0.12),
(1002, 'Bob', 'Bangalore', 0.10),
(1003, 'Charlie', 'Mumbai', 0.18),
(1004, 'David', 'Kolkata', 0.20);

-- INSERT INTO CUSTOMER
INSERT INTO CUSTOMER VALUES
(2000, 'Amit', 'Bangalore', 200, 1000),
(2001, 'Sita', 'Bangalore', 250, 1000),
(2002, 'Ravi', 'Delhi', 150, 1001),
(2003, 'Meera', 'Delhi', 300, 1001),
(2004, 'Ramesh', 'Mumbai', 180, 1003),
(2005, 'Sunita', 'Kolkata', 210, 1004);

-- INSERT INTO ORDERS
INSERT INTO ORDERS VALUES
(3000, 5000, '2024-03-01', 2000, 1000),
(3001, 7000, '2024-03-01', 2001, 1000),
(3002, 3000, '2024-03-02', 2002, 1001),
(3003, 8000, '2024-03-02', 2003, 1001),
(3004, 4500, '2024-03-03', 2004, 1003),
(3005, 6000, '2024-03-03', 2005, 1004);

#1
select cust_name from
customer
where grade > (select avg(grade) from customer where city = "Bangalore");


#2
select s.salesman_id, s.name from
salesman s
where s.salesman_id in (
select c.salesman_id
from customer c
group by c.salesman_id
having count(*)>0);



#3

select s.salesman_id, s.name, "yes" as "has_customer"
from salesman s 
where s.salesman_id in (
select c.salesman_id
from customer c
where city in (select city from salesman d where d.salesman_id = c.salesman_id)
group by c.salesman_id
having count(*)>1)

union

select s.salesman_id, s.name, "no" as "has_customer"
from salesman s 
where s.salesman_id not in (
select c.salesman_id
from customer c
where city in (select city from salesman d where d.salesman_id = c.salesman_id)
group by c.salesman_id
having count(*)>0);

#4

create view hgh as
select o.ord_date,  s.salesman_id, s.name
from orders o
join salesman s on o.salesman_id = s.salesman_id
where purchase_amt = (select max(purchase_amt) from orders f where f.ord_date = o.ord_date);

select * from hgh ;


#5

DELETE FROM orders
WHERE Salesman_id = 1000;

select * from orders




