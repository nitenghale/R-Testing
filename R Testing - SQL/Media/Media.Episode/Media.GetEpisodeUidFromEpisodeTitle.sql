create function Media.GetEpisodeUidFromEpisodeTitle (@episodeTitle nvarchar(250))
	returns uniqueidentifier
as
begin
	declare @episodeUid uniqueidentifier
	declare @seriesUid uniqueidentifier
	declare @seriesTitle nvarchar(100)
	declare @seriesYear smallint
	declare @seasonNumber tinyint
	declare @episodeNumber smallint

	set @seriesTitle = trim(left(@episodeTitle, charindex(') - S', @episodeTitle) - 7))
	set @episodeTitle = trim(right(@episodeTitle, len(@episodeTitle) - len(@seriesTitle)))
	set @seriesYear = substring(@episodeTitle, 2, 4)
	set @seasonNumber = substring(@episodeTitle, 11, 3)
	set @episodeNumber = substring(@episodeTitle, 15, 3)

	set @seriesUid = Media.GetSeriesUidFromSeriesTitleAndYear(@seriesTitle, @seriesYear)
	set @episodeUid = Media.GetEpisodeUidFromSeriesSeasonAndEpisode(@seriesUid, @seasonNumber, @episodeNumber)

	return @episodeUid
end
go
