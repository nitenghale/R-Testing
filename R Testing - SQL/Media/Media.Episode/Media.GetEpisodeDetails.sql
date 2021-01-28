create procedure Media.GetEpisodeDetails
	@episodeUid uniqueidentifier = null
	,@seriesUid uniqueidentifier = null
	,@seriesTitle nvarchar(100) = null
	,@seriesYear smallint = null
	,@seasonNumber tinyint = null
	,@episodeNumber smallint = null
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@episodeUid = ||' + isnull(@episodeUid, 'NULL') + '||' +
		', @seriesUid = ||' + isnull(@seriesUid, 'NULL') + '||' +
		', @seriesTitle = ||' + isnull(@seriesTitle, 'NULL') + '||' +
		', @seriesYear = ||' + isnull(cast(@seriesYear as varchar(5)), 'NULL') + '||' +
		', @seasonNumber = ||' + isnull(cast(@seasonNumber as varchar(4)), 'NULL') + '||' +
		', @episodeNumber = ||' + isnull(cast(@episodeNumber as varchar(5)), 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	if @seriesUid is null and @seriesTitle is not null and @seriesYear is not null
		set @seriesUid = Media.GetSeriesUidFromSeriesTitle(@seriesTitle, @seriesYear)

	if @episodeUid is null 
      and @seriesUid is not null 
	  and @seasonNumber is not null 
	  and @episodeNumber is not null
		set @episodeUid = Media.GetEpisodeUidFromSeriesSeasonAndEpisode(@seriesUid, @seasonNumber, @episodeNumber)

	select
		EpisodeUid
		,Episode.SeriesUid
		,Series.SeriesTitle
		,Series.SeriesYear
		,Series.SeriesDescription
		,Series.NetworkId
		,Network.NetworkAbbreviation
		,Network.NetworkName
		,SeasonNumber
		,EpisodeNumber
		,EpisodeTitle
		,OriginalAirDate
		,Synopsis
		,Episode.AddDateTime
		,Episode.LastMaintenanceDateTime
		,Episode.LastMaintenanceUser
	from Media.Episode
		inner join Media.Series
			on Episode.SeriesUid = Series.SeriesUid
		inner join Reference.Network
			on Series.NetworkId = Network.NetworkId
	where EpisodeUid = @episodeUid
end
