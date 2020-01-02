CREATE TABLE Departments
(
	DepartmentKey int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Department varchar(255)
)

SET IDENTITY_INSERT Departments ON
INSERT Departments (DepartmentKey, Department) VALUES
	(1, 'Finance'),
	(2, 'Business Intelligence'),
	(3, 'Information Technology'),
	(4, 'Accounting')
SET IDENTITY_INSERT Departments OFF

CREATE TABLE Employees
(
	EmployeeKey int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	LastName varchar(25) NOT NULL,
	FirstName varchar(25) NOT NULL,
	Email varchar(50) NOT NULL,
	Hired date NOT NULL,
	Terminated date NULL,
	DepartmentKey int NOT NULL,
	CurrentSupervisorEmployeeKey int NOT NULL --CEO/Top of hierarchy should have their own EmployeeKey
)

SET IDENTITY_INSERT Employees ON
INSERT Employees (EmployeeKey, LastName, FirstName, Email, Hired, DepartmentKey, CurrentSupervisorEmployeeKey) VALUES
	(1, 'Reed', 'Russell', 'russ@mythicalCompany.com', '1/1/2015', 2, 4),
	(2, 'Barnes', 'Eric', 'eric@mythicalCompany.com', '1/1/2015', 3, 1),
	(3, 'Gotti', 'Jason', 'jason@mythicalCompany.com', '1/1/2015', 3, 2),
	(4, 'Boss', 'Da', 'DaBoss@mythicalCompany.com', '1/1/2015', 1, 4)
SET IDENTITY_INSERT Employees OFF

/*constraints for employee job salary added */

CREATE TABLE Group1EmployeeJobs
(
	EmployeeJobKey int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	EmployeeKey int NOT NULL,
	JobStart date NOT NULL,
	JobFinish date NULL,
	Title varchar(50) NOT NULL,
	SupervisorEmployeeKey int NOT NULL,
	Salary money
	CONSTRAINT Group1SalaryCheck CHECK (Salary Between 50000 and 150000)
)


INSERT Group1EmployeeJobs (EmployeeKey, JobStart, JobFinish, Title, SupervisorEmployeeKey, Salary) VALUES
(1, '1/1/2015', '7/4/2016', 'Director, IT Development', 4, 60000),
(1, '7/5/2016', '3/1/2017', 'Director, Analytics', 4, 70000),
(1, '3/2/2017', NULL, 'VP, Technology & Analytics', 4, 80000),
(2, '1/1/2015', '3/2/2017', 'Developer 3', 1, 50000),
(2, '3/3/2017', NULL, 'Director, IT Development', 1, 60000),
(3, '1/1/2015', NULL, 'Developer 2', 2, 50000),
(4, '1/1/2015', NULL, 'Da Boss', 4, 100000)


CREATE TABLE ComputerTypes
(
	ComputerTypeKey int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	ComputerType varchar(25) NOT NULL
) 
SET IDENTITY_INSERT ComputerTypes ON
INSERT ComputerTypes (ComputerTypeKey, ComputerType) VALUES 
	(1, 'Desktop'),
	(2, 'Laptop'),
	(3, 'Tablet'),
	(4, 'Phone')
SET IDENTITY_INSERT ComputerTypes OFF


CREATE TABLE ComputerStatuses
(
	ComputerStatusKey int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	ComputerStatus varchar(50) NOT NULL,
	ActiveStatus bit NOT NULL  --an indicator of if this status means the computer is available or not
)

SET IDENTITY_INSERT ComputerStatuses ON
INSERT ComputerStatuses (ComputerStatusKey, ComputerStatus, ActiveStatus) VALUES 
		(0, 'New', 1),
		(1, 'Assigned', 1),
		(2, 'Available', 1),
		(3, 'Lost', 0),
		(4, 'In for Repairs', 0), 
		(5, 'Retired', 1)
SET IDENTITY_INSERT ComputerStatuses OFF

/* constraints for computer price added and JSON check added */

CREATE TABLE Group1Computers
(
	ComputerKey int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	ComputerTypeKey int NOT NULL,
	ComputerStatusKey int NOT NULL DEFAULT(0),
	PurchaseDate date NOT NULL,
	PurchaseCost money NOT NULL,
	CONSTRAINT Group1ComputerPrice CHECK (PurchaseCost Between 1 AND 10000),
	ComputerDetails varchar(max) NULL,
	CONSTRAINT Group1CheckJson CHECK (ISJSON(ComputerDetails)>0)
)

CREATE TABLE EmployeeComputers
(
	EmployeeComputerKey int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	EmployeeKey int NOT NULL,
	ComputerKey int NOT NULL,
	Assigned date NOT NULL,
	Returned date NULL
)

ALTER TABLE Employees
	ADD CONSTRAINT FK_EmployeeDepartment
	FOREIGN KEY (DepartmentKey)
	REFERENCES Departments (DepartmentKey)

ALTER TABLE Employees
	ADD CONSTRAINT FK_EmployeeSupervisor
	FOREIGN KEY (CurrentSupervisorEmployeeKey)
	REFERENCES Employees (EmployeeKey)

ALTER TABLE Group1EmployeeJobs
	ADD CONSTRAINT FK_Employee
	FOREIGN KEY (EmployeeKey)
	REFERENCES Employees (EmployeeKey)

ALTER TABLE Group1EmployeeJobs
	ADD CONSTRAINT FK_EmployeeSupervisorHistory
	FOREIGN KEY (SupervisorEmployeeKey)
	REFERENCES Employees (EmployeeKey)

ALTER TABLE Group1Computers 
	ADD CONSTRAINT FK_ComputerComputerTypes 
	FOREIGN KEY (ComputerTypeKey) 
	REFERENCES ComputerTypes (ComputerTypeKey)

ALTER TABLE Group1Computers
	ADD CONSTRAINT FK_ComputerComputerStatus
	FOREIGN KEY (ComputerStatusKey) 
	REFERENCES ComputerStatuses (ComputerStatusKey)

ALTER TABLE EmployeeComputers
	ADD CONSTRAINT FK_EmployeeComputerEmployee
	FOREIGN KEY (EmployeeKey)
	REFERENCES Employees (EmployeeKey)

ALTER TABLE EmployeeComputers
	ADD CONSTRAINT FK_EmployeeComputerComputer
	FOREIGN KEY (ComputerKey)
	REFERENCES Group1Computers (ComputerKey)


/*
DROP TABLE EmployeeComputers
DROP TABLE Group1EmployeeJobs
DROP TABLE Employees
DROP TABLE Departments
DROP TABLE Group1Computers
DROP TABLE ComputerTypes
DROP TABLE ComputerStatuses 
*/

/*
All the things you have to get done...

 - Stored procedures that accomplish the following things:
*/
	-- Create new departments
GO

CREATE OR ALTER PROCEDURE Group1CreateDepartment
	@Department varchar(255)
AS
INSERT INTO Departments(Department) VALUES
	(@Department)

GO
	-- Update the name of existing departments

CREATE OR ALTER PROCEDURE Group1UpdateDepartmentName
	@oldname varchar(255),
	@newname varchar(255)
AS
IF EXISTS (SELECT Department AS [DK] FROM Departments WHERE Department = @oldname)
	UPDATE Departments 
	SET Department = @newname
	WHERE Department = @oldname
ELSE
	PRINT 'Department does not exist'
GO

/*
	- Create new employees.  Every new employee has to have a job.  Job
		information is stored in "EmployeeJobs".  Make sure you trap
		errors and prevent orphan records in the Employees table.*/

CREATE OR ALTER PROCEDURE Group1AddEmployee
	@LastName varchar(25),
	@firstName varchar(25),
	@email varchar(50),
	@hired date,
	@jobstart date,
	@title varchar(50),
	@supervisor int,
	@department int,
	@key int output
AS
INSERT INTO Employees(LastName, FirstName, Email, Hired, DepartmentKey, CurrentSupervisorEmployeeKey) VALUES
	(@LastName, @firstName, @email, @hired, @department, @supervisor)
	SET @key = @@IDENTITY
INSERT INTO Group1EmployeeJobs(EmployeeKey, JobStart, Title, SupervisorEmployeeKey) VALUES
	(@key, @jobstart, @title, @supervisor)
GO

	/*- Update an employees job.  Any update to a job should generate
		a new record for that employee in the EmployeeJobs table.  This
		would include changing their title, salary, or supervisor*/
CREATE OR ALTER PROCEDURE Group1UpdateJob
	@employeeid int,
	@jobstart date,
	@title varchar(50),
	@salary money,
	@supervisorID int
AS
INSERT INTO Group1EmployeeJobs(EmployeeKey, JobStart, Title, Salary, SupervisorEmployeeKey) VALUES
	(@employeeid, @jobstart, @title, @salary, @supervisorID)
GO

	-- Update an employees department
CREATE OR ALTER PROCEDURE Group1UpdateEmployeeDepartment
	@employeeID int,
	@departmentID int
AS
IF EXISTS (SELECT DepartmentKey AS [DK] FROM Departments WHERE DepartmentKey = @departmentID)
	UPDATE Employees 
	SET DepartmentKey = @departmentID
	WHERE EmployeeKey = @employeeID
ELSE
	PRINT 'Department does not exist'
GO	
	
	-- Update an employees supervisor
CREATE OR ALTER PROCEDURE Group1UpdateSupervisor
	@employeeID int,
	@supervisorID int
AS
IF EXISTS (SELECT EmployeeKey FROM Employees WHERE EmployeeKey = @employeeID)
	IF EXISTS (SELECT CurrentSupervisorEmployeeKey FROM Employees WHERE CurrentSupervisorEmployeeKey = @supervisorID)
		UPDATE Employees
		SET CurrentSupervisorEmployeeKey = @supervisorID
		WHERE EmployeeKey = @employeeID
	ELSE
		PRINT 'Supervisor does not exist'
ELSE
	PRINT 'Employee does not exist'	
GO	
	/*- Terminate an employee.  When an employee is terminated, their
		computer equipment is returned to the company.  Their job
		record is also ended.*/
CREATE OR ALTER PROCEDURE Group1TerminateEmployee
	@employeeID int
AS
BEGIN
IF EXISTS (SELECT EmployeeKey FROM Employees WHERE EmployeeKey = @employeeID)
	UPDATE Employees
	SET Terminated = GETDATE()
	WHERE EmployeeKey = @employeeID
	
ELSE
	PRINT 'Employee does not exist'
	END		

UPDATE 	Group1EmployeeJobs
SET JobFinish = GETDATE()
WHERE EmployeeKey = @employeeID 
AND 
JobFinish IS NULL

BEGIN
IF EXISTS (SELECT EmployeeKey FROM EmployeeComputers WHERE EmployeeKey = @employeeID)
	UPDATE EmployeeComputers
	SET Returned = GETDATE()
	WHERE EmployeeKey = @employeeID

ELSE
	PRINT 'Employee did not have computer assigned'
	END
GO		
	
	/*- Add a new computer to the companies inventory.  You'll need to 
		pass in a JSON string that has the computer details you want 
		stored in your database (stored in ComputerDetails).*/


CREATE OR ALTER PROCEDURE Group1AddComputer
	@computertypekey int,
	@computerstatuskey int,
	@purchasedate date, 
	@purchasecost money,
	@json varchar(max)
AS
INSERT INTO Group1Computers(ComputerTypeKey, ComputerStatusKey, PurchaseDate, PurchaseCost, ComputerDetails) VALUES
	(@computertypekey, @computerstatuskey, @purchasedate, @purchasecost, @json)
	/*
	SELECT ComputerTypeKey, ComputerStatusKey, PurchaseDate, PurchaseCost, ComputerDetails
	FROM OPENJSON(@json)
	WITH (ComputerTypeKey int, ComputerStatusKey int, PurchaseDate date, PurchaseCost money, Computer */
GO
	/*- Assign/return/report lost/retire a computer.  You cannot retire
		a computer that still has some value left (has to be put back 
		in inventory or reported as lost).*/
CREATE OR ALTER PROCEDURE Group1ChangeComputerStatus
	@computerkey int,
	@status int
AS
BEGIN
IF EXISTS (SELECT ComputerKey FROM Group1Computers WHERE ComputerKey = @computerkey)
	BEGIN
	IF (@status >= 0 AND @status <=5)
		IF(@status != 5)
		UPDATE Group1Computers
		SET ComputerStatusKey = @status
		WHERE ComputerKey = @computerkey

		ELSE
			BEGIN
			DECLARE @purchasedate date
			SET @purchasedate = (SELECT PurchaseDate FROM Group1Computers WHERE ComputerKey = @computerkey)
		
			IF(MONTH(GETDATE()) - MONTH(@purchasedate) > 36) 
				UPDATE Group1Computers
				SET ComputerStatusKey = @status
				WHERE ComputerKey = @computerkey
			ELSE
				PRINT 'Computer still has value, cannot retire'
				END

	ELSE
		PRINT 'Incorrect status key entered, values must be from 0 to 5'
		END
ELSE
	PRINT 'Computer does not exist'
	END

GO

EXEC Group1CreateDepartment @Department = 'Software'

EXEC Group1UpdateDepartmentName @oldname = 'Software', @newname = 'New Software'

DECLARE @json1 nvarchar (max)
SET @json1 = '{"ComputerDetails" : "Dell Inspiron 22 All-in-One 21.5",  "Computer Type" : "Desktop", "RAM" : "16GB", "Windows": "10 Home"}'

EXEC Group1AddComputer @computertypekey = 1, @computerstatuskey = 0, @purchasedate = '2019/01/01', @purchasecost = 399.99, @json = @json1

DECLARE @json2 nvarchar (max)
SET @json2 = '{"ComputerDetails":"HP - 19.5", "Computer Type" : "All-in-One", "Processor" : "AMD E2-Series",  "RAM" : "8GB", "Hard drive" : "1 TB Hard Drive"}'

EXEC Group1AddComputer @computertypekey = 2, @computerstatuskey = 1, @purchasedate = '2018/01/01', @purchasecost = 319.99, @json = @json2

DECLARE @json3 nvarchar (max)
SET @json3 = '{"ComputerDetails":"Dell Inspiron 11 3000 11.6", "Computer Type" : "laptop", "RAM" :  "4GB",  "Windows" : "10 Home"}'

EXEC Group1AddComputer @computertypekey = 3, @computerstatuskey = 2, @purchasedate = '2019/02/01', @purchasecost = 179.99, @json = @json3

DECLARE @json4 nvarchar (max)
SET @json4 = '{"ComputerDetails":"Apple - 10.5", "Computer Type" :  "iPad Pro with Wi-Fi", "Hard Drive" :  "64GB", "Color" : "gray"}'

EXEC Group1AddComputer @computertypekey = 4, @computerstatuskey = 3, @purchasedate = '2018/09/09', @purchasecost = 499.99, @json = @json4

DECLARE @json5 nvarchar (max)
SET @json5 = '{"ComputerDetails":"Samsung Galaxy S10 Plus", "Computer Type" : "Phone"}'

EXEC Group1AddComputer @computertypekey = 4, @computerstatuskey = 4, @purchasedate = '2018/11/22', @purchasecost = 999.99, @json = @json5

EXEC Group1AddEmployee @LastName = 'Stan', @firstname = 'Smith', @email = 'dfjskl', @hired = '2018/09/11', @jobstart = '2018/09/12', @title = 'Developer 1', @supervisor = 2, @department = 3, @key = 0

EXEC Group1UpdateJob @employeeid = 2, @jobstart = '2019/01/01', @title = 'boss', @salary = 50000, @supervisorID = 3

EXEC Group1UpdateEmployeeDepartment @employeeID = 2, @departmentID = 3

EXEC Group1UpdateSupervisor @employeeID = 4, @supervisorID = 3

EXEC Group1TerminateEmployee @employeeID = 4

EXEC Group1ChangeComputerStatus @computerkey = 1, @status = 4

EXEC Group1ChangeComputerStatus @computerkey = 1, @status = 100

EXEC Group1ChangeComputerStatus @computerkey = 1, @status = 5

INSERT EmployeeComputers (EmployeeKey, ComputerKey, Assigned, Returned) VALUES
(1, 1, '2019/02/01', NULL),
(2, 2, '2019/02/01', NULL),
(5, 5, '2019/02/01', NULL)

/*
drop procedure Group1AddComputer
drop procedure Group1AddEmployee
drop procedure Group1ChangeComputerStatus
drop procedure Group1CreateDepartment
drop procedure Group1TerminateEmployee
drop procedure Group1UpdateDepartmentName
drop procedure Group1UpdateEmployeeDepartment
drop procedure Group1UpdateJob
drop procedure Group1UpdateSupervisor
*/



/* Views Go Here */
/* - A list of all active computers (i.e. exclude lost and retired).  Include
		who is assigned the computer (if applicable), when it was purchased, 
		its monthly depreciation rate, and the specs of the computer*/
GO

CREATE OR ALTER VIEW Group1ActiveComputers AS
SELECT
	E.FirstName,
	E.LastName,
	G1C.PurchaseDate,
	G1C.ComputerDetails,
	CS.ComputerStatus,
	ROUND(G1C.PurchaseCost * 0.0277777777777778, 2) [DepreciationRate],
	CS.ActiveStatus
FROM
	Group1Computers G1C 
	LEFT JOIN ComputerTypes CT ON CT.ComputerTypeKey = G1C.ComputerTypeKey
	LEFT JOIN ComputerStatuses CS ON CS.ComputerStatusKey = G1C.ComputerStatusKey
	LEFT JOIN EmployeeComputers EC ON EC.ComputerKey = G1C.ComputerKey
	LEFT JOIN Employees E ON EC.EmployeeKey = E.EmployeeKey
WHERE
	CS.ActiveStatus = 1;

--Test the view
SELECT * FROM Group1ActiveComputers;

/*- A list of current employees, their supervisor, the department they are in
		their current salary, their current title, the date they last
		recieved a raise, and the percentage increase that raise was */
GO

CREATE OR ALTER VIEW Group1CurrentEmployeeList AS
SELECT
	E.FirstName [EmployeeFirstName],
	E.LastName [EmployeeLastName],
	ES.FirstName [SupervisorFirstName],
	ES.LastName [SupervisorLastName],
	D.Department,
	G1E.Title,
	G1E.JobStart [DateOfLastRaise]
FROM
	Employees E
	INNER JOIN Employees ES ON E.CurrentSupervisorEmployeeKey = ES.EmployeeKey
	INNER JOIN Departments D ON E.DepartmentKey = D.DepartmentKey
	INNER JOIN Group1EmployeeJobs G1E ON G1E.EmployeeKey = E.EmployeeKey
WHERE
	G1E.JobFinish IS NULL;

--Test employee view
SELECT * FROM Group1CurrentEmployeeList;

 /*- Triggers that need to be written

	- I don't trust people when they have full access to my database.  Write
		something that prevents someone from deleting an employee.  Instead,
		have it add a termination date to their employee record and close
		out their active job record. */

GO

CREATE Trigger Group1InsteadOfDelete
ON Employees
INSTEAD OF DELETE
AS 
BEGIN
	UPDATE E SET E.Terminated = GETDATE()
	FROM 
		Employees E 
	INNER JOIN Deleted D ON D.EmployeeKey = E.EmployeeKey
	WHERE 
		E.Terminated IS NULL;

	UPDATE EJ SET EJ.JobFinish = GETDATE() 
	FROM Group1EmployeeJobs EJ
	INNER JOIN Deleted D ON D.EmployeeKey = EJ.EmployeeKey
	WHERE
		EJ.JobFinish IS NULL;
END;

--Checking the Trigger to make sure it works
DELETE Employees
WHERE EmployeeKey = 1
	OR
	EmployeeKey = 2;

--checking to make sure that the constraints work

UPDATE Group1EmployeeJobs SET Salary = 200000
WHERE EmployeeKey = 1;

--checking to make sure that the computer price constraint works
INSERT Group1Computers(ComputerTypeKey, ComputerStatusKey, PurchaseDate, PurchaseCost) VALUES (1, 2, GETDATE(), 20000)
INSERT Group1Computers(ComputerTypeKey, ComputerStatusKey, PurchaseDate, PurchaseCost) VALUES (2, 1, GETDATE(), 5000)

--checking to make sure json constraint works
INSERT Group1Computers(ComputerTypeKey, ComputerStatusKey, PurchaseDate, PurchaseCost, ComputerDetails) VALUES (2, 1, GETDATE(), 5000, 
    '{"ComputerTypeKey" : 1, "Computer Status" : "1"}')
INSERT Group1Computers(ComputerTypeKey, ComputerStatusKey, PurchaseDate, PurchaseCost, ComputerDetails) VALUES (2, 1, GETDATE(), 5000, 
    '{"ComputerTypeKey : 1, "Computer Status" : "1"}')

/* Functions goes here */
/* - Functions to write

	- Write a function that takes a date and a dollar value and calculates
		a monthly depreciation value.  Computer equipment is usually 
		depreciated over 36 months - i.e. it loses 1/36th of its value
		each month after it is purchased.  
	- Write a function that provides the current value of any computer currently
		in your inventory */

CREATE FUNCTION MonthlyDepreciation (@DATE date, @MONEY money)
RETURNS int
AS
BEGIN
	DECLARE @DepreciationValue money
	DECLARE @DATEdifference int
	DECLARE @DATEdifference2 int
		SET @DATEdifference = DATEPART(year, @DATE)
		SET @DATEdifference2 = @DATEdifference + 3
		SET @DATEdifference = (@DATEdifference2 - @DATEdifference) * 12
		SET @MONEY = CAST(@MONEY AS int)
		SET @MONEY = @MONEY / @DATEdifference
	RETURN @MONEY
END

CREATE FUNCTION ComputerValue (@ComputerKey int)
RETURNS int
AS
BEGIN
	DECLARE @PurchaseDate date
	DECLARE @PurchaseCost money
	DECLARE @MD int
	DECLARE @Value int
	DECLARE @CurrentDate date
	DECLARE @PurchaseMonth int
	DECLARE @CurrentMonth int
	DECLARE @PurchaseYear int
	DECLARE @CurrentYear int
	SELECT @PurchaseDate = PurchaseDate, @PurchaseCost = PurchaseCost FROM dbo.Group1Computers WHERE @ComputerKey = ComputerKey
	SET @MD = dbo.MonthlyDepreciation(@PurchaseDate, @PurchaseCost)
	SET @CurrentDate = GETDATE()
		IF DATEPART(year, @CurrentDate) = DATEPART(year, @PurchaseDate)
			BEGIN
			SET @PurchaseMonth = DATEPART(month, @PurchaseDate)
			SET @CurrentMonth = DATEPART(month, @CurrentDate)
			SET @CurrentMonth = @CurrentMonth - @PurchaseMonth
			SET @Value = @MD * @CurrentMonth
			END;
		ELSE
			BEGIN
			SET @PurchaseMonth = DATEPART(month, @PurchaseDate)
			SET @CurrentMonth = DATEPART(month, @CurrentDate)
			SET @PurchaseYear = DATEPART(year, @PurchaseDate)
			SET @CurrentYear = DATEPART(year, @CurrentDate)
			SET @CurrentYear = (@CurrentYear - @PurchaseYear) * 12
			SET @CurrentMonth = (@CurrentMonth - @PurchaseMonth) + @CurrentYear
			SET @Value = @MD * @CurrentMonth
			END;
	RETURN @Value
END

/* Queries to write
 Write a query that provides me the active employees for any date I want
		to provide.  Include their job, supervisor, department, title, 
		name, and email address*/
SELECT
    EJ.EmployeeJobKey, 
    E.CurrentSupervisorEmployeeKey, 
    E.DepartmentKey, 
    EJ.Title,
    CONCAT(E.FirstName, ' ', E.LastName) AS [Name], 
    E.Email
FROM
    Employees E
    INNER JOIN Group1EmployeeJobs EJ ON E.EmployeeKey = EJ.EmployeeJobKey
WHERE 
    E.Terminated IS NULL;

/* Write a query that provides all lost or retired computers.  Include
		the purchase details, how many people were assigned the computer,
		the last person to have the computer, and the last status of the computer */

SELECT
    C.PurchaseDate,
    C.PurchaseCost,
    CONCAT(E.FirstName, ' ', E.LastName) AS [Name],
    CS.ActiveStatus,
    COUNT(E.EmployeeKey) AS [TotalUser]
FROM
    ComputerStatuses CS 
    INNER JOIN Group1Computers C ON CS.ComputerStatusKey = C.ComputerStatusKey
    INNER JOIN EmployeeComputers EC ON EC.ComputerKey = C.ComputerKey
    INNER JOIN Employees E ON E.EmployeeKey = EC.EmployeeKey
WHERE 
    (CS.ComputerStatusKey = 3 
    OR
    CS.ComputerStatusKey = 5)
    AND 
    EC.Returned IS NULL
GROUP BY
    C.PurchaseDate,
    C.PurchaseCost,
    CONCAT(E.FirstName, ' ', E.LastName),
    CS.ActiveStatus;

