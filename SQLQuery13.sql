DECLARE @Year INT = 2026;
DECLARE @Month INT = 3;

;WITH Dates AS (
    SELECT DATEFROMPARTS(@Year, @Month, 1) AS CalendarDate
    UNION ALL
    SELECT DATEADD(DAY, 1, CalendarDate)
    FROM Dates
    WHERE CalendarDate < EOMONTH(DATEFROMPARTS(@Year, @Month, 1))
),
WeekData AS (
    SELECT 
        CalendarDate,
        DATEPART(WEEK, CalendarDate) AS WeekNum,
        DATEPART(WEEKDAY, CalendarDate) AS WeekDayNum,
        DATENAME(WEEKDAY, CalendarDate) AS WeekDayName
    FROM Dates
)
SELECT 
    MIN(CASE WHEN WeekDayNum = 1 THEN CalendarDate END) AS Sunday,
    MIN(CASE WHEN WeekDayNum = 2 THEN CalendarDate END) AS Monday,
    MIN(CASE WHEN WeekDayNum = 3 THEN CalendarDate END) AS Tuesday,
    MIN(CASE WHEN WeekDayNum = 4 THEN CalendarDate END) AS Wednesday,
    MIN(CASE WHEN WeekDayNum = 5 THEN CalendarDate END) AS Thursday,
    MIN(CASE WHEN WeekDayNum = 6 THEN CalendarDate END) AS Friday,
    MIN(CASE WHEN WeekDayNum = 7 THEN CalendarDate END) AS Saturday
FROM WeekData
GROUP BY WeekNum
ORDER BY WeekNum
OPTION (MAXRECURSION 1000);