create trigger Media.Media_Update
	on Media.Media
	after update
as
begin
	set nocount on

	insert into Maintenance.Media_Media
	(
		MediaUid
		,MaintenanceType
		,MediaTitle_Before
		,MediaTitle_After
		,MediaTypeId_Before
		,MediaTypeId_After
		,MediaType_Before
		,MediaType_After
		,NetworkId_Before
		,NetworkId_After
		,NetworkName_Before
		,NetworkName_After
		,ParentMediaUid_Before
		,ParentMediaUid_After
		,ParentMediaTitle_Before
		,ParentMediaTitle_After
	)
	select
		deleted.MediaUid
		,'U'
		,deleted.MediaTitle
		,inserted.MediaTitle
		,deleted.MediaTypeId
		,inserted.MediaTypeId
		,MediaType_deleted.MediaType
		,MediaType_inserted.MediaType
		,deleted.NetworkId
		,inserted.NetworkId
		,Network_deleted.NetworkName
		,Network_inserted.NetworkName
		,deleted.ParentMediaUid
		,inserted.ParentMediaUid
		,Media_deleted.MediaTitle
		,Media_inserted.MediaTitle
	from deleted
		left join Reference.MediaType as MediaType_deleted
			on deleted.MediaTypeId = MediaType_deleted.MediaTypeId
		left join Reference.Network as Network_deleted
			on deleted.NetworkId = Network_deleted.NetworkId
		left join Media.Media as Media_deleted
			on deleted.ParentMediaUid = Media_deleted.MediaUid
		left join inserted
			on deleted.MediaUid = inserted.MediaUid
		left join Reference.MediaType as MediaType_inserted
			on inserted.MediaTypeId = MediaType_inserted.MediaTypeId
		left join Reference.Network as Network_inserted
			on inserted.NetworkId = Network_inserted.NetworkId
		left join Media.Media as Media_inserted
			on inserted.ParentMediaUid = Media_inserted.ParentMediaUid
end
