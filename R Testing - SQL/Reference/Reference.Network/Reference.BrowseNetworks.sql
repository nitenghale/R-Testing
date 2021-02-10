create procedure Reference.BrowseNetworks
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = null


	select
		NetworkId
		,isnull(NetworkAbbreviation, '') as NetworkAbbreviation
		,NetworkName
		,isnull(cast(ChannelNumber as varchar(8)), '') as ChannelNumber
		--,LastMaintenanceDateTime
		--,LastMaintenanceUser
	from Reference.Network
	order by Network.NetworkName
end
