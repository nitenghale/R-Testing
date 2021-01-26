create trigger Reference.Network_Delete
	on Reference.Network
	after delete
as
begin
	set nocount on

	insert into Maintenance.Reference_Network
	(
		NetworkId
		,MaintenanceType
		,NetworkAbbreviation_Before
		,NetworkName_Before
		,ChannelNumber_Before
	)
	select
		NetworkId
		,'D'
		,NetworkAbbreviation
		,NetworkName
		,ChannelNumber
	from deleted
end
