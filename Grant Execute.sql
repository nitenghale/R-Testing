exec Reference.BrowseNetworks

select * from Media.Movie

print newid()
print newid()
print newid()

exec sp_who2

grant execute on Reference.BrowseNetworks to RTesting
grant execute on Reference.AddNetwork to RTesting
grant execute on Reference.UpdateNetwork to RTesting
grant insert, update, delete on Reference.Network to RTesting

grant execute on Reference.BrowseStatusCodes to RTesting
grant execute on Reference.AddStatusCode to RTesting
grant insert, update, delete on Reference.StatusCode to RTesting

grant execute on Media.BrowseMovies to RTesting
grant execute on Media.AddMovie to RTesting
grant insert, update, delete on Media.Movie to RTesting

grant execute on Reference.ListNetworks to RTesting

select * from Activity.ActivityLog order by ActivityDateTime desc

--kill 73

--delete from Reference.Network where NetworkId > 1
--delete from Media.Movie

exec Reference.BrowseStatusCodes

select * from Maintenance.Reference_Network

exec Media.BrowseMovies

exec Reference.ListNetworks

--exec Reference.AddNetwork @networkName = 'NP Test 3'

select * from Media.Series

exec Media.BrowseSeries

grant execute on Media.BrowseSeries to RTesting
grant insert, update, delete on Media.Series to RTesting
grant execute on Media.AddSeries to RTesting
grant execute on Media.ListSeries to RTesting

exec Media.BrowseEpisodes @seriesTitle = 'Testing 2', @seriesYear = 2021

grant execute on Media.BrowseEpisodes to RTesting
grant insert, update, delete on Media.Episode to RTesting
grant execute on Media.AddEpisode to RTesting
