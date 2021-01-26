create table Media.PlaylistMedia
(
	PlaylistMediaId bigint identity(1,1) not null
	,PlaylistId smallint not null
	,MediaUid uniqueidentifier not null
	,PlaylistSequence smallint not null
	,LastMaintenanceDateTime datetime not null
	,LastMaintenanceUser nvarchar(50) not null
)
