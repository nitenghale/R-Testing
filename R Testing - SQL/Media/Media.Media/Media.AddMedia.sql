﻿create procedure Media.AddMedia
	@mediaUid uniqueidentifier = null
	,@mediaTitle nvarchar(100)
	,@mediaTypeId tinyint = null
	,@mediaType nvarchar(20) = null
	,@networkId smallint = null
	,@networkName nvarchar(20) = null
	,@parentMediaUid uniqueidentifier = null
	,@parentMediaTitle nvarchar(100) = null
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@mediaUid = ||' + isnull(@mediaUid, 'NULL') + '||' +
		', @mediaTitle = ||' + isnull(@mediaTitle, 'NULL') + '||' +
		', @mediaTypeId = ||' + isnull(cast(@mediaTypeId as varchar(4)), 'NULL') + '||' +
		', @mediaType = ||' + isnull(@mediaType, 'NULL') + '||' +
		', @networkId = ||' + isnull(cast(@networkId as varchar(5)), 'NULL') + '||' +
		', @networkName = ||' + isnull(@networkName, 'NULL') + '||' +
		', @parentMediaUid = ||' + isnull(@parentMediaUid, 'NULL') + '||' +
		', @parentMediaTitle = ||' + isnull(@parentMediaTitle, 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	if @mediaUid is null
		set @mediaUid = newid()

	if @mediaTypeId is null and @mediaType is not null
		set @mediaTypeId = Reference.GetMediaTypeIdFromMediaType(@mediaType)

	if @networkId is null and @networkName is not null
		set @networkId = Reference.GetNetworkIdFromNetworkName(@networkName)

	if @parentMediaUid is null and @parentMediaTitle is not null
		set @parentMediaUid = Media.GetMediaUidFromMediaTitle(@parentMediaTitle)

	insert into Media.Media
	(
		MediaUid
		,MediaTitle
		,MediaTypeId
		,NetworkId
		,ParentMediaUid
	)
	values
	(
		@mediaUid
		,@mediaTitle
		,@mediaTypeId
		,@networkId
		,@parentMediaUid
	)
end
