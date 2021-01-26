create trigger Reference.StatusCode_Update
	on Reference.StatusCode
	after update
as
begin
	set nocount on

	insert Maintenance.Reference_StatusCode
	(
		StatusCodeId
		,MaintenanceType
		,StatusCode_Before
		,StatusCode_After
		,StatusDescription_Before
		,StatusDescription_After
	)
	select
		deleted.StatusCodeId
		,'U'
		,deleted.StatusCode
		,inserted.StatusCode
		,deleted.StatusDescription
		,inserted.StatusDescription
	from deleted
		left join inserted
			on deleted.StatusCodeId = inserted.StatusCodeId
end
