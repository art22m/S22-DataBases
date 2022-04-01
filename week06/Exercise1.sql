CREATE TABLE if not exists Suppliers 
(
	sid integer NOT NULL PRIMARY KEY,
	sname varchar(50),
	address varchar(50)
);

CREATE TABLE if not exists Parts 
(
	pid integer NOT NULL PRIMARY KEY,
	pname varchar(50),
	color varchar(50)
);

CREATE TABLE if not exists Catalog_ 
(
	sid integer NOT NULL,
	pid integer NOT NULL,
	PRIMARY KEY (sid, pid),
	FOREIGN KEY (sid) REFERENCES Suppliers(sid),
	FOREIGN KEY (pid) REFERENCES Parts(pid),
	cost_ real
);

INSERT INTO Suppliers (sid, sname, address) VALUES
    (1, 'Yosemite Sham', 'Devil’s canyon, AZ'),
	(2, 'Wiley E. Coyote', 'RR Asylum, NV'),
	(3, 'YElmer Fudd', 'Carrot Patch, MN');
	
INSERT INTO Parts (pid, pname, color) VALUES
    (1, 'Red1', 'Red'),
	(2, 'Red2', 'Red'),
	(3, 'Green1', 'Green'),
	(4, 'Blue1', 'Blue'),
	(5, 'Red3', 'Red');
	
INSERT INTO Catalog_ (sid, pid, cost_) VALUES
    (1, 1, 10),
	(1, 2, 20),
	(1, 3, 30),
	(1, 4, 40),
	(1, 5, 50),
	(2, 1, 9),
	(2, 3, 34),
	(2, 5, 48);
	
	-- 1 Find the names of suppliers who supply some red part.
	SELECT DISTINCT sname
	FROM (Catalog_ JOIN Parts ON Catalog_.pid = Parts.pid) JOIN Suppliers ON Catalog_.sid = Suppliers.sid
	WHERE color = 'Red';

	-- 2 Find the sids of suppliers who supply some red or green part.
	SELECT DISTINCT sid
	FROM Catalog_ JOIN Parts ON Catalog_.pid = Parts.pid
	WHERE color = 'Red' OR color = 'Green';

	-- 3 Find the sids of suppliers who supply some red part or are at 221 Packer Street.
	SELECT DISTINCT sid
	FROM Catalog_ JOIN Parts ON Catalog_.pid = Parts.pid
	WHERE color = 'Red' UNION (SELECT sid 
							   FROM Suppliers 
							   WHERE address = '221 Packer Street');

	-- 4 Find the sids of suppliers who supply every red or green part.
	SELECT DISTINCT Catalog_.sid
	FROM Catalog_ 
	EXCEPT SELECT DISTINCT T1.sid 
		   FROM (SELECT Suppliers.sid, Parts.pid 
				 FROM Suppliers, Parts 
				 WHERE Parts.color='Red' EXCEPT SELECT T2.sid, T2.pid 
												FROM Catalog_ AS T2) AS T1
	UNION
	SELECT DISTINCT sid 
	FROM Catalog_, Parts 
	WHERE Catalog_.pid=Parts.pid AND Parts.color='Green';


	-- 5 Find the sids of suppliers who supply every red part or supply every green part.
	SELECT DISTINCT Catalog_.sid
	FROM Catalog_ 
	EXCEPT SELECT DISTINCT T1.sid 
		   FROM (SELECT Suppliers.sid, Parts.pid 
				 FROM Suppliers, Parts 
				 WHERE Parts.color='Red' EXCEPT SELECT T2.sid, T2.pid 
												FROM Catalog_ AS T2) AS T1
	UNION
	SELECT DISTINCT Catalog_.sid
	FROM Catalog_ 
	EXCEPT SELECT DISTINCT T1.sid 
		   FROM (SELECT Suppliers.sid, Parts.pid 
				 FROM Suppliers, Parts 
				 WHERE Parts.color='Green' EXCEPT SELECT T2.sid, T2.pid 
												FROM Catalog_ AS T2) AS T1;
											
	-- 6 Find pairs of sids such that the supplier with the first sid charges more for some part than the supplier with the second sid.
	SELECT T1.sid, T2.sid
	FROM Catalog_ AS T1, Catalog_ AS T2
	WHERE T1.sid != T2.sid AND T1.pid = T2.pid AND T1.cost_ > T2.cost_;

	-- 7 Find the pids of parts supplied by at least two different suppliers.
	SELECT DISTINCT T1.pid
	FROM Catalog_ AS T1, Catalog_ AS T2
	WHERE T1.pid = T2.pid AND T1.sid != T2.sid;

	-- 8 find the average cost of the red parts and green parts for each of the suppliers
	SELECT AVG(Catalog_.cost_), Catalog_.sid, Parts.color
	FROM Catalog_ JOIN Parts ON Catalog_.pid=Parts.pid AND Parts.color='Red'
	GROUP BY Catalog_.sid, Parts.color
	UNION
	SELECT AVG(Catalog_.cost_), Catalog_.sid, Parts.color
	FROM Catalog_ JOIN Parts ON Catalog_.pid=Parts.pid AND Parts.color='Green'
	GROUP BY Catalog_.sid, Parts.color;

	-- 9 find the sids of suppliers whose most expensive part costs $50 or more
	SELECT DISTINCT sid
	FROM Catalog_
	WHERE Catalog_.cost_ >= 50