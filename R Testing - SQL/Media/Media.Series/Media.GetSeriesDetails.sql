create procedure Media.GetSeriesDetails
	@seriesUid uniqueidentifier = null
	,@seriesTitle nvarchar(100) = null
	,@seriesYear smallint = null
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@seriesUid = ||' + isnull(cast(@seriesUid as varchar(50)), 'NULL') + '||' +
		', @seriesTitle = ||' + isnull(@seriesTitle, 'NULL') + '||' +
		', @seriesYear = ||' + isnull(cast(@seriesYear as varchar(5)), 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	if @seriesUid is null and @seriesTitle is not null and @seriesYear is not null
		set @seriesUid = media.GetSeriesUidFromSeriesTitleAndYear(@seriesTitle, @seriesYear)

	select
		SeriesUid
		,SeriesTitle
		,SeriesYear
		,Series.NetworkId
		,NetworkName
		,SeriesDescription
		,AddDateTime
		,Series.LastMaintenanceDateTime
		,Series.LastMaintenanceUser
	from Media.Series
		inner join Reference.Network
			on Series.NetworkId = Network.NetworkId
	where SeriesUid = @seriesUid
end
go
