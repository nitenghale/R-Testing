alter table Reference.MediaType add constraint DF_MediaType_LastMaintenanceDateTime default (getdate()) for LastMaintenanceDateTime
