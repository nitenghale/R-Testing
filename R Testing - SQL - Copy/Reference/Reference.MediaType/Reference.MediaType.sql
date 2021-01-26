create table Reference.MediaType
(
	MediaTypeId tinyint identity(1,1) not null
	,MediaType nvarchar(20) not null
	,MediaTypeDescription nvarchar(100) null
	,LastMaintenanceDateTime datetime not null
	,LastMaintenanceUser nvarchar(50) not null
)