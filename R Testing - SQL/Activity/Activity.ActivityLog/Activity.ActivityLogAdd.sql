create procedure Activity.ActivityLogAdd
	@objectName varchar(150)
	,@objectParameters nvarchar(max)
as
begin
	set nocount on

	insert into Activity.ActivityLog
	(
		ActivitySequence
		,ObjectName
		,ObjectParameters
	)
	values
	(
		Activity.GetNextActivitySequence()
		,@objectName
		,@objectParameters
	)
end
