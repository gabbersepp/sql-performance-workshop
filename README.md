# sql-performance-workshop

## How to Build Docker Image

`cd docker && docker build -t gabbersepp/sql2017_perfworkshop .`

## How to execute

`docker run -it --rm -p 1433:1433 gabbersepp/sql2017_perfworkshop`

## Setup

The container will setup itself after starting. Everytime the container is stopped and removed ( = Reset), the setup is started again and you have a fresh & clean setup.