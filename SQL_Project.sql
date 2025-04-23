USE Project;
show databases;

SELECT * from mobile_sales;

-- a show distict
SELECT DISTINCT payment_method FROM mobile_sales;
SELECT DISTINCT Brand FROM mobile_sales;


-- b Create a function on the table.
DELIMITER //

CREATE FUNCTION GetAveragePrice()
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
DECLARE avg_price DECIMAL(10, 2);
    
SELECT AVG(Price) INTO avg_price
FROM mobile_sales;
    
    RETURN avg_price;
END //

DELIMITER ;

SELECT GetAveragePrice() AS avg_price;

-- -- e. Add a new field to the table.
 ALTER TABLE mobile_sales
 ADD COLUMN Tax DECIMAL(10,2) AFTER Total_Revenue;


SELECT * FROM mobile_sales;
UPDATE mobile_sales
SET Tax = Total_Revenue * 0.1;
SELECT * FROM mobile_sales;

-- -- c. Create Insert, Delete and Update triggers on your table.


CREATE TRIGGER before_Total_Revenue_update
BEFORE UPDATE ON mobile_sales
FOR EACH ROW
SET NEW.Tax = Total_Revenue * 0.1;

DROP TRIGGER before_Total_Revenue_update;

INSERT INTO mobile_sales 
-- (Transaction_ID, Date, Mobile_Model, Brand, Price, Units_Sold, Total_Revenue, Customer_Age, Customer_Gender, Location, Payment_Method) 
VALUES 
(80, '2024-09-30', 'Itel A3', 'Itel', 10000, 2, 2000, 4000 ,30, 'Male', 'Miami', 'Debit Card');

SELECT * FROM mobile_sales WHERE Transaction_ID = 80;


CREATE TRIGGER before_insert_mobile_sales
BEFORE INSERT ON mobile_sales
FOR EACH ROW
SET NEW.Total_Revenue = NEW.Price * NEW.Units_Sold;  

-- DROP TRIGGER before_insert_mobile_sales;

 INSERT INTO mobile_sales 
(Transaction_ID, Date, Mobile_Model, Brand, Price, Units_Sold, Total_Revenue, Customer_Age, Customer_Gender, Location, Payment_Method) 
VALUES 
(6, '2024-10-29', 'Nokia 8.3', 'Nokia', 699.99, 2, 0,25, 'Male', 'Miami', 'Credit Card');

SELECT * FROM mobile_sales WHERE Transaction_ID = 80;



UPDATE mobile_sales
SET Price = 850.00
WHERE Transaction_ID = 50;

CREATE TABLE expenses(
	expense_id int primary key, expense_name varchar(55), expense_total decimal(10,2));
    
    SELECT * FROM expenses;
    
    INSERT INTO expenses
    VALUES (1, "Total_Revenue", 0.00),
		   (2, "Supplies", 0.00),
           (3, "Taxes", 0.00);

UPDATE expenses
SET expense_total = (select sum(Total_Revenue) from mobile_sales)
WHERE expense_name = "Total_Revenue";
SELECT * FROM expenses;

CREATE TRIGGER after_Total_Revenue_delete
AFTER DELETE ON mobile_sales
FOR EACH ROW
UPDATE expenses
SET expense_total = expense_total - old.Total_Revenue
WHERE expense_name = "Total_Revenue";

-- DROP TRIGGER after_Total_Revenue_delete;

DELETE from mobile_sales
WHERE transaction_id = 80;

SELECT * FROM expenses;


-- CREATE  STORED PROCEDURE 

DELIMITER //
CREATE PROCEDURE large_revenue()
BEGIN
	SELECT *
    FROM mobile_sales
    WHERE total_revenue >= 20000;
END//
DELIMITER ;

CALL large_revenue();

-- ALTER TABLE mobile_sales CHANGE Customer_Age Age int;

SELECT * FROM mobile_sales;
--  Create a new user in your database
 CREATE USER 'PA'@ 'localhost' IDENTIFIED BY '123456'; 

-- Grant the new user select, insert and alter privileges.
 GRANT SELECT, INSERT, ALTER ON Project.mobile_sales TO 'PA'@localhost;

REVOKE ALL PRIVILEGES,
GRANT OPTION FROM  'PA'@'localhost';

"C:\Program Files\MySQL\MySQL Server 9.0\bin\mysqldump.exe" -u root -p project mobile_sales > C:\Users\PAULA\Desktop\mobile_sales_backup.sql

"C:\Program Files\MySQL\MySQL Server 9.0\bin\mysql.exe" -u root -p test_project < C:\Users\PAULA\Desktop\mobile_sales_backup.sql

-- Char: Fixed length. Always uses the same amount of space, even if the value is shorter than the defined length.
-- Varchar: Variable length. Only uses space based on the length of the actual data stored.

-- SQL: A language used to query and manipulate databases.
-- MySQL: A database management system (DBMS) that uses SQL.

-- Triggers are special stored procedures that automatically execute in response to specific events in a database.

-- Primary key: Unique Identifier
-- Foreign key: Primary key in another colum



































