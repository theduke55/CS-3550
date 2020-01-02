DROP TABLE tbarker_Employees;
DROP TABLE tbarker_Benefits;
DROP TABLE tbarker_Departments;
DROP TABLE tbarker_Zip;

-----Create Tables
CREATE TABLE tbarker_Zip
(
	ZipID INT IDENTITY(1,1) NOT NULL,
	Zipcode VARCHAR(5) NOT NULL,
	City VARCHAR(20) NOT NULL,
	State VARCHAR(2) NOT NULL
);

CREATE TABLE tbarker_Departments
(
	DepartmentID INT IDENTITY(1,1) NOT NULL,
	DepartmentName VARCHAR(50) NOT NULL
);

CREATE TABLE tbarker_Benefits
(
	BenefitID INT IDENTITY(1,1) NOT NULL,
	BenefitName VARCHAR(50) NOT NULL,
	BenefitCost MONEY NOT NULL,
	BenefitDescription VARCHAR(200) NOT NULL
);

CREATE TABLE tbarker_Employees
(
	EmployeeID INT IDENTITY(1,1) NOT NULL,
	EmployeeFirstName VARCHAR(50) NOT NULL,
	EmployeeLastName VARCHAR(50) NOT NULL,
	EmployeeDOB DATE NOT NULL,
	EmployeeJobTitle VARCHAR(50) NOT NULL,
	EmployeeVeteranStatus VARCHAR(50) NULL,
	EmployeeEthnicity VARCHAR(50) NOT NULL,
	EmployeeSupervisorID INT NOT NULL,
	IsActive BIT NOT NULL,
	ZipID INT NOT NULL,
	StreetAddress VARCHAR(50) NOT NULL,
	BeginDate DATE NOT NULL,
	EndDate DATE NULL,
	DepartmentID INT NOT NULL,
	BenefitID INT NULL
);


-----Create Primary Keys
ALTER TABLE tbarker_Employees
ADD CONSTRAINT PK_EmployeeID PRIMARY KEY (EmployeeID);

ALTER TABLE tbarker_Departments
ADD CONSTRAINT PK_DepartmentID PRIMARY KEY (DepartmentID);

ALTER TABLE tbarker_Benefits
ADD CONSTRAINT PK_BenefitID PRIMARY KEY (BenefitID);

ALTER TABLE tbarker_Zip
ADD CONSTRAINT PK_ZipID PRIMARY KEY (ZipID);


-----Create Foreign Keys
ALTER TABLE tbarker_Employees
ADD CONSTRAINT FK_Employees_BenefitID FOREIGN KEY (BenefitID) REFERENCES tbarker_Benefits (BenefitID);

ALTER TABLE tbarker_Employees
ADD CONSTRAINT FK_Employees_ZipID FOREIGN KEY (ZipID) REFERENCES tbarker_Zip (ZipID);

ALTER TABLE tbarker_Employees
ADD CONSTRAINT FK_Employees_DepartmentID FOREIGN KEY (DepartmentID) REFERENCES tbarker_Departments (DepartmentID);


-----Insert values into Zip Table
INSERT INTO tbarker_Zip (Zipcode, City, State)
VALUES ('84404', 'Ogden', 'UT'),
	('84414', 'Farr West', 'UT'),
	('84401', 'Ogden', 'UT');


-----Insert values into Departments Table
INSERT INTO tbarker_Departments (DepartmentName)
VALUES ('Executive'),
	('Human Resources'),
	('Sales');


-----Insert values into Benefits Table
INSERT INTO tbarker_Benefits (BenefitName, BenefitCost, BenefitDescription)
VALUES ('Basic Health', 50, 'Healthcare only, high deductible'),
	('Deluxe Health and Dental', 75, 'Healthcare and dental, moderate deductible'),
	('Triple Coverage', 100, 'Health, dental, and vision, moderate deductible'),
	('Premium Coverage', 150, 'Health, dental, and vision, low deductible'),
	('Premium Coverage', 150, 'Health, dental, and vision, low deductible');


-----Insert values into Employees Table
INSERT INTO tbarker_Employees (EmployeeFirstName, EmployeeLastName, EmployeeDOB, EmployeeJobTitle, EmployeeVeteranStatus, 
EmployeeEthnicity, EmployeeSupervisorID, IsActive, ZipID, StreetAddress, BeginDate, EndDate, DepartmentID, BenefitID)
VALUES
('Trevor', 'Barker', '1988/01/13', 'CEO', 'N/A', 'Not Hispanic or Latino', 1, 1, 1, '1146 Harrop St.', '2019/01/01', NULL, 1, 4),
('Blaire', 'Christopherson', '1988/07/11', 'HR Manager', 'N/A', 'Not Hispanic or Latino', 1, 1, 1, '1148 Harrop St.', '2019/02/27', NULL, 2, 4),
('Trudy', 'Bustos', '1969/02/10', 'Sales Manager', 'N/A', 'Hispanic or Latino', 1, 1, 2, '1471 W 3450 N', '2019/02/27', NULL, 3, 4),
('Tanisha', 'Iglesias', '1990/07/16', 'Salesman', 'Disabled Veteran', 'Hispanic or Latino', 3, 1, 3, '101 Dan St.', '2019/02/27', NULL, 3, 1),
('Joe', 'Blow', '1950/01/01', 'Salesman', 'N/A', 'Not Hispanic or Latino', 3, 0, 1, '200 Eccles', '2019/02/26', '2019/02/27', 3, NULL),
('Alex', 'Trebech', '1900/01/01', 'Salesman', 'N/A', 'Not Hispanic or Latino', 3, 1, 2, '1537 W 3775 N', '2019/02/26', '2019/02/27', 3, 3),
('Ethan', 'Smith', '1970/4/18', 'Human Resources Representative', 'Retired Veteran', 'Not Hispanic or Latino', 2, 1, 1, '1146 Harrop St.', '2019/02/27', NULL, 2, 2);


--Show an employee change in departments
UPDATE tbarker_Employees
SET EmployeeJobTitle = 'Human Resources Representative',
	EmployeeSupervisorID = 2,
	BeginDate = '2019/02/27',
	EndDate = NULL,
	DepartmentID = 2
WHERE EmployeeID = 6;

/*Write a query that returns all active employees, the department they are currently assigned to, their supervisor,
 and the benefits package they are assigned to.
 */

SELECT
	E.EmployeeFirstName,
	E.EmployeeLastName,
	D.DepartmentName,
	S.EmployeeFirstName [SupervisorFirstName],
	S.EmployeeLastName [SupervisorLastName],
	B.BenefitName
FROM
	tbarker_Employees E
	INNER JOIN tbarker_Departments D ON E.DepartmentID = D.DepartmentID
	INNER JOIN tbarker_Benefits B ON E.BenefitID = B.BenefitID
	INNER JOIN tbarker_Employees S ON E.EmployeeSupervisorID = S.EmployeeID;