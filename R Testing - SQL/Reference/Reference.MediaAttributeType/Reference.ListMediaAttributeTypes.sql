create procedure Reference.ListMediaAttributeTypes
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = null

	select MediaAttributeType
	from Reference.MediaAttributeType
	order by MediaAttributeType
end
go

grant execute on Reference.ListMediaAttributeTypes to RTesting
go
