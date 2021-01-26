create procedure Reference.DeleteMediaType
	@mediaTypeId tinyint
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@mediaTypeId = ||' + isnull(cast(@mediaTypeId as varchar(4)), 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	delete from Reference.MediaType
	where MediaTypeId = @mediaTypeId
end
