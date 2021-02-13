create procedure Reference.UpdateNetwork
	@networkId smallint
	,@networkAbbreviation nvarchar(10) = null
	,@networkName nvarchar(50)
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

	update Reference.Network
	set
		NetworkAbbreviation = @networkAbbreviation
		,NetworkName = @networkName
		,ChannelNumber = @channelNumber
		,LastMaintenanceDateTime = getdate()
		,LastMaintenanceUser = system_user
	where NetworkId = @networkId
end
go

grant execute on Reference.UpdateNetwork to RTesting
go
