create database p1;
use p1;

CREATE TABLE BOOK (
    Book_id INT,
    Title VARCHAR(200),
    Publisher_Name VARCHAR(100),
    Pub_Year YEAR
);

CREATE TABLE BOOK_AUTHORS (
    Book_id INT,
    Author_Name VARCHAR(100)
);

CREATE TABLE PUBLISHER (
    Pub_id INT,
    Name VARCHAR(100),
    Address VARCHAR(200),
    Phone VARCHAR(15)
);

CREATE TABLE BOOK_COPIES (
    Book_id INT,
    Branch_id INT,
    No_of_Copies INT
);

CREATE TABLE BOOK_LENDING (
    Book_id INT,
    Branch_id INT,
    Card_No INT,
    Date_Out DATE,
    Due_Date DATE
);

CREATE TABLE LIBRARY_BRANCH (
    Branch_id INT,
    Branch_Name VARCHAR(100),
    Address VARCHAR(200)
);

#add primary key contrsinats

alter table book
add constraint book_keysff primary key(book_id);

ALTER TABLE BOOK_AUTHORS
ADD CONSTRAINT PK_BOOK_AUTHORS PRIMARY KEY (Book_id, Author_Name);

ALTER TABLE PUBLISHER
ADD CONSTRAINT PK_PUBLISHER PRIMARY KEY (Pub_id);

ALTER TABLE BOOK_COPIES
ADD CONSTRAINT PK_BOOK_COPIES PRIMARY KEY (Book_id, Branch_id);

ALTER TABLE BOOK_LENDING
ADD CONSTRAINT PK_BOOK_LENDING PRIMARY KEY (Book_id, Branch_id, Card_No);

ALTER TABLE LIBRARY_BRANCH
ADD CONSTRAINT PK_LIBRARY_BRANCH PRIMARY KEY (Branch_id);

#add foregin key constrainst

alter table books
add constraint fk_pubslishercss foreign key(publisher_name) references publisher (name);

alter table book_authors
ADD CONSTRAINT FK_BOOK_AUTHORS_BOOK FOREIGN KEY (Book_id) REFERENCES BOOK(Book_id) ON DELETE CASCADE;

ALTER TABLE BOOK_COPIES
ADD CONSTRAINT FK_BOOK_COPIES_BOOK FOREIGN KEY (Book_id) REFERENCES BOOK(Book_id) ON DELETE CASCADE;

ALTER TABLE BOOK_LENDING
ADD CONSTRAINT FK_BOOK_LENDING_BOOK FOREIGN KEY (Book_id) REFERENCES BOOK(Book_id) ON DELETE CASCADE;

ALTER TABLE BOOK_COPIES
ADD CONSTRAINT FK_BOOK_COPIES_BRANCH FOREIGN KEY (Branch_id) REFERENCES LIBRARY_BRANCH(Branch_id);

ALTER TABLE BOOK_LENDING
ADD CONSTRAINT FK_BOOK_LENDING_BRANCH FOREIGN KEY (Branch_id) REFERENCES LIBRARY_BRANCH(Branch_id);

# inserting
INSERT INTO BOOK VALUES
(1, 'Database Systems', 'Pearson', 2018),
(2, 'Operating Systems', 'McGraw Hill', 2019),
(3, 'Computer Networks', 'Pearson', 2020),
(4, 'Data Structures', 'O Reilly', 2017),
(5, 'Machine Learning', 'Springer', 2021),
(8, 'Machine Learning', 'Springer', 2021);

INSERT INTO PUBLISHER VALUES
(101, 'Pearson', 'New York', '1234567890'),
(102, 'McGraw Hill', 'Chicago', '2345678901'),
(103, 'O Reilly', 'San Francisco', '3456789012'),
(104, 'Springer', 'Berlin', '4567890123'),
(105, 'Elsevier', 'London', '5678901234');

INSERT INTO BOOK_AUTHORS VALUES
(1, 'Korth'),
(2, 'Silberschatz'),
(3, 'Tanenbaum'),
(4, 'Mark Allen Weiss'),
(5, 'Tom Mitchell');

INSERT INTO LIBRARY_BRANCH VALUES
(10, 'Central Library', 'Main Street'),
(11, 'Science Block', 'North Wing'),
(12, 'Engineering Block', 'East Wing'),
(13, 'IT Block', 'South Wing'),
(14, 'Management Block', 'West Wing');

INSERT INTO BOOK_COPIES VALUES
(1, 10, 5),
(2, 11, 3),
(3, 12, 4),
(4, 13, 2),
(5, 14, 6);

truncate book_lending;
TRUNCATE TABLE BOOK_LENDING;

INSERT INTO BOOK_LENDING VALUES
(1, 10, 1001, '2025-01-10', '2025-01-24'),
(2, 11, 1001, '2025-02-15', '2025-03-01'),
(3, 12, 1001, '2025-03-01', '2025-03-15'),
(4, 13, 1001, '2025-04-05', '2025-04-19'),
(5, 11, 1002, '2025-01-12', '2025-01-26'),
(2, 11, 1002, '2025-02-18', '2025-03-04'),
(3, 12, 1002, '2025-03-10', '2025-03-24'),
(4, 13, 1002, '2025-04-12', '2025-04-26'),
(5, 14, 1002, '2025-05-15', '2025-05-29'),
(3, 12, 1003, '2025-03-05', '2025-03-19'),
(4, 13, 1004, '2025-03-07', '2025-03-21'),
(5, 14, 1005, '2025-03-09', '2025-03-23');

#1
SELECT B.Book_id, 
       B.Title, 
       B.Publisher_Name, 
       A.Author_Name, 
       C.Branch_id, 
       C.No_of_Copies
FROM BOOK B
JOIN BOOK_AUTHORS A ON B.Book_id = A.Book_id
JOIN BOOK_COPIES C ON B.Book_id = C.Book_id;
select * from book_lending;

#2
SELECT Card_No, COUNT(*) AS Total_Books_Borrowed
FROM BOOK_LENDING
WHERE Date_Out BETWEEN '2025-01-01' AND '2025-06-30'
GROUP BY Card_No
HAVING COUNT(*) > 3;


#step1: enable cascade while declaring foreign key  This way, deleting a book from
# BOOK will automatically delete related records from other tablesALTER TABLE BOOK_AUTHORS


DELETE FROM BOOK 
WHERE
    Book_id = 3;

SELECT 
    *
FROM
    book
WHERE
    book_id ;
select * from book_authors;

#4th one
SELECT Pub_Year, COUNT(*) AS Total_Books
FROM BOOK
GROUP BY Pub_Year;

#5th one
CREATE VIEW Book_Availability AS
SELECT B.Book_id, B.Title, SUM(BC.No_of_Copies) AS Total_Copies
FROM BOOK B
JOIN BOOK_COPIES BC ON B.Book_id = BC.Book_id
GROUP BY B.Book_id, B.Title;

select * from book_Availability;