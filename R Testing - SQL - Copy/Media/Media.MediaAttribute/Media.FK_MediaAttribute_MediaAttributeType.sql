﻿alter table Media.MediaAttribute add constraint FK_MediaAttribute_MediaAttributeType foreign key (MediaAttributeTypeId) references Reference.MediaAttributeType (MediaAttributeTypeId)