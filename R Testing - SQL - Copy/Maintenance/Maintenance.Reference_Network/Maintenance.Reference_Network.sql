create table Maintenance.Reference_Network
(
	MaintenanceDateTime datetime2(7) not null
	,NetworkId smallint not null
	,MaintenanceType char(1) not null
	,MaintenanceUser nvarchar(50) not null
	,NetworkAbbreviation_Before nvarchar(10) null
	,NetworkAbbreviation_After nvarchar(10) null
	,NetworkName_Before nvarchar(50) null
	,NetworkName_After nvarchar(50) null
	,ChannelNumber_Before decimal(7, 2) null
	,ChannelNumber_After decimal(7, 2) null
)
