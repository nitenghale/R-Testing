﻿alter table Media.Media add constraint FK_Media_Network foreign key (NetworkId) references Reference.Network (NetworkId)