create table Maintenance.Reference_MediaAttributeType
(
	MaintenanceDateTime datetime2 not null
	,MediaAttributeTypeId smallint not null
	,MaintenanceType char(1) not null
	,MaintenanceUser nvarchar(50) not null
	,MediaAttributeType_Before nvarchar(20) null
	,MediaAttributeType_After nvarchar(20) null
	,MediaAttributeDescription_Before nvarchar(100) null
	,MediaAttributeDescription_After nvarchar(100) null
	,MediaAttributeRepeatable_Before bit null
	,MediaAttributeRepeatable_After bit null
)
go

alter table Maintenance.Reference_MediaAttributeType add constraint PK_Reference_MediaAttributeType primary key clustered (MaintenanceDateTime, MediaAttributeTypeId)
go

alter table Maintenance.Reference_MediaAttributeType add constraint DF_Reference_MediaAttributeType_MaintenanceDateTime default (getdate()) for MaintenanceDateTime
go

alter table Maintenance.Reference_MediaAttributeType add constraint DF_Reference_MediaAttributeType_MaintenanceUser default (system_user) for MaintenanceUser
go

grant select, insert on Maintenance.Reference_MediaAttributeType to RTesting
go

deny update, delete on Maintenance.Reference_MediaAttributeType to RTesting
go
