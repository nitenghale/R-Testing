create procedure Reference.BrowseMediaAttributeTypes
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = null

	select
		MediaAttributeTypeId
		,MediaAttributeType
		,MediaAttributeDescription
		,MediaAttributeRepeatable
		,LastMaintenanceDateTime
		,LastMaintenanceUser
	from Reference.MediaAttributeType
	order by MediaAttributeType
end
