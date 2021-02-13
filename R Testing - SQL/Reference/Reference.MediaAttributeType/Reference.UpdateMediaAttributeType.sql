create procedure Reference.UpdateMediaAttributeType
	@mediaAttributeTypeId smallint
	,@mediaAttributeType nvarchar(20)
	,@mediaAttributeDescription nvarchar(100) = null
	,@mediaAttributeRepeatable bit = 'false'
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@mediaAttributeTypeId = ||' + isnull(cast(@mediaAttributeTypeId as varchar(5)), 'NULL') + '||' +
		', @mediaAttributeType = ||' + isnull(@mediaAttributeType, 'NULL') + '||' +
		', @mediaAttributeDescription = ||' + isnull(@mediaAttributeDescription, 'NULL') + '||' +
		', @mediaAttributeRepeatable = ||' + isnull(cast(@mediaAttributeRepeatable as varchar(5)), 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	update Reference.MediaAttributeType
	set
		MediaAttributeType = @mediaAttributeType
		,MediaAttributeDescription = @mediaAttributeDescription
		,MediaAttributeRepeatable = @mediaAttributeRepeatable
		,LastMaintenanceDateTime = getdate()
		,LastMaintenanceUser = system_user
	where MediaAttributeTypeId = @mediaAttributeTypeId
end
go

grant execute on Reference.UpdateMediaAttributeType to RTesting
go
