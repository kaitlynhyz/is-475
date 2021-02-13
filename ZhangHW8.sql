/*Q1*/
SELECT
	ProductID,
	Description,
	QOH
FROM tblProduct
WHERE ProductID NOT IN (SELECT ProductID From tblPurchaseOrderLine)

/*Q2*/
SELECT
	CONVERT(VARCHAR, PODateNeeded, 107) 'DateofRequiredDelivery',
	PONumber,
	CONVERT(VARCHAR, PODatePlaced, 107) 'DateofPurchaseOrder',
	Name 'VendorName',
	'(' + substring(Phone,1,3) + ') ' + substring(Phone,4,3) + '-' + substring(Phone,7,4) 'VendorPhoneNumber',
	BuyerEmpID 'BuyerID'
FROM tblPurchaseOrder
INNER JOIN tblVendor
ON tblPurchaseOrder.VendorID = tblVendor.VendorID
WHERE MONTH(PODateNeeded) between 10 and 11 
ORDER BY PODateNeeded DESC 

/*Q3*/
SELECT
	CONVERT(VARCHAR, PODateNeeded, 107) 'DateofRequiredDelivery',
	PONumber,
	CONVERT(VARCHAR, PODatePlaced, 107) 'DateofPurchaseOrder',
	Name 'VendorName',
	'(' + substring(Phone,1,3) + ') ' + substring(Phone,4,3) + '-' + substring(Phone,7,4) 'VendorPhoneNumber',
	ISNULL(EmpFirstName + ' ' + EmpLastName, 'No Buyer') 'BuyerName'
FROM tblPurchaseOrder
INNER JOIN tblVendor
ON tblPurchaseOrder.VendorID = tblVendor.VendorID
LEFT JOIN tblEmployee
ON tblPurchaseOrder.BuyerEmpID = tblEmployee.EmpID
WHERE MONTH(PODateNeeded) between 10 and 11 
ORDER BY PODateNeeded DESC 

/*Q4*/
SELECT
	CONVERT(VARCHAR, PODateNeeded, 107) 'DateofRequiredDelivery',
	PONumber,
	CONVERT(VARCHAR, PODatePlaced, 107) 'DateofPurchaseOrder',
	Name 'VendorName',
	'(' + substring(Phone,1,3) + ') ' + substring(Phone,4,3) + '-' + substring(Phone,7,4) 'VendorPhoneNumber',
	ISNULL((e.EmpFirstName + ' ' + e.EmpLastName), 'No Buyer') 'BuyerName',
	ISNULL((m.EmpFirstName + ' ' + m.EmpLastName), '**No Manager**') 'ManagerName'
FROM tblPurchaseOrder
INNER JOIN tblVendor
ON tblPurchaseOrder.VendorID = tblVendor.VendorID
LEFT JOIN tblEmployee e
ON tblPurchaseOrder.BuyerEmpID = e.EmpID
LEFT JOIN tblEmployee m
ON m.EmpID = e.EmpMgrID
WHERE (MONTH(PODateNeeded) = 10 or MONTH(PODateNeeded) = 11) AND YEAR(PODateNeeded) = YEAR(GETDATE())
ORDER BY PODateNeeded DESC 

/*Q5*/
SELECT
	ProductID,
	DateReceived,
	PONumber 'PurchaseOrderNumber',
	QtyReceived,
	Description
FROM tblReceiver
INNER JOIN tblPurchaseOrderLine
ON tblReceiver.POLineID = tblPurchaseOrderLine.POLineID
INNER JOIN tblCondition
ON tblReceiver.ConditionID = tblCondition.ConditionID
WHERE Description like '%damage'
ORDER BY ProductID, DateReceived ASC

/*Q6*/
SELECT
	tblProduct.ProductID,
	tblProduct.Description 'ProductDescription',
	tblProductType.Description 'Product Type',
	DateReceived,
	tblPurchaseOrder.PONumber,
	Name 'VendorName',
	'(' + substring(Phone,1,3) + ') ' + substring(Phone,4,3) + '-' + substring(Phone,7,4) 'VendorPhoneNumber',
	QtyReceived,
	tblCondition.Description
FROM tblReceiver
INNER JOIN tblPurchaseOrderLine
ON tblReceiver.POLineID = tblPurchaseOrderLine.POLineID
INNER JOIN tblCondition
ON tblReceiver.ConditionID = tblCondition.ConditionID
INNER JOIN tblProduct
ON tblPurchaseOrderLine.ProductID = tblProduct.ProductID
INNER JOIN tblProductType
ON tblProduct.ProductTypeID = tblProductType.ProductTypeID
INNER JOIN tblPurchaseOrder
ON tblPurchaseOrderLine.PONumber = tblPurchaseOrder.PONumber
INNER JOIN tblVendor
ON tblPurchaseOrder.VendorID = tblVendor.VendorID
WHERE tblCondition.Description like '%damage'
ORDER BY ProductID, DateReceived ASC

/*Q7*/
SELECT DISTINCT
	Name 'VendorName',
	'(' + substring(Phone,1,3) + ') ' + substring(Phone,4,3) + '-' + substring(Phone,7,4) 'VendorPhoneNumber'
FROM tblReceiver
LEFT JOIN tblPurchaseOrderLine
ON tblReceiver.POLineID = tblPurchaseOrderLine.POLineID
LEFT JOIN tblCondition
ON tblReceiver.ConditionID = tblCondition.ConditionID
LEFT JOIN tblProduct
ON tblPurchaseOrderLine.ProductID = tblProduct.ProductID
LEFT JOIN tblPurchaseOrder
ON tblPurchaseOrderLine.PONumber = tblPurchaseOrder.PONumber
LEFT JOIN tblVendor
ON tblPurchaseOrder.VendorID = tblVendor.VendorID
WHERE tblCondition.Description like '%damage' and tblProduct.Description = 'Alpine Small Pot'


/*Q8*/
SELECT
	tblProduct.ProductID,
	Description,
	COUNT(QtyOrdered) 'CountofPurchaseOrders',
	ISNULL(CAST(SUM(QtyOrdered) as DECIMAL(10,0)), '0.00') 'TotalQuantityOrdered',
	ISNULL(MAX(tblPurchaseOrderLine.Price), '0.00') 'MaximumPricePaid',
	ISNULL(MIN(tblPurchaseOrderLine.Price), '0.00') 'MaximumPricePaid',
	ISNULL(ROUND(AVG(tblPurchaseOrderLine.Price),2), '0.00') 'AveragePricePaid'
FROM tblProduct
LEFT JOIN tblPurchaseOrderLine
ON tblProduct.ProductID = tblPurchaseOrderLine.ProductID
GROUP BY tblProduct.ProductID, Description

/*Q9*/
SELECT
	tblPurchaseOrderLine.PONumber,
	PODatePlaced,
	Name 'VendorName',
	ISNULL(EmpLastName + ', ' + substring(EmpFirstName,1,1), 'No Buyer') + '.' 'Buyer',
	tblProduct.ProductID,
	tblProduct.Description 'ProductDescription',
	PODateNeeded,
	QtyOrdered 'Quantity Ordered',
	Price 'Unit Price',
	CAST((QtyOrdered * Price) as MONEY) 'ExtendedPrice'
FROM tblPurchaseOrder
INNER JOIN tblVendor
ON tblPurchaseOrder.VendorID = tblVendor.VendorID
LEFT JOIN tblEmployee
ON tblPurchaseOrder.BuyerEmpID = tblEmployee.EmpID
INNER JOIN tblPurchaseOrderLine
ON tblPurchaseOrder.PONumber = tblPurchaseOrderLine.PONumber
INNER JOIN tblProduct
ON tblPurchaseOrderLine.ProductID = tblProduct.ProductID
ORDER BY tblPurchaseOrderLine.PONumber, tblPurchaseOrderLine.ProductID

/*Q10*/
SELECT
	tblPurchaseOrderLine.PONumber,
	PODatePlaced,
	Name 'VendorName',
	ISNULL(EmpLastName + ', ' + substring(EmpFirstName,1,1), 'No Buyer') + '.' 'Buyer',
	tblProduct.ProductID,
	tblProduct.Description 'ProductDescription',
	PODateNeeded 'ProductDateNeeded',
	QtyOrdered 'Quantity Ordered',
	DateReceived,
	ISNULL(QtyReceived, '0.00') 'QtyReceived'
FROM tblProduct
INNER JOIN tblPurchaseOrderLine
ON tblProduct.ProductID = tblPurchaseOrderLine.ProductID
INNER JOIN tblPurchaseOrder
ON tblPurchaseOrderLine.PONumber = tblPurchaseOrder.PONumber
INNER JOIN tblVendor
ON tblPurchaseOrder.VendorID = tblVendor.VendorID
LEFT JOIN tblEmployee
ON tblPurchaseOrder.BuyerEmpID = tblEmployee.EmpID
LEFT JOIN tblReceiver
ON tblPurchaseOrderLine.POLineID = tblReceiver.POLineID
WHERE tblPurchaseOrderLine.PONumber IS NOT NULL
ORDER BY tblPurchaseOrderLine.PONumber, tblPurchaseOrderLine.ProductID

/*Q11*/
SELECT
	tblPurchaseOrder.PONumber,
	tblVendor.Name,
	tblProduct.ProductID,
	Description 'ProductDescription',
	PODateNeeded 'ProductDateNeeded',
	QtyOrdered 'QuantityOrdered',
	ISNULL(SUM(QtyReceived), '0.00') 'TotalQuantityReceived',
	ISNULL(QtyOrdered - SUM(QtyReceived), '0.00') 'QuantityRemainingToBeReceived',
CASE
	WHEN QtyOrdered - SUM(QtyReceived) = 0
		THEN 'Complete'
	WHEN QtyOrdered - SUM(QtyReceived) < 0
		THEN 'Over Shipment'
	WHEN QtyOrdered - SUM(QtyReceived) > 0
		THEN 'Partial Shipment'
	ELSE 'Not Received'
END 'Receiving Status'
FROM tblProduct
INNER JOIN tblPurchaseOrderLine
ON tblProduct.ProductID = tblPurchaseOrderLine.ProductID
INNEr JOIN tblPurchaseOrder
ON tblPurchaseOrderLine.PONumber = tblPurchaseOrder.PONumber
INNER JOIN tblVendor
ON tblPurchaseOrder.VendorID = tblVendor.VendorID
LEFT JOIN tblReceiver
ON tblPurchaseOrderLine.POLineID = tblReceiver.POLineID
WHERE tblPurchaseOrder.PONumber IS NOT NULL
GROUP BY 
	tblProduct.ProductID, 
	Description, 
	QtyOrdered, 
	PODateNeeded, 
	tblPurchaseOrder.PONumber, 
	tblVendor.Name
ORDER BY tblPurchaseOrder.PONumber, tblProduct.ProductID, PODateNeeded

/*Q12*/
SELECT
	PONumber,
	PODatePlaced,
	PODateNeeded,
	Terms,
	tblVendor.VendorID,
	Name 'VendorName'
FROM tblPurchaseOrder
INNER JOIN tblVendor
ON tblPurchaseOrder.VendorID = tblVendor.VendorID
WHERE PONumber NOT IN 
	(SELECT PONumber
	FROM tblPurchaseORderLine
	INNER JOIN tblReceiver
	ON tblPurchaseOrderLine.POLineiD = tblReceiver.POLineID)

/*Q13*/
SELECT
	tblPurchaseOrder.PONumber,
	Name 'VendorName',
	tblPurchaseOrderLine.ProductID,
	Description,
	Price
FROM tblProduct
INNER JOIN tblPurchaseOrderLine
ON tblProduct.ProductID = tblPurchaseOrderLine.ProductID
INNER JOIN tblPurchaseOrder
ON tblPurchaseOrderLine.PONumber = tblPurchaseOrder.PONumber
INNER JOIN tblVendor
ON tblPurchaseOrder.VendorID = tblVendor.VendorID
WHERE Price = (SELECT MIN(Price) from tblPurchaseOrderLine)

/*Q14*/
SELECT
	tblProduct.ProductID,
	Description 'ProductDescription',
	EOQ 'ProductEconomicOrderQuantity',
	ISNULL(CONVERT(VARCHAR,DatePurchased, 107), 'Not in Purchase History') 'MostRecentPurchaseDate',
	ISNULL(Qty, '0.00') 'QuantityPurchased',
	ISNULL(Price, '0.00') 'PurchasePrice'
FROM tblProduct
LEFT JOIN tblPurchaseHistory
ON tblProduct.ProductID = tblPurchaseHistory.ProductID
WHERE DatePurchased = 
	(SELECT MAX(DatePurchased) 
	FROM tblPurchaseHistory
	WHERE tblProduct.ProductID = tblPurchaseHistory.ProductID)
	OR DatePurchased is NULL
ORDER BY tblProduct.ProductID
