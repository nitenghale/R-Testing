create procedure Media.UpdateEpisode
	@episodeUid uniqueidentifier
	,@seriesUid uniqueidentifier = null
	,@seriesTitle nvarchar(100) = null
	,@seriesYear smallint = null
	,@seasonNumber tinyint
	,@episodeNumber smallint
	,@episodeTitle nvarchar(100) = null
	,@originalAirDate date = null
	,@synopsis nvarchar(max) = null
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@episodeUid = ||' + isnull(cast(@episodeUid as varchar(50)), 'NULL') + '||' +
		', @seriesUid = ||' + isnull(cast(@seriesUid as varchar(50)), 'NULL') + '||' +
		', @seriesTitle = ||' + isnull(@seriesTitle, 'NULL') + '||' +
		', @seriesYear = ||' + isnull(cast(@seriesYear as varchar(5)), 'NULL') + '||' +
		', @seasonNumber = ||' + isnull(cast(@seasonNumber as varchar(4)), 'NULL') + '||' +
		', @episodeNumber = ||' + isnull(cast(@episodeNumber as varchar(5)), 'NULL') + '||' +
		', @episodeTitle = ||' + isnull(@episodeTitle, 'NULL') + '||' +
		', @originalAirDate = ||' + isnull(cast(@originalAirDate as varchar(10)), 'NULL') + '||' +
		', @synopsis = ||' + isnull(@synopsis, 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	if @seriesUid is null and @seriesTitle is not null and @seriesYear is not null
		set @seriesUid = Media.GetSeriesUidFromSeriesTitleAndYear(@seriesTitle, @seriesYear)


	update Media.Episode
	set
		SeriesUid = @seriesUid
		,SeasonNumber = @seasonNumber
		,EpisodeNumber = @episodeNumber
		,EpisodeTitle = @episodeTitle
		,OriginalAirDate = @originalAirDate
		,Synopsis = @synopsis
		,LastMaintenanceDateTime = getdate()
		,LastMaintenanceUser = system_user
	where EpisodeUid = @episodeUid
end
