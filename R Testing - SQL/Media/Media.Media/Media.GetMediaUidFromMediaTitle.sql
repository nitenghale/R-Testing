create function Media.GetMediaUidFromMediaTitle (@mediaTitle nvarchar(100))
	returns uniqueidentifier
as
begin
	declare @mediaUid uniqueidentifier

	set @mediaUid = (select MediaUid from Media.Media where MediaTitle = @mediaTitle)

	return @mediaUid
end
