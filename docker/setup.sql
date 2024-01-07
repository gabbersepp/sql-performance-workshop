CREATE DATABASE workshop;
ALTER DATABASE workshop SET READ_COMMITTED_SNAPSHOT ON

go

use workshop

create table Action (
    id int not null IDENTITY(1,1) PRIMARY KEY,
    Action nvarchar(255),
    Date DateTimeOffset,
    CreatorId int not null
)
go
 
create table Detail (
    ActionId int not null,
    Discriminator nvarchar(255),
    id int not null IDENTITY(1,1) PRIMARY KEY,
    Date date,
    constraint FK_Tab1 FOREIGN KEY (ActionId) references Action(Id)
        ON DELETE CASCADE
)
go
  
declare @PossibleActionsStr nvarchar(max)
set @PossibleActionsStr = 'Saved,Solved,Canceled,Closed,Reopened,Deleted'

declare @rowcount int
set @rowcount = 1
WHILE @RowCount <= 5000
BEGIN
insert into Action(Action, Date, CreatorId) 
values ((select value from (select value, ROW_NUMBER()over(order by value) rn from STRING_SPLIT (@PossibleActionsStr, ',')) t where rn = @rowcount%6 + 1), DATEADD(MS, @rowcount, GETDATE()), @rowcount % 1000)
set @rowcount = @rowcount + 1
end
 
insert into Detail (ActionId, Discriminator, Date)
select id, Action, CURRENT_TIMESTAMP from Action

create nonclustered index IX_ActionId on Detail(ActionId) INCLUDE (Date)
create nonclustered index IX_CreatorId on Action(CreatorId)

--create nonclustered index IX_tab1_id2 on tab1(id2)
--create nonclustered index IX_details_tab_id on details(tab1_id)
--drop index IX_ActionId on Detail
--drop index IX_CreatorId on Action