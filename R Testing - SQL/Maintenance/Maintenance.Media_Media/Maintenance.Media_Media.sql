create table Maintenance.Media_Media
(
	MaintenanceDateTime datetime2 not null
	,MediaUid uniqueidentifier not null
	,MaintenanceType char(1) not null
	,MaintenanceUser nvarchar(50) not null
	,MediaTitle_Before nvarchar(100) null
	,MediaTitle_After nvarchar(100) null
	,MediaTypeId_Before tinyint null
	,MediaTypeId_After tinyint null
	,MediaType_Before nvarchar(20) null
	,MediaType_After nvarchar(20) null
	,NetworkId_Before smallint null
	,NetworkId_After smallint null
	,NetworkName_Before nvarchar(20) null
	,NetworkName_After nvarchar(20) null 
	,ParentMediaUid_Before uniqueidentifier null
	,ParentMediaUid_After uniqueidentifier null
	,ParentMediaTitle_Before nvarchar(100) null
	,ParentMediaTitle_After nvarchar(100) null
)
