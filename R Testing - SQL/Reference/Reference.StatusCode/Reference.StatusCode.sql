create table Reference.StatusCode
(
	StatusCodeId tinyint identity(1,1) not null
	,StatusCode nvarchar(20) not null
	,StatusDescription nvarchar(100) null
	,LastMaintenanceDateTime datetime not null
	,LastMaintenanceUser nvarchar(50) not null
)
go

alter table Reference.StatusCode add constraint PK_StatusCode primary key clustered (StatusCodeId)
go

create unique nonclustered index IX_StatusCode_StatusCode on Reference.StatusCode (StatusCode) on IndexData
go

alter table Reference.StatusCode add constraint DF_StatusCode_LastMaintenanceDateTime default (getdate()) for LastMaintenanceDateTime
go

alter table Reference.StatusCode add constraint DF_StatusCode_LastMaintenanceUser default (system_user) for LastMaintenanceUser
go

grant select, insert, update, delete on Reference.StatusCode to RTesting
go

create trigger Reference.StatusCode_Insert
	on Reference.StatusCode
	after insert
as
begin
	set nocount on

	insert into Maintenance.Reference_StatusCode
	(
		StatusCodeId
		,MaintenanceType
		,StatusCode_After
		,StatusDescription_After
	)
	select
		StatusCodeId
		,'I'
		,StatusCode
		,StatusDescription
	from inserted
end
go

create trigger Reference.StatusCode_Update
	on Reference.StatusCode
	after update
as
begin
	set nocount on

	insert Maintenance.Reference_StatusCode
	(
		StatusCodeId
		,MaintenanceType
		,StatusCode_Before
		,StatusCode_After
		,StatusDescription_Before
		,StatusDescription_After
	)
	select
		deleted.StatusCodeId
		,'U'
		,deleted.StatusCode
		,inserted.StatusCode
		,deleted.StatusDescription
		,inserted.StatusDescription
	from deleted
		left join inserted
			on deleted.StatusCodeId = inserted.StatusCodeId
end
go

create trigger Reference.StatusCode_Delete
	on Reference.StatusCode
	after delete
as
begin
	set nocount on

	insert into Maintenance.Reference_StatusCode
	(
		StatusCodeId
		,MaintenanceType
		,StatusCode_Before
		,StatusDescription_Before
	)
	select
		StatusCodeId
		,'D'
		,StatusCode
		,StatusDescription
	from deleted
end
go
