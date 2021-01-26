create procedure Media.BrowseMedia
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = null

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
	order by
		Media_Parent.MediaTitle
		,Media.MediaTitle
end
