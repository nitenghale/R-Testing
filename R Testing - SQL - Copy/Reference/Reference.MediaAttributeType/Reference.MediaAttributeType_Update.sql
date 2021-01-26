create trigger Reference.MediaAttributeType_Update
	on Reference.MediaAttributeType
	after update
as
begin
	set nocount on

	insert into Maintenance.Reference_MediaAttributeType
	(
		MediaAttributeTypeId
		,MaintenanceType
		,MediaAttributeType_Before
		,MediaAttributeType_After
		,MediaAttributeDescription_Before
		,MediaAttributeDescription_After
		,MediaAttributeRepeatable_Before
		,MediaAttributeRepeatable_After
	)
	select
		deleted.MediaAttributeTypeId
		,'U'
		,deleted.MediaAttributeType
		,inserted.MediaAttributeType
		,deleted.MediaAttributeDescription
		,inserted.MediaAttributeDescription
		,deleted.MediaAttributeRepeatable
		,inserted.MediaAttributeRepeatable
	from deleted
		left join inserted
			on deleted.MediaAttributeTypeId = inserted.MediaAttributeTypeId
end
