create table Maintenance.Media_Movie
(
	MaintenanceDateTime datetime2 not null
	,MovieUid uniqueidentifier not null
	,MaintenanceType char(1) not null
	,MaintenanceUser nvarchar(50) not null
	,MovieTitle_Before nvarchar(100) null
	,MovieTitle_After nvarchar(100) null
	,ReleaseDate_Before date null
	,ReleaseDate_After date null
	,NetworkId_Before smallint null
	,NetworkId_After smallint null
	,NetworkName_Before nvarchar(50) null
	,NetworkName_After nvarchar(50) null
	,Synopsis_Before nvarchar(max) null
	,Synopsis_After nvarchar(max) null
)
go

alter table Maintenance.Media_Movie add constraint PK_Media_Movie primary key clustered (MaintenanceDateTime, MovieUid)
go

alter table Maintenance.Media_Movie add constraint DF_Media_Movie_MaintenanceDateTime default (getdate()) for MaintenanceDateTime
go

alter table Maintenance.Media_Movie add constraint DF_Media_Movie_MaintenanceUser default (system_user) for MaintenanceUser
go

grant select, insert on Maintenance.Media_Movie to RTesting
go

deny update, delete on Maintenance.Media_Movie to RTesting
go
