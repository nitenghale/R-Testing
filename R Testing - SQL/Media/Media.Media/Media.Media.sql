create table Media.Media
(
	MediaUid uniqueidentifier not null
	,MediaTitle nvarchar(100) not null
	,MediaTypeId tinyint not null
	,NetworkId smallint null
	,ParentMediaUid uniqueidentifier null
	,AddDateTime datetime2 not null
	,LastMaintenanceDateTime datetime not null
	,LastMaintenanceUser nvarchar(50) not null
)
