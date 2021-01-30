create procedure Media.GetMovieDetails
	@movieUid uniqueidentifier = null
	,@movieTitle nvarchar(100) = null
	,@releaseDate date = null
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		',@movieUid = ||' + isnull(@movieUid, 'NULL') + '||' +
		', @movieTitle = ||' + isnull(@movieTitle, 'NULL') + '||' +
		', @releaseDate = ||' + isnull(cast(@releaseDate as varchar(10)), 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	if @movieUid is null and @movieTitle is not null and @releaseDate is not null
		set @movieUid = Media.GetMovieUidFromMovieTitleAndReleaseDate

	select
		MovieUid
		,MovieTitle
		,ReleaseDate
		,Movie.NetworkId
		,Network.NetworkAbbreviation
		,Network.NetworkName
		,Network.ChannelNumber
		,Movie.AddDateTime
		,Movie.LastMaintenanceDateTime
		,Movie.LastMaintenanceUser
	from Media.Movie
		left join Reference.Network
			on Movie.NetworkId = Network.NetworkId
	where MovieUid = @movieUid
end
