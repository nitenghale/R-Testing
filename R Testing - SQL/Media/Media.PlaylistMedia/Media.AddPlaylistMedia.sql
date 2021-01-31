create procedure Media.AddPlaylistMedia
	@playlistId smallint = null
	,@playlistName nvarchar(50) = null
	,@mediaReferenceUid uniqueidentifier = null
	,@movieUid uniqueidentifier = null
	,@movieTitle nvarchar(107) = null
	,@episodeUid uniqueidentifier = null
	,@episodeTitle nvarchar(250) = null
	,@seriesUid uniqueidentifier = null
	,@seriesTitle nvarchar(107) = null
	,@mediaTypeId tinyint = null
	,@mediaType nvarchar(20) = null
	,@playlistSequence smallint = null
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@playlistId = ||' + isnull(cast(@playlistId as varchar(5)), 'NULL') + '||' +
		', @playlistName = ||' + isnull(@playlistName, 'NULL') + '||' +
		', @mediaReferenceUid = ||' + isnull(cast(@mediaReferenceUid as varchar(50)), 'NULL') + '||' +
		', @movieUid = ||' + isnull(cast(@movieUid as varchar(50)), 'NULL') + '||' +
		', @movieTitle = ||' + isnull(@movieTitle, 'NULL') + '||' +
		', @episodeUid = ||' + isnull(cast(@episodeUid as varchar(50)), 'NULL') + '||' +
		', @episodeTitle = ||' + isnull(@episodeTitle, 'NULL') + '||' +
		', @seriesUid = ||' + isnull(cast(@seriesUid as varchar(50)), 'NULL') + '||' +
		', @seriesTitle = ||' + isnull(@seriesTitle, 'NULL') + '||' +
		', @mediaTypeId = ||' + isnull(cast(@mediaTypeId as varchar(4)), 'NULL') + '||' +
		', @mediaType = ||' + isnull(@mediaType, 'NULL') + '||' +
		', @playlistSequence = ||' + isnull(cast(@playlistSequence as varchar(5)), 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	if @playlistId is null and @playlistName is not null
		set @playlistId = Media.GetPlaylistIdFromPlaylistName(@playlistName)

	if @movieUid is null and @movieTitle is not null
		set @mediaReferenceUid = Media.GetMovieUidFromMovieTitle(@movieTitle)
	else if @episodeUid is null and @episodeTitle is not null
		set @mediaReferenceUid = Media.GetEpisodeUidFromEpisodeTitle(@episodeTitle)
	else if @seriesUid is null and @seriesTitle is not null
		set @mediaReferenceUid = Media.GetSeriesUidFromSeriesTitle(@seriesTitle)
	else if @movieUid is not null
		set @mediaReferenceUid = @movieUid
	else if @episodeUid is not null
		set @mediaReferenceUid = @episodeUid
	else if @seriesUid is not null
		set @mediaReferenceUid = @seriesUid

	if @mediaTypeId is null and @mediaType is not null
		set @mediaTypeId = Reference.GetMediaTypeIdFromMediaType(@mediaType)

	if @playlistSequence is null
		set @playlistSequence = Media.PlaylistMediaGetNextPlaylistSequence(@playlistId)

	insert into Media.PlaylistMedia
	(
		PlaylistId
		,MediaReferenceUid
		,MediaTypeId
		,PlaylistSequence
	)
	values
	(
		@playlistId
		,@mediaReferenceUid
		,@mediaTypeId
		,@playlistSequence
	)
end
