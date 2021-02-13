create table Maintenance.Media_Episode
(
	MaintenanceDateTime datetime2 not null
	,EpisodeUid uniqueidentifier not null
	,MaintenanceType char(1) not null
	,MaintenanceUser nvarchar(50) not null
	,SeriesUid_Before uniqueidentifier null
	,SeriesUid_After uniqueidentifier null
	,SeriesTitle_Before nvarchar(100) null
	,SeriesTitle_After nvarchar(100) null
	,SeriesYear_Before smallint null
	,SeriesYear_After smallint null
	,SeasonNumber_Before tinyint null
	,SeasonNumber_After tinyint null
	,EpisodeNumber_Before smallint null
	,EpisodeNumber_After smallint null
	,EpisodeTitle_Before nvarchar(100) null
	,EpisodeTitle_After nvarchar(100) null
	,OriginalAirDate_Before date null
	,OriginalAirDate_After date null
	,Synopsis_Before nvarchar(max) null
	,Synopsis_After nvarchar(max) null
)
go

alter table Maintenance.Media_Episode add constraint PK_Media_Episode primary key clustered (MaintenanceDateTime, EpisodeUid)
go

alter table Maintenance.Media_Episode add constraint DF_Media_Episode_MaintenanceDateTime default (getdate()) for MaintenanceDateTime
go

alter table Maintenance.Media_Episode add constraint DF_Media_Episode_MaintenanceUser default (system_user) for MaintenanceUser
go

grant select, insert on Maintenance.Media_Episode to RTesting
go

deny update, delete on Maintenance.Media_Episode to RTesting
go
