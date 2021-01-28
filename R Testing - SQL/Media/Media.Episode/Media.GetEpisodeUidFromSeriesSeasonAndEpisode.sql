create function Media.GetEpisodeUidFromSeriesSeasonAndEpisode (
	@seriesUid uniqueidentifier
	,@seasonNumber tinyint
	,@episodeNumber smallint)
	returns uniqueidentifier
as
begin
	declare @episodeUid uniqueidentifier

	set @episodeUid = (
		select EpisodeUid
		from Media.Episode
		where
			SeasonNumber = @seasonNumber
			and EpisodeNumber = @episodeNumber)

	return @episodeUid
end
