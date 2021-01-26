create table Reference.MediaAttributeType
(
	MediaAttributeTypeId smallint identity(1,1) not null
	,MediaAttributeType nvarchar(20) not null
	,MediaAttributeDescription nvarchar(100) null
	,MediaAttributeRepeatable bit not null
	,LastMaintenanceDateTime datetime not null
	,LastMaintenanceUser nvarchar(50) not null
)