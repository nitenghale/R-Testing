create procedure Reference.AddMediaType
	@mediaType nvarchar(20)
	,@mediaTypeDescription nvarchar(100) = null
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@mediaType = ||' + isnull(@mediaType, 'NULL') + '||' +
		', @mediaTypeDescription = ||' + isnull(@mediaTypeDescription, 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	insert into Reference.MediaType
	(
		MediaType
		,MediaTypeDescription
	)
	values
	(
		@mediaType
		,@mediaTypeDescription
	)
end
