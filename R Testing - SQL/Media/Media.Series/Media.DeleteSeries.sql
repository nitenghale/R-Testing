create procedure Media.DeleteSeries
	@seriesUid uniqueidentifier
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@seriesUid = ||' + isnull(cast(@seriesUid as varchar(50)), 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	delete from Media.Series
	where SeriesUid = @seriesUid
end
go

grant execute on Media.DeleteSeries to RTesting
go
