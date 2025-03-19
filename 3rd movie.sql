#3
-- STEP 1: Create Tables (No constraints)

create database p3;
use p3;
CREATE TABLE ACTOR (
    Act_id INT,
    Act_Name VARCHAR(50),
    Act_Gender VARCHAR(10)
);

CREATE TABLE DIRECTOR (
    Dir_id INT,
    Dir_Name VARCHAR(50),
    Dir_Phone VARCHAR(15)
);

CREATE TABLE MOVIES (
    Mov_id INT,
    Mov_Title VARCHAR(100),
    Mov_Year YEAR,
    Mov_Lang VARCHAR(20),
    Dir_id INT
);

CREATE TABLE MOVIE_CAST (
    Act_id INT,
    Mov_id INT,
    Role VARCHAR(50)
);

CREATE TABLE RATING (
    Mov_id INT,
    Rev_Stars INT
);

-- STEP 2: Add Constraints using ALTER
ALTER TABLE ACTOR 
ADD PRIMARY KEY (Act_id);

ALTER TABLE DIRECTOR 
ADD PRIMARY KEY (Dir_id);

ALTER TABLE MOVIES 
ADD PRIMARY KEY (Mov_id);

ALTER TABLE MOVIES 
ADD CONSTRAINT fk_movies_director 
FOREIGN KEY (Dir_id) REFERENCES DIRECTOR(Dir_id) ;

ALTER TABLE MOVIE_CAST 
ADD PRIMARY KEY (Act_id, Mov_id);  -- ✅ Composite primary key added here

ALTER TABLE MOVIE_CAST 
ADD CONSTRAINT fk_cast_actor 
FOREIGN KEY (Act_id) REFERENCES ACTOR(Act_id) ON DELETE CASCADE;

ALTER TABLE MOVIE_CAST 
ADD CONSTRAINT fk_cast_movie 
FOREIGN KEY (Mov_id) REFERENCES MOVIES(Mov_id) ON DELETE CASCADE;

ALTER TABLE RATING 
ADD PRIMARY KEY (Mov_id);

ALTER TABLE RATING 
ADD CONSTRAINT fk_rating_movie 
FOREIGN KEY (Mov_id) REFERENCES MOVIES(Mov_id) ON DELETE CASCADE;
-- Insert sample data into DIRECTOR table
INSERT INTO DIRECTOR (Dir_id, Dir_Name, Dir_Phone) VALUES
(1, 'Hitchcock', '555-1234'),
(2, 'Steven Spielberg', '555-5678'),
(3, 'Christopher Nolan', '555-8765');

-- Insert sample data into ACTOR table
INSERT INTO ACTOR (Act_id, Act_Name, Act_Gender) VALUES
(1, 'Anthony Perkins', 'Male'),
(2, 'Tom Hanks', 'Male'),
(3, 'Leonardo DiCaprio', 'Male'),
(4, 'Meryl Streep', 'Female');

-- Insert sample data into MOVIES table
INSERT INTO MOVIES (Mov_id, Mov_Title, Mov_Year, Mov_Lang, Dir_id) VALUES
(1, 'Psycho', 1960, 'English', 1),
(2, 'Jaws', 1975, 'English', 2),
(3, 'Inception', 2010, 'English', 3),
(4, 'The Revenant', 2015, 'English', 3),
(5, 'Catch Me If You Can', 2002, 'English', 2);

-- Insert sample data into MOVIE_CAST table
INSERT INTO MOVIE_CAST (Act_id, Mov_id, Role) VALUES
(1, 1, 'Norman Bates'),
(2, 2, 'Chief Brody'),
(3, 3, 'Dom Cobb'),
(4, 4, 'Hugh Glass'),
(1, 5, 'Frank Abagnale Jr.'),
(2, 5, 'Carl Hanratty');

-- Insert sample data into RATING table
INSERT INTO RATING (Mov_id, Rev_Stars) VALUES
(1, 5),
(2, 4),
(3, 5),
(4, 3),
(5, 5);



SELECT Mov_Title
FROM MOVIES
JOIN DIRECTOR ON MOVIES.Dir_id = DIRECTOR.Dir_id
WHERE DIRECTOR.Dir_Name = 'Hitchcock';



SELECT Mov_Title 
FROM MOVIES 
WHERE Mov_id IN (
    SELECT Mov_id 
    FROM MOVIE_CAST 
    WHERE Act_id IN (
        SELECT Act_id 
        FROM MOVIE_CAST 
        GROUP BY Act_id 
        HAVING COUNT(DISTINCT Mov_id) >= 2
    )
);



-- Insert movies after 2015
INSERT INTO MOVIES (Mov_id, Mov_Title, Mov_Year, Mov_Lang, Dir_id) VALUES
(6, 'The Post', 2017, 'English', 2),
(7, 'The Martian', 2015, 'English', 2);

-- Insert movie cast for these movies
INSERT INTO MOVIE_CAST (Act_id, Mov_id, Role) VALUES
(1, 6, 'Ben Bradlee'),  -- Anthony Perkins acts in "The Post"
(2, 6, 'Katharine Graham'),  -- Tom Hanks acts in "The Post"
(3, 7, 'Mark Watney');  -- Leonardo DiCaprio acts in "The Martian"

-- Now let's ensure that actors who acted in movies before 2000 (already in the table) also appear in these new movies
-- Anthony Perkins already acted in "Psycho" (1960)
-- Tom Hanks already acted in "Catch Me If You Can" (2002)

-- Let's add another actor (e.g., Meryl Streep) to these movies
INSERT INTO MOVIE_CAST (Act_id, Mov_id, Role) VALUES
(4, 6, 'Meryl Streep Role in The Post'),
(4, 7, 'Meryl Streep Role in The Martian');



SELECT Act_Name
FROM ACTOR
WHERE Act_id IN (
    SELECT Act_id
    FROM MOVIE_CAST MC
    JOIN MOVIES M ON MC.Mov_id = M.Mov_id
    WHERE M.Mov_Year < 2000
)
AND Act_id IN (
    SELECT Act_id
    FROM MOVIE_CAST MC
    JOIN MOVIES M ON MC.Mov_id = M.Mov_id
    WHERE M.Mov_Year > 2015
);


SELECT MOVIES.Mov_Title, MAX(RATING.Rev_Stars) AS Max_Rev_Stars
FROM MOVIES
JOIN RATING ON MOVIES.Mov_id = RATING.Mov_id
GROUP BY MOVIES.Mov_Title
ORDER BY MOVIES.Mov_Title;




UPDATE RATING
SET Rev_Stars = 5
WHERE Mov_id IN (
    SELECT MOVIES.Mov_id
    FROM MOVIES
    JOIN DIRECTOR ON MOVIES.Dir_id = DIRECTOR.Dir_id
    WHERE DIRECTOR.Dir_Name = 'Steven Spielberg'
);

select * from rating;