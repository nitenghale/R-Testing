create trigger Reference.MediaAttributeType_Insert
	on Reference.MediaAttributeType
	after insert
as
begin
	set nocount on

	insert into Maintenance.Reference_MediaAttributeType
	(
		MediaAttributeTypeId
		,MaintenanceType
		,MediaAttributeType_After
		,MediaAttributeDescription_After
		,MediaAttributeRepeatable_After
	)
	select
		MediaAttributeTypeId
		,'I'
		,MediaAttributeType
		,MediaAttributeDescription
		,MediaAttributeRepeatable
	from inserted
end
