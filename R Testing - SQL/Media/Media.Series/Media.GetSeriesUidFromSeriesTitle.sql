create function Media.GetSeriesUidFromSeriesTitle (@seriesTitle nvarchar(100), @seriesYear smallint)
	returns uniqueidentifier
as
begin
	declare @seriesUid uniqueidentifier

	set @seriesUid = (
		select SeriesUid 
		from Media.Series 
		where
			SeriesTitle = @seriesTitle
			and SeriesYear = @seriesYear)

	return @seriesUid
end
