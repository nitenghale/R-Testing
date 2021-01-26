create table Media.MediaAttribute
(
	MediaAttributeId bigint identity(1,1) not null
	,MediaUid uniqueidentifier not null
	,MediaAttributeTypeId smallint not null
	,MediaAttributeValue nvarchar(max) not null
	,LastMaintenanceDateTime datetime not null
	,LastMaintenanceUser nvarchar(50) not null
)