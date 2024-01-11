-- Session 1
begin transaction
update Detail set discriminator = discriminator where Actionid = 1


-- Session 2
begin transaction
select Date from detail with(holdlock) where Actionid = 1 


-- gleiches nochmal mit
drop index IX_ActionId on Detail

-- am Ende wieder
create nonclustered index IX_ActionId on Detail(ActionId)



nochmal testen, was passiert hier?
nochmaltesten, ob man in hd daten schreiben ü lesen kann