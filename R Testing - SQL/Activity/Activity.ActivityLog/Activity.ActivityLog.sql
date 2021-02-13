create table Activity.ActivityLog
(
	ActivityDateTime datetime2(7) not null
	,ActivitySequence tinyint not null
	,ActivityUser nvarchar(50) not null
	,ObjectName varchar(150) not null
	,ObjectParameters nvarchar(max) null
)
go

alter table Activity.ActivityLog add constraint PK_ActivityLog primary key clustered (ActivityDateTime, ActivitySequence)
go

create nonclustered index IX_ActivityLog_ObjectName on Activity.ActivityLog (ObjectName, ActivityDateTime) on IndexData
go

alter table Activity.ActivityLog add constraint DF_ActivityLog_ActivityDateTime default (getdate()) for ActivityDateTime
go

alter table Activity.ActivityLog add constraint DF_ActivityLog_ActivityUser default (system_user) for ActivityUser
go

grant select, insert on Activity.ActivityLog to RTesting
go

deny update, delete on Activity.ActivityLog to RTesting
go
