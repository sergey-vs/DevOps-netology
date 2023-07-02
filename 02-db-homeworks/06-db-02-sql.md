# Домашнее задание к занятию 2. «SQL»

## Введение

Перед выполнением задания вы можете ознакомиться с [дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/virt-11/additional).

## Задание 1

*Используя Docker, поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.*

*Приведите получившуюся команду или docker-compose-манифест.*

<details><summary><b>docker-compose.yml</b></summary>

```yml
version: "3.7"

volumes:
  data: {}
  backup: {}

services:
  postgres:
    container_name: psql
    image: postgres:12
    restart: always
    environment:
      POSTGRES_PASSWORD: "passwd"
      PGDATA: "/var/lib/postgresql/data/pgdata"
    volumes:
      - ./:/var/lib/postgresql/data
      - ./backup:/var/lib/postgresql/backup
    ports:
      - "0.0.0.0:5432:5432"
```

</details>

```bash
┌──(sergey㉿kali)-[~/docker/dbtest]
└─$ docker-compose build && docker-compose up -d
postgres uses an image, skipping
Creating network "dbtest_default" with the default driver
Creating volume "dbtest_data" with default driver
Creating volume "dbtest_backup" with default driver
Pulling postgres (postgres:12)...
12: Pulling from library/postgres
5b5fe70539cd: Pull complete
...
99197f9b9881: Pull complete
Digest: sha256:723e604853502af74506a537fda6c2301a0dc0cee39b2cbb73c03abd2aeed5a8
Status: Downloaded newer image for postgres:12
Creating psql ... done

──(sergey㉿kali)-[~/docker/dbtest]                                                                                                                         
└─$ docker ps -a                                                                                                                                            
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS          PORTS                    NAMES                                       
319da3ce8ea4   postgres:12   "docker-entrypoint.s…"   17 seconds ago   Up 16 seconds   0.0.0.0:5432->5432/tcp   psql

┌──(sergey㉿kali)-[~/docker/dbtest]                                                                                                                         
└─$ docker exec -it psql sh                                                                                                                                 
# ls -la /var/lib/postgresql                                                                                                                                
total 20                                                                                                                                                    
drwxr-xr-x 1 postgres postgres 4096 Jul  2 07:54 .                                                                                                          
drwxr-xr-x 1 root     root     4096 Jun 14 21:34 ..                                                                                                         
drwxr-xr-x 2 root     root     4096 Jul  2 07:54 backup                                                                                                     
drwxr-xr-x 3 root     root     4096 Jul  2 07:54 data  
```
***

## Задание 2

<em>В БД из задачи 1:</em>

 + создайте пользователя test-admin-user и БД test_db;

```bash
# su - postgres
postgres@319da3ce8ea4:~$ pdql
-bash: pdql: command not found
postgres@319da3ce8ea4:~$ psql
psql (12.15 (Debian 12.15-1.pgdg120+1))
Type "help" for help.

postgres=# CREATE USER "test-admin-user" WITH PASSWORD 'passwd';
ERROR:  role "test-admin-user" already exists
postgres=# CREATE DATABASE test_db;
ERROR:  database "test_db" already exists
postgres=# \c test_db
You are now connected to database "test_db" as user "postgres".
test_db=# 
```

 + в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже);

```bash
test_db=# CREATE TABLE orders (id SERIAL PRIMARY KEY, наименование TEXT,  цена INT);
CREATE TABLE
test_db=# CREATE TABLE clients(id SERIAL PRIMARY KEY, фамилия TEXT, страна_проживания TEXT, заказ INT, CONSTRAINT fk_orders FOREIGN KEY (заказ) REFERENCES orders (id));
CREATE TABLE
test_db=# CREATE INDEX страна_проживания_idx ON clients(страна_проживания);
CREATE INDEX
test_db=# 
```

 + предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db;

```bash
test_db=# GRANT ALL PRIVILEGES ON DATABASE test_db TO "test-admin-user";
GRANT
test_db=# GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO "test-admin-user";
GRANT
test_db=# GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO "test-admin-user";
GRANT
```

 + создайте пользователя test-simple-user;

```bash
test_db=# CREATE USER "test-simple-user" WITH PASSWORD 'passwd';
CREATE ROLE
```

 + предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE этих таблиц БД test_db.

```bash
test_db=# GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO "test-simple-user";
GRANT
test_db=# 
```

<details><summary><em>Таблица orders:</em></summary>

 + id (serial primary key);
 + наименование (string);
 + цена (integer).

</details>

<details><summary><em>Таблица clients:</em></summary>

 + id (serial primary key);
 + фамилия (string);
 + страна проживания (string, index);
 + заказ (foreign key orders).

</details>

<em>Приведите:</em>

 + итоговый список БД после выполнения пунктов выше;

```bash
test_db=# \list
                                     List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |       Access privileges        
-----------+----------+----------+------------+------------+--------------------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                   +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                   +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/postgres                  +
           |          |          |            |            | postgres=CTc/postgres         +
           |          |          |            |            | "test-admin-user"=CTc/postgres
(4 rows)
```

 + описание таблиц (describe);

```bash
test_db=# \d orders
                                     Table "public.orders"
          Column          |  Type   | Collation | Nullable |              Default               
--------------------------+---------+-----------+----------+------------------------------------
 id                       | integer |           | not null | nextval('orders_id_seq'::regclass)
 наименование             | text    |           |          | 
 цена                     | integer |           |          | 
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "fk_orders" FOREIGN KEY ("заказ") REFERENCES orders(id)

test_db=# \d clients
                                          Table "public.clients"
              Column               |  Type   | Collation | Nullable |               Default               
-----------------------------------+---------+-----------+----------+-------------------------------------
 id                                | integer |           | not null | nextval('clients_id_seq'::regclass)
 фамилия                           | text    |           |          | 
 страна_проживания                 | text    |           |          | 
 заказ                             | integer |           |          | 
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "страна_проживания_idx" btree ("страна_проживания")
Foreign-key constraints:
    "fk_orders" FOREIGN KEY ("заказ") REFERENCES orders(id)

```
 + SQL-запрос для выдачи списка пользователей с правами над таблицами test_db;

`SELECT * from information_schema.table_privileges WHERE table_catalog ILIKE 'test_db%' and table_schema ILIKE 'public';`

 + список пользователей с правами над таблицами test_db.

```bash
test_db=# SELECT * from information_schema.table_privileges WHERE table_catalog ILIKE 'test_db%' and table_schema ILIKE 'public';
 grantor  |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy 
----------+------------------+---------------+--------------+------------+----------------+--------------+----------------
 postgres | postgres         | test_db       | public       | orders     | INSERT         | YES          | NO
 postgres | postgres         | test_db       | public       | orders     | SELECT         | YES          | YES
 postgres | postgres         | test_db       | public       | orders     | UPDATE         | YES          | NO
 postgres | postgres         | test_db       | public       | orders     | DELETE         | YES          | NO
 postgres | postgres         | test_db       | public       | orders     | TRUNCATE       | YES          | NO
 postgres | postgres         | test_db       | public       | orders     | REFERENCES     | YES          | NO
 postgres | postgres         | test_db       | public       | orders     | TRIGGER        | YES          | NO
 postgres | test-admin-user  | test_db       | public       | orders     | INSERT         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | SELECT         | NO           | YES
 postgres | test-admin-user  | test_db       | public       | orders     | UPDATE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | DELETE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | TRUNCATE       | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | REFERENCES     | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | TRIGGER        | NO           | NO
 postgres | test-simple-user | test_db       | public       | orders     | INSERT         | NO           | NO
 postgres | test-simple-user | test_db       | public       | orders     | SELECT         | NO           | YES
 postgres | test-simple-user | test_db       | public       | orders     | UPDATE         | NO           | NO
 postgres | test-simple-user | test_db       | public       | orders     | DELETE         | NO           | NO
 postgres | postgres         | test_db       | public       | clients    | INSERT         | YES          | NO
 postgres | postgres         | test_db       | public       | clients    | SELECT         | YES          | YES
 postgres | postgres         | test_db       | public       | clients    | UPDATE         | YES          | NO
 postgres | postgres         | test_db       | public       | clients    | DELETE         | YES          | NO
 postgres | postgres         | test_db       | public       | clients    | TRUNCATE       | YES          | NO
 postgres | postgres         | test_db       | public       | clients    | REFERENCES     | YES          | NO
 postgres | postgres         | test_db       | public       | clients    | TRIGGER        | YES          | NO
 postgres | test-admin-user  | test_db       | public       | clients    | INSERT         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | SELECT         | NO           | YES
 postgres | test-admin-user  | test_db       | public       | clients    | UPDATE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | DELETE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | TRUNCATE       | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | REFERENCES     | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | TRIGGER        | NO           | NO
 postgres | test-simple-user | test_db       | public       | clients    | INSERT         | NO           | NO
 postgres | test-simple-user | test_db       | public       | clients    | SELECT         | NO           | YES
 postgres | test-simple-user | test_db       | public       | clients    | UPDATE         | NO           | NO
 postgres | test-simple-user | test_db       | public       | clients    | DELETE         | NO           | NO
(36 rows)

test_db-# \dp                                                                                                                    
                                           Access privileges
 Schema |      Name      |   Type   |         Access privileges          | Column privileges | Policies 
--------+----------------+----------+------------------------------------+-------------------+----------
 public | clients        | table    | postgres=arwdDxt/postgres         +|                   | 
        |                |          | "test-admin-user"=arwdDxt/postgres+|                   | 
        |                |          | "test-simple-user"=arwd/postgres   |                   | 
 public | clients_id_seq | sequence | postgres=rwU/postgres             +|                   | 
        |                |          | "test-admin-user"=rwU/postgres     |                   | 
 public | orders         | table    | postgres=arwdDxt/postgres         +|                   | 
        |                |          | "test-admin-user"=arwdDxt/postgres+|                   | 
        |                |          | "test-simple-user"=arwd/postgres   |                   | 
 public | orders_id_seq  | sequence | postgres=rwU/postgres             +|                   | 
        |                |          | "test-admin-user"=rwU/postgres     |                   | 
(4 rows)

```

***

## Задание 3

*Используя SQL-синтаксис, наполните таблицы следующими тестовыми данными*:

<details><summary><em>Таблица orders</em></summary>

 |Наименование|цена|
 |------------|----|
 |Шоколад| 10 |
 |Принтер| 3000 |
 |Книга| 500 |
 |Монитор| 7000|
 |Гитара| 4000|

</details>

```bash
test_db=# INSERT INTO public.orders (наименование, цена) VALUES('Шоколад', 10),('Принтер', 3000),('Книга', 500),('Монитор', 7000),('Гитара', 4000);
INSERT 0 5
```
 
<details><summary><em>Таблица clients</em></summary>

 |ФИО|Страна проживания|
 |------------|----|
 |Иванов Иван Иванович| USA |
 |Петров Петр Петрович| Canada |
 |Иоганн Себастьян Бах| Japan |
 |Ронни Джеймс Дио| Russia|
 |Ritchie Blackmore| Russia|
 
</details>

```bash
test_db=# INSERT INTO public.clients (фамилия, страна_проживания) VALUES('Иванов Иван Иванович', 'USA'),('Петров Петр Петрович', 'Canada'),('Иоганн Себастьян Бах', 'Japan'),('�онни Джеймс Дио', 'Russia'),('Ritchie Blackmore', 'Russia');

INSERT 0 5
```

*Используя SQL-синтаксис*:

 + вычислите количество записей для каждой таблицы.

```bash
test_db=# select count(*) from orders;
 count 
-------
     5
(1 row)

test_db=# select count(*) from clients;
 count 
-------
     5
(1 row)
```

*Приведите в ответе*:
- запросы,
- результаты их выполнения.

```sql
test_db=# select * from orders;
 id | наименование | цена 
----+--------------------------+----------
  1 | Шоколад           |       10
  2 | Принтер           |     3000
  3 | Книга             |      500
  4 | Монитор           |     7000
  5 | Гитара            |     4000
(5 rows)

test_db=# select * from clients;
 id |             фамилия             | страна_проживания | заказ 
----+----------------------------------------+-----------------------------------+------------
  1 | Иванов Иван Иванович | USA                               |           
  2 | Петров Петр Петрович | Canada                            |           
  3 | Иоганн Себастьян Бах | Japan                             |           
  4 | Ронни Джеймс Дио     | Russia                            |           
  5 | Ritchie Blackmore    | Russia                            |           
(5 rows)
```

***

## Задание 4

*Часть пользователей из таблицы clients решили оформить заказы из таблицы orders*.

<details><summary><em>Используя foreign keys, свяжите записи из таблиц, согласно таблице:</em></summary>

 |ФИО|Заказ|
 |------------|----|
 |Иванов Иван Иванович| Книга |
 |Петров Петр Петрович| Монитор |
 |Иоганн Себастьян Бах| Гитара |

</details>

*Приведите SQL-запросы для выполнения этих операций*.

```sql
test_db=# update clients set заказ =(select id from orders o where наименование='Книга') where фамилия ='Иванов Иван Иванович';
UPDATE 1
test_db=# update clients set заказ =(select id from orders o where наименование='Монитор') where фамилия ='Петров Петр Петрович';
UPDATE 1
test_db=# update clients set заказ =(select id from orders o where наименование='Гитара') where фамилия ='Иоганн Себастьян Бах';
UPDATE 1
test_db=# select * from clients;
 id |             фамилия             | страна_проживания | заказ 
----+----------------------------------------+-----------------------------------+------------
  4 | Ронни Джеймс Дио     | Russia                            |           
  5 | Ritchie Blackmore    | Russia                            |           
  1 | Иванов Иван Иванович | USA                               |          3
  2 | Петров Петр Петрович | Canada                            |          4
  3 | Иоганн Себастьян Бах | Japan                             |          5
(5 rows)
```

*Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод этого запроса*.

```sql
test_db=# select * from clients c join orders o on c.заказ =o.id and c.заказ IS NOT NULL order by c.id;
 id |             фамилия             | страна_проживания | заказ | id | наименование | цена 
----+----------------------------------------+-----------------------------------+------------+----+--------------------------+----------
  1 | Иванов Иван Иванович | USA                               |          3 |  3 | Книга             |      500
  2 | Петров Петр Петрович | Canada                            |          4 |  4 | Монитор           |     7000
  3 | Иоганн Себастьян Бах | Japan                             |          5 |  5 | Гитара            |     4000
(3 rows)
```

*Подсказка: используйте директиву* `UPDATE`.

***

## Задание 5

*Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 (используя директиву EXPLAIN)*.

```bash
test_db=# explain select * from clients where заказ is not null;
                        QUERY PLAN                         
-----------------------------------------------------------
 Seq Scan on clients  (cost=0.00..18.10 rows=806 width=72)
   Filter: ("заказ" IS NOT NULL)
(2 rows)

test_db=# explain select * from clients c join orders o on c.заказ =o.id and c.заказ IS NOT NULL order by c.id;
                                  QUERY PLAN                                   
-------------------------------------------------------------------------------
 Sort  (cost=96.14..98.15 rows=806 width=116)
   Sort Key: c.id
   ->  Hash Join  (cost=37.00..57.23 rows=806 width=116)
         Hash Cond: (c."заказ" = o.id)
         ->  Seq Scan on clients c  (cost=0.00..18.10 rows=806 width=72)
               Filter: ("заказ" IS NOT NULL)
         ->  Hash  (cost=22.00..22.00 rows=1200 width=40)
               ->  Seq Scan on orders o  (cost=0.00..22.00 rows=1200 width=40)
(8 rows)
```

*Приведите получившийся результат и объясните, что значат полученные значения*.

 При первом запросе по таблице clients планировщик выбрал план простого последовательного сканирования.

*Числа, перечисленные в скобках (слева направо), имеют следующий смысл: Стоимость запуска (0.00) - время, которое проходит, прежде чем начнётся этап вывода данных, например для сортирующего узла это время сортировки. Вторая цифра - общая стоимость (18.10) - вычисляется в предположении что данная часть плана выполняется до конца, то есть возвращает все доступные строки. Ожидаемое количество строк (806), которое должен вывести этот узел плана при выполнении до конца узла плана. Ожидаемый средний размер строк (72), выводимых этим узлом плана (в байтах)*.

 Второй план запроса включает стоимость выполненич сортировки результата и сканирования таблицы orders
***

## Задание 6

*Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. задачу 1).*

```bash
postgres@319da3ce8ea4:~$ exit
logout
# chown -R postgres:postgres /var/lib/postgresql/backup/
#  ls -la /var/lib/postgresql/
total 28
drwxr-xr-x 1 postgres postgres 4096 Jul  2 08:04 .
drwxr-xr-x 1 root     root     4096 Jun 14 21:34 ..
drwxr-xr-x 2 postgres postgres 4096 Jul  2 07:54 backup
-rw------- 1 postgres postgres   15 Jul  2 08:04 .bash_history
drwxr-xr-x 3 root     root     4096 Jul  2 07:54 data
-rw------- 1 postgres postgres 2181 Jul  2 08:03 .psql_history
# su - postgres
postgres@319da3ce8ea4:~$ cd /var/lib/postgresql/backup/
postgres@319da3ce8ea4:~/backup$ pg_dumpall --database=test_db -c -U postgres | gzip > dump_test_db.gz
postgres@319da3ce8ea4:~/backup$ pg_dump -Fd test_db -f dump_2023_07_02                               
postgres@319da3ce8ea4:~/backup$ ls -la
total 16
drwxr-xr-x 3 postgres postgres 4096 Jul  2 08:05 .
drwxr-xr-x 1 postgres postgres 4096 Jul  2 08:04 ..
drwx------ 2 postgres postgres 4096 Jul  2 08:05 dump_2023_07_02
-rw-r--r-- 1 postgres postgres 2004 Jul  2 08:05 dump_test_db.gz
```

*Остановите контейнер с PostgreSQL, но не удаляйте volumes*.

```bash
┌──(sergey㉿kali)-[~/docker/dbtest]
└─$ docker-compose stop                                                                                                                                     
Stopping psql ... done
```

*Поднимите новый пустой контейнер с PostgreSQL*.

```bash
┌──(sergey㉿kali)-[~/docker/dbtest]
└─$ docker run --name psql2 -e POSTGRES_PASSWORD=passwd -e PGDATA=/var/lib/postgresql/data/pgdata -d -v "$(pwd)/newdata":/var/lib/postgresql/data -v "/home/sergey/docker/dbtest/backup":/var/lib/postgresql/backup:rw postgres:12
ad6ae862c3d84fad0c28fda601e33ada56e0b6a77410016ee31d175f7de2b78d
┌──(sergey㉿kali)-[~/docker/dbtest]
└─$ docker ps -a
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS                     PORTS      NAMES
ad6ae862c3d8   postgres:12   "docker-entrypoint.s…"   23 seconds ago   Up 22 seconds              5432/tcp   psql2
319da3ce8ea4   postgres:12   "docker-entrypoint.s…"   16 minutes ago   Exited (0) 7 minutes ago              psql
```

*Восстановите БД test_db в новом контейнере*.

```bash
──(sergey㉿kali)-[~/docker/dbtest]
└─$ docker exec -it psql2 sh
# su - postgres
postgres@ad6ae862c3d8:~$ psql -U postgres -c 'create database test_db;'
CREATE DATABASE
postgres@ad6ae862c3d8:~$ cd backup/
postgres@ad6ae862c3d8:~/backup$ ls
dump_2023_07_02  dump_test_db.gz
postgres@ad6ae862c3d8:~/backup$ gzip -d dump_test_db.gz
postgres@ad6ae862c3d8:~/backup$ psql -U postgres -W test_db < dump_test_db
Password: 
SET
...

GRANT
postgres@ad6ae862c3d8:~/backup$ psql -h localhost -U test-admin-user test_db
psql (12.15 (Debian 12.15-1.pgdg120+1))
Type "help" for help.

test_db=> \list
                                     List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |       Access privileges        
-----------+----------+----------+------------+------------+--------------------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                   +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | postgres=CTc/postgres         +
           |          |          |            |            | =c/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/postgres                  +
           |          |          |            |            | postgres=CTc/postgres         +
           |          |          |            |            | "test-admin-user"=CTc/postgres
(4 rows)

test_db=> SELECT c.* FROM clients c JOIN orders o ON c.заказ = o.id;
 id |             фамилия             | страна_проживания | заказ 
----+----------------------------------------+-----------------------------------+------------
  2 | Петров Петр Петрович | Canada                            |          4
  1 | Иванов Иван Иванович | USA                               |          3
  3 | Иоганн Себастьян Бах | Japan                             |          5
(3 rows)

test_db=> exit
postgres@ad6ae862c3d8:~/backup$ psql -h localhost -U test-admin-user test_db


```
*Приведите список операций, который вы применяли для бэкапа данных и восстановления*.
