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

create unique nonclustered index IX_Episode_Series_Season_Episode on Media.Episode (SeriesUid, SeasonNumber, EpisodeNumber) on IndexData
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

grant select, insert, update, delete on Media.Episode to RTesting
go

create trigger Media.Episode_Insert
	on Media.Episode
	after insert
as
begin
	set nocount on

	insert into Maintenance.Media_Episode
	(
		EpisodeUid
		,MaintenanceType
		,SeriesUid_After
		,SeriesTitle_After
		,SeriesYear_After
		,SeasonNumber_After
		,EpisodeNumber_After
		,EpisodeTitle_After
		,OriginalAirDate_After
		,Synopsis_After
	)
	select
		EpisodeUid
		,'I'
		,inserted.SeriesUid
		,Series.SeriesTitle
		,Series.SeriesYear
		,SeasonNumber
		,EpisodeNumber
		,EpisodeTitle
		,OriginalAirDate
		,Synopsis
	from inserted
		left join Media.Series
			on inserted.SeriesUid = Series.SeriesUid
end
go

create trigger Media.Episode_Update
	on Media.Episode
	after update
as
begin
	set nocount on

	insert into Maintenance.Media_Episode
	(
		EpisodeUid
		,MaintenanceType
		,SeriesUid_Before
		,SeriesUid_After
		,SeriesTitle_Before
		,SeriesTitle_After
		,SeriesYear_Before
		,SeriesYear_After
		,SeasonNumber_Before
		,SeasonNumber_After
		,EpisodeNumber_Before
		,EpisodeNumber_After
		,EpisodeTitle_Before
		,EpisodeTitle_After
		,OriginalAirDate_Before
		,OriginalAirDate_After
		,Synopsis_Before
		,Synopsis_After
	)
	select
		deleted.EpisodeUid
		,'U'
		,deleted.SeriesUid
		,inserted.SeriesUid
		,Series_deleted.SeriesTitle
		,Series_inserted.SeriesTitle
		,Series_deleted.SeriesYear
		,Series_inserted.SeriesYear
		,deleted.SeasonNumber
		,inserted.SeasonNumber
		,deleted.EpisodeNumber
		,inserted.EpisodeNumber
		,deleted.EpisodeTitle
		,inserted.EpisodeTitle
		,deleted.OriginalAirDate
		,inserted.OriginalAirDate
		,deleted.Synopsis
		,inserted.Synopsis
	from deleted
		left join Media.Series as Series_deleted
			on deleted.SeriesUid = Series_deleted.SeriesUid
		left join inserted
			on deleted.EpisodeUid = inserted.EpisodeUid
		left join Media.Series as Series_inserted
			on inserted.SeriesUid = Series_inserted.SeriesUid
end
go

create trigger Media.Episode_Deleted
	on Media.Episode
	after delete
as
begin
	set nocount on

	insert into Maintenance.Media_Episode
	(
		EpisodeUid
		,MaintenanceType
		,SeriesUid_Before
		,SeriesTitle_Before
		,SeriesYear_Before
		,SeasonNumber_Before
		,EpisodeNumber_Before
		,EpisodeTitle_Before
		,OriginalAirDate_Before
		,Synopsis_Before
	)
	select
		EpisodeUid
		,'D'
		,deleted.SeriesUid
		,Series.SeriesTitle
		,Series.SeriesYear
		,SeasonNumber
		,EpisodeNumber
		,EpisodeTitle
		,OriginalAirDate
		,Synopsis
	from deleted
		left join Media.Series
			on deleted.SeriesUid = Series.SeriesUid
end
go
