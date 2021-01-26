create table Reference.Network
(
	NetworkId smallint identity(1,1) not null
	,NetworkAbbreviation nvarchar(10) null
	,NetworkName nvarchar(50) null
	,ChannelNumber decimal(7, 2) null
	,LastMaintenanceDateTime datetime not null
	,LastMaintenanceUser nvarchar(50) not null
)