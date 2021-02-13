create function Reference.GetNetworkIdFromNetworkName (@networkName nvarchar(50))
	returns smallint
as
begin
	declare @networkId smallint

	set @networkId = (select NetworkId from Reference.Network where NetworkName = @networkName)

	return @networkId
end
go

grant execute on Reference.GetNetworkIdFromNetworkName to RTesting
go
