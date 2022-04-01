CREATE TABLE if not exists Author
(
 author_id INTEGER PRIMARY KEY,
 first_name VARCHAR,
 last_name VARCHAR
);

CREATE TABLE if not exists Book
(
 book_id INTEGER PRIMARY KEY,
 book_title VARCHAR,
 month_ VARCHAR,
 year_ INTEGER,
 editor INTEGER,
 
 FOREIGN KEY (editor) REFERENCES Author(author_id)
);

CREATE TABLE if not exists Pub
(
 pub_id INTEGER PRIMARY KEY,
 title VARCHAR,
 book_id INTEGER,
 
 FOREIGN KEY (book_id) REFERENCES Book(book_id)
);

CREATE TABLE if not exists AuthorPub
(
 author_id INTEGER,
 pub_id INTEGER,
 author_position INTEGER,
 
 PRIMARY KEY (author_id, pub_id),
 FOREIGN KEY (author_id) REFERENCES Author(author_id),
 FOREIGN KEY (pub_id) REFERENCES Pub(pub_id)
);

INSERT INTO Author VALUES
(1, 'John', 'McCarthy'),
(2, 'Dennis', 'Ritchie'),
(3, 'Ken', 'Thompson'),
(4, 'Claude', 'Shannon'),
(5, 'Alan', 'Turing'),
(6, 'Alonzo', 'Church'),
(7, 'Perry', 'White'),
(8, 'Moshe', 'Vardi'),
(9, 'Roy', 'Batty');

INSERT INTO Book VALUES
(1, 'CACM', 'April', 1960, 8),
(2, 'CACM', 'July', 1974, 8),
(3, 'BTS', 'July', 1948, 2),
(4, 'MLS', 'November', 1936, 7),
(5, 'Mind', 'October', 1950, NULL),
(6, 'AMS', 'Month', 1941, NULL),
(7, 'AAAI', 'July', 2012, 9),
(8, 'NIPS', 'July', 2012, 9);

INSERT INTO Pub VALUES
(1, 'LISP', 1),
(2, 'Unix', 2),
(3, 'Info Theory', 3),
(4, 'Turing Machines', 4),
(5, 'Turing Test', 5),
(6, 'Lambda Calculus', 6);

INSERT INTO AuthorPub VALUES
(1,1,1),
(2,2,1),
(3,2,2),
(4,3,1),
(5,4,1),
(5,5,1),
(6,6,1);

-- 1
SELECT *
FROM Author JOIN Book ON Author.author_id = Book.editor;

-- 2
SELECT T1.first_name, T1.last_name
FROM (SELECT T2.author_id, T2.first_name, T2.last_name FROM Author AS T2
  EXCEPT
  SELECT B1.editor, Author.first_name, Author.last_name
  FROM Book AS B1 JOIN Author ON B1.editor=Author.author_id
  ) AS T1;
  
-- 3
SELECT author_id
FROM Author
EXCEPT
SELECT editor
FROM Book;