create procedure Reference.UpdateStatusCode
	@statusCodeId tinyint
	,@statusCode nvarchar(20)
	,@statusDescription nvarchar(100) = null
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@statusCodeId = ||' + isnull(cast(@statusCodeId as varchar(4)), 'NULL') + '||' +
		', @statusCode = ||' + isnull(@statusCode, 'NULL') + '||' +
		', @statusDescription = ||' + isnull(@statusDescription, 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	update Reference.StatusCode
	set
		StatusCode = @statusCode
		,StatusDescription = @statusDescription
		,LastMaintenanceDateTime = getdate()
		,LastMaintenanceUser = system_user
	where StatusCodeId = @statusCodeId
end
go

grant execute on Reference.UpdateStatusCode to RTesting
go
