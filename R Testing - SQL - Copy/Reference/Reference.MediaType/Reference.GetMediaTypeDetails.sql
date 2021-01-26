create procedure Reference.GetMediaTypeDetails
	@mediaTypeId tinyint = null
	,@mediaType nvarchar(20) = null
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@mediaTypeId = ||' + isnull(cast(@mediaTypeId as varchar(4)), 'NULL') + '||' +
		'@mediaType = ||' + isnull(@mediaType, 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	if @mediaTypeId is null
		set @mediaType = Reference.GetMediaTypeIdFromMediaType(@mediaType)

	select
		MediaTypeId
		,MediaType
		,MediaTypeDescription
		,LastMaintenanceDateTime
		,LastMaintenanceUser
	from Reference.MediaType
	where MediaTypeId = @mediaTypeId
end
