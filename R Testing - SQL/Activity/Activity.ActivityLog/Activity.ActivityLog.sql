create table Activity.ActivityLog
(
	ActivityDateTime datetime2(7) not null
	,ActivityUser nvarchar(50) not null
	,ObjectName varchar(150) not null
	,ObjectParameters nvarchar(max) null
)