FROM mcr.microsoft.com/mssql/server:2017-latest
ENV SA_PASSWORD Test1234!
# port 1433
ENV ACCEPT_EULA Y

WORKDIR / 

RUN wget https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2017.bak

COPY . .

RUN chmod +x /entrypoint.sh
RUN chmod +x /configure-db.sh

ENTRYPOINT ["/entrypoint.sh"]