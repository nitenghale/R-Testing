create procedure Reference.DeleteStatusCode
	@statusCodeId tinyint
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@statusCodeId = ||' + isnull(cast(@statusCodeId as varchar(4)), 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	delete from Reference.StatusCode
	where StatusCodeId = @statusCodeId
end
go

grant execute on Reference.DeleteStatusCode to RTesting
go
