create table Maintenance.Media_Series
(
	MaintenanceDateTime datetime2 not null
	,SeriesUid uniqueidentifier not null
	,MaintenanceType char(1) not null
	,MaintenanceUser nvarchar(50) not null
	,SeriesTitle_Before nvarchar(100) null
	,SeriesTitle_After nvarchar(100) null
	,SeriesYear_Before smallint null
	,SeriesYear_After smallint null
	,NetworkId_Before smallint null
	,NetworkId_After smallint null
	,NetworkName_Before nvarchar(50) null
	,NetworkName_After nvarchar(50) null
	,SeriesDescription_Before nvarchar(max) null
	,SeriesDescription_After nvarchar(max) null
)
go

alter table Maintenance.Media_Series add constraint PK_Media_Series primary key clustered (MaintenanceDateTime, SeriesUid)
go

alter table Maintenance.Media_Series add constraint DF_Media_Series_MaintenanceDateTime default (getdate()) for MaintenanceDateTime
go

alter table Maintenance.Media_Series add constraint DF_Media_Series_MaintenanceUser default (system_user) for MaintenanceUser
go

grant select, insert on Maintenance.Media_Series to RTesting
go

deny update, delete on Maintenance.Media_Series to RTesting
go
