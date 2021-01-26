alter table Maintenance.Reference_Network add constraint DF_Reference_Network_MaintenanceDateTime default (getdate()) for MaintenanceDateTime
