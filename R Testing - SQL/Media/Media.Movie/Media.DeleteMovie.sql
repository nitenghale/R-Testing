create procedure Media.DeleteMovie
	@movieUid uniqueidentifier
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		',@movieUid = ||' + isnull(@movieUid, 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	delete from Media.Movie
	where MovieUid = @movieUid
end
