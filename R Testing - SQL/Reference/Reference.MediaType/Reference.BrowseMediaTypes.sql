create procedure Reference.BrowseMediaTypes
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = null

	select
		MediaTypeId
		,MediaType
		,MediaTypeDescription
		,LastMaintenanceDateTime
		,LastMaintenanceUser
	from Reference.MediaType
	order by MediaType
end
go

grant execute on Reference.BrowseMediaTypes to RTesting
go
