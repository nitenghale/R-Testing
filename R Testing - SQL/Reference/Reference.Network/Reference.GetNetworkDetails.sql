create procedure Reference.GetNetworkDetails
	@networkId smallint = null
	,@networkAbbreviation nvarchar(10) = null
	,@networkName nvarchar(50) = null
	,@channelNumber decimal(7, 2) = null
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@networkId = ||' + isnull(cast(@networkId as varchar(5)), 'NULL') + '||' +
		', @networkAbbreviation = ||' + isnull(@networkAbbreviation, 'NULL') + '||' +
		', @networkName = ||' + isnull(@networkName, 'NULL') + '||' +
		', @channelNumber = ||' + isnull(cast(@channelNumber as varchar(8)), 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	if @networkId is null
		set @networkId = Reference.GetNetworkIdFromNetworkName(@networkName)

	select
		NetworkId
		,NetworkAbbreviation
		,NetworkName
		,ChannelNumber
		,LastMaintenanceDateTime
		,LastMaintenanceUser
	from Reference.Network
	where NetworkId = @networkId
end
