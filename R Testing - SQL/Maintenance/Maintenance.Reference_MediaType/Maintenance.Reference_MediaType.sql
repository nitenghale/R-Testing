create table Maintenance.Reference_MediaType
(
	MaintenanceDateTime datetime2 not null
	,MediaTypeId tinyint not null
	,MaintenanceType char(1) not null
	,MaintenanceUser nvarchar(50) not null
	,MediaType_Before nvarchar(20) null
	,MediaType_After nvarchar(20) null
	,MediaTypeDescription_Before nvarchar(100) null
	,MediaTypeDescrption_After nvarchar(100) null
)
go

alter table Maintenance.Reference_MediaType add constraint PK_Reference_MediaType primary key clustered (MaintenanceDateTime, MediaTypeId)
go

alter table Maintenance.Reference_MediaType add constraint DF_Reference_MediaType_MaintenanceDateTime default (getdate()) for MaintenanceDateTime
go

alter table Maintenance.Reference_MediaType add constraint DF_Reference_MediaType_MaintenanceUser default (system_user) for MaintenanceUser
go

grant select, insert on Maintenance.Reference_MediaType to RTesting
go

deny update, delete on Maintenance.Reference_MediaType to RTesting
go
