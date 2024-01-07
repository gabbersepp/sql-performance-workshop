create nonclustered index IX_Discriminator on Detail(Discriminator) WHERE Discriminator = 'Canceled'

select id from detail where Discriminator = 'Canceled'

EXEC sp_executesql
N'select id from detail where Discriminator = @parameter',
N'@parameter VARCHAR(255)',
N'Canceled'

DROP INDEX IX_Discriminator on Detail