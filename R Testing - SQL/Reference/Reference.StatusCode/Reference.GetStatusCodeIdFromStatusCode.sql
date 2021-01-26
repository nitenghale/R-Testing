create function Reference.GetStatusCodeIdFromStatusCode (@statusCode nvarchar(20))
	returns tinyint
as
begin
	declare @statusCodeId tinyint

	set @statusCodeId = (select StatusCodeId from Reference.StatusCode where StatusCode = @statusCode)

	return @statusCodeId
end
