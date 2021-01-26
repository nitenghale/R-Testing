create trigger Reference.MediaType_Update
	on Reference.MediaType
	after update
as
begin
	set nocount on

	insert into Maintenance.Reference_MediaType
	(
		MediaTypeId
		,MaintenanceType
		,MediaType_Before
		,MediaType_After
		,MediaTypeDescription_Before
		,MediaTypeDescrption_After
	)
	select
		deleted.MediaTypeId
		,'U'
		,deleted.MediaType
		,inserted.MediaType
		,deleted.MediaTypeDescription
		,inserted.MediaTypeDescription
	from deleted
		left join inserted
			on deleted.MediaTypeId = inserted.MediaTypeId
end
