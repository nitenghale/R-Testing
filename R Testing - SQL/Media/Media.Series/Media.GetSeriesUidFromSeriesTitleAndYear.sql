﻿create function Media.GetSeriesUidFromSeriesTitleAndYear (@seriesTitle nvarchar(100), @seriesYear smallint)
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
go

grant execute on Media.GetSeriesUidFromSeriesTitleAndYear to RTesting
go
