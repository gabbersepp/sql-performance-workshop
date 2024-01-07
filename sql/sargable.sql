create nonclustered index ix_action on Action(Action)
SET STATISTICS IO ON

-- Beispiel: Optimizer macht aus Nonsargable eine Sargable Condition
select id from Action where Action <> 'Deleted'

-- auch hier: Optimizer kann Sargable Condition daraus machen
select id from Action where Action not in ( 'Deleted', 'hans')

-- aber: hier nicht!
select id from Action where Action not in ( 'Deleted', 'äöüß')

-- nutzt man aber Parameter, geht es schon wieder
DBCC FREEPROCCACHE
EXEC sp_executesql
N'select id from Action where Action not in ( ''Deleted'', @action)',
N'@action NVARCHAR(255)',
N'äöüß'

-- Like geht, wenn keine Wildcard am Anfang
SELECT id from Action where Action LIKE 'Del%'

-- Like geht nicht, wenn Wildcard am Anfang
SELECT id from Action where Action LIKE '%Del%'

-- Sargable führt zu Seek, ist aber trotzdem schlecht: Scan Count 3
select id from Action where Action in ( 'Canceled', 'Closed', 'Deleted')
-- Table 'Action'. Scan count 3, logical reads 25, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

-- Besser mit BETWEEN: Scan Count 1
select id from Action where Action >= 'Canceled' and action <= 'Deleted'
-- Table 'Action'. Scan count 1, logical reads 17, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

select distinct Action from action order by 1 asc

drop index ix_action on action