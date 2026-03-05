CREATE DATABASE lesson9;
GO

USE lesson9;
GO

CREATE TABLE Employees
(
    EmployeeID  INTEGER PRIMARY KEY,
    ManagerID   INTEGER NULL,
    JobTitle    VARCHAR(100) NOT NULL
);

INSERT INTO Employees (EmployeeID, ManagerID, JobTitle) 
VALUES
    (1001, NULL, 'President'),
    (2002, 1001, 'Director'),
    (3003, 1001, 'Office Manager'),
    (4004, 2002, 'Engineer'),
    (5005, 2002, 'Engineer'),
    (6006, 2002, 'Engineer');


WITH RECURSIVE Employees AS (
    -- Base case: President (depth = 0)
    SELECT 
        EmployeeID,
        ManagerID,
        JobTitle,
        0 AS Depth
    FROM Employees
    WHERE ManagerID IS NULL
    
    UNION ALL
    
    -- Recursive case: employees reporting to managers
    SELECT 
        e.EmployeeID,
        e.ManagerID,
        e.JobTitle,
        eh.Depth + 1
    FROM Employees e
    INNER JOIN EmployeeHierarchy eh
        ON e.ManagerID = eh.EmployeeID
)
SELECT * 
FROM EmployeeHierarchy
ORDER BY Depth, EmployeeID;

--Task2


WITH RECURSIVE Factorials AS (
    SELECT 1 AS Num, 1 AS Factorial
    UNION ALL
    SELECT Num + 1, Factorial * (Num + 1)
    FROM Factorials
    WHERE Num < 10
)
SELECT * FROM Factorials;


--Task3

WITH RECURSIVE Fibonacci AS (
    SELECT 1 AS n, 1 AS Fibonacci_Number
    UNION ALL
    SELECT 2, 1
    UNION ALL
    SELECT n + 1, f1.Fibonacci_Number + f2.Fibonacci_Number
    FROM Fibonacci f1
    JOIN Fibonacci f2 ON f1.n = f2.n + 1
    WHERE f1.n < 10
)
SELECT * FROM Fibonacci ORDER BY n;