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
go

alter table Media.RecordingPart add constraint PK_RecordingPart primary key clustered (RecordingPartId)
go

alter table Media.RecordingPart add constraint FK_RecordingPart_Recording foreign key (RecordingId) references Media.Recording (RecordingId)
go

grant select, insert, update, delete on Media.RecordingPart to RTesting
go
