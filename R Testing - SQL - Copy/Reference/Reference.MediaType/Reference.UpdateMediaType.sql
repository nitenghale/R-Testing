create procedure Reference.UpdateMediaType
	@mediaTypeId tinyint
	,@mediaType nvarchar(20)
	,@mediaTypeDescription nvarchar(100) = null
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@mediaTypeId = ||' + isnull(cast(@mediaTypeId as varchar(4)), 'NULL') + '||' +
		', @mediaType = ||' + isnull(@mediaType, 'NULL') + '||' +
		', @mediaTypeDescription = ||' + isnull(@mediaTypeDescription, 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	update Reference.MediaType
	set
		MediaType = @mediaType
		,MediaTypeDescription = @mediaTypeDescription
		,LastMaintenanceDateTime = getdate()
		,LastMaintenanceUser = system_user
	where MediaTypeId = @mediaTypeId
end
