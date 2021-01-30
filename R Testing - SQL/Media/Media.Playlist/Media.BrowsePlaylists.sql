create procedure Media.BrowsePlaylists
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = null

	select
		PlaylistId
		,PlaylistName
		,LastMaintenanceDateTime
		,LastMaintenanceUser
	from Media.Playlist
	order by PlaylistName
end
