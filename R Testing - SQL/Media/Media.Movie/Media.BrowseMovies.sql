create procedure Media.BrowseMovies
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = null

	select
		--MovieUid
		MovieTitle
		,ReleaseDate
		--,Movie.NetworkId
		,Network.NetworkAbbreviation
		,Network.NetworkName
		,Network.ChannelNumber
		,Synopsis
		--,AddDateTime
		,Movie.LastMaintenanceDateTime
		,Movie.LastMaintenanceUser
	from Media.Movie
		left join Reference.Network
			on Movie.NetworkId = Network.NetworkId
	order by
		MovieTitle
		,ReleaseDate
end
