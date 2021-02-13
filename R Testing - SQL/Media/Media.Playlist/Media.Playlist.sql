create table Media.Playlist
(
	PlaylistId smallint identity(1,1) not null
	,PlaylistName nvarchar(50) not null
	,LastMaintenanceDateTime datetime not null
	,LastMaintenanceUser nvarchar(50) not null
)
go

alter table Media.Playlist add constraint PK_Playlist primary key clustered (PlaylistId)
go

create unique nonclustered index IX_Playlist_PlaylistName on Media.Playlist (PlaylistName) on IndexData
go

alter table Media.Playlist add constraint DF_Playlist_LastMaintenanceDateTime default (getdate()) for LastMaintenanceDateTime
go

alter table Media.Playlist add constraint DF_Playlist_LastMaintenanceUser default (system_user) for LastMaintenanceUser
go

grant select, insert, update, delete on Media.Playlist to RTesting
go

create trigger Media.Playlist_Insert
	on Media.Playlist
	after insert
as
begin
	set nocount on

	insert into Maintenance.Media_Playlist
	(
		PlaylistId
		,MaintenanceType
		,PlaylistName_After
	)
	select
		PlaylistId
		,'I'
		,PlaylistName
	from inserted
end
go

create trigger Media.Playlist_Update
	on Media.Playlist
	after update
as
begin
	set nocount on

	insert into Maintenance.Media_Playlist
	(
		PlaylistId
		,MaintenanceType
		,PlaylistName_Before
		,PlaylistName_After
	)
	select
		deleted.PlaylistId
		,'U'
		,deleted.PlaylistName
		,inserted.PlaylistName
	from deleted
		left join inserted
			on deleted.PlaylistId = inserted.PlaylistId
end
go

create trigger Media.Playlist_Delete
	on Media.Playlist
	after delete
as
begin
	set nocount on

	insert into Maintenance.Media_Playlist
	(
		PlaylistId
		,MaintenanceType
		,PlaylistName_Before
	)
	select
		PlaylistId
		,'D'
		,PlaylistName
	from deleted
end
go
