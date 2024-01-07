 -- Merge join
  select pm.*
 from Production.ProductModel pm
 join Production.ProductModelProductDescriptionCulture pmpd on pm.ProductModelID = pmpd.ProductModelID

 -- loop Join
  select pm.*
 from Production.ProductModel pm
 join Production.ProductModelProductDescriptionCulture pmpd on pm.ProductModelID = pmpd.ProductModelID
 where pm.Name = 'HL Mountain Front Wheel'

 -- hash join
 -- kein Beispiel gefunden - und ich war zu faul, lange zu suchen