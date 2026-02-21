-- create database lesson5
-- go
-- use lesson5

DROP TABLE IF EXISTS Employees;

CREATE TABLE Employees (
    EmployeeID  INT,
    Name        VARCHAR(50),
    Department  VARCHAR(50),
    Salary      DECIMAL(10,2),
    HireDate    DATE
);

INSERT INTO Employees (EmployeeID, Name, Department, Salary, HireDate)
VALUES
(1, 'Alice', 'HR',      4500.00, '2020-01-15'),
(2, 'Bob',   'HR',      5000.00, '2021-03-10'),
(3, 'Carol', 'IT',      7000.00, '2019-07-23'),
(4, 'David', 'IT',      7200.00, '2022-05-18'),
(5, 'Eve',   'Finance', 6000.00, '2020-11-01'),
(6, 'Frank', 'Finance', 6200.00, '2021-09-12'),
(7, 'Grace', 'HR',      4800.00, '2023-02-20'),
(8, 'Hank',  'IT',      7100.00, '2024-06-05');

-- 1. Assign a Unique Rank to Each Employee Based on Salary
SELECT EmployeeID, Name, Salary,
       RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
FROM Employees;

-- 2. Find Employees Who Have the Same Salary Rank
SELECT EmployeeID, Name, Salary,
       DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
FROM Employees;

-- 3. Identify the Top 2 Highest Salaries in Each Department
WITH Ranked AS (
    SELECT EmployeeID, Name, Department, Salary,
           DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS DeptRank
    FROM Employees
)
SELECT EmployeeID, Name, Department, Salary, DeptRank
FROM Ranked
WHERE DeptRank <= 2;

-- 4. Find the Lowest-Paid Employee in Each Department
WITH Ranked AS (
    SELECT EmployeeID, Name, Department, Salary,
           RANK() OVER (PARTITION BY Department ORDER BY Salary ASC) AS DeptRank
    FROM Employees
)
SELECT EmployeeID, Name, Department, Salary, DeptRank
FROM Ranked
WHERE DeptRank = 1;

-- 5. Running Total of Salaries in Each Department
SELECT EmployeeID, Name, Department, Salary,
       SUM(Salary) OVER (PARTITION BY Department ORDER BY HireDate) AS RunningTotal
FROM Employees;

-- 6. Total Salary of Each Department Without GROUP BY
SELECT EmployeeID, Name, Department, Salary,
       SUM(Salary) OVER (PARTITION BY Department) AS DeptTotal
FROM Employees;

-- 7. Average Salary in Each Department Without GROUP BY
SELECT EmployeeID, Name, Department, Salary,
       AVG(Salary) OVER (PARTITION BY Department) AS DeptAvg
FROM Employees;

-- 8. Difference Between Salary and Department Average
SELECT EmployeeID, Name, Department, Salary,
       Salary - AVG(Salary) OVER (PARTITION BY Department) AS DiffFromDeptAvg
FROM Employees;

-- 9. Moving Average Salary Over 3 Employees
SELECT EmployeeID, Name, Salary,
       AVG(Salary) OVER (ORDER BY EmployeeID ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS MovingAvg
FROM Employees;

-- 10. Sum of Salaries for Last 3 Hired Employees
SELECT SUM(Salary) AS Last3Total
FROM (
    SELECT Salary
    FROM Employees
    ORDER BY HireDate DESC
    OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY
) AS t;

-- 11. Running Average of Salaries
SELECT EmployeeID, Name, Salary,
       AVG(Salary) OVER (ORDER BY HireDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningAvg
FROM Employees;

-- 12. Max Salary Over Sliding Window of 2 Before and 2 After
SELECT EmployeeID, Name, Salary,
       MAX(Salary) OVER (ORDER BY EmployeeID ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) AS WindowMax
FROM Employees;

-- 13. Percentage Contribution of Salary to Department Total
SELECT EmployeeID, Name, Department, Salary,
       (Salary * 100.0 / SUM(Salary) OVER (PARTITION BY Department)) AS SalaryPct
FROM Employees;