create table Media.Series
(
	SeriesUid uniqueidentifier not null
	,SeriesTitle nvarchar(100) not null
	,SeriesYear smallint not null
	,NetworkId smallint not null
	,SeriesDescription nvarchar(max) null
	,AddDateTime datetime2 not null
	,LastMaintenanceDateTime datetime not null
	,LastMaintenanceUser nvarchar(50) not null
)
go

alter table Media.Series add constraint PK_Series primary key nonclustered (SeriesUid)
go

create unique clustered index IX_Series_AddDateTime on Media.Series (AddDateTime, SeriesUid)
go

create unique nonclustered index IX_Series_SeriesTitle_SeriesYear on Media.Series (SeriesTitle, SeriesYear) on IndexData
go

alter table Media.Series add constraint FK_Series_Network foreign key (NetworkId) references Reference.Network (NetworkId)
go

alter table Media.Series add constraint DF_Series_SeriesUid default (newid()) for SeriesUid
go

alter table Media.Series add constraint DF_Series_AddDateTime default (getdate()) for AddDateTime
go

alter table Media.Series add constraint DF_Series_LastMaintenanceDateTime default (getdate()) for LastMaintenanceDateTime
go

alter table Media.Series add constraint DF_Series_LastMaintenanceUser default (system_user) for LastMaintenanceUser
go

grant select, insert, update, delete on Media.Series to RTesting
go

create trigger Media.Series_Insert
	on Media.Series
	after insert
as
begin
	set nocount on

	insert into Maintenance.Media_Series
	(
		SeriesUid
		,MaintenanceType
		,SeriesTitle_After
		,SeriesYear_After
		,NetworkId_After
		,NetworkName_After
		,SeriesDescription_After
	)
	select
		SeriesUid
		,'I'
		,SeriesTitle
		,SeriesYear
		,inserted.NetworkId
		,NetworkName
		,SeriesDescription
	from inserted
		left join Reference.Network
			on inserted.NetworkId = Network.NetworkId
end
go

create trigger Media.Series_Update
	on Media.Series
	after update
as
begin
	set nocount on

	insert into Maintenance.Media_Series
	(
		SeriesUid
		,MaintenanceType
		,SeriesTitle_Before
		,SeriesTitle_After
		,SeriesYear_Before
		,SeriesYear_After
		,NetworkId_Before
		,NetworkId_After
		,NetworkName_Before
		,NetworkName_After
		,SeriesDescription_Before
		,SeriesDescription_After
	)
	select
		deleted.SeriesUid
		,'U'
		,deleted.SeriesTitle
		,inserted.SeriesTitle
		,deleted.SeriesYear
		,inserted.SeriesYear
		,deleted.NetworkId
		,inserted.NetworkId
		,Network_deleted.NetworkName
		,Network_inserted.NetworkName
		,deleted.SeriesDescription
		,inserted.SeriesDescription
	from deleted
		left join Reference.Network as Network_deleted
			on deleted.NetworkId = Network_deleted.NetworkId
		left join inserted
			on deleted.SeriesUid = inserted.SeriesUid
		left join Reference.Network as Network_inserted
			on inserted.NetworkId = Network_inserted.NetworkId
end
go

create trigger Media.Series_Delete
	on Media.Series
	after delete
as
begin
	set nocount on

	insert into Maintenance.Media_Series
	(
		SeriesUid
		,MaintenanceType
		,SeriesTitle_Before
		,SeriesYear_Before
		,NetworkId_Before
		,NetworkName_Before
		,SeriesDescription_Before
	)
	select
		SeriesUid
		,'I'
		,SeriesTitle
		,SeriesYear
		,deleted.NetworkId
		,NetworkName
		,SeriesDescription
	from deleted
		left join Reference.Network
			on deleted.NetworkId = Network.NetworkId
end
go
