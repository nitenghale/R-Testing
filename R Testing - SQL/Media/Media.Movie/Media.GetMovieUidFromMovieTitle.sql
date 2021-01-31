create function Media.GetMovieUidFromMovieTitle (@movieTitle nvarchar(107))
	returns uniqueidentifier
as
begin
	declare @movieUid uniqueidentifier
	declare @movieYear nvarchar(7)

	set @movieYear = trim(right(@movieTitle, 7))
	set @movieYear = replace(@movieYear, '(', '')
	set @movieYear = replace(@movieYear, ')', '')

	set @movieTitle = trim(left(@movieTitle, len(@movieTitle) - 7))

	set @movieUid = (
		select MovieUid 
		from Media.Movie
		where
			Movie.MovieTitle = @movieTitle
			and year(ReleaseDate) = cast(@movieYear as smallint))

	return @movieUid
end
