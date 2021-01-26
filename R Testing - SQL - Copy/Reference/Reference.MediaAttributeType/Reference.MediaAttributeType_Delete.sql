create trigger Reference.MediaAttributeType_Delete
	on Reference.MediaAttributeType
	after delete
as
begin
	set nocount on

	insert into Maintenance.Reference_MediaAttributeType
	(
		MediaAttributeTypeId
		,MaintenanceType
		,MediaAttributeType_Before
		,MediaAttributeDescription_Before
		,MediaAttributeRepeatable_Before
	)
	select
		MediaAttributeTypeId
		,'D'
		,MediaAttributeType
		,MediaAttributeDescription
		,MediaAttributeRepeatable
	from deleted
end
