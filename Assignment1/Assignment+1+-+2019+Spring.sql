/* (5) Question #1: Write a query that returns "Hello World!  My name is <<insert your
	name here>>"
*/
SELECT
	'Hello World! My name is Trevor Barker';

/* (5) Question #2: Fix the following query.  It should return 
	13 rows, first one is "USB food flash drive - banana"
*/
SELECT
	SI.StockItemID,
	SI.StockItemName AS [ItemForSale],
	SI.ColorID AS [Color]

FROM
	Warehouse.StockItems SI
	
WHERE
	SI.ColorID IS NULL
	AND
	SI.StockItemName LIKE '%USB%'
	
ORDER BY
	ItemForSale;


/* (10) Question #3: Write a query against Sales.Orders that returns all rows
	for salesPersonPersonID 2 that occured in 2016 where 
	PickingCompletedWhen does not have a date.  You will get
	66 records back.
*/

SELECT
	*

FROM 
	Sales.Orders

WHERE
	SalespersonPersonID = 2
	AND
	YEAR(OrderDate) = 2016
	AND
	PickingCompletedWhen IS NULL;


/* (10) Question #4: Write a query against the Application.People table.  Return
	only SalesPeople (isSalesperson = 1).  Return the PersonID,
	parse the FullName to a first and last name (based on the space).
	Return the Logon Name without @wideworldimporters.com.  Sort the
	entire set by last name.  You should get ten records back, Lily Code
	should be first.
*/

SELECT
	PersonID,
	SUBSTRING(FullName, 1, CHARINDEX(' ', FullName) - 1) AS FirstName, 
	SUBSTRING(FullName, CHARINDEX(' ', FullName) + 1, len(FullName)) AS LastName,
	SUBSTRING(LogonName, 1, CHARINDEX('@', LogonName) -1) AS Logon_Name

FROM
	Application.People

WHERE
	IsSalesperson = 1

ORDER BY
	LastName;


/* Question #5: Return rows from Sales.Invoices for SalesPersonId 20.
	Filter the results down to match the following criteria:
		- All records that fall in quarter 4 and on a Friday
		- All records that fall in the month of December 2015

	Return the InvoiceID, the SalesPersonID, the Customer ID, and the InvoiceDate.
	Sort the final results by the CustomerID and then InvoiceDate

	You should get 427 records back.
*/

SELECT
	InvoiceID,
	SalespersonPersonID,
	CustomerID,
	InvoiceDate

FROM
	Sales.Invoices

WHERE
	SalespersonPersonID = 20
	AND
		((DATEPART(QUARTER, InvoiceDate) = 4
		AND
		DATEPART(WEEKDAY, InvoiceDate) = 6)
		OR
		(DATEPART(MONTH, InvoiceDate) = 12
		AND
		DATEPART(YEAR, InvoiceDate) = 2015))