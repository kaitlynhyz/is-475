CREATE TABLE tblVendor
(
VendorID	CHAR(5) PRIMARY KEY NOT NULL,
Name	VARCHAR(30) NOT NULL,
Address1	VARCHAR(30) NOT NULL,
Address2	VARCHAR(30),
City	VARCHAR(20) NOT NULL,
State	CHAR(2)	 NOT NULL,
Zip	VARCHAR(12) NOT NULL,
Email	VARCHAR(30),
Contact	VARCHAR(30),
Phone	CHAR(15) NOT NULL,
FirstBuyDate	DATETIME NOT NULL
);

CREATE TABLE tblEmployee
(
EmpID	CHAR(6) PRIMARY KEY NOT NULL,
EmpLastName	VARCHAR(30) NOT NULL,
EmpFirstName	VARCHAR(30) NOT NULL,
EmpEmail	VARCHAR(30),
EmpPhone	CHAR(15) NOT NULL,
EmpMgrID	CHAR(6) FOREIGN KEY REFERENCES tblEmployee (EmpID)
);

CREATE TABLE tblCondition
(
ConditionID	CHAR(2) PRIMARY KEY NOT NULL,
Description	VARCHAR(30) NOT NULL
);

CREATE TABLE tblPurchaseOrder
(
PONumber	CHAR(6) PRIMARY KEY NOT NULL,
PODatePlaced	DATETIME NOT NULL,
PODateNeeded	DATETIME,
Terms	VARCHAR(15),
Conditions	VARCHAR(15),
BuyerEmpID	CHAR(6) FOREIGN KEY REFERENCES tblEmployee (EmpID),
VendorID	CHAR(5) FOREIGN KEY REFERENCES tblVendor (VendorID) NOT NULL
);

CREATE TABLE tblProductType
(
ProductTypeID	CHAR(2) PRIMARY KEY NOT NULL,
Description	VARCHAR(30) NOT NULL
);

CREATE TABLE tblProduct
(
ProductID	CHAR(5) PRIMARY KEY NOT NULL,
Description	VARCHAR(30) NOT NULL,
UOM	CHAR(10) CHECK (UOM IN('each', 'feet', 'inches', 'meters', 'cm', 'sheet', 'case')),
EOQ DECIMAL(6,2),
QOH	DECIMAL(8,2) NOT NULL,
QOHDateUpdated	DATETIME,
ProductTypeID	CHAR(2) FOREIGN KEY REFERENCES tblProductType (ProductTypeID) NOT NULL
);

CREATE TABLE tblPurchaseOrderLine
(
POLineID	INT PRIMARY KEY NOT NULL,
PONumber	CHAR(6) FOREIGN KEY REFERENCES tblPurchaseOrder (PONumber) NOT NULL,
ProductID	CHAR(5) FOREIGN KEY REFERENCES tblProduct (ProductID) NOT NULL,
QtyOrdered	DECIMAL(6,2)
	CHECK (QtyOrdered > 0),
Price	MONEY NOT NULL,
DateNeeded	DATETIME NOT NULL
);

CREATE TABLE tblReceiver
(
ReceiverID	INT IDENTITY(1,1) PRIMARY KEY,
DateReceived	DATETIME NOT NULL,
QtyReceived	DECIMAL(6,2)
	CHECK (QtyReceived > 0),
ConditionID	CHAR(2) FOREIGN KEY REFERENCES tblCondition (ConditionID) NOT NULL,
ReceiveEmpID	CHAR(6) FOREIGN KEY REFERENCES tblEmployee (EmpID),
POLineID	INT FOREIGN KEY REFERENCES tblPurchaseOrderLine (POLineID)
);

CREATE TABLE tblPurchaseHistory
(
HistoryID	INT IDENTITY(1,1) PRIMARY KEY,
ProductID	CHAR(5) FOREIGN KEY REFERENCES tblProduct (ProductID) NOT NULL,
DatePurchased	DATETIME NOT NULL,
Qty	DECIMAL(8,2) NOT NULL,
Price	MONEY NOT NULL,
QtyReceivedOnTime	DECIMAL(8,2),
VendorID	CHAR(5) FOREIGN KEY REFERENCES tblVendor (VendorID)
);
