create procedure Media.UpdateMovie
	@movieUid uniqueidentifier
	,@movieTitle nvarchar(100)
	,@releaseDate date
	,@networkId smallint = null
	,@networkName nvarchar(50) = null
	,@synopsis nvarchar(max) = null
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		',@movieUid = ||' + isnull(cast(@movieUid as varchar(50)), 'NULL') + '||' +
		', @movieTitle = ||' + isnull(@movieTitle, 'NULL') + '||' +
		', @releaseDate = ||' + isnull(cast(@releaseDate as varchar(10)), 'NULL') + '||' +
		', @networkId = ||' + isnull(cast(@networkId as varchar(5)), 'NULL') + '||' +
		', @networkName = ||' + isnull(@networkName, 'NULL') + '||' +
		', @synopsis = ||' + isnull(@synopsis, 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	if @networkId is null and @networkName is not null
		set @networkId = Reference.GetNetworkIdFromNetworkName(@networkName)

	update Media.Movie
	set
		MovieTitle = @movieTitle
		,ReleaseDate = @releaseDate
		,NetworkId = @networkId
		,Synopsis = @synopsis
		,LastMaintenanceDateTime = getdate()
		,LastMaintenanceUser = system_user
	where MovieUid = @movieUid
end
go

grant execute on Media.UpdateMovie to RTesting
go
