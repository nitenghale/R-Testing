/*
Do not change the database path or name variables.
Any sqlcmd variables will be properly substituted during 
build and deployment.
*/
ALTER DATABASE [$(DatabaseName)]
	ADD FILEGROUP [IndexData]
GO

ALTER DATABASE [$(DatabaseName)]
ADD FILE
(
    NAME = 'IndexData',
    FILENAME = 'C:\SQL\Indexes\RTesting_IndexData.ndf',
    SIZE = 5MB,
    MAXSIZE = 1024MB,
    FILEGROWTH = 5MB
)
TO FILEGROUP IndexData
GO
