-- Index um guten Plan zu haben
create nonclustered index ix_action on Action (Action)

insert into Action (Action, Date, CreatorId)
values ('test1', CURRENT_TIMESTAMP, 1)

-- Index seek mit Lookup
select Date from action where action = 'test1'

-- Clustered Index Scan
EXEC sp_executesql N'
DECLARE @action nvarchar(255)
set @action = ''test1''
select Date from action where action = @action
'

-- Index Seek mit Lookup
EXEC sp_executesql
N'select Date from action where action = @action',
N'@action VARCHAR(255)',
N'test1'

DROP INDEX ix_action on Action