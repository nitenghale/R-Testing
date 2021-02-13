create function Reference.GetMediaTypeIdFromMediaType (@mediaType nvarchar(20))
	returns tinyint
as
begin
	declare @mediaTypeId tinyint

	set @mediaTypeId = (select MediaTypeId from Reference.MediaType where MediaType = @mediaType)

	return @mediaTypeId
end
go

grant execute on Reference.GetMediaTypeIdFromMediaType to RTesting
go
