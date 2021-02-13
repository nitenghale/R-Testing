create function Media.GetPlaylistIdFromPlaylistName (@playlistName nvarchar(50))
	returns smallint
as
begin
	declare @playlistId smallint

	set @playlistId = (select PlaylistId from Media.Playlist where PlaylistName = @playlistName)

	return @playlistId
end
go

grant execute on Media.GetPlaylistIdFromPlaylistName to RTesting
go
