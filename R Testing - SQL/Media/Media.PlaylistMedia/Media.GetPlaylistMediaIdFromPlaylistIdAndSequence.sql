create function Media.GetPlaylistMediaIdFromPlaylistIdAndSequence (@playlistId smallint, @playlistSequence smallint)
	returns bigint
as
begin
	declare @playlistMediaId bigint

	set @playlistMediaId = (
		select PlaylistMediaId 
		from Media.PlaylistMedia
		where
			PlaylistId = @playlistId
			and PlaylistSequence = @playlistSequence)

	return @playlistMediaId
end
