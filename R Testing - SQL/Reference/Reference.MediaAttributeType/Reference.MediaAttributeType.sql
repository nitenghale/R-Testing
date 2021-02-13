create table Reference.MediaAttributeType
(
	MediaAttributeTypeId smallint identity(1,1) not null
	,MediaAttributeType nvarchar(20) not null
	,MediaAttributeDescription nvarchar(100) null
	,MediaAttributeRepeatable bit not null
	,LastMaintenanceDateTime datetime not null
	,LastMaintenanceUser nvarchar(50) not null
)
go

alter table Reference.MediaAttributeType add constraint PK_MediaAttributeType primary key clustered (MediaAttributeTypeId)
go

alter table Reference.MediaAttributeType add constraint DF_MediaAttributeType_LastMaintenanceDateTime default (getdate()) for LastMaintenanceDateTime
go

alter table Reference.MediaAttributeType add constraint DF_MediaAttributeType_LastMaintenanceUser default (system_user) for LastMaintenanceUser
go

grant select, insert, update, delete on Reference.MediaAttributeType to RTesting
go

create trigger Reference.MediaAttributeType_Insert
	on Reference.MediaAttributeType
	after insert
as
begin
	set nocount on

	insert into Maintenance.Reference_MediaAttributeType
	(
		MediaAttributeTypeId
		,MaintenanceType
		,MediaAttributeType_After
		,MediaAttributeDescription_After
		,MediaAttributeRepeatable_After
	)
	select
		MediaAttributeTypeId
		,'I'
		,MediaAttributeType
		,MediaAttributeDescription
		,MediaAttributeRepeatable
	from inserted
end
go

create trigger Reference.MediaAttributeType_Update
	on Reference.MediaAttributeType
	after update
as
begin
	set nocount on

	insert into Maintenance.Reference_MediaAttributeType
	(
		MediaAttributeTypeId
		,MaintenanceType
		,MediaAttributeType_Before
		,MediaAttributeType_After
		,MediaAttributeDescription_Before
		,MediaAttributeDescription_After
		,MediaAttributeRepeatable_Before
		,MediaAttributeRepeatable_After
	)
	select
		deleted.MediaAttributeTypeId
		,'U'
		,deleted.MediaAttributeType
		,inserted.MediaAttributeType
		,deleted.MediaAttributeDescription
		,inserted.MediaAttributeDescription
		,deleted.MediaAttributeRepeatable
		,inserted.MediaAttributeRepeatable
	from deleted
		left join inserted
			on deleted.MediaAttributeTypeId = inserted.MediaAttributeTypeId
end
go

create trigger Reference.MediaAttributeType_Delete
	on Reference.MediaAttributeType
	after delete
as
begin
	set nocount on

	insert into Maintenance.Reference_MediaAttributeType
	(
		MediaAttributeTypeId
		,MaintenanceType
		,MediaAttributeType_Before
		,MediaAttributeDescription_Before
		,MediaAttributeRepeatable_Before
	)
	select
		MediaAttributeTypeId
		,'D'
		,MediaAttributeType
		,MediaAttributeDescription
		,MediaAttributeRepeatable
	from deleted
end
go
