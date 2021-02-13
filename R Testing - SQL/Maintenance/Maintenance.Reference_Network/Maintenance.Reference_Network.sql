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
go

alter table Maintenance.Reference_Network add constraint PK_Reference_Network primary key clustered (MaintenanceDateTime, NetworkId)
go

alter table Maintenance.Reference_Network add constraint DF_Reference_Network_MaintenanceDateTime default (getdate()) for MaintenanceDateTime
go

alter table Maintenance.Reference_Network add constraint DF_Reference_Network_MaintenanceUser default (system_user) for MaintenanceUser
go

grant select, insert on Maintenance.Reference_Network to RTesting
go

deny update, delete on Maintenance.Reference_Network to RTesting
go
