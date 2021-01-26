create function Reference.GetMediaAttributeTypeIdFromMediaAttributeType (@mediaAttributeType nvarchar(20))
	returns smallint
as
begin
	declare @mediaAttributeTypeId smallint

	set @mediaAttributeTypeId = (select MediaAttributeTypeId from Reference.MediaAttributeType where MediaAttributeType = @mediaAttributeType)

	return @mediaAttributeTypeId
end
