CREATE TABLE IF NOT EXISTS InitialTableEX1 (
	orderId integer NOT NULL,
	date_ date NOT NULL,
	customerId integer NOT NULL, 
	customerName varchar(50) NOT NULL,
	city varchar(50) NOT NULL,
	itemId integer NOT NULL,
	itemName varchar(50) NOT NULL,
	quant integer NOT NULL,
	price real NOT NULL,
	PRIMARY KEY(orderId, customerId, itemId)
);

INSERT INTO InitialTableEX1 (orderId, date_, customerId, customerName, city, itemId, itemName, quant, price) VALUES
	(2301, '2011-02-23', 101, 'Martin', 'Prague', 3786, 'Net', 3, 35),
	(2301, '2011-02-23', 101, 'Martin', 'Prague', 4011, 'Racket', 6, 65),
	(2301, '2011-02-23', 101, 'Martin', 'Prague', 9132, 'Pack-3', 8, 4.75),
	(2302, '2011-02-25', 107, 'Herman', 'Madrid', 5794, 'Pack-6', 4, 5),
	(2303, '2011-02-27', 110, 'Pedro', 'Moscow', 4011, 'Racket', 2, 65),
	(2303, '2011-02-27', 110, 'Pedro', 'Moscow', 3141, 'Cover', 2, 10);

CREATE TABLE IF NOT EXISTS Customers (
	customerId integer NOT NULL PRIMARY KEY,
	customerName varchar(50) NOT NULL,
	city varchar(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS Orders (
	orderId integer NOT NULL PRIMARY KEY,
	date_ date NOT NULL, 
	customerId integer NOT NULL,
	FOREIGN KEY (customerId) REFERENCES Customers(customerId)
);

CREATE TABLE IF NOT EXISTS Items (
	itemId integer NOT NULL PRIMARY KEY,
	itemName varchar(50) NOT NULL,
	price real NOT NULL
);

CREATE TABLE IF NOT EXISTS OrderItem (
	orderId integer NOT NULL,
	itemId integer NOT NULL,
	quant integer NOT NULL,
	
	FOREIGN KEY (orderId) REFERENCES Orders(orderId),
	FOREIGN KEY (itemId) REFERENCES Items(itemId),
	PRIMARY KEY (orderId, itemId)
);

INSERT INTO Items (itemId, itemName, price) (
	SELECT DISTINCT itemId, itemName, price
	FROM InitialTableEX1
);

INSERT INTO Customers (customerId, customerName, city) (
	SELECT DISTINCT customerId, customerName, city
	FROM InitialTableEX1
);

INSERT INTO Orders (orderId, date_, customerId) (
	SELECT DISTINCT orderId, date_, customerId
	FROM InitialTableEX1
);

INSERT INTO OrderItem (orderId, itemId, quant) (
	SELECT DISTINCT orderId, itemId, quant
	FROM InitialTableEX1
);

-- 1) Calculate the total number of items per order and the total amount to pay for the order.
SELECT OrderItem.orderId, COUNT(OrderItem.itemId) AS TotalNumber, SUM(Items.price * OrderItem.quant) AS OrderCost
FROM OrderItem, Items
WHERE OrderItem.itemId = Items.itemId
GROUP BY (orderId);

-- 2) Obtain the customer whose purchase in terms of money has been greater than the others
SELECT DISTINCT Customers.customerId, SUM(OrderItem.quant * Items.price) AS MaxSpendings
FROM Customers, OrderItem, Orders, Items
WHERE OrderItem.orderId = Orders.orderId 
	  AND Orders.customerId = Customers.customerId
	  AND OrderItem.itemId = Items.itemId
GROUP BY Customers.customerId
ORDER BY MaxSpendings DESC LIMIT 1;