-----------------------------
-- Arithmetische Operationen
-----------------------------
select id from action where creatorid*2 < 10

-- vs

select id from action where creatorid < 5

------------------------------
-- Funktionen
------------------------------
create nonclustered index IX_date on Action (Date)

select id from action where DATEPART(year, date) > 2023

-- vs

select id from action where date > '2024-01-01 00:00:00 +00:00'
