--DROP TABLES
DROP TABLE tbarker_Scores;
DROP TABLE tbarker_Schedules;
DROP TABLE tbarker_Locations;
DROP TABLE tbarker_Teams;

--CREATE TABLES
CREATE TABLE tbarker_Teams
(
	TeamID INT IDENTITY(1,1) NOT NULL,
	Seed INT NOT NULL,
	Region VARCHAR(50) NOT NULL,
	SchoolName VARCHAR(50) NOT NULL,
	TeamName VARCHAR(50) NOT NULL,
	BracketAlias VARCHAR(50) NOT NULL
);

CREATE TABLE tbarker_Locations
(
	LocationID INT IDENTITY(1,1) NOT NULL,
	City VARCHAR(50) NOT NULL,
	State VARCHAR(2) NOT NULL
);

CREATE TABLE tbarker_Schedules
(
	ScheduleID INT IDENTITY(1,1) NOT NULL,
	GameDateTime DATETIME NOT NULL,
	HighSeedTeamID INT NOT NULL,
	LowSeedTeamID INT NOT NULL,
	LocationID INT NOT NULL
);

CREATE TABLE tbarker_Scores
(
	ScoreID INT IDENTITY(1,1) NOT NULL,
	ScheduleID int NOT NULL,
	WinningScore INT NOT NULL,
	LosingScore INT NOT NULL,
	WinningTeamID INT NOT NULL,
	LosingTeamID INT NOT NULL
);


--ADD PRIMARY KEYS
ALTER TABLE tbarker_Teams
	ADD CONSTRAINT PK_Teams PRIMARY KEY (TeamID);
ALTER TABLE tbarker_Locations
	ADD CONSTRAINT PK_Locations PRIMARY KEY (LocationID);
ALTER TABLE tbarker_Schedules
	ADD CONSTRAINT PK_Schedules PRIMARY KEY (ScheduleID);
ALTER TABLE tbarker_Scores
	ADD CONSTRAINT PK_Scores PRIMARY KEY (ScoreID);


--ADD FOREIGN KEYS
ALTER TABLE tbarker_Schedules
	ADD CONSTRAINT FK_Schedules
	FOREIGN KEY (HighSeedTeamID) REFERENCES tbarker_Teams (TeamID),
	FOREIGN KEY (LowSeedTeamID) REFERENCES tbarker_Teams (TeamID),
	FOREIGN KEY (LocationID) REFERENCES tbarker_Locations (LocationID);
ALTER TABLE tbarker_Scores
	ADD CONSTRAINT FK_Scores
	FOREIGN KEY (WinningTeamID) REFERENCES tbarker_Teams (TeamID),
	FOREIGN KEY (LosingTeamID) REFERENCES tbarker_Teams (TeamID);


--INSERT TEAM DATA
INSERT tbarker_Teams (Seed, Region, SchoolName, TeamName, BracketAlias)
	VALUES(1, 'West', 'Xavier University', 'Musketeers', 'Xavier'),
		(2, 'West', 'University of North Carolina', 'Tar Heels', 'North Carolina'),
		(3, 'West', 'University of Michigan', 'Wolverines', 'Michigan'),
		(4, 'West', 'Gonzaga University', 'Bulldogs', 'Gonzaga'),
		(5, 'West', 'Ohio State University', 'Buckeyes', 'Ohio State'),
		(6, 'West', 'University of Houston', 'Cougars', 'Houston'),
		(7, 'West', 'Texas A&M University', 'Aggies', 'Texas A&M'),
		(8, 'West', 'University of Missouri', 'Tigers', 'Missouri'),
		(9, 'West', 'Florida State University', 'Seminoles', 'Florida State'),
		(10, 'West', 'Providence College', 'Friars', 'Providence'),
		(11, 'West', 'San Diego State University', 'Aztecs', 'San Diego State'),
		(12, 'West', 'South Dakota State University', 'Jackrabbits', 'South Dakota State'),
		(13, 'West', 'University of North Carolina at Greensboro', 'Spartans', 'UNC Greensboro'),
		(14, 'West', 'University of Montana', 'Grizzlies', 'Montana'),
		(15, 'West', 'Lipscomb University', 'Bisons', 'Lipscomb'),
		(16, 'West', 'Texas Southern University', 'Tigers', 'Texas Southern');


--INSERT LOCATION DATA
INSERT tbarker_Locations (City, State)
	VALUES ('Nashville', 'TN'),
	('Boise', 'ID'),
	('Wichita', 'KS'),
	('Charolette', 'NC'),
	('Los Angeles', 'CA'),
	('San Antonio', 'TX');


--INSERT SCHEDULES DATA
SET IDENTITY_INSERT tbarker_Schedules ON
INSERT tbarker_Schedules (ScheduleID ,GameDateTime, HighSeedTeamID, LowSeedTeamID, LocationID)
	VALUES(4, '2018-03-15 1:30 PM', 13, 4, 2),
		(3, '2018-03-15 4:00 PM', 12, 5, 2),
		(5, '2018-03-15 7:20 PM', 11, 6, 3),
		(6, '2018-03-15 9:50 PM', 14, 3, 3),
		(7, '2018-03-16 12:15 PM', 10, 7, 4),
		(8, '2018-03-16 2:45 PM', 15, 2, 4),
		(1, '2018-03-16 7:20 PM', 16, 1, 1),
		(2, '2018-03-16 9:50 PM', 9, 8, 1),
		(9, '2018-03-18 8:40 PM', 9, 1, 1),
		(10, '2018-03-17 7:45 PM', 5, 4, 2),
		(11, '2018-03-17 9:40 PM', 6, 3, 3),
		(12, '2018-03-18 5:20 PM', 7, 2, 4),
		(13, '2018-03-22 10:06 PM', 9, 4, 5),
		(14, '2018-03-22 7:40 PM', 7, 3, 5),
		(15, '2018-03-24 8:50 PM', 9, 3, 5);
SET IDENTITY_INSERT tbarker_schedules OFF


--INSERT SCORES DATA
INSERT tbarker_Scores (WinningScore, LosingScore, WinningTeamID, LosingTeamID, ScheduleID)
	VALUES (102, 83, 1, 16, 1),
		(67, 54, 9, 8, 2),
		(81, 73, 5, 12, 3),
		(68, 64, 4, 13, 4),
		(67, 65, 6, 11, 5),
		(61, 47, 3, 14, 6),
		(73, 69, 7, 10, 7),
		(84, 66, 2, 15, 8),
		(75, 70, 9, 1, 9),
		(90, 84, 4, 5, 10),
		(64, 63, 3, 6, 11),
		(86, 65, 7, 2, 12),
		(75, 60, 9, 4, 13),
		(99, 72, 3, 7, 14),
		(58, 54, 3, 9, 15);

--QUERY FOR ALL GAME DATA
SELECT
	L.City,
	L.State,
	S.HighSeedTeamID,
	T1.BracketAlias [SchoolName],
	S.LowSeedTeamID,
	T2.BracketAlias [SchoolName],
	SC.WinningScore,
	SC.LosingScore,
	(SELECT T.BracketAlias FROM tbarker_Teams T WHERE T.TeamID = SC.WinningTeamID) [WinningTeam],
	(SELECT T.BracketAlias FROM tbarker_Teams T WHERE T.TeamID = SC.LosingTeamID) [LosingTeam]
FROM
	tbarker_Schedules S 
	INNER JOIN tbarker_Teams T1 ON S.HighSeedTeamID = T1.TeamID
	INNER JOIN tbarker_Teams T2 ON S.LowSeedTeamID = T2.TeamID
	INNER JOIN tbarker_Locations L on S.LocationID = L.LocationID
	LEFT JOIN tbarker_Scores SC on sc.ScheduleID = S.ScheduleID
	LEFT JOIN tbarker_Teams WT ON SC.WinningTeamID = WT.TeamID
	LEFT JOIN tbarker_Teams LT ON SC.LosingTeamID = LT.TeamID
ORDER BY
	S.ScheduleID;

/*•	(10 points) Declare a variable of type date and set it to some value of your choice.  
Write a query that has a column for each of the following:
o	the date 28 days from the date
o	the date 1 year + 1 day from the date
o	how many days between the day and Christmas 2017
o	the name of the day your date falls on (Wednesday for example)
*/
DECLARE @MyBirthday DATE = '1988/01/13'
PRINT @MyBirthday
SELECT 
	DATEADD(DAY, 28, @MyBirthday) AS TwentyEightDaysLater,
	DATEADD(DAY, 1, DATEADD(YEAR, 1, @MyBirthday)) AS OneYearOneDay,
	DATEDIFF(DAY, @MyBirthday, '2017/12/25') AS DaysFromChristmas2017,
	FORMAT(@MyBirthday, 'ddd') AS NameOfTheDay;


/*•	(15 points) Write a query that returns how many customers we have in each state.  
Customers can be found in the Sales.Customers database, city and state information in the 
Application.StateProvinces and Application.Cities tables.  Use the DeliveryCityID column in Customers to make your joins.  
Your query should return all states – 53 records and should be ordered from the most to the least number of customers.  
Return the full state name, not the two-letter code
o	Delaware has 0 customers, Texas has 46
*/
SELECT
	SP.StateProvinceName,
	COUNT(CU.CustomerID) [NumOfCustomers]
FROM
	Application.StateProvinces SP
	INNER JOIN Application.Cities CI ON CI.StateProvinceID = SP.StateProvinceID
	LEFT JOIN Sales.Customers CU ON CI.CityID = CU.DeliveryCityID
GROUP BY
	SP.StateProvinceName
ORDER BY
	[NumOfCustomers]


/*•	(15 points) Write a query that brings back all the stock items (in warehouse.StockItems).  
Provide a column that totals sales for each for 2013, 2014, 2015, and 2016.  Include the StockItemName and StockItemID.  
Sort the list from largest overall sales to the smallest.
	You should get 227 records and 6 columns.  
*/
SELECT
	SI.StockItemID,
	SI.StockItemName,
	SUM(CASE WHEN YEAR(I.InvoiceDate) = 2013 THEN IL.ExtendedPrice ELSE NULL END) AS [2013Sales],
	SUM(CASE WHEN YEAR(I.InvoiceDate) = 2014 THEN IL.ExtendedPrice ELSE NULL END) [2014Sales],
	SUM(CASE WHEN YEAR(I.InvoiceDate) = 2015 THEN IL.ExtendedPrice ELSE NULL END) AS [2015Sales],
	SUM(CASE WHEN YEAR(I.InvoiceDate) = 2016 THEN IL.ExtendedPrice ELSE NULL END) [2016Sales]
FROM
	Warehouse.StockItems SI
	INNER JOIN Sales.InvoiceLines IL ON SI.StockItemID = IL.StockItemID
	INNER JOIN Sales.Invoices I ON IL.InvoiceID = I.InvoiceID
GROUP BY 
	SI.StockItemID,
	SI.StockItemName
ORDER BY
	[2013Sales] DESC,
	[2014Sales] DESC,
	[2015Sales] DESC,
	[2016Sales] DESC;
