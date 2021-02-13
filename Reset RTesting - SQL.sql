use [master]
go

if exists(select 1 from sys.databases where name = N'RTesting')
begin
	alter database RTesting set single_user with rollback immediate
	drop database RTesting
end
go

if exists(select 1 from sys.sql_logins where name = N'RTesting')
begin
	drop login RTesting
end
go

if not exists(select 1 from sys.databases where name = N'RTesting')
	create database RTesting
go
