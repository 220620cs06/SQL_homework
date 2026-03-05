--create
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name NVARCHAR(50),
    Department NVARCHAR(50),
    Salary INT
);

--insert into
INSERT INTO Employees (EmployeeID, Name, Department, Salary) VALUES
(1, 'Alice', 'HR', 5000),
(2, 'Bob', 'IT', 7000),
(3, 'Charlie', 'Sales', 6000),
(4, 'David', 'HR', 5500),
(5, 'Emma', 'IT', 7200);

--temporary table
CREATE TABLE #EmployeeTransfers (
    EmployeeID INT,
    Name NVARCHAR(50),
    Department NVARCHAR(50),
    Salary INT
);

--Orders

CREATE TABLE Orders_DB1 (
    OrderID INT PRIMARY KEY,
    CustomerName NVARCHAR(50),
    Product NVARCHAR(50),
    Quantity INT
);

--insert
INSERT INTO Orders_DB1 (OrderID, CustomerName, Product, Quantity) VALUES
(101, 'Alice', 'Laptop', 1),
(102, 'Bob', 'Phone', 2),
(103, 'Charlie', 'Tablet', 1),
(104, 'David', 'Monitor', 1);

--ddl
CREATE TABLE Orders_DB2 (
    OrderID INT PRIMARY KEY,
    CustomerName NVARCHAR(50),
    Product NVARCHAR(50),
    Quantity INT
);


INSERT INTO Orders_DB2 (OrderID, CustomerName, Product, Quantity) VALUES
(101, 'Alice', 'Laptop', 1),
(103, 'Charlie', 'Tablet', 1);

DECLARE @MissingOrders TABLE (
    OrderID INT,
    CustomerName NVARCHAR(50),
    Product NVARCHAR(50),
    Quantity INT
);

--ddl
CREATE TABLE WorkLog (
    EmployeeID INT,
    EmployeeName NVARCHAR(50),
    Department NVARCHAR(50),
    WorkDate DATE,
    HoursWorked INT
);

--insert into
INSERT INTO WorkLog (EmployeeID, EmployeeName, Department, WorkDate, HoursWorked) VALUES
(1, 'Alice', 'HR', '2024-03-01', 8),
(2, 'Bob', 'IT', '2024-03-01', 9),
(3, 'Charlie', 'Sales', '2024-03-02', 7),
(1, 'Alice', 'HR', '2024-03-03', 6),
(2, 'Bob', 'IT', '2024-03-03', 8),
(3, 'Charlie', 'Sales', '2024-03-04', 9);

--ddl
CREATE VIEW vw_MonthlyWorkSummary AS
WITH EmployeeSummary AS (
    SELECT 
        EmployeeID,
        EmployeeName,
        Department,
        SUM(HoursWorked) AS TotalHoursWorked
    FROM WorkLog
    GROUP BY EmployeeID, EmployeeName, Department
),
DepartmentSummary AS (
    SELECT 
        Department,
        SUM(HoursWorked) AS TotalHoursDepartment,
        AVG(HoursWorked) AS AvgHoursDepartment
    FROM WorkLog
    GROUP BY Department
)
SELECT 
    e.EmployeeID,
    e.EmployeeName,
    e.Department,
    e.TotalHoursWorked,
    d.TotalHoursDepartment,
    d.AvgHoursDepartment
FROM EmployeeSummary e
JOIN DepartmentSummary d ON e.Department = d.Department;


;with factorial(num,fact) as
(
	select 1,1
	union all
	select num+1,fact*(num+1)
	from factorial
	where num<10
)
select * from factorial


;with fibonacci(fib,prev) as
( 
	select 1,0  
	union all
	select fib+(prev),fib
	from fibonacci
	where fib+(prev)<100
)
select fib from fibonacci