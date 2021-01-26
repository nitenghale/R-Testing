create procedure Reference.AddStatusCode
	@statusCode nvarchar(20)
	,@statusDescription nvarchar(100) = null
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@statusCode = ||' + isnull(@statusCode, 'NULL') + '||' +
		', @statusDescription = ||' + isnull(@statusDescription, 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	insert into Reference.StatusCode
	(
		StatusCode
		,StatusDescription
	)
	values
	(
		@statusCode
		,@statusDescription
	)
end
