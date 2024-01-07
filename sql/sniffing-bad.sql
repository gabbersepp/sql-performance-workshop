-- Index um guten Plan zu haben
create nonclustered index ix_action on Action (Action)

insert into Action (Action, Date, CreatorId)
values ('test2', CURRENT_TIMESTAMP, 1)

-- Index Seek mit Lookup
-- gut, weil nur eine Zeile enthalten ist
EXEC sp_executesql
N'select Date from action where action = @action',
N'@action VARCHAR(255)',
N'test2'

-- Index Seek + Lookup schlecht, siehe Reads vgl. zu neuem Plan (Parameter einfach ändern)
EXEC sp_executesql
N'select Date from action where action = @action',
N'@action VARCHAR(255)',
N'Reopened'

DROP INDEX ix_action on Action