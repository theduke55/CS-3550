/*
Question #1: 5 points

Write a query that counts how many invoices are in the system for 
	each year.  You will need only the Sales.Invoices table for this query.
	The year can be determined by the InvoiceDate column.  Sort the final 
	results by the count of invoices, largest to smallest.

You should get 4 rows back.  2015 had 22,250 invoices
*/
SELECT
	COUNT(InvoiceID) [Invoices], 
	YEAR(InvoiceDate) [Year]
FROM
	Sales.Invoices
GROUP BY
	YEAR(InvoiceDate)
ORDER BY
	Invoices DESC;	


/*
Question #2: 5 points

Write a query that returns the average, min, and max
	quantities for all stock items.  You'll need the 
	Warehouse.StockItems and Sales.InvoiceLines tables.
	They join on the StockItemID column.  Return the 
	StockItemID, StockItem name, and the average, min, 
	and max quantities.  Sort the final result by the 
	average quantity, largest to smallest.

You should get 227 rows.  The "Black and orange fragile despatch tape 48mmx75m"
	stock item has an average quanity of 199, a minimum of 36, and a maximum
	of 360.
*/
SELECT
	SI.StockItemID,
	SI.StockItemName,
	AVG(IL.Quantity) [Average Quantity],
	MIN(IL.Quantity) [Minimum Quantity],
	MAX(IL.Quantity) [Max Quantity]
FROM
	Warehouse.StockItems SI 
	INNER JOIN Sales.InvoiceLines IL ON SI.StockItemID = IL.StockItemID
GROUP BY
	SI.StockItemID,
	SI.StockItemName
ORDER BY
	AVG(IL.Quantity) DESC;

/* 
Question #3: 10 points

Write a query that shows all colors in the Warehouse.Colors table
	and the number of StockItems (in Warehouse.StockItems) that have the color.  Return the 
	color ID, the Color Name, and the count of stock items.  Order the final results by
	the count, largest to smallest.

You should get 36 rows back.  Black has 51 stock items, Hot Pink has 0.  The two
	tables can be joined on the ColorID column
*/
SELECT
	C.ColorID [ColorID],
	C.ColorName [Color Name],
	COUNT(SI.StockItemID) [Number of Stock Items]
FROM
	Warehouse.Colors C
	LEFT JOIN Warehouse.StockItems SI ON C.ColorID = SI.ColorID
GROUP BY
	C.ColorID,
	C.ColorName 
ORDER BY
	[Number of Stock Items] DESC;

/*
Question #4: 10 points

Write a query to identify any StockItem that has sold more than
	40,000 units in 2015.  You will need the Warehouse.StockItems,
	Sales.Invoices, and Sales.InvoiceLines tables.  Sales.Invoices
	joins to Sales.InvoiceLines on InvoiceID.  Sales.InvoiceLines
	joins to the StockItems table on StockItemID.  You can get the quanity
	sold from the Quantity value in the InvoiceLines table.  The date
	of sale is the InvoiceDate in the Invoices table.

You should get 21 rows back.  The top seller was "Black and orange fragile despatch tape 48mmx75m"
	at 64,224 items sold.  The last item on the list is "Black and orange handle with care despatch tape  48mmx100m"
	at 40,800 items sold
*/
SELECT
	SI.StockItemName [Item Name],
	SUM(IL.Quantity) [Quantity]
FROM
	Sales.Invoices I
	INNER JOIN Sales.InvoiceLines IL ON I.InvoiceID = IL.InvoiceID
	INNER JOIN Warehouse.StockItems SI ON IL.StockItemID = SI.StockItemID
GROUP BY
	SI.StockItemName,
	YEAR(I.InvoiceDate)
HAVING
	SUM(IL.Quantity) > 40000
	AND
	YEAR(I.InvoiceDate) = 2015
ORDER BY
	Quantity DESC;

/*
Question #5: 15 points

Write a query that brings back a row for each customer, a count
	of invoices they have, the total extended price of all invoices, 
	the min value, and the max value of the invoice total.  
	To get the total value of an invoice, you have
	to sum up the extended price value in the Sales.InvoiceLines table.
	You will need the Sales.Invoices, Sales.InvoiceLines, and Sales.Customers 
	tables.  The first two join on the InvoiceID column.  Sales.Customers joins
	to Sales.Invoices on the CustomerID.  Order the final results by the 
	count of invoices (largest to smallest), then by the largest invoice (largest
	to smallest).

	You should get 663 rows back.  Bhaavan Rai is the first row with 144 
	invoices.  Their smallest invoice total was 29.90, the largest 20,386.31.  
	Total business with Bhaavan Rai is $369,173.36
*/
WITH T1(InvoiceID,Total)
AS 
(
	SELECT
		IL.InvoiceID [InvoiceID],
		SUM(IL.ExtendedPrice) AS [Total]
	FROM
		Sales.InvoiceLines IL
	GROUP BY
		IL.InvoiceID
)

SELECT
	C.CustomerID [Customer ID],
	C.CustomerName [Customer's Full Name],
	COUNT(DISTINCT T1.InvoiceID) [Number of Invoices],
	SUM(Total) [Total],
	MIN(Total) [Smallest Invoice],
	MAX(Total) [Largest Invoice]
FROM
	Sales.Invoices I 
	INNER JOIN T1 ON I.InvoiceID = T1.InvoiceID
	INNER JOIN Sales.Customers C ON C.CustomerID = I.CustomerID
GROUP BY
	C.CustomerID,
	C.CustomerName
ORDER BY
	[Number of Invoices] DESC,
	[Largest Invoice] DESC;