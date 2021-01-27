create procedure Media.BrowseSeries
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = null

	select
		SeriesUid
		,SeriesTitle
		,SeriesYear
		--,Series.NetworkId
		,NetworkName
		,SeriesDescription
		,AddDateTime
		,Series.LastMaintenanceDateTime
		,Series.LastMaintenanceUser
	from Media.Series
		inner join Reference.Network
			on Series.NetworkId = Network.NetworkId
	order by
		SeriesTitle
		,SeriesYear
end
