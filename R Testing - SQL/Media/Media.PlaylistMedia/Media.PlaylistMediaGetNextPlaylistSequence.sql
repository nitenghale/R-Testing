create function Media.PlaylistMediaGetNextPlaylistSequence (@playlistId smallint)
	returns smallint
as
begin
	declare @playlistSequence smallint

	set @playlistSequence = (select max(PlaylistSequence) from Media.PlaylistMedia where PlaylistId = @playlistId) + 1

	return @playlistSequence
end
