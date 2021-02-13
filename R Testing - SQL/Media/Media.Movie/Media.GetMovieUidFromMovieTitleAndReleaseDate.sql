create function Media.GetMovieUidFromMovieTitleAndReleaseDate (@movieTitle nvarchar(100), @releaseDate date)
	returns uniqueidentifier
as
begin
	 declare @movieUid uniqueidentifier

	 set @movieUid = (select MovieUid from Media.Movie where MovieTitle = @movieTitle and ReleaseDate = @releaseDate)

	 return @movieUid
end
go

grant execute on Media.GetMovieUidFromMovieTitleAndReleaseDate to RTesting
go
