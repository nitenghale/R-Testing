create procedure Reference.GetMediaAttributeTypeDetails
	@mediaAttributeTypeId smallint = null
	,@mediaAttributeType nvarchar(20) = null
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@mediaAttributeTypeId = ||' + isnull(cast(@mediaAttributeTypeId as varchar(5)), 'NULL') + '||' +
		', @mediaAttributeType = ||' + isnull(@mediaAttributeType, 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	if @mediaAttributeTypeId is null
		set @mediaAttributeTypeId = Reference.GetMediaAttributeTypeIdFromMediaAttributeType(@mediaAttributeType)

	select
		MediaAttributeTypeId
		,MediaAttributeType
		,MediaAttributeDescription
		,MediaAttributeRepeatable
		,LastMaintenanceDateTime
		,LastMaintenanceUser
	from Reference.MediaAttributeType
	where MediaAttributeTypeId = @mediaAttributeTypeId
end
