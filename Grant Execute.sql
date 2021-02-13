print newid()
print newid()
print newid()

select * from Activity.ActivityLog order by ActivityDateTime desc

exec sp_who2
--kill 73

-- Reference.Network
grant execute on Reference.BrowseNetworks to RTesting
grant execute on Reference.AddNetwork to RTesting
grant execute on Reference.UpdateNetwork to RTesting
grant execute on Reference.ListNetworks to RTesting
grant insert, update, delete on Reference.Network to RTesting

--delete from Reference.Network
exec Reference.ListNetworks

-- Reference.StatusCode
grant execute on Reference.BrowseStatusCodes to RTesting
grant execute on Reference.AddStatusCode to RTesting
grant execute on Reference.UpdateStatusCode to RTesting
grant insert, update, delete on Reference.StatusCode to RTesting

exec Reference.BrowseStatusCodes

-- Media.Movie
grant execute on Media.BrowseMovies to RTesting
grant execute on Media.AddMovie to RTesting
grant execute on Media.UpdateMovie to RTesting
grant insert, update, delete on Media.Movie to RTesting

exec Media.BrowseMovies
--delete from Media.Movie

-- Media.Series
grant execute on Media.BrowseSeries to RTesting
grant insert, update, delete on Media.Series to RTesting
grant execute on Media.AddSeries to RTesting
grant execute on Media.ListSeries to RTesting
grant execute on Media.UpdateSeries to RTesting

exec Media.BrowseSeries

-- Media.Episode
grant execute on Media.BrowseEpisodes to RTesting
grant insert, update, delete on Media.Episode to RTesting
grant execute on Media.AddEpisode to RTesting

select * from Media.PlaylistMedia
