create trigger Reference.StatusCode_Delete
	on Reference.StatusCode
	after delete
as
begin
	set nocount on

	insert into Maintenance.Reference_StatusCode
	(
		StatusCodeId
		,MaintenanceType
		,StatusCode_Before
		,StatusDescription_Before
	)
	select
		StatusCodeId
		,'D'
		,StatusCode
		,StatusDescription
	from deleted
end
