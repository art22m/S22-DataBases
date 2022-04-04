CREATE TABLE IF NOT EXISTS InitialTableEX2 (
	school varchar(50),
	teacher varchar(50),
	course varchar(50),
	room varchar(50),
	grade varchar(50),
	book varchar(50),
	publisher varchar(50),
	loanDate date
);

INSERT INTO InitialTableEX2 (school, teacher, course, room, grade, book, publisher, loanDate) VALUES
	('Horizon Education Institute', 'Chad Russell', 'Logical thinking', '1.A01', '1st grade', 'Learning and teaching in early childhood', 'BOA Editions', '2010-09-09'),
	('Horizon Education Institute', 'Chad Russell', 'Wrtting', '1.A01', '1st grade', 'Preschool,N56', 'Taylor & Francis Publishing', '2010-05-05'),
	('Horizon Education Institute', 'Chad Russell', 'Numerical Thinking', '1.A01', '1st grade', 'Learning and teaching in early childhood', 'BOA Editions', '2010-05-05'),
	('Horizon Education Institute', 'E.F.Codd', 'Spatial, Temporal and Causal Thinking', '1.B01', '1st grade', 'Early Childhood Education N9', 'Prentice Hall', '2010-05-06'),
	('Horizon Education Institute', 'E.F.Codd', 'Numerical Thinking', '1.B01', '1st grade', 'Learning and teaching in early childhood', 'BOA Editions', '2010-05-06'),
	('Horizon Education Institute', 'Jones Smith', 'Wrtting', '1.A01', '2nd grade', 'Learning and teaching in early childhood', 'BOA Editions', '2010-09-09'),
	('Horizon Education Institute', 'Jones Smith', 'English', '1.A01', '2nd grade', 'Know how to educate: guide for Parents and', 'McGraw Hill', '2010-05-05'),
	('Bright Institution', 'Adam Baker', 'Logical thinking', '2.B01', '1st grade', 'Know how to educate: guide for Parents and', 'McGraw Hill', '2010-10-18'),
	('Bright Institution', 'Adam Baker', 'Numerical Thinking', '2.B01', '1st grade', 'Learning and teaching in early childhood', 'BOA Editions', '2010-05-06');

CREATE TABLE IF NOT EXISTS Books (
	book varchar(50) PRIMARY KEY,
	publisher varchar(50)
);

CREATE TABLE IF NOT EXISTS TeachIn (
	teacher varchar(50) PRIMARY KEY,
	school varchar(50)
);

CREATE TABLE IF NOT EXISTS Classes (
	course varchar(50) NOT NULL,
	teacher varchar(50) NOT NULL,
	room varchar(50) NOT NULL, 
	loanDate date NOT NULL,
	book varchar(50),
	grade varchar(50),
	PRIMARY KEY (course, teacher, room, loanDate),
	FOREIGN KEY (book) REFERENCES Books(book),
	FOREIGN KEY (teacher) REFERENCES TeachIn(teacher)
);

INSERT INTO Books (book, publisher) 
(SELECT DISTINCT book, publisher FROM InitialTableEX2);

INSERT INTO TeachIn
(SELECT DISTINCT teacher, school FROM InitialTableEX2);

INSERT INTO Classes
(SELECT course, teacher, room, loanDate, book, grade FROM InitialTableEX2);

-- 1) Obtain for each of the schools, the number of books that have been loaned to each publishers.
SELECT DISTINCT school, Books.book, COUNT(Books.book), publisher
FROM Classes, Books, TeachIn
WHERE Classes.book = Books.book AND Classes.teacher = TeachIn.teacher
GROUP BY school, Books.book;


-- 2) For each school, find the book that has been on loan the longest and the teacher in charge of it.
SELECT DISTINCT ON (school) school, Classes.book, loanDate, Classes.teacher
FROM Classes, Books, TeachIn
WHERE Classes.book = Books.book AND TeachIn.teacher = Classes.teacher
ORDER BY school, loanDate DESC, Classes.book;