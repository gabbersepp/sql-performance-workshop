create nonclustered index ix_action on Action (Action)

SET STATISTICS IO ON

insert into Action (Action, Date, CreatorId)
values ('test', CURRENT_TIMESTAMP, 1)

select Date from action where action = 'test'

-- Plan ist gut, NonClustered Seek + Lookup

DBCC SHOW_STATISTICS(Action, ix_action)

-- Statistik passt

insert into Action (Action, date, creatorid)
select top 900 'test', date, creatorid from action

-- Eingefügte Menge ist unterhalb der 20% Schwelle -> Kein Autoupdate

select Date from action where action = 'test'

-- Plan ist der gleiche
--Table 'Action'. Scan count 1, logical reads 1811, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

-- Nun updaten
UPDATE STATISTICS Action ix_action

-- ausführen

select Date from action where action = 'test'

-- Plötzlich Scan, kein Seek+Lookup

--Table 'Action'. Scan count 1, logical reads 45, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

DROP index ix_action on Action