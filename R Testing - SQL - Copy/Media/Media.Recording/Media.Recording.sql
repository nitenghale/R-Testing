create table Media.Recording
(
	RecordingId smallint identity(1,1) not null
	,RecordingDateTime datetime not null
	,MediaUid uniqueidentifier not null
	,StatusCodeId tinyint not null
	,LastMaintenanceDateTime datetime not null
	,LastMaintenanceUser nvarchar(50) not null
)