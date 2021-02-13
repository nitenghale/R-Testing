create table Reference.MediaType
(
	MediaTypeId tinyint identity(1,1) not null
	,MediaType nvarchar(20) not null
	,MediaTypeDescription nvarchar(100) null
	,LastMaintenanceDateTime datetime not null
	,LastMaintenanceUser nvarchar(50) not null
)
go

alter table Reference.MediaType add constraint PK_MediaType primary key clustered (MediaTypeId)
go

create unique nonclustered index IX_MediaType_MediaType on Reference.MediaType (MediaType) on IndexData
go

alter table Reference.MediaType add constraint DF_MediaType_LastMaintenanceDateTime default (getdate()) for LastMaintenanceDateTime
go

alter table Reference.MediaType add constraint DF_MediaType_LastMaintenanceUser default (system_user) for LastMaintenanceUser
go

grant select, insert, update, delete on Reference.MediaType to RTesting
go

create trigger Reference.MediaType_Insert
	on Reference.MediaType
	after insert
as
begin
	set nocount on

	insert into Maintenance.Reference_MediaType
	(
		MediaTypeId
		,MaintenanceType
		,MediaType_After
		,MediaTypeDescrption_After
	)
	select
		MediaTypeId
		,'I'
		,MediaType
		,MediaTypeDescription
	from inserted
end
go

create trigger Reference.MediaType_Update
	on Reference.MediaType
	after update
as
begin
	set nocount on

	insert into Maintenance.Reference_MediaType
	(
		MediaTypeId
		,MaintenanceType
		,MediaType_Before
		,MediaType_After
		,MediaTypeDescription_Before
		,MediaTypeDescrption_After
	)
	select
		deleted.MediaTypeId
		,'U'
		,deleted.MediaType
		,inserted.MediaType
		,deleted.MediaTypeDescription
		,inserted.MediaTypeDescription
	from deleted
		left join inserted
			on deleted.MediaTypeId = inserted.MediaTypeId
end
go

create trigger Reference.MediaType_Delete
	on Reference.MediaType
	after delete
as
begin
	set nocount on

	insert into Maintenance.Reference_MediaType
	(
		MediaTypeId
		,MaintenanceType
		,MediaType_Before
		,MediaTypeDescription_Before
	)
	select
		MediaTypeId
		,'D'
		,MediaType
		,MediaTypeDescription
	from deleted
end
go
