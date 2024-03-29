# Домашнее задание к занятию "6.4.PostgreSQL"

## Задание 1

*Используя **Docker**, поднимите инстанс* **PostgreSQL** *(версию 13)*. *Данные БД сохраните в volume*.

<details><summary><b>docker-compose.yml</b></summary>

```yml
version: "3.7"

volumes:
  data: {}
  backup: {}

services:
  postgres:
    container_name: psql_1
    image: postgres:13
    restart: always
    environment:
      POSTGRES_PASSWORD: "123"
      POSTGERS_USER: "root"
      PGDATA: "/var/lib/postgresql/data/pgdata"
    volumes:
      - ./data:/var/lib/postgresql/data
      - ./backup:/var/lib/postgresql/backup
    ports:
      - "0.0.0.0:5432:5432"
```
</details>

```bash
netology@deb11-vm1:~/docker/dbpsql$ docker-compose up -d
Creating network "dbpsql_default" with the default driver
Creating volume "dbpsql_data" with default driver
Creating volume "dbpsql_backup" with default driver
Pulling postgres (postgres:13)...
13: Pulling from library/postgres
faef57eae888: Pull complete
...
b8dec84b144c: Pull complete
Digest: sha256:0f18de936266e03891e186db616e530e0e4365ef5fb300d4bb27318538b80604
Status: Downloaded newer image for postgres:13
Creating psql_1 ... done
netology@deb11-vm1:~/docker/dbpsql$ docker ps -a
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS          PORTS                    NAMES
6161b8e9df7b   postgres:13   "docker-entrypoint.s…"   13 minutes ago   Up 13 minutes   0.0.0.0:5432->5432/tcp   psql_1

```

*Подключитесь к БД **PostgreSQL**, используя `psql`*.

```bash
netology@deb11-vm1:~/docker/dbpsql$ docker exec -it psql_1 bash
root@6161b8e9df7b:/# psql -U postgres
psql (13.11 (Debian 13.11-1.pgdg120+1))
Type "help" for help.

postgres=# 

```
*Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам*.

*Найдите и приведите управляющие команды для*:

 - вывода списка БД,

```bash
 \l[+]   [PATTERN]      list databases
```
 - подключения к БД,

```bash
Connection
  \c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
                         connect to new database (currently "postgres")
```
 - вывода списка таблиц,

```bash
\dt[S+] [PATTERN]      list tables
```
 - вывода описания содержимого таблиц,

```bash
\d[S+]                 list tables, views, and sequences
\d[S+]  NAME           describe table, view, sequence, or index
```
 - выхода из psql.

```bash
\q                     quit psql
```
***

## Задание 2

*Используя `psql`, создайте БД `test_database`*.

```bash
postgres=# CREATE DATABASE test_database;
CREATE DATABASE
```
*Изучите [бэкап БД](./src/604/test_dump.sql)*.

*Восстановите бэкап БД в `test_database`*.

```bash
root@6161b8e9df7b:/# psql -U postgres test_database < /var/lib/postgresql/backup/test_dump.sql 
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval 
--------
      8
(1 row)

ALTER TABLE
```
*Перейдите в управляющую консоль `psql` внутри контейнера*.

*Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице*.

```bash
postgres=# \c test_database
You are now connected to database "test_database" as user "postgres".
test_database=# \dt+
                              List of relations
 Schema |  Name  | Type  |  Owner   | Persistence |    Size    | Description 
--------+--------+-------+----------+-------------+------------+-------------
 public | orders | table | postgres | permanent   | 8192 bytes | 
(1 row)

est_database=# ANALyZE VERBOSE public.orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
```
*Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` с наибольшим средним значением размера элементов в байтах*.

*Приведите в ответе команду, которую вы использовали для вычисления, и полученный результат*.

```bash
test_database=# SELECT attname, avg_width from pg_stats WHERE tablename='orders'; 
 attname | avg_width 
---------+-----------
 id      |         4
 title   |        16
 price   |         4
(3 rows)
```
***

## Задание 3

*Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и поиск по ней занимает долгое время. Вам как успешному выпускнику курсов DevOps в Нетологии предложили провести разбиение таблицы на 2: шардировать на orders_1 - price>499 и orders_2 - price<=499*.

*Предложите SQL-транзакцию для проведения этой операции*.

```bash
test_database=# BEGIN;
BEGIN
test_database=*# CREATE TABLE orders_1 (LIKE orders);
CREATE TABLE
test_database=*# INSERT INTO orders_1 SELECT * FROM orders WHERE price >499;
INSERT 0 3
test_database=*# DELETE FROM orders WHERE price >499;
DELETE 3
test_database=*# CREATE TABLE orders_2 (LIKE orders);
CREATE TABLE
test_database=*# INSERT INTO orders_2 SELECT * FROM orders WHERE price <=499;
INSERT 0 5
test_database=*# DELETE FROM orders WHERE price <=499;
DELETE 5
test_database=*# COMMIT;
COMMIT
test_database=# SELECT * FROM public.orders;
 id | title | price 
----+-------+-------
(0 rows)

test_database=# SELECT * FROM public.orders_1;
 id |       title        | price 
----+--------------------+-------
  2 | My little database |   500
  6 | WAL never lies     |   900
  8 | Dbiezdmin          |   501
(3 rows)

test_database=# SELECT * FROM public.orders_2;
 id |        title         | price 
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  7 | Me and my bash-pet   |   499
(5 rows)

test_database=# \dt
          List of relations
 Schema |   Name   | Type  |  Owner   
--------+----------+-------+----------
 public | orders   | table | postgres
 public | orders_1 | table | postgres
 public | orders_2 | table | postgres
(3 rows)

```
*Можно ли было изначально исключить ручное разбиение при проектировании таблицы orders*?

Ответ: "ручного" разбиения можно было избежать при проектировании таблицы путём введения секционирования до внесения данных в таблицу.


## Задание 4

*Используя утилиту `pg_dump`, создайте бекап БД `test_database`*.

```bash
root@6161b8e9df7b:/# pg_dump -U postgres -d test_database > /var/lib/postgresql/backup/test_database_dump.sql
```
*Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`*?

Я бы добавил свойство `UNIQUE`

```sql
 title character varying(80) NOT NULL UNIQUE
```
