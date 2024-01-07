USE [master];
GO
RESTORE DATABASE [AdventureWorks2017]
FROM DISK = '/AdventureWorks2017.bak'
WITH
    MOVE 'AdventureWorks2017' TO '/var/opt/mssql/data/AdventureWorks2017.mdf',
    MOVE 'AdventureWorks2017_log' TO '/var/opt/mssql/data/AdventureWorks2017_log.ldf',
    FILE = 1,
    NOUNLOAD,
    STATS = 5;
GO