create procedure Reference.AddMediaAttributeType
	@mediaAttributeType nvarchar(20)
	,@mediaAttributeDescription nvarchar(100) = null
	,@mediaAttributeRepeatable bit = 'false'
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@mediaAttributeType = ||' + isnull(@mediaAttributeType, 'NULL') + '||' +
		', @mediaAttributeDescription = ||' + isnull(@mediaAttributeDescription, 'NULL') + '||' +
		', @mediaAttributeRepeatable = ||' + isnull(cast(@mediaAttributeRepeatable as varchar(5)), 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	insert into Reference.MediaAttributeType
	(
		MediaAttributeType
		,MediaAttributeDescription
		,MediaAttributeRepeatable
	)
	values
	(
		@mediaAttributeType
		,@mediaAttributeDescription
		,@mediaAttributeRepeatable
	)
end
