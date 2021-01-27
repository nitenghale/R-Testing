create procedure Media.AddSeries
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
		'@seriesUid = ||' + isnull(@seriesUid, 'NULL') + '||' +
		', @seriesTitle = ||' + isnull(@seriesTitle, 'NULL') + '||' +
		', @seriesYear = ||' + isnull(cast(@seriesYear as varchar(5)), 'NULL') + '||' +
		', @networkId = ||' + isnull(cast(@networkId as varchar(5)), 'NULL') + '||' +
		', @networkName = ||' + isnull(@networkName, 'NULL') + '||' +
		', @seriesDescription = ||' + isnull(@seriesDescription, 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	if @seriesUid is null
		set @seriesUid = newid()

	if @networkId is null and @networkName is not null
		set @networkId = Reference.GetNetworkIdFromNetworkName(@networkName)

	insert into Media.Series
	(
		SeriesUid
		,SeriesTitle
		,SeriesYear
		,NetworkId
		,SeriesDescription
	)
	values
	(
		@seriesUid
		,@seriesTitle
		,@seriesYear
		,@networkId
		,@seriesDescription
	)
end
go
