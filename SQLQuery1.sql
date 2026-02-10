
/*
git init
git add .
git status
git commit -m "Initial commit: Add SQL folder"


Link your local folder to the GitHub repository:
git remote add origin https://github.com/your-username/my-s...


Push the folder to the main branch of your GitHub repository:
git push -u origin main
*/

--create database class1
--go
use class1

--#### **1. NOT NULL Constraint**  
--- Create a table named `student` with columns:  
--  - `id` (integer, should **not allow NULL values**)  
--  - `name` (string, can allow NULL values)  
--  - `age` (integer, can allow NULL values)  
--- First, create the table without the NOT NULL constraint.  
--- Then, use `ALTER TABLE` to apply the NOT NULL constraint to the `id` column.  

--###

create table student(
id int not null,
name varchar(100),
age int
);

alter table student
alter column id int not null;



--#### **2. UNIQUE Constraint**  
--- Create a table named `product` with the following columns:  
--  - `product_id` (integer, should be **unique**)  
--  - `product_name` (string, no constraint)  
--  - `price` (decimal, no constraint)  
--- First, define `product_id` as UNIQUE inside the `CREATE TABLE` statement.  
--- Then, drop the unique constraint and add it again using `ALTER TABLE`.  
--- Extend the constraint so that the combination of `product_id` and `product_name` must be unique.

CREATE TABLE product (
    product_id INT UNIQUE,
    product_name VARCHAR(100),
    price DECIMAL(10, 2)
);

ALTER TABLE product
ADD CONSTRAINT UQ_product_id UNIQUE (product_id);



--#### **3. PRIMARY KEY Constraint**  
--- Create a table named `orders` with:  
--  - `order_id` (integer, should be the **primary key**)  
--  - `customer_name` (string, no constraint)  
--  - `order_date` (date, no constraint)  
--- First, define the primary key inside the `CREATE TABLE` statement.  
--- Then, drop the primary key and add it again using `ALTER TABLE`.  


CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    order_date DATE
);

ALTER TABLE product DROP CONSTRAINT UQ_product_id;
ALTER TABLE product ADD CONSTRAINT UQ_product UNIQUE (product_id, product_name); 


--#### **4. FOREIGN KEY Constraint**  
--- Create two tables:  
--  - `category`:  
--    - `category_id` (integer, primary key)  
--    - `category_name` (string)  
--  - `item`:  
--    - `item_id` (integer, primary key)  
--    - `item_name` (string)  
--    - `category_id` (integer, should be a **foreign key referencing category_id in category table**)  
--- First, define the foreign key inside `CREATE TABLE`.  
--- Then, drop and add the foreign key using `ALTER TABLE`.  

CREATE TABLE category (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100)
);

CREATE TABLE item (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES category(category_id)
);


ALTER TABLE item DROP CONSTRAINT FK__item__category_id;
ALTER TABLE item ADD CONSTRAINT FK_item_category FOREIGN KEY (category_id) REFERENCES category(category_id); 



--#### **5. CHECK Constraint**  
--- Create a table named `account` with:  
--  - `account_id` (integer, primary key)  
--  - `balance` (decimal, should always be greater than or equal to 0)  
--  - `account_type` (string, should only accept values `'Saving'` or `'Checking'`)  
--- Use `CHECK` constraints to enforce these rules.  
--- First, define the constraints inside `CREATE TABLE`.  
--- Then, drop and re-add the `CHECK` constraints using `ALTER TABLE`.  

CREATE TABLE account (
    account_id INT PRIMARY KEY,
    balance DECIMAL(10,2) CHECK (balance >= 0),
    account_type VARCHAR(20) CHECK (account_type IN ('Saving', 'Checking'))
);

ALTER TABLE account DROP CONSTRAINT CHK_balance;
ALTER TABLE account DROP CONSTRAINT CHK_account_type;
ALTER TABLE account ADD CONSTRAINT CHK_balance CHECK (balance >= 0);
ALTER TABLE account ADD CONSTRAINT CHK_account_type CHECK (account_type IN ('Saving', 'Checking')); 


--#### **6. DEFAULT Constraint**  
--- Create a table named `customer` with:  
--  - `customer_id` (integer, primary key)  
--  - `name` (string, no constraint)  
--  - `city` (string, should have a default value of `'Unknown'`)  
--- First, define the default value inside `CREATE TABLE`.  
--- Then, drop and re-add the default constraint using `ALTER TABLE`.  


CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(100) DEFAULT 'Unknown'
);


ALTER TABLE customer DROP CONSTRAINT DF__customer__city;
ALTER TABLE customer ADD CONSTRAINT DF_city DEFAULT 'Unknown' FOR city;


--#### **7. IDENTITY Column**  
--- Create a table named `invoice` with:  
--  - `invoice_id` (integer, should **auto-increment starting from 1**)  
--  - `amount` (decimal, no constraint)  
--- Insert 5 rows into the table without specifying `invoice_id`.  
--- Enable and disable `IDENTITY_INSERT`, then manually insert a row with `invoice_id = 100`.  



CREATE TABLE invoice (
    invoice_id INT IDENTITY(1,1) PRIMARY KEY,
    amount DECIMAL(10,2)
);

INSERT INTO invoice (amount) VALUES (100.00), (200.00), (300.00), (400.00), (500.00);

SET IDENTITY_INSERT invoice ON;
INSERT INTO invoice (invoice_id, amount) VALUES (100, 600.00);
SET IDENTITY_INSERT invoice OFF; 

--### **8. All at once**  
--- Create a `books` table with:  
--  - `book_id` (integer, primary key, auto-increment)  
--  - `title` (string, **must not be empty**)  
--  - `price` (decimal, **must be greater than 0**)  
--  - `genre` (string, default should be `'Unknown'`)  
--- Insert data and test if all constraints work as expected.  

CREATE TABLE books (
    book_id INT IDENTITY(1,1) PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    price DECIMAL(10,2) CHECK (price > 0),
    genre VARCHAR(50) DEFAULT 'Unknown'
);

INSERT INTO books (title, price, genre) VALUES ('SQL Guide', 29.99, 'Tech');
INSERT INTO books (title, price) VALUES ('Python Book', 39.99);  -- genre defaults
-- INSERT INTO books (title, price) VALUES ('Invalid', -5);  -- Fails CHECK




--### **9. Scenario: Library Management System**  
--You need to design a simple database for a library where books are borrowed by members.  

--### **Tables and Columns:**  

--1. **Book** (Stores information about books)  
--   - `book_id` (Primary Key)  
--   - `title` (Text)  
--   - `author` (Text)  
--   - `published_year` (Integer)  

--2. **Member** (Stores information about library members)  
--   - `member_id` (Primary Key)  
--   - `name` (Text)  
--   - `email` (Text)  
--   - `phone_number` (Text)  

--3. **Loan** (Tracks which members borrow which books)  
--   - `loan_id` (Primary Key)  
--   - `book_id` (Foreign Key → References `book.book_id`)  
--   - `member_id` (Foreign Key → References `member.member_id`)  
--   - `loan_date` (Date)  
--   - `return_date` (Date, can be NULL if not returned yet)  

--### **Tasks:**  
--1. **Understand Relationships**  
--   - A **member** can borrow multiple **books**.  
--   - A **book** can be borrowed by different members at different times.  
--   - The **Loan** table connects `Book` and `Member` (Many-to-Many).  

--2. **Write SQL Statements**  
--   - Create the tables with proper constraints (Primary Key, Foreign Key).  
--   - Insert at least 2-3 sample records into each table.

CREATE TABLE Book (
    book_id INT IDENTITY(1,1) PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(100) NOT NULL,
    published_year INT CHECK (published_year > 1900)
);

CREATE TABLE Member (
    member_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone_number VARCHAR(20)
);

CREATE TABLE Loan (
    loan_id INT IDENTITY(1,1) PRIMARY KEY,
    book_id INT FOREIGN KEY REFERENCES Book(book_id),
    member_id INT FOREIGN KEY REFERENCES Member(member_id),
    loan_date DATE NOT NULL,
    return_date DATE NULL
); 

INSERT INTO Book (title, author, published_year) VALUES
('SQL Basics', 'John Doe', 2020),
('Python ML', 'Jane Smith', 2022),
('AI Vision', 'Bob Lee', 2024);

INSERT INTO Member (name, email, phone_number) VALUES
('Alice Johnson', 'alice@email.com', '+998901234567'),
('Bob Brown', 'bob@email.com', '+998987654321'),
('Carol Davis', 'carol@email.com', NULL);

INSERT INTO Loan (book_id, member_id, loan_date, return_date) VALUES
(1, 1, '2026-02-01', NULL),
(2, 2, '2026-01-15', '2026-02-10'),
(3, 1, '2026-02-05', NULL); 

