create table Reference.StatusCode
(
	StatusCodeId tinyint identity(1,1) not null
	,StatusCode nvarchar(20) not null
	,StatusDescription nvarchar(100) null
	,LastMaintenanceDateTime datetime not null
	,LastMaintenanceUser nvarchar(50) not null
)