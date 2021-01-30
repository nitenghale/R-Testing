create procedure Media.UpdatePlaylist
	@playlistId smallint
	,@playlistName nvarchar(50)
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@playlistId = ||' + isnull(cast(@playlistId as varchar(5)), 'NULL') + '||' +
		', @playlistName = ||' + isnull(@playlistName, 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	update Media.Playlist
	set
		PlaylistName = @playlistId
		,LastMaintenanceDateTime = getdate()
		,LastMaintenanceUser = system_user
	where PlaylistId = @playlistId
end
