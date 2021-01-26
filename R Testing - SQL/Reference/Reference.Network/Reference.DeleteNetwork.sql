create procedure Reference.DeleteNetwork
	@networkId smallint
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@networkId = ||' + isnull(cast(@networkId as varchar(5)), 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	delete from Reference.Network where NetworkId = @networkId
end
