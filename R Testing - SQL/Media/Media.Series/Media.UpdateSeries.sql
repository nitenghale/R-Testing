create procedure Media.UpdateSeries
	@seriesUid uniqueidentifier = null
	,@seriesTitle nvarchar(100)
	,@seriesYear smallint
	,@networkId smallint = null
	,@networkName nvarchar(20) = null
	,@seriesDescription nvarchar(max) = null
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@seriesUid = ||' + isnull(cast(@seriesUid as varchar(50)), 'NULL') + '||' +
		', @seriesTitle = ||' + isnull(@seriesTitle, 'NULL') + '||' +
		', @seriesYear = ||' + isnull(cast(@seriesYear as varchar(5)), 'NULL') + '||' +
		', @networkId = ||' + isnull(cast(@networkId as varchar(5)), 'NULL') + '||' +
		', @networkName = ||' + isnull(@networkName, 'NULL') + '||' +
		', @seriesDescription = ||' + isnull(@seriesDescription, 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	if @seriesUid is null and @seriesTitle is not null and @seriesYear is not null
		set @seriesUid = media.GetSeriesUidFromSeriesTitleAndYear(@seriesTitle, @seriesYear)

	if @networkId is null and @networkName is not null
		set @networkId = Reference.GetNetworkIdFromNetworkName(@networkName)

	update Media.Series
	set
		SeriesTitle = @seriesTitle
		,SeriesYear = @seriesYear
		,NetworkId = @networkId
		,SeriesDescription = @seriesDescription
		,LastMaintenanceDateTime = getdate()
		,LastMaintenanceUser = system_user
	where SeriesUid = @seriesUid
end
