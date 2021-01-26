create table Maintenance.Media_MediaAttribute
(
	MaintenanceDateTime datetime2 not null
	,MediaAttributeId bigint not null
	,MaintenanceType char(1) not null
	,MaintenanceUser nvarchar(50) not null
	,MediaUid_Before uniqueidentifier null
	,MediaUid_After uniqueidentifier null
	,MediaTitle_Before nvarchar(100) null
	,MediaTitle_After nvarchar(100) null
	,MediaAttributeTypeId_Before smallint null
	,MediaAttributeTypeId_After smallint null
	,MediaAttributeType_Before nvarchar(20) null
	,MediaAttributeType_After nvarchar(20) null
	,MediaAttributeValue_Before nvarchar(max) null
	,MediaAttributeValue_After nvarchar(max) null
)
