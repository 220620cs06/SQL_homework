--go
--use class1

--### **1. DELETE vs TRUNCATE vs DROP (with IDENTITY example)**
--- Create a table `test_identity` with an `IDENTITY(1,1)` column and insert 5 rows.
--- Use `DELETE`, `TRUNCATE`, and `DROP` one by one (in different test cases) and observe how they behave.
--- Answer the following questions:


create table test_identity(
	id int identity(1,1),
	name VARCHAR(50)
);

INSERT INTO test_identity (name)
VALUES ('A'), ('B'), ('C'), ('D'), ('E');

SELECT * FROM test_identity;

--delete

DELETE FROM test_identity;
SELECT * FROM test_identity;
INSERT INTO test_identity (name) VALUES ('F');
SELECT * FROM test_identity;

--What happens to the identity column when you use `DELETE`?
--Rows are removed, but the identity counter does not reset.
--If last ID was 5, the next insert will be 6.


--truncate

TRUNCATE TABLE test_identity;
INSERT INTO test_identity (name) VALUES ('G');
SELECT * FROM test_identity;

--What happens to the identity column when you use `TRUNCATE`?
-- All rows are removed, and the identity counter resets to 1.


--drop

DROP TABLE test_identity;
--What happens to the table when you use `DROP`?
--The table itself is deleted. You cannot insert or query until you recreate it.





--#### **2. Common Data Types**
--- Create a table `data_types_demo` with columns covering at least **one example of each data type** covered in class.
--- Insert values into the table.
--- Retrieve and display the values.

CREATE TABLE data_types_demo (
    id INT,
    name VARCHAR(50),
    dob DATE,
    salary DECIMAL(10,2),
    is_active BIT,
    created_at DATETIME,
    notes TEXT
);

INSERT INTO data_types_demo VALUES
(1, 'Alice', '1990-01-01', 5000.50, 1, GETDATE(), 'First record'),
(2, 'Bob', '1985-05-12', 7000.00, 0, GETDATE(), 'Second record');

SELECT * FROM data_types_demo;





--#### **3. Inserting and Retrieving an Image**
--- Create a `photos` table with an `id` column and a `varbinary(max)` column.
--- Insert an image into the table using `OPENROWSET`.
--- Write a Python script to retrieve the image and save it as a file.


create table photos(
   id INT IDENTITY(1,1),
   image VARBINARY(MAX)
);


insert into photos(image)
select * from openrowset(
	bulk 'C:\Users\Hp\Pictures\flower.webp',SINGLE_BLOB
) as img

select @@servername

select * from photos

--#### **4. Computed Columns**
--- Create a `student` table with a computed column `total_tuition` as `classes * tuition_per_class`.
--- Insert 3 sample rows.
--- Retrieve all data and check if the computed column works correctly.
drop table if exists student;
CREATE TABLE student (
    id INT IDENTITY(1,1),
    name VARCHAR(50),
    classes INT,
    tuition_per_class DECIMAL(10,2),
    total_tuition AS (classes * tuition_per_class)
);

INSERT INTO student (name, classes, tuition_per_class)
VALUES ('Ali', 5, 1000), ('Bob', 3, 1200), ('Cathy', 4, 900);

SELECT * FROM student;


--#### **5. CSV to SQL Server**
--- Download or create a CSV file with at least 5 rows of worker data (`id, name`).
--- Use `BULK INSERT` to import the CSV file into the `worker` table.
--- Verify the imported data.

CREATE TABLE worker (
    id INT,
    name VARCHAR(50)
);

BULK INSERT worker
FROM 'C:\Users\Hp\Downloads\workers.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

SELECT * FROM worker;