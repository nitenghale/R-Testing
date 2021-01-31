create function Media.GetSeriesUidFromSeriesTitle (@seriesTitle nvarchar(107))
	returns uniqueidentifier
as
begin
	declare @seriesUid uniqueidentifier
	declare @seriesYear nvarchar(7)

	set @seriesYear = trim(right(@seriesTitle, 7))
	set @seriesYear = replace(@seriesYear, '(', '')
	set @seriesYear = replace(@seriesYear, ')', '')

	set @seriesTitle = trim(left(@seriesTitle, len(@seriesTitle) - 7))

	set @seriesUid = Media.GetSeriesUidFromSeriesTitleAndYear(@seriesUid, cast(@seriesYear as smallint))

	return @seriesUid
end
