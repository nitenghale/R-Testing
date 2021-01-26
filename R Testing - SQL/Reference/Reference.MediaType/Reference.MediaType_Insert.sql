create trigger Reference.MediaType_Insert
	on Reference.MediaType
	after insert
as
begin
	set nocount on

	insert into Maintenance.Reference_MediaType
	(
		MediaTypeId
		,MaintenanceType
		,MediaType_After
		,MediaTypeDescrption_After
	)
	select
		MediaTypeId
		,'I'
		,MediaType
		,MediaTypeDescription
	from inserted
end
