create table Maintenance.Media_PlaylistMedia
(
	MaintenanceDateTime datetime2 not null
	,PlaylistMediaId bigint not null
	,MaintenanceType char(1) not null
	,MaintenanceUser nvarchar(50) not null
	,PlaylistId_Before smallint null
	,PlaylistId_After smallint null
	,PlaylistName_Before nvarchar(50) null
	,PlaylistName_After nvarchar(50) null
	,MediaReferenceUid_Before uniqueidentifier null
	,MediaReferenceUid_After uniqueidentifier null
	,MediaTitle_Before nvarchar(225)  null
	,MediaTitle_After nvarchar(107) null
	,MediaTypeId_Before tinyint null
	,MediaTypeId_After tinyint null
	,MediaType_Before nvarchar(20) null
	,MediaType_After nvarchar(20) null
	,PlaylistSequence_Before smallint null
	,PlaylistSequence_After smallint null
)
go

alter table Maintenance.Media_PlaylistMedia add constraint PK_Media_PlaylistMedia primary key clustered (MaintenanceDateTime, PlaylistMediaId)
go

alter table Maintenance.Media_PlaylistMedia add constraint DF_Media_PlaylistMedia_MaintenanceDateTime default (getdate()) for MaintenanceDateTime
go

alter table Maintenance.Media_PlaylistMedia add constraint DF_Media_PlaylistMedia_MaintenanceUser default (system_user) for MaintenanceUser
go

grant select, insert on Maintenance.Media_PlaylistMedia to RTesting
go

deny update, delete on Maintenance.Media_PlaylistMedia to RTesting
go
