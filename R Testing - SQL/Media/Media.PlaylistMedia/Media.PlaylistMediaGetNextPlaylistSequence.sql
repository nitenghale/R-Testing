create function Media.PlaylistMediaGetNextPlaylistSequence (@playlistId smallint, @mediaUid uniqueidentifier)
	returns smallint
as
begin
	declare @playlistSequence smallint

	set @playlistSequence = (
		select max(PlaylistSequence) 
		from Media.PlaylistMedia
		where
			PlaylistId = @playlistId
			and MediaUid = @mediaUid) + 1

	return @playlistSequence
end
