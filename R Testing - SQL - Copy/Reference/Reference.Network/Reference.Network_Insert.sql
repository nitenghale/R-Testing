create trigger Reference.Network_Insert
	on Reference.Network
	after insert
as
begin
	set nocount on

	insert into Maintenance.Reference_Network
	(
		NetworkId
		,MaintenanceType
		,NetworkAbbreviation_After
		,NetworkName_After
		,ChannelNumber_After
	)
	select
		NetworkId
		,'I'
		,NetworkAbbreviation
		,NetworkName
		,ChannelNumber
	from inserted
end
