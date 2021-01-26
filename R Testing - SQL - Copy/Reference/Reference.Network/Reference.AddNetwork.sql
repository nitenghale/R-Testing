create procedure Reference.AddNetwork
	@networkAbbreviation nvarchar(10) = null
	,@networkName nvarchar(50)
	,@channelNumber decimal(7, 2) = null
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@networkAbbreviation = ||' + isnull(@networkAbbreviation, 'NULL') + '||' +
		', @networkName = ||' + isnull(@networkName, 'NULL') + '||' +
		', @channelNumber = ||' + isnull(cast(@channelNumber as varchar(8)), 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	insert into Reference.Network
	(
		NetworkAbbreviation
		,NetworkName
		,ChannelNumber
	)
	values
	(
		@networkAbbreviation
		,@networkName
		,@channelNumber
	)
end
