create procedure Reference.DeleteMediaAttributeType
	@mediaAttributeTypeId smallint
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@mediaAttributeTypeId = ||' + isnull(cast(@mediaAttributeTypeId as varchar(5)), 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	delete from Reference.MediaAttributeType
	where MediaAttributeTypeId = @mediaAttributeTypeId
end
go

grant execute on Reference.DeleteMediaAttributeType to RTesting
go
