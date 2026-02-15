--create database lesson3
--go
--use lesson3

--## DDL
--sql
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2),
    HireDate DATE
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    Status VARCHAR(20) CHECK (Status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Stock INT
);


---
/*
### **Task 1: Employee Salary Report**
Write an SQL query that:
- Selects the **top 10% highest-paid** employees.
- Groups them by **department** and calculates the **average salary per department**.
- Displays a new column `SalaryCategory`:
  - 'High' if Salary > 80,000  
  - 'Medium' if Salary is **between** 50,000 and 80,000  
  - 'Low' otherwise.  
- Orders the result by `AverageSalary` **descending**.
- Skips the first 2 records and fetches the next 5.

---
*/
INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, Salary, HireDate)
VALUES
(1, 'Alice', 'Smith', 'IT', 90000, '2020-05-10'),
(2, 'Bob', 'Johnson', 'HR', 60000, '2019-03-15'),
(3, 'Charlie', 'Williams', 'Finance', 75000, '2021-07-01'),
(4, 'Diana', 'Brown', 'IT', 85000, '2018-11-20'),
(5, 'Ethan', 'Davis', 'Finance', 45000, '2022-01-12'),
(6, 'Fiona', 'Miller', 'HR', 95000, '2017-09-05'),
(7, 'George', 'Wilson', 'IT', 50000, '2023-02-14'),
(8, 'Hannah', 'Moore', 'Finance', 82000, '2020-06-30');


SELECT 
    Department,
    AVG(Salary) AS AverageSalary,
    CASE 
        WHEN AVG(Salary) > 80000 THEN 'High'
        WHEN AVG(Salary) BETWEEN 50000 AND 80000 THEN 'Medium'
        ELSE 'Low'
    END AS SalaryCategory
FROM Employees
WHERE Salary >= 80000  -- simple filter for top salaries
GROUP BY Department
ORDER BY AverageSalary DESC
OFFSET 2 ROWS FETCH NEXT 5 ROWS ONLY;



/*

### **Task 2: Customer Order Insights**
Write an SQL query that:
- Selects customers who placed orders **between** '2023-01-01' and '2023-12-31'.  
- Includes a new column `OrderStatus` that returns:
  - 'Completed' for **Shipped** or **Delivered** orders.  
  - 'Pending' for **Pending** orders.  
  - 'Cancelled' for **Cancelled** orders.  
- Groups by `OrderStatus` and finds the **total number of orders** and **total revenue**.  
- Filters only statuses where revenue is greater than 5000.  
- Orders by `TotalRevenue` **descending**.

---
*/
INSERT INTO Orders (OrderID, CustomerName, OrderDate, TotalAmount, Status)
VALUES
(101, 'John Doe', '2023-02-10', 3000, 'Pending'),
(102, 'Jane Roe', '2023-03-15', 7000, 'Shipped'),
(103, 'Sam Lee', '2023-05-20', 12000, 'Delivered'),
(104, 'Chris Kim', '2023-07-25', 2000, 'Cancelled'),
(105, 'Pat Green', '2023-09-05', 8000, 'Delivered'),
(106, 'Alex White', '2023-11-11', 6000, 'Pending');

SELECT 
    CASE 
        WHEN Status IN ('Shipped', 'Delivered') THEN 'Completed'
        WHEN Status = 'Pending' THEN 'Pending'
        ELSE 'Cancelled'
    END AS OrderStatus,
    COUNT(*) AS TotalOrders,
    SUM(TotalAmount) AS TotalRevenue
FROM Orders
WHERE OrderDate BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY 
    CASE 
        WHEN Status IN ('Shipped', 'Delivered') THEN 'Completed'
        WHEN Status = 'Pending' THEN 'Pending'
        ELSE 'Cancelled'
    END
HAVING SUM(TotalAmount) > 5000
ORDER BY TotalRevenue DESC;


/*
### **Task 3: Product Inventory Check**
Write an SQL query that:
- Selects **distinct** product categories.
- Finds the **most expensive** product in each category.
- Assigns an inventory status using `IIF`:
  - 'Out of Stock' if `Stock = 0`.  
  - 'Low Stock' if `Stock` is **between** 1 and 10.  
  - 'In Stock' otherwise.  
- Orders the result by `Price` **descending** and skips the first 5 rows.

*/
INSERT INTO Products (ProductID, ProductName, Category, Price, Stock)
VALUES
(201, 'Laptop Pro', 'Electronics', 1500, 5),
(202, 'Smartphone X', 'Electronics', 1200, 0),
(203, 'Office Chair', 'Furniture', 300, 12),
(204, 'Desk Deluxe', 'Furniture', 450, 2),
(205, 'Running Shoes', 'Sportswear', 120, 0),
(206, 'Tennis Racket', 'Sportswear', 200, 8),
(207, 'Smartwatch', 'Electronics', 800, 15),
(208, 'Sofa Comfort', 'Furniture', 1000, 1);


SELECT 
    Category,
    ProductName,
    Price,
    IIF(Stock = 0, 'Out of Stock',
        IIF(Stock BETWEEN 1 AND 10, 'Low Stock', 'In Stock')) AS InventoryStatus
FROM Products
ORDER BY Price DESC
OFFSET 5 ROWS;
