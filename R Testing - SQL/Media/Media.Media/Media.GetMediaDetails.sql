create procedure Media.GetMediaDetails
	@mediaUid uniqueidentifier = null
	,@mediaTitle nvarchar(100) = null
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@mediaUid = ||' + isnull(@mediaUid, 'NULL') + '||' +
		', @mediaTitle = ||' + isnull(@mediaTitle, 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	if @mediaUid is null
		set @mediaUid = Media.GetMediaUidFromMediaTitle(@mediaTitle)

	select
		Media.MediaUid
		,Media.MediaTitle
		,Media.MediaTypeId
		,MediaType
		,Media.NetworkId
		,NetworkName
		,Media.ParentMediaUid
		,Media_Parent.MediaTitle
		,Media.AddDateTime
		,Media.LastMaintenanceDateTime
		,Media.LastMaintenanceUser
	from Media.Media
		left join Reference.MediaType
			on Media.MediaTypeId = MediaType.MediaTypeId
		left join Reference.Network
			on Media.NetworkId = Network.NetworkId
		left join Media.Media as Media_Parent
			on Media.ParentMediaUid = Media_Parent.MediaUid
	where MediaUid = @mediaUid
end
