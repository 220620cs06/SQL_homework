-- Drop if exists (optional cleanup)
IF OBJECT_ID('dbo.EMPLOYEES_N', 'U') IS NOT NULL
    DROP TABLE dbo.EMPLOYEES_N;

-- Create table
CREATE TABLE dbo.EMPLOYEES_N
(
    [EMPLOYEE_ID] INT NOT NULL PRIMARY KEY,
    [FIRST_NAME] VARCHAR(20) NULL,
    [HIRE_DATE] DATE NOT NULL
);

-- Example data insert (for testing)
INSERT INTO dbo.EMPLOYEES_N (EMPLOYEE_ID, FIRST_NAME, HIRE_DATE) VALUES
(1, 'Alice', '1975-06-01'),
(2, 'Bob', '1976-03-15'),
(3, 'Charlie', '1977-09-20'),
(4, 'David', '1979-01-10'),
(5, 'Eva', '1980-05-05'),
(6, 'Frank', '1982-07-12'),
(7, 'Grace', '1983-11-30'),
(8, 'Helen', '1984-04-18'),
(9, 'Ian', '1985-08-22'),
(10, 'Jack', '1990-02-14'),
(11, 'Karen', '1997-12-01');

 --Task1

-- Drop if exists (optional cleanup)
IF OBJECT_ID('dbo.Groupings', 'U') IS NOT NULL
    DROP TABLE dbo.Groupings;

-- Create table
CREATE TABLE dbo.Groupings
(
    [Step Number] INT NOT NULL PRIMARY KEY,
    [Status] VARCHAR(20) NOT NULL
);

-- Sample data insert
INSERT INTO dbo.Groupings ([Step Number], [Status]) VALUES
(1, 'Passed'),
(2, 'Passed'),
(3, 'Passed'),
(4, 'Passed'),
(5, 'Failed'),
(6, 'Failed'),
(7, 'Failed'),
(8, 'Failed'),
(9, 'Failed'),
(10, 'Passed'),
(11, 'Passed'),
(12, 'Passed');

