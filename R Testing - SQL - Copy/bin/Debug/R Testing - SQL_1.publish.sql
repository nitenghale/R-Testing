﻿/*
Deployment script for RTesting

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "RTesting"
:setvar DefaultFilePrefix "RTesting"
:setvar DefaultDataPath "C:\SQL\Data\"
:setvar DefaultLogPath "C:\SQL\Logs\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'Rename refactoring operation with key 41219328-07e4-4f6a-9414-2aed5ee2137b is skipped, element [Reference].[MediaType].[LastMaintenaceDateTime] (SqlSimpleColumn) will not be renamed to LastMaintenanceDateTime';


GO
PRINT N'Creating [Activity]...';


GO
CREATE SCHEMA [Activity]
    AUTHORIZATION [dbo];


GO
PRINT N'Creating [Maintenance]...';


GO
CREATE SCHEMA [Maintenance]
    AUTHORIZATION [dbo];


GO
PRINT N'Creating [Reference]...';


GO
CREATE SCHEMA [Reference]
    AUTHORIZATION [dbo];


GO
PRINT N'Creating [Activity].[ActivityLog]...';


GO
CREATE TABLE [Activity].[ActivityLog] (
    [ActivityDateTime] DATETIME2 (7)  NOT NULL,
    [ActivityUser]     NVARCHAR (50)  NOT NULL,
    [ObjectName]       VARCHAR (150)  NOT NULL,
    [ObjectParameters] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_ActivityLog] PRIMARY KEY CLUSTERED ([ActivityDateTime] ASC)
);


GO
PRINT N'Creating [Activity].[ActivityLog].[IX_ActivityLog_ObjectName]...';


GO
CREATE NONCLUSTERED INDEX [IX_ActivityLog_ObjectName]
    ON [Activity].[ActivityLog]([ObjectName] ASC, [ActivityDateTime] ASC);


GO
PRINT N'Creating [Maintenance].[Reference_Network]...';


GO
CREATE TABLE [Maintenance].[Reference_Network] (
    [MaintenanceDateTime]        DATETIME2 (7)  NOT NULL,
    [NetworkId]                  SMALLINT       NOT NULL,
    [MaintenanceType]            CHAR (1)       NOT NULL,
    [MaintenanceUser]            NVARCHAR (50)  NOT NULL,
    [NetworkAbbreviation_Before] NVARCHAR (10)  NULL,
    [NetworkAbbreviation_After]  NVARCHAR (10)  NULL,
    [NetworkName_Before]         NVARCHAR (50)  NULL,
    [NetworkName_After]          NVARCHAR (50)  NULL,
    [ChannelNumber_Before]       DECIMAL (7, 2) NULL,
    [ChannelNumber_After]        DECIMAL (7, 2) NULL,
    CONSTRAINT [PK_Reference_Network] PRIMARY KEY CLUSTERED ([MaintenanceDateTime] ASC, [NetworkId] ASC)
);


GO
PRINT N'Creating [Maintenance].[Reference_Network].[IX_Reference_Network_NetworkId]...';


GO
CREATE NONCLUSTERED INDEX [IX_Reference_Network_NetworkId]
    ON [Maintenance].[Reference_Network]([NetworkId] ASC, [MaintenanceDateTime] ASC);


GO
PRINT N'Creating [Maintenance].[Reference_StatusCode]...';


GO
CREATE TABLE [Maintenance].[Reference_StatusCode] (
    [MaintenanceDateTime]      DATETIME2 (7)  NOT NULL,
    [StatusCodeId]             TINYINT        NOT NULL,
    [MaintenanceType]          CHAR (1)       NOT NULL,
    [MaintenanceUser]          NVARCHAR (50)  NOT NULL,
    [StatusCode_Before]        NVARCHAR (20)  NULL,
    [StatusCode_After]         NVARCHAR (20)  NULL,
    [StatusDescription_Before] NVARCHAR (100) NULL,
    [StatusDescription_After]  NVARCHAR (100) NULL,
    CONSTRAINT [PK_Reference_StatusCode] PRIMARY KEY CLUSTERED ([MaintenanceDateTime] ASC, [StatusCodeId] ASC)
);


GO
PRINT N'Creating [Maintenance].[Reference_MediaType]...';


GO
CREATE TABLE [Maintenance].[Reference_MediaType] (
    [MaintenanceDateTime]         DATETIME2 (7)  NOT NULL,
    [MediaTypeId]                 TINYINT        NOT NULL,
    [MaintenanceType]             CHAR (1)       NOT NULL,
    [MaintenanceUser]             NVARCHAR (50)  NOT NULL,
    [MediaType_Before]            NVARCHAR (20)  NULL,
    [MediaType_After]             NVARCHAR (20)  NULL,
    [MediaTypeDescription_Before] NVARCHAR (100) NULL,
    [MediaTypeDescrption_After]   NVARCHAR (100) NULL,
    CONSTRAINT [PK_Reference_MediaType] PRIMARY KEY CLUSTERED ([MaintenanceDateTime] ASC, [MediaTypeId] ASC)
);


GO
PRINT N'Creating [Reference].[Network]...';


GO
CREATE TABLE [Reference].[Network] (
    [NetworkId]               SMALLINT       IDENTITY (1, 1) NOT NULL,
    [NetworkAbbreviation]     NVARCHAR (10)  NULL,
    [NetworkName]             NVARCHAR (50)  NULL,
    [ChannelNumber]           DECIMAL (7, 2) NULL,
    [LastMaintenanceDateTime] DATETIME       NOT NULL,
    [LastMaintenanceUser]     NVARCHAR (50)  NOT NULL,
    CONSTRAINT [PK_Network] PRIMARY KEY CLUSTERED ([NetworkId] ASC)
);


GO
PRINT N'Creating [Reference].[Network].[IX_Network_NetworkName]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Network_NetworkName]
    ON [Reference].[Network]([NetworkName] ASC, [ChannelNumber] ASC);


GO
PRINT N'Creating [Reference].[StatusCode]...';


GO
CREATE TABLE [Reference].[StatusCode] (
    [StatusCodeId]            TINYINT        IDENTITY (1, 1) NOT NULL,
    [StatusCode]              NVARCHAR (20)  NOT NULL,
    [StatusDescription]       NVARCHAR (100) NULL,
    [LastMaintenanceDateTime] DATETIME       NOT NULL,
    [LastMaintenanceUser]     NVARCHAR (50)  NOT NULL,
    CONSTRAINT [PK_StatusCode] PRIMARY KEY CLUSTERED ([StatusCodeId] ASC)
);


GO
PRINT N'Creating [Reference].[StatusCode].[IX_StatusCode_StatusCode]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_StatusCode_StatusCode]
    ON [Reference].[StatusCode]([StatusCode] ASC);


GO
PRINT N'Creating [Reference].[MediaType]...';


GO
CREATE TABLE [Reference].[MediaType] (
    [MediaTypeId]             TINYINT        IDENTITY (1, 1) NOT NULL,
    [MediaType]               NVARCHAR (20)  NOT NULL,
    [MediaTypeDescription]    NVARCHAR (100) NULL,
    [LastMaintenanceDateTime] DATETIME       NOT NULL,
    [LastMaintenanceUser]     NVARCHAR (50)  NOT NULL,
    CONSTRAINT [PK_MediaType] PRIMARY KEY CLUSTERED ([MediaTypeId] ASC)
);


GO
PRINT N'Creating [Reference].[MediaType].[IX_MediaType_MediaType]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MediaType_MediaType]
    ON [Reference].[MediaType]([MediaType] ASC);


GO
PRINT N'Creating [Activity].[DF_ActivityLog_ActivityUser]...';


GO
ALTER TABLE [Activity].[ActivityLog]
    ADD CONSTRAINT [DF_ActivityLog_ActivityUser] DEFAULT (system_user) FOR [ActivityUser];


GO
PRINT N'Creating [Activity].[DF_ActivityLog_ActivityDateTime]...';


GO
ALTER TABLE [Activity].[ActivityLog]
    ADD CONSTRAINT [DF_ActivityLog_ActivityDateTime] DEFAULT (getdate()) FOR [ActivityDateTime];


GO
PRINT N'Creating [Maintenance].[DF_Reference_Network_MaintenanceUser]...';


GO
ALTER TABLE [Maintenance].[Reference_Network]
    ADD CONSTRAINT [DF_Reference_Network_MaintenanceUser] DEFAULT (system_user) FOR [MaintenanceUser];


GO
PRINT N'Creating [Maintenance].[DF_Reference_Network_MaintenanceDateTime]...';


GO
ALTER TABLE [Maintenance].[Reference_Network]
    ADD CONSTRAINT [DF_Reference_Network_MaintenanceDateTime] DEFAULT (getdate()) FOR [MaintenanceDateTime];


GO
PRINT N'Creating [Maintenance].[DF_Reference_StatusCode_MaintenanceUser]...';


GO
ALTER TABLE [Maintenance].[Reference_StatusCode]
    ADD CONSTRAINT [DF_Reference_StatusCode_MaintenanceUser] DEFAULT (system_user) FOR [MaintenanceUser];


GO
PRINT N'Creating [Maintenance].[DF_Reference_StatusCode_MaintenanceDateTime]...';


GO
ALTER TABLE [Maintenance].[Reference_StatusCode]
    ADD CONSTRAINT [DF_Reference_StatusCode_MaintenanceDateTime] DEFAULT (getdate()) FOR [MaintenanceDateTime];


GO
PRINT N'Creating [Maintenance].[DF_Reference_MediaType_MaintenanceUser]...';


GO
ALTER TABLE [Maintenance].[Reference_MediaType]
    ADD CONSTRAINT [DF_Reference_MediaType_MaintenanceUser] DEFAULT (system_user) FOR [MaintenanceUser];


GO
PRINT N'Creating [Maintenance].[DF_Reference_MediaType_MaintenanceDateTime]...';


GO
ALTER TABLE [Maintenance].[Reference_MediaType]
    ADD CONSTRAINT [DF_Reference_MediaType_MaintenanceDateTime] DEFAULT (getdate()) FOR [MaintenanceDateTime];


GO
PRINT N'Creating [Reference].[DF_Network_LastMaintenanceUser]...';


GO
ALTER TABLE [Reference].[Network]
    ADD CONSTRAINT [DF_Network_LastMaintenanceUser] DEFAULT (system_user) FOR [LastMaintenanceUser];


GO
PRINT N'Creating [Reference].[DF_Network_LastMaintenanceDateTime]...';


GO
ALTER TABLE [Reference].[Network]
    ADD CONSTRAINT [DF_Network_LastMaintenanceDateTime] DEFAULT (getdate()) FOR [LastMaintenanceDateTime];


GO
PRINT N'Creating [Reference].[DF_StatusCode_LastMaintenanceUser]...';


GO
ALTER TABLE [Reference].[StatusCode]
    ADD CONSTRAINT [DF_StatusCode_LastMaintenanceUser] DEFAULT (system_user) FOR [LastMaintenanceUser];


GO
PRINT N'Creating [Reference].[DF_StatusCode_LastMaintenanceDateTime]...';


GO
ALTER TABLE [Reference].[StatusCode]
    ADD CONSTRAINT [DF_StatusCode_LastMaintenanceDateTime] DEFAULT (getdate()) FOR [LastMaintenanceDateTime];


GO
PRINT N'Creating [Reference].[DF_MediaType_LastMaintenanceUser]...';


GO
ALTER TABLE [Reference].[MediaType]
    ADD CONSTRAINT [DF_MediaType_LastMaintenanceUser] DEFAULT (system_user) FOR [LastMaintenanceUser];


GO
PRINT N'Creating [Reference].[DF_MediaType_LastMaintenanceDateTime]...';


GO
ALTER TABLE [Reference].[MediaType]
    ADD CONSTRAINT [DF_MediaType_LastMaintenanceDateTime] DEFAULT (getdate()) FOR [LastMaintenanceDateTime];


GO
PRINT N'Creating [Reference].[Network_Update]...';


GO
create trigger Reference.Network_Update
	on Reference.Network
	after update
as
begin
	set nocount on

	insert into Maintenance.Reference_Network
	(
		NetworkId
		,MaintenanceType
		,NetworkAbbreviation_Before
		,NetworkAbbreviation_After
		,NetworkName_Before
		,NetworkName_After
		,ChannelNumber_Before
		,ChannelNumber_After
	)
	select
		deleted.NetworkId
		,'U'
		,deleted.NetworkAbbreviation
		,inserted.NetworkAbbreviation
		,deleted.NetworkName
		,inserted.NetworkName
		,deleted.ChannelNumber
		,inserted.ChannelNumber
	from deleted
		left join inserted
			on deleted.NetworkId = inserted.NetworkId
end
GO
PRINT N'Creating [Reference].[Network_Insert]...';


GO
create trigger Reference.Network_Insert
	on Reference.Network
	after insert
as
begin
	set nocount on

	insert into Maintenance.Reference_Network
	(
		NetworkId
		,MaintenanceType
		,NetworkAbbreviation_After
		,NetworkName_After
		,ChannelNumber_After
	)
	select
		NetworkId
		,'I'
		,NetworkAbbreviation
		,NetworkName
		,ChannelNumber
	from inserted
end
GO
PRINT N'Creating [Reference].[Network_Delete]...';


GO
create trigger Reference.Network_Delete
	on Reference.Network
	after delete
as
begin
	set nocount on

	insert into Maintenance.Reference_Network
	(
		NetworkId
		,MaintenanceType
		,NetworkAbbreviation_Before
		,NetworkName_Before
		,ChannelNumber_Before
	)
	select
		NetworkId
		,'D'
		,NetworkAbbreviation
		,NetworkName
		,ChannelNumber
	from deleted
end
GO
PRINT N'Creating [Reference].[StatusCode_Update]...';


GO
create trigger Reference.StatusCode_Update
	on Reference.StatusCode
	after update
as
begin
	set nocount on

	insert Maintenance.Reference_StatusCode
	(
		StatusCodeId
		,MaintenanceType
		,StatusCode_Before
		,StatusCode_After
		,StatusDescription_Before
		,StatusDescription_After
	)
	select
		deleted.StatusCodeId
		,'U'
		,deleted.StatusCode
		,inserted.StatusCode
		,deleted.StatusDescription
		,inserted.StatusDescription
	from deleted
		left join inserted
			on deleted.StatusCodeId = inserted.StatusCodeId
end
GO
PRINT N'Creating [Reference].[StatusCode_Insert]...';


GO
create trigger Reference.StatusCode_Insert
	on Reference.StatusCode
	after insert
as
begin
	set nocount on

	insert into Maintenance.Reference_StatusCode
	(
		StatusCodeId
		,MaintenanceType
		,StatusCode_After
		,StatusDescription_After
	)
	select
		StatusCodeId
		,'I'
		,StatusCode
		,StatusDescription
	from inserted
end
GO
PRINT N'Creating [Reference].[StatusCode_Delete]...';


GO
create trigger Reference.StatusCode_Delete
	on Reference.StatusCode
	after delete
as
begin
	set nocount on

	insert into Maintenance.Reference_StatusCode
	(
		StatusCodeId
		,MaintenanceType
		,StatusCode_Before
		,StatusDescription_Before
	)
	select
		StatusCodeId
		,'D'
		,StatusCode
		,StatusDescription
	from deleted
end
GO
PRINT N'Creating [Reference].[MediaType_Update]...';


GO
create trigger Reference.MediaType_Update
	on Reference.MediaType
	after update
as
begin
	set nocount on

	insert into Maintenance.Reference_MediaType
	(
		MediaTypeId
		,MaintenanceType
		,MediaType_Before
		,MediaType_After
		,MediaTypeDescription_Before
		,MediaTypeDescrption_After
	)
	select
		deleted.MediaTypeId
		,'U'
		,deleted.MediaType
		,inserted.MediaType
		,deleted.MediaTypeDescription
		,inserted.MediaTypeDescription
	from deleted
		left join inserted
			on deleted.MediaTypeId = inserted.MediaTypeId
end
GO
PRINT N'Creating [Reference].[MediaType_Insert]...';


GO
create trigger Reference.MediaType_Insert
	on Reference.MediaType
	after insert
as
begin
	set nocount on

	insert into Maintenance.Reference_MediaType
	(
		MediaTypeId
		,MaintenanceType
		,MediaType_After
		,MediaTypeDescrption_After
	)
	select
		MediaTypeId
		,'I'
		,MediaType
		,MediaTypeDescription
	from inserted
end
GO
PRINT N'Creating [Reference].[MediaType_Delete]...';


GO
create trigger Reference.MediaType_Delete
	on Reference.MediaType
	after delete
as
begin
	set nocount on

	insert into Maintenance.Reference_MediaType
	(
		MediaTypeId
		,MaintenanceType
		,MediaType_Before
		,MediaTypeDescription_Before
	)
	select
		MediaTypeId
		,'D'
		,MediaType
		,MediaTypeDescription
	from deleted
end
GO
PRINT N'Creating [Reference].[NetworkIdFromName]...';


GO
create function Reference.NetworkIdFromName (@networkName nvarchar(50))
	returns smallint
as
begin
	set nocount on

	declare @networkId smallint

	set @networkId = (select NetworkId from Reference.Network where NetworkName = @networkName)

	return @networkId
end
GO
PRINT N'Creating [Reference].[MediaTypeIdFromType]...';


GO
create function Reference.MediaTypeIdFromType (@mediaType nvarchar(20))
	returns tinyint
as
begin
	set nocount on

	declare @mediaTypeId tinyint

	set @mediaTypeId = (select MediaTypeId from Reference.MediaType where MediaType = @mediaType)

	return @mediaTypeId
end
GO
PRINT N'Creating [Reference].[StatusCodeIdFromCode]...';


GO
create function Reference.StatusCodeIdFromCode (@statusCode nvarchar(20))
	returns tinyint
as
begin
	set nocount on

	declare @statusCodeId tinyint

	set @statusCodeId = (select StatusCodeId from Reference.StatusCode where StatusCode = @statusCode)

	return @statusCodeId
end
GO
PRINT N'Creating [Activity].[ActivityLogAdd]...';


GO
create procedure Activity.ActivityLogAdd
	@objectName varchar(150)
	,@objectParameters nvarchar(max)
as
begin
	set nocount on

	insert into Activity.ActivityLog
	(
		ObjectName
		,ObjectParameters
	)
	values
	(
		@objectName
		,@objectParameters
	)
end
GO
PRINT N'Creating [Reference].[NetworkAdd]...';


GO
create procedure Reference.NetworkAdd
	@networkAbbreviation nvarchar(10) = null
	,@networkName nvarchar(50)
	,@channelNumber decimal(7, 2) = null
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@networkAbbreviation = ||' + isnull(@networkAbbreviation, 'NULL') + '||' +
		', @networkName = ||' + isnull(@networkName, 'NULL') + '||' +
		', @channelNumber = ||' + isnull(cast(@channelNumber as varchar(8)), 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	insert into Reference.Network
	(
		NetworkAbbreviation
		,NetworkName
		,ChannelNumber
	)
	values
	(
		@networkAbbreviation
		,@networkName
		,@channelNumber
	)
end
GO
PRINT N'Creating [Reference].[NetworkList]...';


GO
create procedure Reference.NetworkList
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = null

	select NetworkName
	from Reference.Network
	order by NetworkName
end
GO
PRINT N'Creating [Reference].[NetworkDetails]...';


GO
create procedure Reference.NetworkDetails
	@networkId smallint = null
	,@networkAbbreviation nvarchar(10) = null
	,@networkName nvarchar(50) = null
	,@channelNumber decimal(7, 2) = null
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@networkId = ||' + isnull(cast(@networkId as varchar(5)), 'NULL') + '||' +
		', @networkAbbreviation = ||' + isnull(@networkAbbreviation, 'NULL') + '||' +
		', @networkName = ||' + isnull(@networkName, 'NULL') + '||' +
		', @channelNumber = ||' + isnull(cast(@channelNumber as varchar(8)), 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	if @networkId is null
		set @networkId = Reference.NetworkIdFromName

	select
		NetworkId
		,NetworkAbbreviation
		,NetworkName
		,ChannelNumber
		,LastMaintenanceDateTime
		,LastMaintenanceUser
	from Reference.Network
	where NetworkId = @networkId
end
GO
PRINT N'Creating [Reference].[NetworkDelete]...';


GO
create procedure Reference.NetworkDelete
	@networkId smallint
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@networkId = ||' + isnull(cast(@networkId as varchar(5)), 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	delete from Reference.Network where NetworkId = @networkId
end
GO
PRINT N'Creating [Reference].[NetworkBrowse]...';


GO
create procedure Reference.NetworkBrowse
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = null


	select
		NetworkId
		,isnull(NetworkAbbreviation, '') as NetworkAbbreviation
		,NetworkName
		,isnull(ChannelNumber, '') as ChannelNumber
		,LastMaintenanceDateTime
		,LastMaintenanceUser
	from Reference.Network
	order by Network.NetworkName
end
GO
PRINT N'Creating [Reference].[MediaTypeDelete]...';


GO
create procedure Reference.MediaTypeDelete
	@mediaTypeId tinyint
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@mediaTypeId = ||' + isnull(cast(@mediaTypeId as varchar(4)), 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	delete from Reference.MediaType
	where MediaTypeId = @mediaTypeId
end
GO
PRINT N'Creating [Reference].[MediaTypeAdd]...';


GO
create procedure Reference.MediaTypeAdd
	@mediaType nvarchar(20)
	,@mediaTypeDescription nvarchar(100) = null
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@mediaType = ||' + isnull(@mediaType, 'NULL') + '||' +
		', @mediaTypeDescription = ||' + isnull(@mediaTypeDescription, 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	insert into Reference.MediaType
	(
		MediaType
		,MediaTypeDescription
	)
	values
	(
		@mediaType
		,@mediaTypeDescription
	)
end
GO
PRINT N'Creating [Reference].[StatusCodeUpdate]...';


GO
create procedure Reference.StatusCodeUpdate
	@statusCodeId tinyint
	,@statusCode nvarchar(20)
	,@statusDescription nvarchar(100) = null
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@statusCodeId = ||' + isnull(cast(@statusCodeId as varchar(4)), 'NULL') + '||' +
		', @statusCode = ||' + isnull(@statusCode, 'NULL') + '||' +
		', @statusDescription = ||' + isnull(@statusDescription, 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	update Reference.StatusCode
	set
		StatusCode = @statusCode
		,StatusDescription = @statusDescription
		,LastMaintenanceDateTime = getdate()
		,LastMaintenanceUser = system_user
	where StatusCodeId = @statusCodeId
end
GO
PRINT N'Creating [Reference].[StatusCodeDetails]...';


GO
create procedure Reference.StatusCodeDetails
	@statusCodeId tinyint = null
	,@statusCode nvarchar(20) = null
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@statusCodeId = ||' + isnull(cast(@statusCodeId as varchar(4)), 'NULL') + '||' +
		', @statusCode = ||' + isnull(@statusCode, 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	if @statusCodeId is null
		set @statusCodeId = Reference.StatusCodeIdFromCode(@statusCode)

	select
		StatusCodeId
		,StatusCode
		,StatusDescription
		,LastMaintenanceDateTime
		,LastMaintenanceUser
	from Reference.StatusCode
	where StatusCodeId = @statusCodeId
end
GO
PRINT N'Creating [Reference].[StatusCodeDelete]...';


GO
create procedure Reference.StatusCodeDelete
	@statusCodeId tinyint
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@statusCodeId = ||' + isnull(cast(@statusCodeId as varchar(4)), 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	delete from Reference.StatusCode
	where StatusCodeId = @statusCodeId
end
GO
PRINT N'Creating [Reference].[StatusCodeBrowse]...';


GO
create procedure Reference.StatusCodeBrowse
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = null

	select
		StatusCodeId
		,StatusCode
		,StatusDescription
		,LastMaintenanceDateTime
		,LastMaintenanceUser
	from Reference.StatusCode
	order by StatusCode
end
GO
PRINT N'Creating [Reference].[StatusCodeAdd]...';


GO
create procedure Reference.StatusCodeAdd
	@statusCode nvarchar(20)
	,@statusDescription nvarchar(100) = null
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@statusCode = ||' + isnull(@statusCode, 'NULL') + '||' +
		', @statusDescription = ||' + isnull(@statusDescription, 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	insert into Reference.StatusCode
	(
		StatusCode
		,StatusDescription
	)
	values
	(
		@statusCode
		,@statusDescription
	)
end
GO
PRINT N'Creating [Reference].[NetworkUpdate]...';


GO
create procedure Reference.NetworkUpdate
	@networkId smallint
	,@networkAbbreviation nvarchar(10) = null
	,@networkName nvarchar(50)
	,@channelNumber decimal(7, 2) = null
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@networkId = ||' + isnull(cast(@networkId as varchar(5)), 'NULL') + '||' +
		', @networkAbbreviation = ||' + isnull(@networkAbbreviation, 'NULL') + '||' +
		', @networkName = ||' + isnull(@networkName, 'NULL') + '||' +
		', @channelNumber = ||' + isnull(cast(@channelNumber as varchar(8)), 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	update Reference.Network
	set
		NetworkAbbreviation = @networkAbbreviation
		,NetworkName = @networkName
		,ChannelNumber = @channelNumber
		,LastMaintenanceDateTime = getdate()
		,LastMaintenanceUser = system_user
	where NetworkId = @networkId
end
GO
PRINT N'Creating [Reference].[MediaTypeUpdate]...';


GO
create procedure Reference.MediaTypeUpdate
	@mediaTypeId tinyint
	,@mediaType nvarchar(20)
	,@mediaTypeDescription nvarchar(100) = null
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@mediaTypeId = ||' + isnull(cast(@mediaTypeId as varchar(4)), 'NULL') + '||' +
		', @mediaType = ||' + isnull(@mediaType, 'NULL') + '||' +
		', @mediaTypeDescription = ||' + isnull(@mediaTypeDescription, 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	update Reference.MediaType
	set
		MediaType = @mediaType
		,MediaTypeDescription = @mediaTypeDescription
		,LastMaintenanceDateTime = getdate()
		,LastMaintenanceUser = system_user
	where MediaTypeId = @mediaTypeId
end
GO
PRINT N'Creating [Reference].[MediaTypeDetails]...';


GO
create procedure Reference.MediaTypeDetails
	@mediaTypeId tinyint = null
	,@mediaType nvarchar(20) = null
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	declare @objectParameters nvarchar(max) = 
		'@mediaTypeId = ||' + isnull(cast(@mediaTypeId as varchar(4)), 'NULL') + '||' +
		'@mediaType = ||' + isnull(@mediaType, 'NULL') + '||'
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = @objectParameters

	if @mediaTypeId is null
		set @mediaType = Reference.MediaTypeIdFromType(@mediaType)

	select
		MediaTypeId
		,MediaType
		,MediaTypeDescription
		,LastMaintenanceDateTime
		,LastMaintenanceUser
	from Reference.MediaType
	where MediaTypeId = @mediaTypeId
end
GO
PRINT N'Creating [Reference].[MediaTypeBrowse]...';


GO
create procedure Reference.MediaTypeBrowse
as
begin
	set nocount on

	declare @objectName varchar(150) = object_schema_name(@@procid) + '.' + object_name(@@procid)
	exec Activity.ActivityLogAdd @objectName = @objectName, @objectParameters = null

	select
		MediaTypeId
		,MediaType
		,MediaTypeDescription
		,LastMaintenanceDateTime
		,LastMaintenanceUser
	from Reference.MediaType
	order by MediaType
end
GO
-- Refactoring step to update target server with deployed transaction logs

IF OBJECT_ID(N'dbo.__RefactorLog') IS NULL
BEGIN
    CREATE TABLE [dbo].[__RefactorLog] (OperationKey UNIQUEIDENTIFIER NOT NULL PRIMARY KEY)
    EXEC sp_addextendedproperty N'microsoft_database_tools_support', N'refactoring log', N'schema', N'dbo', N'table', N'__RefactorLog'
END
GO
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '41219328-07e4-4f6a-9414-2aed5ee2137b')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('41219328-07e4-4f6a-9414-2aed5ee2137b')

GO

GO
PRINT N'Update complete.';


GO