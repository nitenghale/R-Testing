﻿create procedure Media.DeleteMedia
	@mediaUid uniqueidentifier
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@mediaUid = ||' + isnull(@mediaUid, 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	delete from Media.Media
	where MediaUid = @mediaUid
end
