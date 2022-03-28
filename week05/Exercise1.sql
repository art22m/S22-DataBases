CREATE TABLE Customer 
(
  id 	       int         NOT NULL PRIMARY KEY,
  discount     int,
  creditLimit  int, 
  balance      int         NOT NULL,
  house        varchar(50) NOT NULL,
  street       varchar(50) NOT NULL,
  district     varchar(50) NOT NULL,
  city         varchar(50) NOT NULL
);

CREATE TABLE Orders
(
  id           int         NOT NULL PRIMARY KEY,
  orderDate    date        NOT NULL, 
  house        varchar(50) NOT NULL,
  street       varchar(50) NOT NULL,
  district     varchar(50) NOT NULL,
  city         varchar(50) NOT NULL,
  customerId   int  	   NOT NULL,
  FOREIGN KEY (customerId) REFERENCES Customer(id)
);

CREATE TABLE Item
(
  id           int         NOT NULL PRIMARY KEY,
  description  varchar(50) NOT NULL
);

CREATE TABLE Manufacturer
(
  id          int      NOT NULL PRIMARY KEY,
  phonenumber char(50) NOT NULL
);

CREATE TABLE OrderItems ( 
  orderId int,
  itemId int,
  FOREIGN KEY (orderId) REFERENCES Orders(id),
  FOREIGN KEY (itemId) REFERENCES Item(id),
  quantity int NOT NULL
);

CREATE TABLE ItemManufacturer (
  manufacturerId int,
  itemId int,
  FOREIGN KEY (manufacturerId)REFERENCES Manufacturer(id),
  FOREIGN KEY (itemId) REFERENCES Item(id),
  quantity int NOT NULL  
)