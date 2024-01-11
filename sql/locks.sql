-- 1 ROW Lock
-- Zeigt, wie ein RID Lock erzeugt und dargestellt wird
ALTER TABLE AWBuildVersion DROP CONSTRAINT PK_AWBuildVersion_SystemInformationID  WITH ( ONLINE = OFF )

BEGIN TRANSACTION
UPDATE AWBuildVersion SET VersionDate = VersionDate where SystemInformationID = 1
ROLLBACK

ALTER TABLE AWBuildVersion ADD  CONSTRAINT PK_AWBuildVersion_SystemInformationID PRIMARY KEY CLUSTERED (SystemInformationID ASC)

-- 2 Key Lock 
-- Zeigt Verwendung von Key Locks

BEGIN TRANSACTION
UPDATE HumanResources.Department SET Name = Name WHERE DepartmentID < 4
ROLLBACK

-- 3 Lock Escalation
-- Demonstriert eskaltion von key Lock zu Object Lock
set statistics time on

BEGIN TRANSACTION
UPDATE [Production].[TransactionHistory] --with(tablock) 
SET [TransactionDate] = [TransactionDate] WHERE [TransactionID] < 100010

UPDATE [Production].[TransactionHistory] --with(tablock) 
SET [TransactionDate] = [TransactionDate] WHERE [TransactionID] < 200000
ROLLBACK
-- Es ist Unterschied bei "CPU" erkennbar

-- 4 Lock Mode Shared
-- Demonstriert readonly Zugriffe und Shared Locks - Keine Locks sichtbar
BEGIN TRANSACTION
SELECT * FROM HumanResources.Department
-- keine Locks sichtbar
ROLLBACK

-----------------------------------------------------------------------------------------
-- 5 Lock Mode Shared
-- Demonstriert readonly Zugriffe und Shared Locks
--------------------------------------------------------------------------------------
BEGIN TRANSACTION
SELECT * FROM HumanResources.Department WITH (HOLDLOCK)
where departmentid = 1 
-- Locks sichtbar
ROLLBACK

-------------------------------------------------------------------------------------
-- 6 U Locks
-- Szenario 1: Kein U Lock sichtbar
----------------------------------------------------------------------------------

-- Session 1
BEGIN TRANSACTION
SELECT * FROM HumanResources.Department WITH (HOLDLOCK)
where departmentid = 1 

-- Session 2
BEGIN TRANSACTION
UPDATE HumanResources.Department SET ModifiedDate = ModifiedDate
where DepartmentID = 1


-------------------------------------------------------------------------------------
-- 6 U Locks
-- Szenario 2: U Lock sichtbar
----------------------------------------------------------------------------------
-- Session 1
BEGIN TRANSACTION
SELECT * FROM HumanResources.Department WITH (HOLDLOCK)
where departmentid = 1 

-- Session 2
BEGIN TRANSACTION
UPDATE HumanResources.Department SET ModifiedDate = ModifiedDate
where name like '%ng%' 

----------------------------------------------------------
-- 7 I Locks
-- Szenario: I Lock auf höherer Stufe
------------------------------------------------------------
Begin transaction
update HumanResources.Department set Name = Name where DepartmentID = 1

--------------------------------------------------
-- 8 Read Uncommitted Isolation Level
-- Änderung sichtbar ohne Commit
-----------------------------------------------------
-- Session 1
begin transaction
update HumanResources.Department set Name = 'asdadada' where DepartmentID = 1

-- Session 2
begin transaction
set transaction isolation level read uncommitted
select * from HumanResources.Department where DepartmentID = 1

--------------------------------------------------
-- 9 Read Committed Isolation Level
-- Änderung nicht sichtbar ohne Commit
-- X Lock führt zu WAIT
-----------------------------------------------------
-- Session 1
begin transaction
update HumanResources.Department set Name = 'asdadada' where DepartmentID = 1

-- Session 2
begin transaction
set transaction isolation level read committed
select * from HumanResources.Department where DepartmentID = 1

--------------------------------------------------
-- 10 Repeatable Read Isolation Level
-----------------------------------------------------
-- Session 1
begin transaction
set transaction isolation level repeatable read
select * from HumanResources.Department where DepartmentID > 15

-- Session 2
begin transaction
insert into HumanResources.Department (Name, GroupName, ModifiedDate) VALUES ('Test', 'Test', CURRENT_TIMESTAMP)
commit

-- Session 2
select * from HumanResources.Department where DepartmentID > 15

----------------------------------------------------------
-- 11 Serializable Level
-- Effekt fehlender Index
-- Szenario: keine neuen Einträge möglich
---------------------------------------------------------
-- Ausführen
alter table AWBuildVersion
add TestId int

INSERT INTO AWBuildVersion (TestId, [Database Version], VersionDate, ModifiedDate)
VALUES (1, '14.0.1000.169', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(20, '14.0.1000.169', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)

-- Session 1
begin transaction
SET Transaction Isolation LEvel Serializable
select SystemInformationID from AWBuildVersion where TestId = 1

-- Session 2
begin transaction
INSERT INTO AWBuildVersion (TestId, [Database Version], VersionDate, ModifiedDate)
VALUES (25, '14.0.1000.169', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)

----------------------------------------------------------
-- 12 Serializable Level
-- Effekt vorhandener Index
-- Szenario: neuen Einträge möglich außerhalb der Range
---------------------------------------------------------
-- Ausführen
create nonclustered index ix_biehler on AWBuildVersion (TestId asc)

-- Session 1
begin transaction
SET Transaction Isolation LEvel Serializable
select SystemInformationID from AWBuildVersion where TestId = 1

-- Session 2
begin transaction
INSERT INTO AWBuildVersion (TestId, [Database Version], VersionDate, ModifiedDate)
VALUES (25, '14.0.1000.169', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)


------------------------------------------------------------------
-- 13 Range Lock Cascade Delete
--------------------------------------------------------------------
declare @id int
insert into action (action, date, creatorid) values ('test', CURRENT_TIMESTAMP, 1)
set @id = @@IDENTITY
insert into detail (actionid, Discriminator, date) values (@id, 'test', CURRENT_TIMESTAMP)

begin transaction
set transaction isolation level repeatable read

delete from action where action = 'test'

-- man sieht den Range Lock. Kann Probleme verursachen, muss man einfach wissen


------------------------------------------------------------------
-- 14 Read Committed Snapshot 
--------------------------------------------------------------------

ALTER DATABASE AdventureWorks2017 SET SINGLE_USER WITH ROLLBACK immediate
ALTER DATABASE AdventureWorks2017 SET READ_COMMITTED_SNAPSHOT ON
ALTER DATABASE AdventureWorks2017 SET MULTI_USER WITH ROLLBACK immediate

-- Session 1
begin transaction
set transaction isolation level read committed
update HumanResources.Department set Name = 'asdadada' where DepartmentID = 1

-- Session 2
begin transaction
set transaction isolation level read committed
select * from HumanResources.Department where DepartmentID = 1

-- Session 1
commit

-- Session 2
-- Neuer Wert
select * from HumanResources.Department where DepartmentID = 1

ALTER DATABASE AdventureWorks2017 SET SINGLE_USER WITH ROLLBACK immediate
ALTER DATABASE AdventureWorks2017 SET READ_COMMITTED_SNAPSHOT OFF
ALTER DATABASE AdventureWorks2017 SET MULTI_USER WITH ROLLBACK immediate

------------------------------------------------------------------
-- 15 Snapshot 
--------------------------------------------------------------------

ALTER DATABASE AdventureWorks2017 SET SINGLE_USER WITH ROLLBACK immediate
ALTER DATABASE AdventureWorks2017 SET ALLOW_SNAPSHOT_ISOLATION ON
ALTER DATABASE AdventureWorks2017 SET MULTI_USER WITH ROLLBACK immediate

-- Session 1
set transaction isolation level snapshot
begin transaction
select * from HumanResources.Department where DepartmentID = 1

select * from sys.dm_tran_locks -- Keine Locks!

-- Session 2
set transaction isolation level snapshot
begin transaction
update HumanResources.Department set Name = 'asdadada' where DepartmentID = 1

-- Session 1
-- Weiterhin vorheriger Wert
select * from HumanResources.Department where DepartmentID = 1

-- Session 2
commit

-- Session 1
-- Alter Wert
select * from HumanResources.Department where DepartmentID = 1

ALTER DATABASE AdventureWorks2017 SET SINGLE_USER WITH ROLLBACK immediate
ALTER DATABASE AdventureWorks2017 SET ALLOW_SNAPSHOT_ISOLATION OFF
ALTER DATABASE AdventureWorks2017 SET MULTI_USER WITH ROLLBACK immediate

------------------------------------------------------------------
-- 16 Read Committed Snapshot - Nachteil - Fehler bei Konflikt
--------------------------------------------------------------------

ALTER DATABASE AdventureWorks2017 SET SINGLE_USER WITH ROLLBACK immediate
ALTER DATABASE AdventureWorks2017 SET ALLOW_SNAPSHOT_ISOLATION ON
ALTER DATABASE AdventureWorks2017 SET MULTI_USER WITH ROLLBACK immediate

-- Session 1
set transaction isolation level snapshot
begin transaction
select * from HumanResources.Department where DepartmentID = 1

select * from sys.dm_tran_locks -- Keine Locks!

-- Session 2
set transaction isolation level snapshot
begin transaction
update HumanResources.Department set Name = 'session 2' where DepartmentID = 1

-- Session 1
-- Exception
update HumanResources.Department set Name = 'session 1' where DepartmentID = 1

ALTER DATABASE AdventureWorks2017 SET SINGLE_USER WITH ROLLBACK immediate
ALTER DATABASE AdventureWorks2017 SET ALLOW_SNAPSHOT_ISOLATION OFF
ALTER DATABASE AdventureWorks2017 SET MULTI_USER WITH ROLLBACK immediate


------------------------------------------------------------------
-- 17 Informationen über Locks
--------------------------------------------------------------------
begin transaction
set transaction isolation level repeatable read
select * from AdventureWorks2017.HumanResources.Department where DepartmentID = 1
select * from AdventureWorks2017.HumanResources.Department where DepartmentID = 2


select object_name(1701581100)
dbcc page(6, 1, 12512, 3) with tableresults

-- resource_description bei KEY zeigt die konkrete Zeile an


------------------------------------------------------------------
-- 18 Deadlocks durch S Locks
--------------------------------------------------------------------
-- session 1
begin transaction
set transaction isolation level repeatable read

select * from HumanResources.Department where DepartmentID = 1

-- session 2
begin transaction
set transaction isolation level repeatable read

select * from HumanResources.Department where DepartmentID = 1

-- session 1
update HumanResources.Department set name = name where DepartmentID = 1

-- session 2
update HumanResources.Department set name = name where DepartmentID = 1

------------------------------------------------------------------
-- 19 Locks reduzieren - hier entsteht wieder Deadlock
--------------------------------------------------------------------
create nonclustered index ix_test on HumanResources.Department (Departmentid) include (name)

-- session 1
begin transaction
set transaction isolation level repeatable read

select Name, ModifiedDate from HumanResources.Department with(index(ix_test)) where DepartmentID = 1

-- session 2
begin transaction
set transaction isolation level repeatable read

select Name, ModifiedDate from HumanResources.Department with(index(ix_test)) where DepartmentID = 1

-- hier mal die locks anschauen

-- session 1
update HumanResources.Department set Groupname = Groupname where DepartmentID = 1

-- und jetzt auch. Lock wird geupgradet

-- session 2
update HumanResources.Department set Groupname = Groupname where DepartmentID = 1


------------------------------------------------------------------
-- 20 Locks reduzieren - Covering Index verhindert dies
-- kein S Lock auf Clustered Index
--------------------------------------------------------------------
create nonclustered index ix_test on HumanResources.Department (Departmentid) include (name, ModifiedDate) with(drop_existing = on)

-- session 1
begin transaction
set transaction isolation level repeatable read

select Name, ModifiedDate from HumanResources.Department with(index(ix_test)) where DepartmentID = 1

-- session 2
begin transaction
set transaction isolation level repeatable read

select Name, ModifiedDate from HumanResources.Department with(index(ix_test)) where DepartmentID = 1

-- session 1
update HumanResources.Department set Groupname = Groupname where DepartmentID = 1

-- session 2
update HumanResources.Department set Groupname = Groupname where DepartmentID = 1

------------------------------------------------------------------
-- 21 Deadlock Analyse
--------------------------------------------------------------------
-- session 1
begin transaction
update HumanResources.Department set Groupname = Groupname where DepartmentID = 1

-- session 2
begin transaction
update HumanResources.Department set Groupname = Groupname where DepartmentID = 2 

-- session 1
update HumanResources.Department set Groupname = Groupname where DepartmentID = 2 

-- session 2
update HumanResources.Department set Groupname = Groupname where DepartmentID = 1

--------------------------------------------------------------------
-- 22 Decode Key Waitresource
----------------------------------------------------------------------
SELECT 
    sc.name as schema_name, 
    so.name as object_name, 
    si.name as index_name
FROM sys.partitions AS p
JOIN sys.objects as so on 
    p.object_id=so.object_id
JOIN sys.indexes as si on 
    p.index_id=si.index_id and 
    p.object_id=si.object_id
JOIN sys.schemas AS sc on 
    so.schema_id=sc.schema_id
WHERE hobt_id = 72057594048937984;

SELECT * FROM HumanResources.Department (NOLOCK)
WHERE %%lockres%% = '(e1784bd73cba)';

------------------------------------------------------------------
-- 23 Blocked Process Report
--------------------------------------------------------------------
-- session 1
begin transaction
update HumanResources.Department set Groupname = Groupname where DepartmentID = 1

-- session 2
begin transaction
update HumanResources.Department set Groupname = Groupname where DepartmentID = 1

-- session 3

-- Blocked Process Report aktivieren
SP_CONFIGURE'show advanced options',1 ;
GO
RECONFIGURE;
GO
 
SP_CONFIGURE'blocked process threshold',10;
GO
RECONFIGURE;
GO

-- im trace: lockMode="X" (im nächsten Beispiel relevant)

-- Nach Profiling wieder deaktivieren
SP_CONFIGURE'blocked process threshold',0;
GO
RECONFIGURE;
GO

