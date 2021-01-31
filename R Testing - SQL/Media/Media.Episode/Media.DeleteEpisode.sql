create procedure Media.DeleteEpisode
	@episodeUid uniqueidentifier
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@episodeUid = ||' + isnull(cast(@episodeUid as varchar(50)), 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	delete from Media.Episode
	where EpisodeUid = @episodeUid
end
