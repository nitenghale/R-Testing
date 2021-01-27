﻿create procedure Media.ListSeries
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = null

	select SeriesTitle + ' (' + cast(SeriesYear as varchar(5)) + ')' as SeriesTitle
	from Media.Series
	order by
		SeriesTitle
		,SeriesYear
end
