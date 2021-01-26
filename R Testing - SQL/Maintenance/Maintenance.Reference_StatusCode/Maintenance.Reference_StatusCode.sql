create table Maintenance.Reference_StatusCode
(
	MaintenanceDateTime datetime2 not null
	,StatusCodeId tinyint not null
	,MaintenanceType char(1) not null
	,MaintenanceUser nvarchar(50) not null
	,StatusCode_Before nvarchar(20) null
	,StatusCode_After nvarchar(20) null
	,StatusDescription_Before nvarchar(100) null
	,StatusDescription_After nvarchar(100) null
)
