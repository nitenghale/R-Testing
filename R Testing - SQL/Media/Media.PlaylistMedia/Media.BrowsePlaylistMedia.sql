create procedure Media.BrowsePlaylistMedia
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
		case
			when Episode.EpisodeTitle is not null then
				Series.SeriesTitle + 
				' (' + cast(Series.SeriesYear as varchar(5)) + ')' +
				' - S' + format(Episode.SeasonNumber, '000') + 
				'E' + format(Episode.EpisodeNumber, '000') +
				' - ' + Episode.EpisodeTitle
			when Movie.MovieTitle is not null then
				Movie.MovieTitle +
				' (' + cast(year(Movie.ReleaseDate) as varchar(4)) + ')'
			else ''
		end as 'Title'
	from Media.PlaylistMedia
		left join Media.Episode
			on PlaylistMedia.MediaReferenceUid = Episode.EpisodeUid
		left join Media.Series as Series
			on Episode.SeriesUid = Series.SeriesUid
		left join Media.Movie
			on PlaylistMedia.MediaReferenceUid = Movie.MovieUid
	where PlaylistId = @playlistId
	order by PlaylistSequence
end
go

grant execute on Media.BrowsePlaylistMedia to RTesting
go
