create procedure Media.AddMovie
	@movieUid uniqueidentifier = null
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
		',@movieUid = ||' + isnull(@movieUid, 'NULL') + '||' +
		', @movieTitle = ||' + isnull(@movieTitle, 'NULL') + '||' +
		', @releaseDate = ||' + isnull(cast(@releaseDate as varchar(10)), 'NULL') + '||' +
		', @networkId = ||' + isnull(cast(@networkId as varchar(5)), 'NULL') + '||' +
		', @networkName = ||' + isnull(@networkName, 'NULL') + '||' +
		', @synopsis = ||' + isnull(@synopsis, 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	if @movieUid is null
		set @movieUid = newid()

	if @networkId is null and @networkName is not null
		set @networkId = Reference.GetNetworkIdFromNetworkName(@networkName)

	insert into Media.Movie
	(
		MovieUid
		,MovieTitle
		,ReleaseDate
		,NetworkId
		,Synopsis
	)
	values
	(
		@movieUid
		,@movieTitle
		,@releaseDate
		,@networkId
		,@synopsis
	)
end
go
