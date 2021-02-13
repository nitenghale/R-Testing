create procedure Media.ListPlaylists
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = null

	select PlaylistName
	from Media.Playlist
	order by PlaylistName
end
go

grant execute on Media.ListPlaylists to RTesting
go
