--create database lesson5
--go
--use lesson5

create table Employees(
    EmployeeID  INT,
    Name  VARCHAR(50),
    Department VARCHAR(50),
    Salary  DECIMAL(10,2),
    HireDate  DATE
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

--### Tasks
--#### Ranking Functions
--1. Assign a Unique Rank to Each Employee Based on Salary
SELECT EmployeeID, Name, Salary,
       RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
FROM Employees;


--2. Find Employees Who Have the Same Salary Rank

SELECT EmployeeID, Name, Salary,
       Dense_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
FROM Employees;

--3. Identify the Top 2 Highest Salaries in Each Department

SELECT *
FROM (
    SELECT EmployeeID, Name, Department, Salary,
           DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS DeptRank
    FROM Employees
) t
WHERE DeptRank <= 2;



--4. Find the Lowest-Paid Employee in Each Department

SELECT *
FROM (
    SELECT EmployeeID, Name, Department, Salary,
           RANK() OVER (PARTITION BY Department ORDER BY Salary ASC) AS DeptRank
    FROM Employees
) t
WHERE DeptRank = 1;



--5. Calculate the Running Total of Salaries in Each Department
SELECT EmployeeID, Name, Department, Salary,
	Sum(Salary) over(partition by Department order by HireDate)as total
from Employees;


  
--6. Find the Total Salary of Each Department Without GROUP BY
SELECT EmployeeID, Name, Department, Salary,
       SUM(Salary) OVER (PARTITION BY Department) AS DeptTotal
FROM Employees;


  
--7. Calculate the Average Salary in Each Department Without GROUP BY
SELECT EmployeeID, Name, Department, Salary,
       AVG(Salary) OVER (PARTITION BY Department) AS DeptAvg
FROM Employees;
   

--8. Find the Difference Between an Employee’s Salary and Their Department’s Average
SELECT EmployeeID, Name, Department, Salary,
       Salary-AVG(Salary) OVER (PARTITION BY Department) AS DeptAvg
FROM Employees;


--9. Calculate the Moving Average Salary Over 3 Employees (Including Current, Previous, and Next)

SELECT EmployeeID, Name, Salary,
       AVG(Salary) OVER (order BY EmployeeID rows between 1 preceding and  1 following) AS DeptAvg
FROM Employees;

--10. Find the Sum of Salaries for the Last 3 Hired Employees
--SELECT SUM(Salary) AS Last3Total
--FROM (
--   SELECT Salary
--   FROM Employees
--   ORDER BY HireDate DESC
--   FETCH FIRST 3 ROWS ONLY
--) t;
--11. Calculate the Running Average of Salaries Over All Previous Employees

SELECT EmployeeID, Name, Salary,
       AVG(Salary) OVER (ORDER BY HireDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningAvg
FROM Employees;
   
--12. Find the Maximum Salary Over a Sliding Window of 2 Employees Before and After

SELECT EmployeeID, Name, Salary,
       MAX(Salary) OVER (ORDER BY EmployeeID ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) AS WindowMax
FROM Employees;

--13. Determine the Percentage Contribution of Each Employee’s Salary to Their Department’s Total Salary

SELECT EmployeeID, Name, Department, Salary,
       (Salary * 100.0 / SUM(Salary) OVER (PARTITION BY Department)) AS SalaryPct
FROM Employees;


--Materials: https://drive.google.com/drive/folders/1xSlmxHg0k9uMbmdablQMh5N5XPkbu7m4?usp=sharing

