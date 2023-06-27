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
netology@deb11-vm1:~/docker$ docker-compose build && docker-compose up -d
[+] Running 14/14
 ⠿ postgres Pulled                                                                                                                                                                                                        22.4s
   ⠿ 5b5fe70539cd Pull complete                                                                                                                                                                                            7.0s
   ...
   ⠿ f542e36db272 Pull complete                                                                                                                                                                                           18.8s
[+] Running 2/2
 ⠿ Network docker_default  Created                                                                                                                                                                                         0.0s
 ⠿ Container psql          Started     
netology@deb11-vm1:~/docker$ docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED         STATUS         PORTS                    NAMES
c10e7549b26a   postgres:12   "docker-entrypoint.s…"   3 minutes ago   Up 3 minutes   0.0.0.0:5432->5432/tcp   psql
netology@deb11-vm1:~/docker$ docker exec -it psql sh
# ls -la /var/lib/postgresql
total 20
drwxr-xr-x 1 postgres postgres 4096 Jun 27 12:19 .
drwxr-xr-x 1 root     root     4096 Jun 14 21:34 ..
drwxr-xr-x 2 root     root     4096 Jun 27 12:19 backup
drwxr-xr-x 4     1000     1000 4096 Jun 27 12:19 data
# 

```

***

## Задание 2

<em>В БД из задачи 1:</em>

 + создайте пользователя test-admin-user и БД test_db;

```bash
# su - postgres
postgres@c10e7549b26a:~$ psql
psql (12.15 (Debian 12.15-1.pgdg120+1))
Type "help" for help.

postgres=# CREATE USER "test-admin-user" WITH PASSWORD 'passwd';
CREATE ROLE
postgres=# CREATE DATABASE test_db;
CREATE DATABASE
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

<details><summary><em>Приведите:</em></summary>

 + итоговый список БД после выполнения пунктов выше;
 + описание таблиц (describe);
 + SQL-запрос для выдачи списка пользователей с правами над таблицами test_db;
 + список пользователей с правами над таблицами test_db.

</details>

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
 
<details><summary><em>Таблица clients</em></summary>

 |ФИО|Страна проживания|
 |------------|----|
 |Иванов Иван Иванович| USA |
 |Петров Петр Петрович| Canada |
 |Иоганн Себастьян Бах| Japan |
 |Ронни Джеймс Дио| Russia|
 |Ritchie Blackmore| Russia|
 
</details>

*Используя SQL-синтаксис*:

 + вычислите количество записей для каждой таблицы.

*Приведите в ответе*:


```
- запросы,
- результаты их выполнения.
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

*Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод этого запроса*.

*Подсказка: используйте директиву* `UPDATE`.

***

## Задание 5

*Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 (используя директиву EXPLAIN)*.

*Приведите получившийся результат и объясните, что значат полученные значения*.

***

## Задание 6

*Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. задачу 1).*

*Остановите контейнер с PostgreSQL, но не удаляйте volumes*.

*Поднимите новый пустой контейнер с PostgreSQL*.

*Восстановите БД test_db в новом контейнере*.

*Приведите список операций, который вы применяли для бэкапа данных и восстановления*.
