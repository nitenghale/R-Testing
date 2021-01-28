﻿create procedure Media.BrowseEpisodes
	@seriesUid uniqueidentifier = null
	,@seriesTitle nvarchar(100) = null
	,@seriesYear smallint = null
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@seriesUid = ||' + isnull(@seriesUid, 'NULL') + '||' +
		', @seriesTitle = ||' + isnull(@seriesTitle, 'NULL') + '||' +
		', @seriesYear = ||' + isnull(cast(@seriesYear as varchar(5)), 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	select
		EpisodeUid
		--,Series.SeriesTitle
		--,Series.SeriesYear
		,EpisodeNumber
		,EpisodeTitle
		,OriginalAirDate
		,Synopsis
		,AddDateTime
		,LastMaintenanceDateTime
		,LastMaintenanceUser
	from Media.Episode
		--inner join Media.Series
			--on Episode.SeriesUid = Series.SeriesUid
	order by
		SeasonNumber
		,EpisodeNumber
end
