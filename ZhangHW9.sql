/*Q1*/
CREATE VIEW vReceiverTotalQty AS
SELECT 
	SUM(QtyReceived) 'TotalQtyReceived',
	POLineID
FROM tblReceiver
GROUP BY POLineID

SELECT
	tblPurchaseOrder.PONumber,
	CONVERT(VARCHAR, PODatePlaced, 107) 'PODatePlaced',
	Name 'VendorName',
	ISNULL((e.EmpLastName + ', ' + substring(e.EmpFirstName,1,1) + '.'), 'No Buyer on File') 'EmployeeBuyer',
	ISNULL((m.EmpLastName + ', ' + substring(m.EmpFirstName,1,1)), 'No Manager on File') 'BuyerManager',
	tblProduct.ProductID,
	Description 'ProductDescription',
	CONVERT(VARCHAR, DateNeeded, 107) 'DateNeeded',
	Price 'ProductPrice',
	QtyOrdered,
	ISNULL(TotalQtyReceived, 0) 'TotalQtyReceived',
	ISNULL((QtyOrdered - TotalQtyReceived), 0) 'QtyRemaining',
CASE
	WHEN (QtyOrdered - TotalQtyReceived) = 0
		THEN 'Complete'
	WHEN (QtyOrdered - TotalQtyReceived) < 0
		THEN 'Over Shipped'
	WHEN (QtyOrdered - TotalQtyReceived) > 0
		THEN 'Partially Received'
	ELSE 'Not Received'
END 'Receiving Status'
FROM tblPurchaseOrderLine
LEFT JOIN vReceiverTotalQty
ON tblPurchaseOrderLine.POLineID = vReceiverTotalQty.POLineID
INNER JOIN tblProduct
ON tblPurchaseOrderLine.ProductID = tblProduct.ProductID
INNER JOIN tblPurchaseOrder
ON tblPurchaseOrderLine.PONumber = tblPurchaseOrder.PONumber
INNER JOIN tblVendor
ON tblPurchaseOrder.VendorID = tblVendor.VendorID
LEFT JOIN tblEmployee e
ON tblPurchaseOrder.BuyerEmpID = e.EmpID
LEFT JOIN tblEmployee m
ON e.EmpMgrID = m.EmpID
ORDER BY tblPurchaseOrder.PONumber, tblProduct.ProductID

/*Q2*/
CREATE VIEW vReceivingStatus AS
SELECT
	PONumber,
CASE
	WHEN (QtyOrdered - TotalQtyReceived) = 0
		THEN 'Complete'
	WHEN (QtyOrdered - TotalQtyReceived) < 0
		THEN 'Over Shipped'
	WHEN (QtyOrdered - TotalQtyReceived) > 0
		THEN 'Partially Received'
	ELSE 'Not Received'
END 'Receiving Status'
FROM tblPurchaseOrderLine
LEFT JOIN vReceiverTotalQty
ON tblPurchaseOrderLine.POLineID = vReceiverTotalQty.POLineID

SELECT DISTINCT
	tblPurchaseOrder.PONumber,
	CONVERT(VARCHAR, PODatePlaced, 107) 'PODatePlaced',
	CONVERT(VARCHAR, PODateNeeded, 107) 'PODateNeeded',
	Name 'VendorName'
FROM tblPurchaseOrderLine
INNER JOIN tblReceiver
ON tblPurchaseOrderLine.POLineID = tblReceiver.POLineID
INNER JOIN tblPurchaseOrder
ON tblPurchaseOrderLine.PONumber = tblPurchaseOrder.PONumber
INNER JOIN tblVendor
ON tblPurchaseOrder.VendorID = tblVendor.VendorID
LEFT JOIN vReceivingStatus
ON tblPurchaseOrderLine.PONumber = vReceivingStatus.PONumber
WHERE [Receiving Status] in ('Complete', 'Over Shipped')
and QtyReceived < QtyOrdered

/*Q3*/
SELECT DISTINCT
	tblPurchaseOrder.PONumber,
	CONVERT(VARCHAR, PODatePlaced, 107) 'PODatePlaced',
	CONVERT(VARCHAR, PODateNeeded, 107) 'PODateNeeded',
	Name 'VendorName'
FROM tblPurchaseOrderLine
INNER JOIN tblReceiver
ON tblPurchaseOrderLine.POLineID = tblReceiver.POLineID
INNER JOIN tblPurchaseOrder
ON tblPurchaseOrderLine.PONumber = tblPurchaseOrder.PONumber
INNER JOIN tblVendor
ON tblPurchaseOrder.VendorID = tblVendor.VendorID
LEFT JOIN vReceivingStatus
ON tblPurchaseOrderLine.PONumber = vReceivingStatus.PONumber
WHERE [Receiving Status] in ('Not Received', 'Partially Received')
and QtyReceived < QtyOrdered

/*Q4*/
SELECT DISTINCT
	tblPurchaseOrder.PONumber,
	CONVERT(VARCHAR, PODatePlaced, 107) 'PODatePlaced',
	CONVERT(VARCHAR, PODateNeeded, 107) 'PODateNeeded',
	Name 'VendorName',
	ProductID,
	CONVERT(VARCHAR,MIN(DateReceived), 107) 'FirstDateReceived',
	CONVERT(VARCHAR,MAX(DateReceived), 107) 'LastDateReceived',
	QtyOrdered 'Quantity Ordered',
	TotalQtyReceived 'Quantity Received'
FROM tblPurchaseOrderLine
INNER JOIN tblReceiver
ON tblPurchaseOrderLine.POLineID = tblReceiver.POLineID
INNER JOIN tblPurchaseOrder
ON tblPurchaseOrderLine.PONumber = tblPurchaseOrder.PONumber
INNER JOIN tblVendor
ON tblPurchaseOrder.VendorID = tblVendor.VendorID
LEFT JOIN vReceivingStatus
ON tblPurchaseOrderLine.PONumber = vReceivingStatus.PONumber
LEFT JOIN vReceiverTotalQty
ON tblPurchaseOrderLine.POLineID = vReceiverTotalQty.POLineID
WHERE [Receiving Status] in ('Complete', 'Over Shipped')
and QtyReceived < QtyOrdered
GROUP BY tblPurchaseOrder.PONUmber, PODatePlaced, PODateNeeded, Name, ProductID, QtyOrdered, TotalQtyReceived

/*Q5*/
SELECT 
	tblProduct.ProductID,
	Description,
	tblPurchaseHistory.Price 'RecentHistoricalPrice',
	tblPurchaseOrderLine.Price 'CurrentPrice',
	PONumber,
	Name 'VendorName'
FROM tblPurchaseOrderLine
LEFT JOIN tblProduct
ON tblPurchaseOrderLine.ProductID = tblProduct.ProductID
LEFT JOIN tblPurchaseHistory
ON tblProduct.ProductID = tblPurchaseHistory.ProductID
INNER JOIN tblVendor
ON tblPurchaseHistory.VendorID = tblVendor.VendorID
WHERE DatePurchased = 
	(SELECT MAX(DatePurchased) 
	FROM tblPurchaseHistory
	WHERE tblProduct.ProductID = tblPurchaseHistory.ProductID)
	and
	tblPurchaseOrderLine.Price > tblPurchaseHistory.Price
ORDER BY tblProduct.ProductID, PONumber

/*Q6*/
CREATE VIEW vCountPOLine AS
SELECT DISTINCT
	VendorID,
	QtyOrdered,
	QtyReceived,
	COUNT(tblPurchaseOrderLine.POLineID) 'CountPOLineID'
FROM tblPurchaseOrderLine
LEFT JOIN tblPurchaseOrder
ON tblPurchaseOrderLine.PONumber = tblPurchaseOrder.PONumber
INNER JOIN tblReceiver
ON tblPurchaseOrderLine.POLineID = tblReceiver.POLineID
GROUP BY VendorID, QtyOrdered, QtyReceived

SELECT DISTINCT TOP 1
	tblVendor.VendorID,
	Name 'VendorName',
	Email 'VendorEmailAddress',
	CountPOLineID 
FROM tblVendor
LEFT JOIN vCountPOLine
ON tblVendor.VendorID = vCountPOLine.VendorID
WHERE CountPOLineID = (SELECT MAX([CountPOLineID]) FROM vCountPOLine)
ORDER BY tblVendor.VendorID, Name, Email

/*Q7*/
CREATE VIEW vDamagedQty AS
SELECT
	EmpID,
	Description,
	SUM(QtyReceived) 'DamagedQty'
FROM tblReceiver
LEFT JOIN tblEmployee
ON tblReceiver.ReceiveEmpID = tblEmployee.EmpID
LEFT JOIN tblCondition
ON tblReceiver.ConditionID = tblCondition.ConditionID
WHERE Description like '%damage' 
GROUP BY EmpID, Description

SELECT
	e.EmpID 'EmployeeID',
	(e.EmpLastName + ', ' + substring(e.EmpFirstName,1,1)) 'EmployeeName',
	e.EmpEmail 'empemail',
	m.EmpMgrID 'Manager EmpID',
	(m.EmpLastName + ', ' + substring(m.EmpFirstName,1,1)) 'ManagerName',
	m.EmpEmail "Manager's Email",
	[DamagedQty] "Quantity of Damaged Items Received"
FROM tblPurchaseOrder
LEFT JOIN tblEmployee e
ON tblPurchaseOrder.BuyerEmpID = e.EmpID
LEFT JOIN tblEmployee m
ON m.EmpID = e.EmpMgrID
INNER JOIN vDamagedQty
ON e.EmpID = vDamagedQty.EmpID
WHERE [DamagedQty] = (SELECT MAX([DamagedQty]) FROM vDamagedQty)
GROUP BY e.EmpID, e.EmpLastName, e.EmpFirstName, e.EmpEmail, m.EmpMgrID, 
m.EmpLastName, m.EmpFirstName, m.EmpEmail, [DamagedQty]

/*Q8*/
CREATE VIEW vPurchaseOrderLine AS
SELECT
	tblProduct.ProductID,
	ISNULL(SUM(QtyOrdered),0) 'CurrentQtyonOrder',
	ISNULL(MAX(tblPurchaseOrderLine.Price),0) 'CurrentMaxPrice',
	ISNULL(MIN(tblPurchaseOrderLine.Price),0) 'CurrentMinPrice',
	ISNULL(AVG(tblPurchaseOrderLine.Price),0) 'CurrentAvgPrice'
FROM tblPurchaseOrderLine
RIGHT JOIN tblProduct
ON tblPurchaseOrderLine.ProductID = tblProduct.ProductID
GROUP BY tblProduct.ProductID

CREATE VIEW vPurchaseHistory AS
SELECT
	tblProduct.ProductID,
	ISNULL(MAX(tblPurchaseHistory.Price),0) 'PastMaxPrice',
	ISNULL(MIN(tblPurchaseHistory.Price),0) 'PastMinPrice',
	ISNULL(AVG(tblPurchaseHistory.Price),0) 'PastAvgPrice',
	ISNULL(CONVERT(VARCHAR,DatePurchased,107), 'No Previous Purchase') 'MostRecentPastPurchaseDate',
	ISNULL(tblPurchaseHistory.Price,0) 'MostRecentPastPurchasePrice'
FROM tblPurchaseHistory
LEFT JOIN tblProduct
ON tblPurchaseHistory.ProductID = tblProduct.ProductID
WHERE DatePurchased = (SELECT MAX(DatePurchased) FROM tblPurchaseHistory)
GROUP BY tblProduct.ProductID, DatePurchased, Price

SELECT 
	tblProduct.ProductID,
	Description 'ProductDescription',
	CurrentQtyonOrder,
	CurrentMaxPrice,
	CurrentMinPrice,
	CurrentAvgPrice,
	PastMaxPrice,
	PastMinPrice,
	PastAvgPrice,
	MostRecentPastPurchaseDate,
	MostRecentPastPurchasePrice
FROM tblProduct
LEFT JOIN vPurchaseOrderLine
ON tblProduct.ProductID = vPurchaseOrderLine.ProductID
LEFT JOIN vPurchaseHistory
ON tblProduct.ProductID = vPurchaseHistory.ProductID

/*Q9*/
CREATE VIEW vMaxPrice AS
SELECT
	tblProduct.ProductID,
	MAX(tblPurchaseOrderLine.Price) 'CurrentMaxPrice',
	MAX(tblPurchaseHistory.Price) 'PastMaxPrice'
FROM tblPurchaseOrderLine
INNER JOIN tblProduct
ON tblPurchaseOrderLine.PRoductID = tblProduct.ProductID
INNER JOIN tblPurchaseHistory
ON tblProduct.ProductID = tblPurchaseHistory.ProductID
GROUP BY tblProduct.ProductID

CREATE VIEW vPercentage AS
SELECT
	tblProduct.ProductID,
	(CurrentMaxPrice - PastMaxPrice) 'PriceDifference',
	((CurrentMaxPrice - PastMaxPrice)/(PastMaxPrice)*100) 'Percentage'
FROM tblProduct
INNER JOIN vMaxPrice
ON tblProduct.ProductID = vMaxPrice.ProductID

SELECT
	tblProduct.ProductID,
	Description 'ProductDescription',
	tblPurchaseOrder.PONumber,
	PODatePlaced 'PurchaseOrderDate',
	Name 'VendorName',
	CurrentMaxPrice,
	PastMaxPrice,
	PriceDifference,
	Percentage 'PercentageIncrease'
FROM tblProduct
INNER JOIN tblPurchaseOrderLine
ON tblProduct.ProductiD = tblPurchaseOrderLine.ProductID
INNER JOIN tblPurchaseOrder
ON tblPurchaseORderLine.PONUmber = tblPurchaseOrder.PONumber
INNER JOIN tblVendor
ON tblPurchaseOrder.VendorID = tblVendor.VendorID
INNER JOIN vMaxPrice
ON tblProduct.ProductID = vMaxPrice.ProductID
INNER JOIN vPercentage
ON tblProduct.ProductID = vPercentage.ProductID
WHERE Percentage = (SELECT MAX([Percentage]) FROM vPercentage)
GROUP BY tblProduct.ProductID, Description, tblPurchaseOrder.PONumber, Name, 
CurrentMaxPrice, PastMaxPrice, PriceDifference, Percentage, pODatePlaced

/*Q10*/
CREATE VIEW vMostPurchaseOrderLine AS
SELECT
	tblProductType.ProductTypeID,
	tblProductType.Description 'ProductTypeDescription',
	SUM(QtyOrdered) 'Total'
FROM tblPurchaseOrderLine
INNER JOIN tblProduct
ON tblPurchaseOrderLine.ProductID = tblProduct.ProductID
INNER JOIN tblProductType
ON tblProduct.ProductTypeID = tblProductType.ProductTypeID
WHERE QtyOrdered = (SELECT MAX(QtyOrdered) FROM tblPurchaseOrderLine)
GROUP BY tblProductType.ProductTypeID, tblProductType.Description

CREATE VIEW vMostPurchaseHistory AS
SELECT 
	tblProductType.ProductTypeID,
	tblProductType.Description 'ProductTypeDescription',
	SUM(Price) 'Total'
FROM tblPurchaseHistory
INNER JOIN tblProduct
ON tblPurchaseHistory.ProductID = tblProduct.ProductID
INNER JOIN tblProductType
ON tblProduct.ProductTypeID = tblProductType.ProductTypeID
WHERE Price = (SELECT MAX(Price) FROM tblPurchaseHistory)
GROUP BY tblProductType.ProductTypeID, tblProductType.Description

SELECT
	ProductTypeID,
	ProductTypeDescription,
	Total
FROM vMostPurchaseHistory
UNION
SELECT
	ProductTypeID,
	ProductTypeDescription,
	Total
FROM vMostPurchaseOrderLine
