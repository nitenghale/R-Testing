create table Maintenance.Media_Playlist
(
	MaintenanceDateTime datetime2 not null
	,PlaylistId smallint not null
	,MaintenanceType char(1) not null
	,MaintenanceUser nvarchar(50) not null
	,PlaylistName_Before nvarchar(50) null
	,PlaylistName_After nvarchar(50) null
)
go

alter table Maintenance.Media_Playlist add constraint PK_Media_Playlist primary key clustered (MaintenanceDateTime, PlaylistId)
go

alter table Maintenance.Media_Playlist add constraint DF_Media_Playlist_MaintenanceDatetime default (getdate()) for MaintenanceDateTime
go

alter table Maintenance.Media_Playlist add constraint DF_Media_Playlist_MaintenanceUser default (system_user) for MaintenanceUser
go
