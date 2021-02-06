create procedure Reference.BrowseStatusCodes
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = null

	select
		--StatusCodeId
		StatusCode
		,StatusDescription
		,LastMaintenanceDateTime
		,LastMaintenanceUser
	from Reference.StatusCode
	order by StatusCode
end
