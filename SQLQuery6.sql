create database lesson6
go
use lesson6

--use lesson5

--select * from Employees

/*


1.  
   | EmployeeID | Name     | DepartmentID | Salary  |  
   |-----------|---------|--------------|---------|  
   | 1         | Alice   | 101          | 60000   |  
   | 2         | Bob     | 102          | 70000   |  
   | 3         | Charlie | 101          | 65000   |  
   | 4         | David   | 103          | 72000   |  
   | 5         | Eva     | NULL         | 68000   |  

2. Departments 
   | DepartmentID | DepartmentName |  
   |-------------|---------------|  
   | 101         | IT            |  
   | 102         | HR            |  
   | 103         | Finance       |  
   | 104         | Marketing     |  

3. Projects 
   | ProjectID | ProjectName   | EmployeeID |  
   |----------|-------------|-----------|  
   | 1        | Alpha       | 1         |  
   | 2        | Beta        | 2         |  
   | 3        | Gamma       | 1         |  
   | 4        | Delta       | 4         |  
   | 5        | Omega       | NULL      |  

*/

create table Employees(
 EmployeeID int primary key,
 Name varchar(50),
 DepartmentID int,
 salary decimal(10,2) 
);

INSERT INTO Employees (EmployeeID, Name, DepartmentID, Salary) VALUES
(1, 'Alice', 101, 60000),
(2, 'Bob', 102, 70000),
(3, 'Charlie', 101, 65000),
(4, 'David', 103, 72000),
(5, 'Eva', NULL, 68000);

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(101, 'IT'),
(102, 'HR'),
(103, 'Finance'),
(104, 'Marketing');

CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(50),
    EmployeeID INT
);

INSERT INTO Projects (ProjectID, ProjectName, EmployeeID) VALUES
(1, 'Alpha', 1),
(2, 'Beta', 2),
(3, 'Gamma', 1),
(4, 'Delta', 4),
(5, 'Omega', NULL);





--1. INNER JOIN
--   - Write a query to get a list of employees along with their department names.  

select e.EmployeeID,e.Name,d.DepartmentName
from Employees e
inner join Departments d
on e.DepartmentID=d.DepartmentID


--2. LEFT JOIN 
--   Write a query to list all employees, including those who are not assigned to any department.  

select e.EmployeeID,e.Name,d.DepartmentName
from Employees e
left join Departments d
on e.DepartmentID=d.DepartmentID


--3. RIGHT JOIN 
--  Write a query to list all departments, including those without employees.  

select e.EmployeeID,e.Name,d.DepartmentName
from Employees e
right join Departments d
on e.DepartmentID=d.DepartmentID


--4. FULL OUTER JOIN
--   Write a query to retrieve all employees and all departments, even if there’s no match between them.   

select e.EmployeeID,e.Name,d.DepartmentName
from Employees e
full outer join Departments d
on e.DepartmentID=d.DepartmentID


--5. JOIN with Aggregation
--   - Write a query to find the total salary expense for each department.  

SELECT d.DepartmentName, SUM(e.Salary) AS TotalSalary
FROM Employees e
INNER JOIN Departments d
ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName;



--6. CROSS JOIN
--   Write a query to generate all possible combinations of departments and projects.  

SELECT d.DepartmentName, p.ProjectName
FROM Departments d
CROSS JOIN Projects p;



--7. MULTIPLE JOINS
--   Write a query to get a list of employees with their department names and assigned project names. Include employees even if they don’t have a project.
SELECT e.EmployeeID, e.Name, d.DepartmentName, p.ProjectName
FROM Employees e
LEFT JOIN Departments d
ON e.DepartmentID = d.DepartmentID
LEFT JOIN Projects p
ON e.EmployeeID = p.EmployeeID;
