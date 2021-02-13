create table Media.Movie
(
	MovieUid uniqueidentifier not null
	,MovieTitle nvarchar(100) not null
	,ReleaseDate date not null
	,NetworkId smallint null
	,Synopsis nvarchar(max) null
	,AddDateTime datetime2 not null
	,LastMaintenanceDateTime datetime not null
	,LastMaintenanceUser nvarchar(50) not null
)
go

alter table Media.Movie add constraint PK_Movie primary key nonclustered (MovieUid)
go

create unique clustered index IX_Movie_AddDateTime on Media.Movie (AddDateTime, MovieUid)
go

create unique nonclustered index IX_Movie_MovieTitle_ReleaseDate on Media.Movie (MovieTitle, ReleaseDate) on IndexData
go

alter table Media.Movie add constraint FK_Movie_Network foreign key (NetworkId) references Reference.Network (NetworkId)
go

alter table Media.Movie add constraint DF_Movie_MovieUid default (newid()) for MovieUid
go

alter table Media.Movie add constraint DF_Movie_AddDateTime default (getdate()) for AddDateTime
go

alter table Media.Movie add constraint DF_Movie_LastMaintenanceDateTime default (getdate()) for LastMaintenanceDateTime
go

alter table Media.Movie add constraint DF_Movie_LastMaintenanceUser default (system_user) for LastMaintenanceUser
go

grant select, insert, update, delete on Media.Movie to RTesting
go

create trigger Media.Movie_Insert
	on Media.Movie
	after insert
as
begin
	set nocount on

	insert into Maintenance.Media_Movie
	(
		MovieUid
		,MaintenanceType
		,MovieTitle_After
		,ReleaseDate_After
		,NetworkId_After
		,NetworkName_After
		,Synopsis_After
	)
	select
		MovieUid
		,'I'
		,MovieTitle
		,ReleaseDate
		,inserted.NetworkId
		,NetworkName
		,Synopsis
	from inserted
		left join Reference.Network
			on inserted.NetworkId = Network.NetworkId
end
go

create trigger Media.Movie_Update
	on Media.Movie
	after update
as
begin
	set nocount on

	insert into Maintenance.Media_Movie
	(
		MovieUid
		,MaintenanceType
		,MovieTitle_Before
		,MovieTitle_After
		,ReleaseDate_Before
		,ReleaseDate_After
		,NetworkId_Before
		,NetworkId_After
		,NetworkName_Before
		,NetworkName_After
		,Synopsis_Before
		,Synopsis_After
	)
	select
		deleted.MovieUid
		,'U'
		,deleted.MovieTitle
		,inserted.MovieTitle
		,deleted.ReleaseDate
		,inserted.ReleaseDate
		,deleted.NetworkId
		,inserted.NetworkId
		,Network_deleted.NetworkName
		,Network_inserted.NetworkName
		,deleted.Synopsis
		,inserted.Synopsis
	from deleted
		left join Reference.Network as Network_deleted
			on deleted.NetworkId = Network_deleted.NetworkId
		left join inserted
			on deleted.MovieUid = inserted.MovieUid
		left join Reference.Network as Network_inserted
			on inserted.NetworkId = Network_inserted.NetworkId
end
go

create trigger Media.Movie_Delete
	on Media.Movie
	after delete
as
begin
	set nocount on

	insert into Maintenance.Media_Movie
	(
		MovieUid
		,MaintenanceType
		,MovieTitle_Before
		,ReleaseDate_Before
		,NetworkId_Before
		,NetworkName_Before
		,Synopsis_Before
	)
	select
		MovieUid
		,'D'
		,MovieTitle
		,ReleaseDate
		,deleted.NetworkId
		,NetworkName
		,Synopsis
	from deleted
		left join Reference.Network
			on deleted.NetworkId = Network.NetworkId
end
go
