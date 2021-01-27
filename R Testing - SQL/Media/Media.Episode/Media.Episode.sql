create table Media.Episode
(
	EpisodeUid uniqueidentifier not null
	,SeriesUid uniqueidentifier not null
	,SeasonNumber tinyint not null
	,EpisodeNumber smallint not null
	,EpisodeTitle nvarchar(100) null
	,OriginalAirDate date null
	,Synopsis nvarchar(max) null
	,AddDateTime datetime2 not null
	,LastMaintenanceDateTime datetime not null
	,LastMaintenanceUser nvarchar(50) not null
)
go

alter table Media.Episode add constraint PK_Episode primary key nonclustered (EpisodeUid)
go

create unique clustered index IX_Episode_AddDateTime on Media.Episode (AddDateTime, EpisodeUid)
go

create unique nonclustered index IX_Episode_Series_Season_Episode on Media.Episode (SeriesUid, SeasonNumber, EpisodeNumber)
go

alter table Media.Episode add constraint FK_Episode_Series foreign key (SeriesUid) references Media.Series (SeriesUid)
go

alter table Media.Episode add constraint DF_Episode_EpisodeUid default (newid()) for EpisodeUid
go

alter table Media.Episode add constraint DF_Episode_AddDateTime default (getdate()) for AddDateTime
go

alter table Media.Episode add constraint DF_Episode_LastMaintenanceDateTime default (getdate()) for LastMaintenanceDateTime
go

alter table Media.Episode add constraint DF_Episode_LastMaintenanceUser default (system_user) for LastMaintenanceUser
go
