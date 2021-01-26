create trigger Reference.Network_Update
	on Reference.Network
	after update
as
begin
	set nocount on

	insert into Maintenance.Reference_Network
	(
		NetworkId
		,MaintenanceType
		,NetworkAbbreviation_Before
		,NetworkAbbreviation_After
		,NetworkName_Before
		,NetworkName_After
		,ChannelNumber_Before
		,ChannelNumber_After
	)
	select
		deleted.NetworkId
		,'U'
		,deleted.NetworkAbbreviation
		,inserted.NetworkAbbreviation
		,deleted.NetworkName
		,inserted.NetworkName
		,deleted.ChannelNumber
		,inserted.ChannelNumber
	from deleted
		left join inserted
			on deleted.NetworkId = inserted.NetworkId
end
