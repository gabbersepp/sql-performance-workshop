Hallo,

wir brauchen SQL Server (sollte etwas frischer sein als 2000 xD), SQL Management Studio und den SQL Profiler. Es kann ein existierender SQL Server benutzt werden oder man kann mein Docker Image nutzen. Das Image enthält bereits das Setup Skript und den Import der AdventureWorks Datenbank. Letztere ist eine bekannte Beispieldatenbank von MS. Wir benötigen sie für ein paar Beispiele.

Das SQL Server Managementstudio muss in beiden Fällen installiert sein, da ich das nicht als Dockerimage ausliefern kann. SQL Managementstudio enthält auch den Profiler.

Zudem haben wir ein kleines Beispiel mit Dotnet Core + EFCore. Da gibt es aber nichts zum Livecoden, es muss also nicht zwingend Visual Studio und dotnet core verfügbar sein.

---------------------
-- eigenen SQL Server nutzen
---------------------
- eine neue Datenbank anlegen ("workshop") und dort setup.sql ausführen
- https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2017.bak runterladen und importieren (in eine neue Datenbank natürlich)


---------------------
-- SQL Server über Docker Image ausführen
---------------------

bitte führe folgende Schritte in einer Kommandozeile aus:

docker pull gabbersepp/sql2017_perfworkshop 

docker run -it --rm -p 1433:1433 gabbersepp/sql2017_perfworkshop 

------------------------
-- SQL Management Studio
------------------------
https://learn.microsoft.com/de-de/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16
Die Version müsste egal sein, ich habe Version 19.2



Wenn etwas nicht geht, bitte direkt an gabbersepp@googlemail.com schreiben, sodass wir Probleme möglichst noch vor dem Workshopstart klären können
