/*Q1*/
SELECT
	ProductID,
	Description,
	UOM,
	EOQ
FROM tblproduct
WHERE uom ='feet'

/*Q2*/
SELECT
	PONumber,
	ProductID,
	QtyOrdered,
	DateNeeded
FROM tblPurchaseOrderLine
WHERE 
	QtyOrdered >= 500 and
	YEAR(DateNeeded) = year(GETDATE())

/*Q3*/
SELECT
	EmpLastName 'EmployeeLastName',
	EmpFirstName 'EmployeeFirstName',
	'(' + substring(EmpPhone,1, 3) + ') ' + substring(EmpPhone,4,3) + '-' + substring(EmpPhone,7,4) 'EmployeePhoneNumber',
	EmpEmail
FROM tblEmployee
WHERE EmpEmail is NULL
ORDER BY EmpLastName

/*Q4*/
SELECT
	VendorID,
	Name 'VendorName',
	Address1 + ', ' + City + ', ' + State 'VendorAddress',
	'(' + substring(Phone,1, 3) + ') ' + substring(Phone,4,3) + '-' + substring(Phone,7,4) 'VendorPhone',
	CONVERT(VARCHAR, FirstBuyDate, 107) 'DateFirstBuy'
FROM tblVendor
WHERE 
	State in ('NV', 'CA')
ORDER BY FirstBuyDate


/*Q4A*/
SELECT
	VendorID,
	Name 'VendorName',
	Address1 + ', ' + UPPER(SUBSTRING(City,1,1)) + LOWER(SUBSTRING(City,2,10)) + ', ' + UPPER(State) 'VendorAddress',
	'(' + substring(Phone,1, 3) + ') ' + substring(Phone,4,3) + '-' + substring(Phone,7,4) 'VendorPhone',
	CONVERT(VARCHAR, FirstBuyDate, 107) 'DateFirstBuy'
FROM tblVendor
WHERE 
	State in ('NV', 'CA')
ORDER BY FirstBuyDate;


/*Q5*/
SELECT
	CONVERT(VARCHAR, DateNeeded, 107) 'Date Needed',
	ProductID 'Product Number',
	PONumber 'Purchase Order Number',
	QtyOrdered 'Quantity Ordered',
	Price,
	CAST(QtyOrdered * Price as DECIMAL(10,2)) 'Extended Price'
FROM tblPurchaseOrderLine
WHERE
	YEAR(DateNeeded) = year(GETDATE()) + 1
ORDER BY DateNeeded

/*Q6*/
SELECT MAX(Price) AS 'Most Expensive Selling Price for Product G0983'
FROM tblPurchaseOrderLine
WHERE ProductID = 'G0983'

/*Q7*/
SELECT CAST(ROUND(SUM(QtyOrdered * Price),2) as DECIMAL(10,2)) AS 'Total Order Price for September'
FROM tblPurchaseOrderLine
WHERE 
	YEAR(DateNeeded) = year(GETDATE()) and
	MONTH(DateNeeded) = 9

/*Q8*/
SELECT
	ProductID 'Product Number',
	Description 'Product Description',
	EOQ 'Economic Order Quantity',
	QOH 'Quantity on Hand',
	QOH - EOQ 'Difference',
	CASE
		WHEN EOQ-QOH >= 50
		THEN 'Order Now'
		ELSE NULL
	END OrderMessage
FROM tblProduct
WHERE 
	QOH <= EOQ
ORDER BY ProductID

/*Q9*/
SELECT
	ProductID 'Product Number',
	Description 'Product Description',
	EOQ 'Economic Order Quantity',
	QOH 'Quantity on Hand',
	QOH - EOQ 'Difference',
	CASE
		WHEN QOH = 0
			THEN 'Order Immediately'
		WHEN EOQ - QOH >= 6 and EOQ - QOH <= 10
			THEN 'Order next month'
		WHEN EOQ - QOH >= 11 and EOQ - QOH <= 35
			THEN 'Order next week'
		WHEN EOQ - QOH >= 35
			THEN 'Order this week'
		ELSE NULL
	END OrderMessage
FROM tblProduct
WHERE 
	QOH <= EOQ
ORDER BY EOQ DESC
 
/*Q10*/
SELECT
	ProductTypeID 'Product Type ID',
	COUNT(UOM) 'Count of Products',
	CAST(SUM(QOH) as INT) 'Total Quantity on Hand',
	CAST(ROUND(AVG(QOH), 2) as DECIMAL(10,2)) 'Average Quantity on Hand'
FROM tblProduct
GROUP BY ProductTypeID

/*Q11*/
SELECT
	ProductTypeID 'Product Type ID',
	COUNT(UOM) 'Count of Products',
	CAST(SUM(QOH) as INT) 'Total Quantity on Hand',
	CAST(ROUND(AVG(QOH), 2) as DECIMAL(10,2)) 'Average Quantity on Hand'
FROM tblProduct
GROUP BY ProductTypeID
HAVING AVG(QOH) >=50

/*Q12*/
SELECT
	ProductID 'Product Number',
	CONVERT(VARCHAR, MAX(DatePurchased), 101) 'Last Date Purchased',
	COUNT(Qty) 'Number of Times Purchased',
	MIN(Price) 'Minimum Purchase Price',
	MAX(Price) 'Maximum Purchase Price',
	MAX(Price) - MIN(Price) 'Difference Between Maximum and Minimum Price'
FROM tblPurchaseHistory
GROUP BY ProductID

/*Q13*/
SELECT
	ProductID 'Product Number',
	CONVERT(VARCHAR, MAX(DatePurchased), 101) 'Last Date Purchased',
	COUNT(Qty) 'Number of Times Purchased',
	MIN(Price) 'Minimum Purchase Price',
	MAX(Price) 'Maximum Purchase Price',
	MAX(Price) - MIN(Price) 'Difference Between Maximum and Minimum Price'
FROM tblPurchaseHistory
GROUP BY ProductID
HAVING MAX(Price) - MIN(Price) = 0

/*Q14*/
SELECT
	CONVERT(VARCHAR, PODateNeeded, 107) 'Date Needed',
	CONVERT(VARCHAR,GETDATE(), 107) 'Todays Date',
	DATEDIFF(day, PODateNeeded, GETDATE()) 'Days Overdue',
	PONumber 'Purchase Order Date',
	BuyerEmpID 'Buyer',
	VendorID 'Vendor ID'
FROM tblPurchaseOrder
WHERE
	DATEDIFF(day, PODateNeeded, GETDATE()) >= 7
ORDER BY PODateNeeded


/*Q15*/
SELECT TOP 1
	VendorID,
	Name 'VendorName',
	Zip 'VendorZip',
	CONVERT(varchar, FirstBuyDate, 107) 'DateFirstPurchased'
FROM tblVendor
ORDER BY FirstBuyDate