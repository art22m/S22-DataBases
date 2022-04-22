CREATE TABLE account(
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  credit REAL,
  currency VARCHAR(10),
  bank_name VARCHAR(50)
);


INSERT INTO account(Name, Credit, Currency, BankName) VALUES
	('Account 1', 1000, 'RUB', 'SberBank'),
	('Account 2', 1000, 'RUB', 'Tinkoff'),
	('Account 3', 1000, 'RUB', 'SberBank'),
	('Account 4', 0, 'RUB', '');

CREATE TABLE ledger(	
  id SERIAL PRIMARY KEY,
  from_id INT REFERENCES account (id),
  to_id INT REFERENCES account(id),
  fee REAL,
  amount REAL
  transaction_date_time TIMESTAMP
);


BEGIN transaction;
  SAVEPOINT sp1;
  UPDATE account SET credit = credit - 500 WHERE name = 'Account 1';
  UPDATE account SET credit = credit + 500 WHERE name = 'Account 3';
  INSERT INTO ledger(from_id, to_id, fee, amount, transaction_date_time) VALUES 
  (1, 3, 0, 500, DATE_TRUNC('second', CURRENT_TIMESTAMP::timestamp));
COMMIT;

BEGIN transaction;
  SAVEPOINT sp2;
  UPDATE account SET credit = credit - 700 WHERE name = 'Account 2';
  UPDATE account SET credit = credit + 700 WHERE name = 'Account 1';
  UPDATE account SET credit = credit + 30 WHERE name = 'Account 4';
  INSERT INTO ledger(from_id, to_id, fee, amount, transaction_date_time) VALUES
  (2, 1, 30, 700, DATE_TRUNC('second', CURRENT_TIMESTAMP::timestamp));
COMMIT;

BEGIN transaction;
  SAVEPOINT sp3;
  UPDATE account SET credit = credit - 100 WHERE name = 'Account 2';
  UPDATE account SET credit = credit + 100 WHERE name = 'Account 3';
  UPDATE account V credit = credit + 30 WHERE name = 'Account 4';
  INSERT INTO ledger(from_id, to_id, fee, amount, transaction_date_time) VALUES
  (2, 3, 30, 500, DATE_TRUNC('second', CURRENT_TIMESTAMP::timestamp));
COMMIT;
