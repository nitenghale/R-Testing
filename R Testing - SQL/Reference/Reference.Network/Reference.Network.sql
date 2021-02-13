create table Reference.Network
(
	NetworkId smallint identity(1,1) not null
	,NetworkAbbreviation nvarchar(10) null
	,NetworkName nvarchar(50) null
	,ChannelNumber decimal(7, 2) null
	,LastMaintenanceDateTime datetime not null
	,LastMaintenanceUser nvarchar(50) not null
)
go

alter table Reference.Network add constraint PK_Network primary key clustered (NetworkId)
go

create unique nonclustered index IX_Network_NetworkName on Reference.Network (NetworkName, ChannelNumber) on IndexData
go

alter table Reference.Network add constraint DF_Network_LastMaintenanceDateTime default (getdate()) for LastMaintenanceDateTime
go

alter table Reference.Network add constraint DF_Network_LastMaintenanceUser default (system_user) for LastMaintenanceUser
go

grant select, insert, update, delete on Reference.Network to RTesting
go

create trigger Reference.Network_Insert
	on Reference.Network
	after insert
as
begin
	set nocount on

	insert into Maintenance.Reference_Network
	(
		NetworkId
		,MaintenanceType
		,NetworkAbbreviation_After
		,NetworkName_After
		,ChannelNumber_After
	)
	select
		NetworkId
		,'I'
		,NetworkAbbreviation
		,NetworkName
		,ChannelNumber
	from inserted
end
go

create trigger Reference.Network_Update
	on Reference.Network
	after update
as
begin
	set nocount on

	insert into Maintenance.Reference_Network
	(
		NetworkId
		,MaintenanceType
		,NetworkAbbreviation_Before
		,NetworkAbbreviation_After
		,NetworkName_Before
		,NetworkName_After
		,ChannelNumber_Before
		,ChannelNumber_After
	)
	select
		deleted.NetworkId
		,'U'
		,deleted.NetworkAbbreviation
		,inserted.NetworkAbbreviation
		,deleted.NetworkName
		,inserted.NetworkName
		,deleted.ChannelNumber
		,inserted.ChannelNumber
	from deleted
		left join inserted
			on deleted.NetworkId = inserted.NetworkId
end
go

create trigger Reference.Network_Delete
	on Reference.Network
	after delete
as
begin
	set nocount on

	insert into Maintenance.Reference_Network
	(
		NetworkId
		,MaintenanceType
		,NetworkAbbreviation_Before
		,NetworkName_Before
		,ChannelNumber_Before
	)
	select
		NetworkId
		,'D'
		,NetworkAbbreviation
		,NetworkName
		,ChannelNumber
	from deleted
end
go
