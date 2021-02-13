create procedure Media.DeletePlaylist
	@playlistId smallint
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@playlistId = ||' + isnull(cast(@playlistId as varchar(5)), 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	delete from Media.Playlist
	where PlaylistId = @playlistId
end
go

grant execute on Media.DeletePlaylist to RTesting
go
