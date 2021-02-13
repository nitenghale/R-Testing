create procedure Media.AddPlaylist
	@playlistName nvarchar(50)
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@playlistName = ||' + isnull(@playlistName, 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	insert into Media.Playlist
	(
		PlaylistName
	)
	values
	(
		@playlistName
	)
end
go

grant execute on Media.AddPlaylist to RTesting
go
