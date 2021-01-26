create trigger Reference.StatusCode_Insert
	on Reference.StatusCode
	after insert
as
begin
	set nocount on

	insert into Maintenance.Reference_StatusCode
	(
		StatusCodeId
		,MaintenanceType
		,StatusCode_After
		,StatusDescription_After
	)
	select
		StatusCodeId
		,'I'
		,StatusCode
		,StatusDescription
	from inserted
end
