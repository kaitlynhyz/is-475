# Replica Toy Project
:speech_balloon: The two objectives to this project are to __design a database__ to support the requested operations of the company and __create a prototype__ to test the design.

## Database Design
![ERD Diagram](images/project_erd.png)


## Prototype Database Creation
### 1. **Person**
```
CREATE TABLE xPerson
(
	PersonID	INT PRIMARY KEY NOT NULL,
	LastName	VARCHAR(100) NOT NULL,
	FirstName	VARCHAR(100) NOT NULL,
	phone	CHAR(20) NOT NULL,
	PersonType	VARCHAR(3) NOT NULL
)
```
![Person Table](images/xPerson.PNG)
### 2. **Model**
```
CREATE TABLE xModel
(
	ModelNumber	VARCHAR(30) PRIMARY KEY NOT NULL,
	ModelName	VARCHAR(100) NOT NULL,
	ModelDescription	VARCHAR(100) NOT NULL,
	StandardPrice	MONEY
)
```
![Model Table](images/xModel.PNG)
### 3. **Type**
```
CREATE TABLE xType
(
	ProblemTypeID	INT PRIMARY KEY NOT NULL,
	TypeDescription	VARCHAR(100) NOT NULL
)
```
![Type Table](images/xType.PNG)
### 4. **Toy**
```
CREATE TABLE xToy
(
	SerialNumber	VARCHAR(30) PRIMARY KEY NOT NULL,
	ToyModelNumber	VARCHAR(30) FOREIGN KEY REFERENCES xModel(ModelNumber) NOT NULL,
	PricePaid	MONEY NOT NULL
)
```
![Toy Table](images/xToy.PNG)
### 5. **Problem Report**
```
CREATE TABLE xProblemReport
(
	ProblemReportReportID VARCHAR(30) PRIMARY KEY NOT NULL,
	ProblemDescription	VARCHAR(100) NOT NULL
)
```
![Problem Report Table](images/xProblemReport.PNG)
### 6. **Test**
```
CREATE TABLE xTest
(
	TestID	INT PRIMARY KEY NOT NULL,
	TestDate	DATETIME NOT NULL,
	TestDescription VARCHAR(100) NOT NULL,
	TestResults	VARCHAR(100) NOT NULL,
	TestComplete CHAR(3) NOT NULL
)
```
![Test Table](images/xTest.PNG)
### 7. **Tester**
```
CREATE TABLE xTester
(
	TesterID	INT PRIMARY KEY NOT NULL,
	RelatedTestID	INT,
	PersonID	INT FOREIGN KEY REFERENCES xPerson (PersonID) NOT NULL,
	TestID	INT FOREIGN KEY REFERENCES xTest (TestID)	NOT NULL
)
```
![Tester Table](images/xTester.PNG)
### 8. **Owner**
```
CREATE TABLE xOwner
(
	OwnerID INT PRIMARY KEY NOT NULL,
	PersonID	INT FOREIGN KEY REFERENCES xPerson (PersonID) NOT NULL,
	SerialNumber	INT FOREIGN KEY REFERENCES xToy (SerialNumber) NOT NULL
)
```
![Owner Table](images/xOwner.PNG)
### 10. **Report**
```
CREATE TABLE xReport
(
	ReportDate	DATETIME NOT NULL,
	ReportID	INT FOREIGN KEY REFERENCES xProblemReport (ProblemReportReportID) NOT NULL,
	ProblemReportSerialNumber	INT FOREIGN KEY REFERENCES xToy (SerialNumber) NOT NULL,
	ProblemReportProblemTypeID	INT FOREIGN KEY REFERENCES xType (ProblemTypeID) NOT NULL,
	ReporterID	INT FOREIGN KEY REFERENCES xPerson (PersonID) NOT NULL,
	CompleteDate	DATETIME,
	InjuryYN	CHAR(3) NOT NULL,
	InjuryDescription	VARCHAR(100),
	TestID	INT FOREIGN KEY REFERENCES xTest (TestID) NOT NULL
)
```
![Report Table](images/xReport.PNG)

## SQL Queries
:point_right: [View the queries here!](https://github.com/kaitlynhyz/is-475/blob/main/replica_toy_project.sql)
