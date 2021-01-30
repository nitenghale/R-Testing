create table Media.PlaylistMedia
(
	PlaylistMediaId bigint identity(1,1) not null
	,PlaylistId smallint not null
	,MediaReferenceUid uniqueidentifier not null
	,MediaTypeId tinyint not null
	,PlaylistSequence smallint not null
	,LastMaintenanceDateTime datetime not null
	,LastMaintenanceUser nvarchar(50) not null
)
go

alter table Media.PlaylistMedia add constraint PK_PlaylistMedia primary key clustered (PlaylistMediaId)
go

alter table Media.PlaylistMedia add constraint FK_PlaylistMedia_Playlist foreign key (PlaylistId) references Media.Playlist (PlaylistId)
go

alter table Media.PlaylistMedia add constraint FK_PlaylistMedia_MediaType foreign key (MediaTypeId) references Reference.MediaType (MediaTypeId)
go

alter table Media.PlaylistMedia add constraint DF_PlaylistMedia_LastMaintenanceDateTime default (getdate()) for LastMaintenanceDateTime
go

alter table Media.PlaylistMedia add constraint DF_PlaylistMedia_LastMaintenanceUser default (system_user) for LastMaintenanceUser
go

create trigger Media.PlaylistMedia_Insert
	on Media.PlaylistMedia
	after insert
as
begin
	set nocount on

	insert into Maintenance.Media_PlaylistMedia
	(
		PlaylistMediaId
		,MaintenanceType
		,PlaylistId_After
		,PlaylistName_After
		,MediaReferenceUid_After
		,MediaTitle_After
		,MediaTypeId_After
		,MediaType_After
		,PlaylistSequence_After
	)
	select
		PlaylistMediaId
		,'I'
		,inserted.PlaylistId
		,Playlist.PlaylistName
		,inserted.MediaReferenceUid
		,case
			when Episode.EpisodeTitle is not null then
				Series_Episode.SeriesTitle + 
				' (' + cast(Series_Episode.SeriesYear as varchar(5)) + ')' +
				' - S' + format(Episode.SeasonNumber, '000') + 
				'E' + format(Episode.EpisodeNumber, '000') +
				' - ' + Episode.EpisodeTitle
			when Series.SeriesTitle is not null then
				Series.SeriesTitle + 
				' (' + cast(Series.SeriesYear as varchar(5)) + ')'
			when Movie.MovieTitle is not null then
				Movie.MovieTitle +
				' (' + cast(year(Movie.ReleaseDate) as varchar(4)) + ')'
			else ''
		end
		,inserted.MediaTypeId
		,MediaType.MediaType
		,PlaylistSequence
	from inserted
		left join Media.Playlist
			on inserted.PlaylistId = Playlist.PlaylistId
		left join Reference.MediaType
			on inserted.MediaTypeId = MediaType.MediaTypeId
		left join Media.Episode
			on inserted.MediaReferenceUid = Episode.EpisodeUid
		left join Media.Series as Series_Episode
			on Episode.SeriesUid = Series_Episode.SeriesUid
		left join Media.Series
			on inserted.MediaReferenceUid = Series.SeriesUid
		left join Media.Movie
			on inserted.MediaReferenceUid = Movie.MovieUid
end
go

create trigger Media.PlaylistMedia_Update
	on Media.PlaylistMedia
	after update
as
begin
	set nocount on

	insert into Maintenance.Media_PlaylistMedia
	(
		PlaylistMediaId
		,MaintenanceType
		,PlaylistId_Before
		,PlaylistId_After
		,PlaylistName_Before
		,PlaylistName_After
		,MediaReferenceUid_Before
		,MediaReferenceUid_After
		,MediaTitle_Before
		,MediaTitle_After
		,MediaTypeId_Before
		,MediaTypeId_After
		,MediaType_Before
		,MediaType_After
		,PlaylistSequence_Before
		,PlaylistSequence_After
	)
	select
		deleted.PlaylistMediaId
		,'I'
		,deleted.PlaylistId
		,inserted.PlaylistId
		,Playlist_deleted.PlaylistName
		,Playlist_inserted.PlaylistName
		,deleted.MediaReferenceUid
		,inserted.MediaReferenceUid
		,case
			when Episode_deleted.EpisodeTitle is not null then
				Series_Episode_deleted.SeriesTitle + 
				' (' + cast(Series_Episode_deleted.SeriesYear as varchar(5)) + ')' +
				' - S' + format(Episode_deleted.SeasonNumber, '000') + 
				'E' + format(Episode_deleted.EpisodeNumber, '000') +
				' - ' + Episode_deleted.EpisodeTitle
			when Series_deleted.SeriesTitle is not null then
				Series_deleted.SeriesTitle + 
				' (' + cast(Series_deleted.SeriesYear as varchar(5)) + ')'
			when Movie_deleted.MovieTitle is not null then
				Movie_deleted.MovieTitle +
				' (' + cast(year(Movie_deleted.ReleaseDate) as varchar(4)) + ')'
			else ''
		end
		,case
			when Episode_inserted.EpisodeTitle is not null then
				Series_Episode_inserted.SeriesTitle + 
				' (' + cast(Series_Episode_inserted.SeriesYear as varchar(5)) + ')' +
				' - S' + format(Episode_inserted.SeasonNumber, '000') + 
				'E' + format(Episode_inserted.EpisodeNumber, '000') +
				' - ' + Episode_inserted.EpisodeTitle
			when Series_inserted.SeriesTitle is not null then
				Series_inserted.SeriesTitle + 
				' (' + cast(Series_inserted.SeriesYear as varchar(5)) + ')'
			when Movie_inserted.MovieTitle is not null then
				Movie_inserted.MovieTitle +
				' (' + cast(year(Movie_inserted.ReleaseDate) as varchar(4)) + ')'
			else ''
		end
		,deleted.MediaTypeId
		,inserted.MediaTypeId
		,MediaType_deleted.MediaType
		,MediaType_inserted.MediaType
		,deleted.PlaylistSequence
		,inserted.PlaylistSequence
	from deleted
		left join Media.Playlist as Playlist_deleted
			on inserted.PlaylistId = Playlist_deleted.PlaylistId
		left join Reference.MediaType as MediaType_deleted
			on inserted.MediaTypeId = MediaType_deleted.MediaTypeId
		left join Media.Episode as Episode_deleted
			on inserted.MediaReferenceUid = Episode_deleted.EpisodeUid
		left join Media.Series as Series_Episode_deleted
			on Episode_deleted.SeriesUid = Series_Episode_deleted.SeriesUid
		left join Media.Series as Series_deleted
			on inserted.MediaReferenceUid = Series_deleted.SeriesUid
		left join Media.Movie as Movie_deleted
			on inserted.MediaReferenceUid = Movie_deleted.MovieUid
		left join inserted
			on deleted.PlaylistMediaId = inserted.PlaylistMediaId
		left join Media.Playlist as Playlist_inserted
			on inserted.PlaylistId = Playlist_inserted.PlaylistId
		left join Reference.MediaType as MediaType_inserted
			on inserted.MediaTypeId = MediaType_inserted.MediaTypeId
		left join Media.Episode as Episode_inserted
			on inserted.MediaReferenceUid = Episode_inserted.EpisodeUid
		left join Media.Series as Series_Episode_inserted
			on Episode_inserted.SeriesUid = Series_Episode_inserted.SeriesUid
		left join Media.Series as Series_inserted
			on inserted.MediaReferenceUid = Series_inserted.SeriesUid
		left join Media.Movie as Movie_inserted
			on inserted.MediaReferenceUid = Movie_inserted.MovieUid
end
go

create trigger Media.PlaylistMedia_Delete
	on Media.PlaylistMedia
	after delete
as
begin
	set nocount on

	insert into Maintenance.Media_PlaylistMedia
	(
		PlaylistMediaId
		,MaintenanceType
		,PlaylistId_Before
		,PlaylistName_Before
		,MediaReferenceUid_Before
		,MediaTitle_Before
		,MediaTypeId_Before
		,MediaType_Before
		,PlaylistSequence_Before
	)
	select
		PlaylistMediaId
		,'I'
		,deleted.PlaylistId
		,Playlist.PlaylistName
		,deleted.MediaReferenceUid
		,case
			when Episode.EpisodeTitle is not null then
				Series_Episode.SeriesTitle + 
				' (' + cast(Series_Episode.SeriesYear as varchar(5)) + ')' +
				' - S' + format(Episode.SeasonNumber, '000') + 
				'E' + format(Episode.EpisodeNumber, '000') +
				' - ' + Episode.EpisodeTitle
			when Series.SeriesTitle is not null then
				Series.SeriesTitle + 
				' (' + cast(Series.SeriesYear as varchar(5)) + ')'
			when Movie.MovieTitle is not null then
				Movie.MovieTitle +
				' (' + cast(year(Movie.ReleaseDate) as varchar(4)) + ')'
			else ''
		end
		,deleted.MediaTypeId
		,MediaType.MediaType
		,PlaylistSequence
	from deleted
		left join Media.Playlist
			on deleted.PlaylistId = Playlist.PlaylistId
		left join Reference.MediaType
			on deleted.MediaTypeId = MediaType.MediaTypeId
		left join Media.Episode
			on deleted.MediaReferenceUid = Episode.EpisodeUid
		left join Media.Series as Series_Episode
			on Episode.SeriesUid = Series_Episode.SeriesUid
		left join Media.Series
			on deleted.MediaReferenceUid = Series.SeriesUid
		left join Media.Movie
			on deleted.MediaReferenceUid = Movie.MovieUid
end
go
