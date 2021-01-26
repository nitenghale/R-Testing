create trigger Media.Media_Delete
	on Media.Media
	after delete
as
begin
	set nocount on

	insert into Maintenance.Media_Media
	(
		MediaUid
		,MaintenanceType
		,MediaTitle_Before
		,MediaTypeId_Before
		,MediaType_Before
		,NetworkId_Before
		,NetworkName_Before
		,ParentMediaUid_Before
		,ParentMediaTitle_Before
	)
	select
		MediaUid
		,'D'
		,MediaTitle
		,deleted.MediaTypeId
		,MediaType
		,deleted.NetworkId
		,NetworkName
		,deleted.ParentMediaUid
		,Media.MediaTitle
	from deleted
		left join Reference.MediaType
			on deleted.MediaTypeId = MediaType.MediaTypeId
		left join Reference.Network
			on deleted.NetworkId = Network.NetworkId
		left join Media.Media
			on deleted.ParentMediaUid = Media.MediaUid
end
