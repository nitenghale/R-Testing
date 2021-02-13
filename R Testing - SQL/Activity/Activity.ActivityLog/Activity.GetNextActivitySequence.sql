create function Activity.GetNextActivitySequence ()
	returns tinyint
as
begin
	declare @activitySequence tinyint

	set @activitySequence = (select isnull(max(ActivitySequence), 0) + 1 from Activity.ActivityLog where ActivityDateTime = getdate())

	return @activitySequence
end
go

grant execute on Activity.GetNextActivitySequence to RTesting
go
