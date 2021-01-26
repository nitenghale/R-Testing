create procedure Reference.GetStatusCodeDetails
	@statusCodeId tinyint = null
	,@statusCode nvarchar(20) = null
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@statusCodeId = ||' + isnull(cast(@statusCodeId as varchar(4)), 'NULL') + '||' +
		', @statusCode = ||' + isnull(@statusCode, 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	if @statusCodeId is null
		set @statusCodeId = Reference.GetStatusCodeIdFromStatusCode(@statusCode)

	select
		StatusCodeId
		,StatusCode
		,StatusDescription
		,LastMaintenanceDateTime
		,LastMaintenanceUser
	from Reference.StatusCode
	where StatusCodeId = @statusCodeId
end
