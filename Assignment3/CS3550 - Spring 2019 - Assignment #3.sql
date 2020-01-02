/* Query #1 (10 points):

Write the necessary INSERT statements to add the Best Buy locations in Nebraska 
	and Alaska.  These can be found at https://stores.bestbuy.com/.

The store in Papillion, NE is closing.  Write a delete statement to remove this 
	location from the database (completely ignoring our conversation about why 
	this is so bad to do).

The store in Lincoln, NE has moved locations.  Write an update statement that
	changes its address to:
	42 Balcome
	West Sussex, NE 68511

A new store has opened up in Worcester, MA.  Write an insert statement to add 
	the store (use the address from the site).

Script to create the table included below.

*/

CREATE SCHEMA [Homework];

CREATE TABLE [Homework].Locations
(
	LocationKey int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	LocationName varchar(50) NOT NULL,
	Address1 varchar(50) NOT NULL,
	Address2 varchar(50) NULL,
	City varchar(50) NOT NULL,
	StateCode char(2) NOT NULL,
	ZipCode char(5) NOT NULL,
	Zip4 char(4) NULL
);

INSERT Homework.Locations(LocationName, Address1, City, StateCode, ZipCode)
VALUES('Best Buy North Anchorage', '1200 N Muldoon Rd Ste G', 'Anchorage', 'AK', 99504),
	('Best Buy Achorage', '800 E Dimond Blvd', 'Anchorage', 'AK', 99515),
	('Best Buy Grand Island', '3404 W 13th St', 'Grand Island', 'NE', 68803),
	('Best Buy Lincoln', '6919 O Street', 'Lincoln', 'NE', 68510),
	('Best Buy Omaha East', '115 N 76th St', 'Omaha', 'NE', 68114),
	('Best Buy West Omaha', '333 N 170th St', 'Omaha', 'NE', 68118),
	('Best Buy Papillion', '7949 Towne Center Pkwy', 'Papillion', 'NE', 68046)

DELETE FROM 
	Homework.Locations
WHERE 
	LocationKey = 7
	AND
	LocationName = 'Best Buy Papillion';

UPDATE Homework.Locations
SET Address1 = '42 Balcome',
	City = 'West Sussex',
	ZipCode = 68511
WHERE
	LocationKey = 4;

INSERT Homework.Locations(LocationName, Address1, City, StateCode, ZipCode)
VALUES('Best Buy Worcester', '7 Neponset St', 'Worcester', 'MA', 01606);


/* Question #2 (15 points):

Write a query that returns all items in the Warehouse.StockItems table, their lifetime 
	sales total (as found by summing up Extended Price in the Sales.InvoiceLines table), 
	and the % of total sales for the items supplier.
	
Tables you'll need
 - Purchasing.Suppliers
 - Warehouse.StockItems
 - Sales.InvoiceLines
	
The joins are easy to figure out....

Your query should include the columns seen below.  Sort the final results by the supplier name
	and then percentage of total sales.  You will get 227 rows.  A few examples (found in the 
	first 10 rows of the results if sorted correctly).

SupplierID	SupplierName			StockItemID	StockItemName				TotalSales	PercentageOfSupplierSales
1			A Datum Corporation		221	Novelty chilli chocolates 500g		143741.40	0.114373
1			A Datum Corporation		224	Chocolate frogs 250g				140849.28	0.112072
2			Contoso, Ltd.			152	Pack of 12 action figures (female)	110363.20	0.348822
2			Contoso, Ltd.			151	Pack of 12 action figures (male)	103739.20	0.327886


*/
WITH CTE1
AS (SELECT	
		SI.SupplierID,
		SUM(IL.ExtendedPrice) [GrandTotal]
	FROM
		Warehouse.StockItems SI
		INNER JOIN Sales.InvoiceLines IL ON IL.StockItemID = SI.StockItemID
		INNER JOIN Purchasing.Suppliers SP ON SI.SupplierID = SP.SupplierID
	GROUP BY 
		SI.SupplierID
	)

SELECT
	SP.SupplierID,
	SP.SupplierName,
	SI.StockItemID,
	SI.StockItemName,
	SUM(IL.ExtendedPrice) [Total Sales],
	SUM(IL.ExtendedPrice)/CTE1.GrandTotal [PercentageOfSupplierSales]
FROM
	Warehouse.StockItems SI
	INNER JOIN Sales.InvoiceLines IL ON IL.StockItemID = SI.StockItemID
	INNER JOIN Purchasing.Suppliers SP ON SI.SupplierID = SP.SupplierID
	LEFT JOIN CTE1 ON SP.SupplierID = CTE1.SupplierID
GROUP BY
	SP.SupplierID,
	SP.SupplierName,
	SI.StockItemID,
	SI.StockItemName,
	CTE1.GrandTotal
ORDER BY
	SP.SupplierName,
	PercentageOfSupplierSales DESC;

/*
Question #3 (10 points):

Its time for the annual trade show and you want to make sure all
	your suppliers make it to the party.  The marketing team needs
	a list of all your suppliers, their full delivery address, and 
	the name of both the primary and alternate contacts for the 
	supplier.  Order the results by supplier name.

	You'll be using a number of tables - Purchasing.Suppliers, and
	the People, Cities, and StateProvinces tables in the Application 
	schema.  The columns to join things up are a bit more tricky - 
		- Suppliers to people on the PersonID and the PrimaryContactPersonID
			or AlternateContactPersonID.
		- Cities on CityID to Suppliers on DeliveryCityID
		- StateProvices on StateProvinceID (on both sides)

	Something to keep in mind...  you can join to the same table multiple times
	as long as you give them different aliases.

This query will return 13 rows and 9 columns.  An example to compare to - 

SupplierName		PrimaryContactName	AlternateContactName	DeliveryAddressLine1	DeliveryAddressLine2		DeliveryCityID	CityName	StateProvinceCode	DeliveryPostalCode
A Datum Corporation	Reio Kabin			Oliver Kivi				Suite 10				183838 Southwest Boulevard	38171			Zionsville	IN					46077

*/
SELECT
	S.SupplierName,
	PC.FullName [PrimaryContactName],
	AC.FullName [AlternateContactName],
	S.DeliveryAddressLine1,
	S.DeliveryAddressLine2,
	S.DeliveryCityID,
	C.CityName,
	SP.StateProvinceCode,
	S.DeliveryPostalCode
FROM
	Purchasing.Suppliers S
	INNER JOIN Application.People PC ON S.PrimaryContactPersonID = PC.PersonID
	INNER JOIN Application.People AC ON S.AlternateContactPersonID = AC.PersonID
	INNER JOIN Application.Cities C ON S.DeliveryCityID = C.CityID
	INNER JOIN Application.StateProvinces SP ON SP.StateProvinceID = C.StateProvinceID

/* Question #4 (15 points):

You’ve been asked to send thank you gifts to customers who have purchased large quantities of your recently 
released chocolate animal series (stock item id’s 222, 223, 224, 225).  Your query 
needs to list the customer ID, the customer Name, have a column that totals units of each animal type, 
and a grand total for all animals.  To qualify for the gift, the customer must have purchased at least 300 
of any given animal type, or a total of 500 across all animal types.  Your final query should sort by
the total – largest to smallest.  You should get 20 rows – the first two look like this – 

CustomerID	CustomerName					Beetles	Echidnas	Frogs	Sharks	Total
441			Wingtip Toys (Keosauqua, IA)	216		432			0		96		744
573			Wingtip Toys (Marin City, CA)	264		0			312		168		744
*/
SELECT
	C.CustomerID,
	C.CustomerName,
	SUM(CASE WHEN IL.StockItemID = 222 THEN Quantity ELSE 0 END) [Beetles],
	SUM(CASE WHEN IL.StockItemID = 223 THEN Quantity ELSE 0 END) [Echidnas],
	SUM(CASE WHEN IL.StockItemID = 224 THEN Quantity ELSE 0 END) [Frogs],
	SUM(CASE WHEN IL.StockItemID = 225 THEN Quantity ELSE 0 END) [Sharks],
	SUM(Quantity) [Total]
FROM
	Sales.InvoiceLines IL
	INNER JOIN Sales.Invoices I ON IL.InvoiceID = I.InvoiceID
	INNER JOIN Sales.Customers C ON C.CustomerID = I.CustomerID
WHERE
	IL.StockItemID IN (222, 223, 224, 225)
GROUP BY
	C.CustomerID,
	C.CustomerName
HAVING
	SUM(Quantity) > 500
	OR
	SUM(CASE WHEN IL.StockItemID = 222 THEN Quantity ELSE 0 END) > 300
	OR
	SUM(CASE WHEN IL.StockItemID = 223 THEN Quantity ELSE 0 END) > 300
	OR
	SUM(CASE WHEN IL.StockItemID = 224 THEN Quantity ELSE 0 END) > 300
	OR
	SUM(CASE WHEN IL.StockItemID = 225 THEN Quantity ELSE 0 END) > 300
ORDER BY
	[Total] DESC;