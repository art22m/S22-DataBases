CREATE TABLE Groups 
(
  id int NOT NULL PRIMARY KEY
);

CREATE TABLE Company 
(
  id int NOT NULL PRIMARY KEY,
  superCompanyId int,
  FOREIGN KEY (superCompanyId) REFERENCES Company(id),
  groupId int,
  FOREIGN KEY (groupId) REFERENCES Groups(id)
);

CREATE TABLE Plant 
(
  id int NOT NULL PRIMARY KEY,
  companyId int,
  FOREIGN KEY (companyId) REFERENCES Company(id)
);

CREATE TABLE Item 
(
  id int NOT NULL PRIMARY KEY,
  plantId int,
  FOREIGN KEY (plantId) REFERENCES Plant(id)
);