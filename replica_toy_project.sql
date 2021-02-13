/*Q1*/
SELECT
	ReportID,
	ReportDate,
	CompleteDate,
	ProblemDescription,
	xTest.TestID,
	TestDate
FROM xReport
LEFT JOIN xTest
ON xTest.TestID = xReport.TestID
LEFT JOIN xProblemReport
ON xProblemReport.ProblemReportReportID = xReport.ReportID
WHERE TestDate < ReportDate
ORDER BY ReportID 

/*Q2*/
CREATE VIEW TypeInjury AS
SELECT DISTINCT
	ProblemTypeID,
	COUNT(InjuryYN) 'CountOfInjuryReports'
FROM xReport
LEFT JOIN xType
ON xType.ProblemTypeID = xReport.ProblemReportProblemTypeID
WHERE InjuryYN = 'Yes'
GROUP BY ProblemTypeID

SELECT
	xType.ProblemTypeID,
	TypeDescription,
	COUNT(ProblemReportProblemTypeID) 'CountOfReports',
	ISNULL(CountOfInjuryReports, 0) 'CountOfInjuryReports'
FROM xType
LEFT JOIN xReport
ON xReport.ProblemReportProblemTypeID = xType.ProblemTypeID
LEFT JOIN TypeInjury
ON TypeInjury.ProblemTypeID = xType.ProblemTypeID
GROUP BY xType.ProblemTypeID, TypeDescription, CountOfInjuryReports
ORDER BY xType.ProblemTypeID

/*Q3*/
CREATE VIEW ReporterInfo AS
SELECT DISTINCT
	ReporterID,
	(LastName + ', ' + substring(FirstName,1,1) + '.') 'ReporterName',
	PersonType 'ReporterType'
FROM xReport
INNER JOIN xPerson
ON xPerson.PersonID = xReport.ReporterID

SELECT DISTINCT
	CONVERT(VARCHAR, ReportDate, 107) 'ReportDateOutput',
	ReportID,
	ProblemReportSerialNumber,
	ISNULL(CONVERT(VARCHAR, CompleteDate, 107), 'Not Complete') 'CompleteDate',
	DATEDIFF(day, ReportDate, GETDATE()) 'DaysInSystem',
	ModelNumber 'Model#',
	ModelName,
	ReporterName,
	ReporterType,
	TypeDescription
FROM xReport
LEFT JOIN xToy
ON xToy.SerialNumber = xReport.ProblemReportSerialNumber
LEFT JOIN xModel
ON xModel.ModelNumber = xToy.ToyModelNumber
LEFT JOIN xType
ON xType.ProblemTypeID = xReport.ProblemReportProblemTypeID
LEFT JOIN ReporterInfo
ON ReporterInfo.ReporterID = xReport.ReporterID
WHERE MONTH(ReportDate) = 10 and YEAR(ReportDate) = Year(GETDATE())

/*Q4*/
CREATE VIEW TesterInfo AS
SELECT DISTINCT
	xPerson.PersonID,
	(LastName + ', ' + substring(FirstName,1,1)) 'TesterName'
FROM xPerson
LEFT JOIN xTester
ON xPerson.PersonID = xTester.PersonID


SELECT DISTINCT
	CONVERT(VARCHAR, ReportDate, 107) 'ReportDateOutput',
	ReportID,
	ProblemReportSerialNumber 'Serial#',
	ISNULL(CONVERT(VARCHAR, CompleteDate, 107), 'Not Complete') 'CompleteDate',
	DATEDIFF(day, ReportDate, GETDATE()) 'DaysInSystem',
	ModelNumber 'Model#',
	ModelName,
	ReporterName,
	ReporterType,
	CONVERT(VARCHAR, TestDate, 107) 'TestDate',
	TestDescription,
	TesterName,
	TestComplete
FROM xReport
LEFT JOIN xToy
ON xToy.SerialNumber = xReport.ProblemReportSerialNumber
LEFT JOIN xModel
ON xModel.ModelNumber = xToy.ToyModelNumber
LEFT JOIN ReporterInfo
ON ReporterInfo.ReporterID = xReport.ReporterID
LEFT JOIN xTest
ON xTest.TestID = xReport.TestID
LEFT JOIN xTester
ON xTester.TestID = xTest.TestID
LEFT JOIN TesterInfo
ON xTester.PersonID = TesterInfo.PersonID
WHERE MONTH(ReportDate) = 10 and YEAR(ReportDate) = Year(GETDATE())

/*Q5*/
SELECT 
	ReportID,
	CONVERT(VARCHAR, ReportDate, 107) 'ReportDateOutput',
	ProblemReportSerialNumber 'Serial#',
	ISNULL(CONVERT(VARCHAR, CompleteDate, 107), 'Not Complete') 'CompleteDate',
	DATEDIFF(day, ReportDate, GETDATE()) 'DaysInSystem',
	ModelNumber 'Model#',
	ModelName,
	ReporterName,
	ReporterType,
	COUNT(TestID) 'CountOfTests'
FROM xReport
LEFT JOIN xToy
ON xToy.SerialNumber = xReport.ProblemReportSerialNumber
LEFT JOIN xModel
ON xModel.ModelNumber = xToy.ToyModelNumber
LEFT JOIN ReporterInfo
ON ReporterInfo.ReporterID = xReport.ReporterID
WHERE ReportID IS NOT NULL
GROUP BY 
	ReportID,
	ReportDate,
	ProblemReportSerialNumber,
	CompleteDate,
	ModelNumber,
	ModelName,
	ReporterName,
	ReporterType

/*Q6*/
CREATE VIEW TestCount AS
SELECT
	ReportID,
	COUNT(xTest.TestID) 'CountOfTests'
FROM xTest
LEFT JOIN xReport
ON xReport.TestID = xTest.TestID
GROUP BY ReportID

SELECT DISTINCT
	xReport.ReportID,
	CONVERT(VARCHAR, ReportDate, 107) 'ReportDateOutput',
	ProblemReportSerialNumber 'Serial#',
	ISNULL(CONVERT(VARCHAR, CompleteDate, 107), 'Not Complete') 'CompleteDate',
	DATEDIFF(day, ReportDate, GETDATE()) 'DaysInSystem',
	ModelNumber 'Model#',
	ModelName,
	ReporterName,
	ReporterType,
	CountOfTests
FROM xReport
LEFT JOIN xToy
ON xToy.SerialNumber = xReport.ProblemReportSerialNumber
LEFT JOIN xModel
ON xModel.ModelNumber = xToy.ToyModelNumber
LEFT JOIN ReporterInfo
ON ReporterInfo.ReporterID = xReport.ReporterID
LEFT JOIN TestCount
ON TestCount.ReportID = xReport.ReportID
WHERE 
	xReport.ReportID IS NOT NULL and 
	CompleteDate IS NULL and
	CountOfTests = (SELECT MAX(CountOfTests) FROM TestCount)
ORDER BY ModelName DESC

/*Q7*/
CREATE VIEW ModelTestCount AS
SELECT 
	ModelNumber,
	COUNT(TestID) 'CountOfTests'
FROM xReport
LEFT JOIN xToy
ON xToy.SerialNumber = xReport.ProblemReportSerialNumber
LEFT JOIN xModel
ON xModel.ModelNumber = xToy.ToyModelNumber
GROUP BY ModelNumber

CREATE VIEW ModelInjuryCount AS
SELECT
	ModelNumber,
	COUNT(InjuryYN) 'CountofInjuryReports'
FROM xReport
LEFT JOIN xToy
ON xToy.SerialNumber = xReport.ProblemReportSerialNumber
LEFT JOIN xModel
ON xModel.ModelNumber = xToy.ToyModelNumber
WHERE InjuryYN = 'Yes'
GROUP BY ModelNumber

CREATE VIEW ModelReportCount AS
SELECT DISTINCT
	ModelNumber,
	COUNT(ReportID) 'CountOfReports',
	CONVERT(VARCHAR, ReportDate, 107) 'vReportDate'
FROM xReport
LEFT JOIN xToy
ON xToy.SerialNumber = xReport.ProblemReportSerialNumber
LEFT JOIN xModel
ON xModel.ModelNumber = xToy.ToyModelNumber
GROUP BY ModelNumber, ReportDate

SELECT DISTINCT
	xModel.ModelNumber,
	ModelDescription,
	ISNULL(CountOfReports, 0) 'CountOfReports',
	ISNULL(CountofInjuryReports, 0) 'CountofInjuryReports',
	ISNULL(CONVERT(VARCHAR, ReportDate, 107), 'n/a') 'MostRecentReportDate',
	ISNULL(CONVERT(VARCHAR, ReportDate, 107), 'n/a') 'EarliestReportDate',
	ISNULL(CountOfTests, 0) 'CountOfTests',
	ISNULL(CONVERT(VARCHAR, TestDate, 107), 'n/a') 'MostRecentTestDate',
	ISNULL(CONVERT(VARCHAR, TestDate, 107), 'n/a') 'EarliestTestDate'
FROM xModel
LEFT JOIN xToy
ON xToy.ToyModelNumber = xModel.ModelNumber
LEFT JOIN xReport
ON xReport.ProblemReportSerialNumber = xToy.SerialNumber
LEFT JOIN ModelTestCount
ON ModelTestCount.ModelNumber = xModel.ModelNumber
LEFT JOIN ModelInjuryCount
ON ModelInjuryCount.ModelNumber = xModel.ModelNumber
LEFT JOIN ModelReportCount
ON ModelReportCount.ModelNumber = xModel.ModelNumber
LEFT JOIN xTest
ON xTest.TestID = xReport.TestID
ORDER BY xModel.ModelNumber
