--create database lesson7
--go
--use lesson7
/*
drop table if exists Customers;
drop table if exists Orders;
drop table if exists OrderDetails;
drop table if exists Products;
*/
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10,2)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50)
);

--insert into

INSERT INTO Customers (CustomerID, CustomerName) VALUES
(1, 'Alice Johnson'),
(2, 'Bob Smith'),
(3, 'Charlie Brown'),
(4, 'Diana Prince');

INSERT INTO Products (ProductID, ProductName, Category) VALUES
(101, 'Laptop', 'Electronics'),
(102, 'Smartphone', 'Electronics'),
(103, 'Notebook', 'Stationery'),
(104, 'Pen', 'Stationery'),
(105, 'Desk Chair', 'Furniture');

INSERT INTO Orders (OrderID, CustomerID, OrderDate) VALUES
(1001, 1, '2024-01-10'),
(1002, 1, '2024-02-15'),
(1003, 2, '2024-03-05'),
(1004, 3, '2024-03-20');
-- Note: Diana (CustomerID 4) has no orders
INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, Price) VALUES
(5001, 1001, 101, 1, 1200.00),   -- Alice buys Laptop
(5002, 1001, 103, 2, 5.00),      -- Alice buys Notebooks
(5003, 1002, 102, 1, 800.00),    -- Alice buys Smartphone
(5004, 1003, 104, 10, 1.50),     -- Bob buys Pens
(5005, 1004, 101, 1, 1200.00),   -- Charlie buys Laptop
(5006, 1004, 105, 1, 150.00);    -- Charlie buys Desk Chair


--Task1

select *
from Customers c
left join Orders o
on c. CustomerID =o. CustomerID 

--Task2
select *
from Customers c
left join Orders o
on c. CustomerID =o. CustomerID 
where o.OrderID is null

--Task3
SELECT o.OrderID, p.ProductName, od.Quantity
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID;

--Task4
SELECT c.CustomerID, c.CustomerName, COUNT(o.OrderID) AS OrderCount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(o.OrderID) > 1;

--Task5
SELECT o.OrderID, p.ProductName, od.Price
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
JOIN Orders o ON od.OrderID = o.OrderID
WHERE od.Price = (
    SELECT MAX(Price)
    FROM OrderDetails
    WHERE OrderID = o.OrderID
);

--Task6
SELECT c.CustomerID, c.CustomerName, MAX(o.OrderDate) AS LatestOrderDate
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName;

--Task7
SELECT c.CustomerID, c.CustomerName
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(DISTINCT CASE WHEN p.Category <> 'Electronics' THEN 1 END) = 0;

--Task8
SELECT c.CustomerID, c.CustomerName
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
where p.Category='Stationery';

--Task9
SELECT c.CustomerID, c.CustomerName,
       SUM(od.Quantity * od.Price) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.CustomerName;


