create table Maintenance.Reference_StatusCode
(
	MaintenanceDateTime datetime2 not null
	,StatusCodeId tinyint not null
	,MaintenanceType char(1) not null
	,MaintenanceUser nvarchar(50) not null
	,StatusCode_Before nvarchar(20) null
	,StatusCode_After nvarchar(20) null
	,StatusDescription_Before nvarchar(100) null
	,StatusDescription_After nvarchar(100) null
)
go

alter table Maintenance.Reference_StatusCode add constraint PK_Reference_StatusCode primary key clustered (MaintenanceDateTime, StatusCodeId)
go

alter table Maintenance.Reference_StatusCode add constraint DF_Reference_StatusCode_MaintenanceDateTime default (getdate()) for MaintenanceDateTime
go

alter table Maintenance.Reference_StatusCode add constraint DF_Reference_StatusCode_MaintenanceUser default (system_user) for MaintenanceUser
go

grant select, insert on Maintenance.Reference_StatusCode to RTesting
go

deny update, delete on Maintenance.Reference_StatusCode to RTesting
go
