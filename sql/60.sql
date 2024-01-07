create nonclustered index IX_Discriminator on Detail(Discriminator)

select Discriminator, Date from detail with(INDEX(IX_actionId), INDEX(IX_Discriminator)) where Actionid = 1 

DROP INDEX IX_Discriminator on Detail