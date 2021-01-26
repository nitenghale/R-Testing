create table Maintenance.Reference_MediaType
(
	MaintenanceDateTime datetime2 not null
	,MediaTypeId tinyint not null
	,MaintenanceType char(1) not null
	,MaintenanceUser nvarchar(50) not null
	,MediaType_Before nvarchar(20) null
	,MediaType_After nvarchar(20) null
	,MediaTypeDescription_Before nvarchar(100) null
	,MediaTypeDescrption_After nvarchar(100) null
)