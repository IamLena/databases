use screenshots
go

BULK INSERT Device 
FROM 'C:\sem_05\DB\screenshots\data\device.txt'
WITH (
	DATAFILETYPE = 'char',
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n');
GO


BULK INSERT Os 
FROM 'C:\sem_05\DB\screenshots\data\os.txt'
WITH (
	DATAFILETYPE = 'char',
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n');
GO

BULK INSERT Master 
FROM 'C:\sem_05\DB\screenshots\data\master.txt'
WITH (
	DATAFILETYPE = 'char',
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n');
GO

BULK INSERT OsDeviceMaster
FROM 'C:\sem_05\DB\screenshots\data\odm.txt'
WITH (
	DATAFILETYPE = 'char',
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n');
GO

BULK INSERT Size
FROM 'C:\sem_05\DB\screenshots\data\size1.txt'
WITH (
	DATAFILETYPE = 'char',
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n');
GO

BULK INSERT Langs
FROM 'C:\sem_05\DB\screenshots\data\langs.txt'
WITH (
	DATAFILETYPE = 'char',
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n');
GO

BULK INSERT ScreenShot
FROM 'C:\sem_05\DB\screenshots\data\screenshot.txt'
WITH (
	DATAFILETYPE = 'char',
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n');
GO

BULK INSERT Designer
FROM 'C:\sem_05\DB\screenshots\data\designer.txt'
WITH (
	DATAFILETYPE = 'char',
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n');
GO