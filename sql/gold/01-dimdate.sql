-- Gold: calendario completo del 01-01-2013 al 31-05-2016 (1.247 dias).
CREATE TABLE gold.DimDate (
 DateKey INT NOT NULL, FullDate DATE NOT NULL, DayNumber INT NOT NULL,
 DayName VARCHAR(15) NOT NULL, MonthNumber INT NOT NULL, MonthName VARCHAR(15) NOT NULL,
 QuarterNumber INT NOT NULL, YearNumber INT NOT NULL, YearMonth INT NOT NULL,
 IsWeekend BIT NOT NULL
);
WITH Digits AS (
 SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL
 SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL
 SELECT 8 UNION ALL SELECT 9
), Numbers AS (
 SELECT a.n + b.n*10 + c.n*100 + d.n*1000 AS n
 FROM Digits a CROSS JOIN Digits b CROSS JOIN Digits c CROSS JOIN Digits d
), DateSeries AS (
 SELECT DATEADD(DAY,n,CAST('2013-01-01' AS DATE)) AS CalendarDate
 FROM Numbers WHERE n < 1247
)
INSERT INTO gold.DimDate
SELECT YEAR(CalendarDate)*10000+MONTH(CalendarDate)*100+DAY(CalendarDate),
 CalendarDate, DAY(CalendarDate), DATENAME(WEEKDAY,CalendarDate), MONTH(CalendarDate),
 DATENAME(MONTH,CalendarDate), DATEPART(QUARTER,CalendarDate), YEAR(CalendarDate),
 YEAR(CalendarDate)*100+MONTH(CalendarDate),
 CASE WHEN DATEDIFF(DAY,'1900-01-01',CalendarDate)%7 IN (5,6) THEN 1 ELSE 0 END
FROM DateSeries;
SELECT COUNT(*) AS TotalDates, MIN(FullDate) AS FirstDate, MAX(FullDate) AS LastDate,
 COUNT(DISTINCT DateKey) AS DistinctDateKeys FROM gold.DimDate;
