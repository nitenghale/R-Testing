create table Media.Playlist
(
	PlaylistId smallint identity(1,1) not null
	,PlaylistName nvarchar(50) not null
	,LastMaintenanceDateTime datetime not null
	,LastMaintenanceUser nvarchar(50) not null
)