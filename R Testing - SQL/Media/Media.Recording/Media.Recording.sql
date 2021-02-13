create table Media.Recording
(
	RecordingId smallint identity(1,1) not null
	,RecordingDateTime datetime not null
	,MediaUid uniqueidentifier not null
	,StatusCodeId tinyint not null
	,LastMaintenanceDateTime datetime not null
	,LastMaintenanceUser nvarchar(50) not null
)
go

alter table Media.Recording add constraint PK_Recording primary key clustered (RecordingId)
go

alter table Media.Recording add constraint FK_Recording_StatusCode foreign key (StatusCodeId) references Reference.StatusCode (StatusCodeId)
go

grant select, insert, update, delete on Media.Recording to RTesting
go
