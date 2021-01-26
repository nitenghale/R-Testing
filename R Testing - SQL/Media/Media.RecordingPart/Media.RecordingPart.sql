CREATE TABLE [Media].[RecordingPart]
(
	RecordingPartId int identity(1,1) not null
	,RecordingId smallint not null
	,RecordingSequence tinyint not null
	,StartTime time null
	,EndTime time null
	,LastMaintenanceDateTime datetime not null
	,LastMaintenanceUser nvarchar(50) not null
)
