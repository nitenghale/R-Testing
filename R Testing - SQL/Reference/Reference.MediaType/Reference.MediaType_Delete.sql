create trigger Reference.MediaType_Delete
	on Reference.MediaType
	after delete
as
begin
	set nocount on

	insert into Maintenance.Reference_MediaType
	(
		MediaTypeId
		,MaintenanceType
		,MediaType_Before
		,MediaTypeDescription_Before
	)
	select
		MediaTypeId
		,'D'
		,MediaType
		,MediaTypeDescription
	from deleted
end
