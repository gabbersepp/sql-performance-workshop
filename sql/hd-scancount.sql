---------------------
-- Alter Query
----------------------

exec sp_executesql N'SELECT 
    [Extent1].[Id] AS [Id]
    FROM   [dbo].[Ticket] AS [Extent1]
    OUTER APPLY  (SELECT TOP (1) 
        [Extent2].[CreationDate] AS [CreationDate]
        FROM [dbo].[LastObjectAction] AS [Extent2]
        WHERE ([Extent1].[Id] = [Extent2].[TicketId]) AND (N''Default.SystemActionTypes.Ticket.Closed'' = [Extent2].[SystemAction]) ) AS [Limit1]
    OUTER APPLY  (SELECT TOP (1) 
        [Extent3].[CreationDate] AS [CreationDate]
        FROM [dbo].[LastObjectAction] AS [Extent3]
        WHERE ([Extent1].[Id] = [Extent3].[TicketId]) AND (N''Default.SystemActionTypes.Ticket.Aborted'' = [Extent3].[SystemAction]) ) AS [Limit2]
    WHERE ((N''Default.DataSources.TicketStatuses.Closed'' = [Extent1].[Status]) AND ([Limit1].[CreationDate] < @p__linq__0)) 
	OR ((N''Default.DataSources.TicketStatuses.Aborted'' = [Extent1].[Status]) AND ([Limit2].[CreationDate] < @p__linq__1))'
	,N'@p__linq__0 datetimeoffset(7),@p__linq__1 datetimeoffset(7)'
	,@p__linq__0='2018-01-16 11:21:02.6463526 +00:00',@p__linq__1='2018-01-16 11:21:02.6463526 +00:00'

------------------------------------
-- Neuer (selbstgebauter Query)
-----------------------------------

SELECT 
    [Extent1].[TicketId] AS [Id],
	[Extent1].[SystemAction],
	[Extent1].[CreationDate]
    FROM   [dbo].[LastObjectAction] AS [Extent1] 
	JOIN [dbo].[Ticket] AS [Extent2] ON ([Extent1].[TicketId] = [Extent2].[Id])
	WHERE (('Default.SystemActionTypes.Ticket.Closed' = [Extent1].[SystemAction]  
	AND 'Default.DataSources.TicketStatuses.Closed' = [Extent2].[Status]) 
	OR ('Default.SystemActionTypes.Ticket.Aborted' = [Extent1].[SystemAction] 
	AND 'Default.DataSources.TicketStatuses.Aborted' = [Extent2].[Status])) 
	AND ([Extent1].[CreationDate] < '2018-01-16 11:21:02.6463526 +00:00')

-------------------------------------------------
-- Query nach Code Umbau
------------------------------------------------

exec sp_executesql N'SELECT 
    [Extent1].[TicketId] AS [Id]
    FROM  [dbo].[LastObjectAction] AS [Extent1]
    INNER JOIN [dbo].[Ticket] AS [Extent2] ON [Extent1].[TicketId] = [Extent2].[Id]
    WHERE (((N''Default.SystemActionTypes.Ticket.Closed'' = [Extent1].[SystemAction]) 
	AND (N''Default.DataSources.TicketStatuses.Closed'' = [Extent2].[Status])) 
	OR ((N''Default.SystemActionTypes.Ticket.Aborted'' = [Extent1].[SystemAction]) 
	AND (N''Default.DataSources.TicketStatuses.Aborted'' = [Extent2].[Status]))) 
	AND ([Extent1].[CreationDate] < @p__linq__0)',N'@p__linq__0 datetimeoffset(7)'
	,@p__linq__0='2018-01-16 11:21:02.6463526 +00:00'