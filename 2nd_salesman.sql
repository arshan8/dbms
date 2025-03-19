#2


create database p2;
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

SELECT COUNT(*) AS count_above_bangalore_avg
FROM CUSTOMER
WHERE GRADE > (SELECT AVG(GRADE) 
               FROM CUSTOMER WHERE CITY = 'BANGALORE');






SELECT Name 
FROM SALESMAN
WHERE Salesman_id IN (
    SELECT Salesman_id
    FROM CUSTOMER
    GROUP BY Salesman_id
    HAVING COUNT(*) > 1
);








-- Salesmen who have customers in their city
SELECT S.Salesman_id, S.Name, 'Has Customer' AS Status
FROM SALESMAN S
WHERE S.Salesman_id IN (
    SELECT C.Salesman_id
    FROM CUSTOMER C
    WHERE C.City = (SELECT City FROM SALESMAN WHERE Salesman_id = C.Salesman_id)
)

UNION

-- Salesmen who don't have customers in their city
SELECT S.Salesman_id, S.Name, 'No Customer' AS Status
FROM SALESMAN S
WHERE S.Salesman_id NOT IN (
    SELECT C.Salesman_id
    FROM CUSTOMER C
    WHERE C.City = (SELECT City FROM SALESMAN WHERE Salesman_id = C.Salesman_id)
);






CREATE VIEW Highest_Order_View AS
SELECT O.Ord_Date, S.Salesman_id, S.Name AS Salesman_Name, 
       C.Customer_id, C.Cust_Name, O.Purchase_Amt
FROM ORDERS O
JOIN CUSTOMER C ON O.Customer_id = C.Customer_id
JOIN SALESMAN S ON O.Salesman_id = S.Salesman_id
WHERE (O.Purchase_Amt, O.Ord_Date) IN (
    SELECT MAX(Purchase_Amt), Ord_Date
    FROM ORDERS
    GROUP BY Ord_Date
);
select * from Highest_Order_View;

ALTER TABLE ORDERS
DROP FOREIGN KEY fk_salesman;

ALTER TABLE ORDERS
ADD CONSTRAINT fk_salesman
FOREIGN KEY (Salesman_id) REFERENCES SALESMAN(Salesman_id)
ON DELETE CASCADE;

DELETE FROM orders
WHERE Salesman_id = 1000;

select * from orders

