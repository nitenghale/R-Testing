create procedure Media.GetPlaylistDetails
	@playlistId smallint = null
	,@playlistName nvarchar(50) = null
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@playlistId = ||' + isnull(cast(@playlistId as varchar(5)), 'NULL') + '||' +
		', @playlistName = ||' + isnull(@playlistName, 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	if @playlistId is null and @playlistName is not null
		set @playlistId = Media.GetPlaylistIdFromPlaylistName(@playlistName)

	select
		PlaylistId
		,PlaylistName
		,LastMaintenanceDateTime
		,LastMaintenanceUser
	from Media.Playlist
	where PlaylistId = @playlistId
end
