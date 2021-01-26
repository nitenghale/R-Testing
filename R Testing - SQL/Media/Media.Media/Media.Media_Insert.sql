create trigger Media.Media_Insert
	on Media.Media
	after insert
as
begin
	set nocount on

	insert into Maintenance.Media_Media
	(
		MediaUid
		,MaintenanceType
		,MediaTitle_After
		,MediaTypeId_After
		,MediaType_After
		,NetworkId_After
		,NetworkName_After
		,ParentMediaUid_After
		,ParentMediaTitle_After
	)
	select
		MediaUid
		,'I'
		,MediaTitle
		,inserted.MediaTypeId
		,MediaType
		,inserted.NetworkId
		,NetworkName
		,inserted.ParentMediaUid
		,Media.MediaTitle
	from inserted
		left join Reference.MediaType
			on inserted.MediaTypeId = MediaType.MediaTypeId
		left join Reference.Network
			on inserted.NetworkId = Network.NetworkId
		left join Media.Media
			on inserted.ParentMediaUid = Media.MediaUid
end
go
