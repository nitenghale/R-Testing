create procedure Activity.ActivityLogAdd
	@objectName varchar(150)
	,@objectParameters nvarchar(max)
as
begin
	set nocount on

	insert into Activity.ActivityLog
	(
		ObjectName
		,ObjectParameters
	)
	values
	(
		@objectName
		,@objectParameters
	)
end
