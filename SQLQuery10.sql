--create database lesson10
--go
--use lesson10


CREATE TABLE Shipments (
    N INT PRIMARY KEY,
    Num INT
);


INSERT INTO Shipments (N, Num)
SELECT N, 0
FROM (VALUES (34),(35),(36),(37),(38),(39),(40)) AS t(N);


WITH Ordered AS (
    SELECT Num,
           ROW_NUMBER() OVER (ORDER BY Num) AS rn
    FROM Shipments
),
Counted AS (
    SELECT COUNT(*) AS cnt FROM Ordered
)
SELECT AVG(Num * 1.0) AS Median
FROM Ordered, Counted
WHERE rn IN (cnt/2, cnt/2 + 1);