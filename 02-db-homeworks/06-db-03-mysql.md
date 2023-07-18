# Домашнее задание к занятию "6.3. MySQL"

## Введение

Перед выполнением задания вы можете ознакомиться с [дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/virt-11/additional).

## Задание 1

*Используя Docker, поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume*.

```bash
┌──(sergey㉿kali)-[~/docker/mysqltest]
└─$ docker-compose build && docker-compose up -d
mysqldb uses an image, skipping
Creating network "mysqltest_default" with the default driver
Pulling mysqldb (mysql/mysql-server:8.0)...
8.0: Pulling from mysql/mysql-server
...
Digest: sha256:d6c8301b7834c5b9c2b733b10b7e630f441af7bc917c74dba379f24eeeb6a313
Status: Downloaded newer image for mysql/mysql-server:8.0
Creating mysqltest_mysqldb_1 ... done

```
*Изучите [бэкап БД](src/603/test_dump.sql) и восстановитесь из него*.

*Перейдите в управляющую консоль `mysql` внутри контейнера*.

```bash
┌──(sergey㉿kali)-[~/docker/mysqltest/restore]
└─$ docker ps -a                                                                                                                           
CONTAINER ID   IMAGE                    COMMAND                  CREATED        STATUS                    PORTS                                                        NAMES
5f763e36900c   mysql/mysql-server:8.0   "/entrypoint.sh mysq…"   26 hours ago   Up 27 minutes (healthy)   0.0.0.0:3306->3306/tcp, :::3306->3306/tcp, 33060-33061/tcp   mysqltest_mysqldb_1

┌──(sergey㉿kali)-[~/docker/mysqltest/restore]
└─$ docker exec -it mysqltest_mysqldb_1 sh
sh-4.4# mysql -u mysql_adm -p test_db < /var/lib/mysql-restore/test_dump.sql 
Enter password: 
sh-4.4# mysql -u mysql_adm -p test_db
Enter password: 
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 71
Server version: 8.0.32 MySQL Community Server - GPL

Copyright (c) 2000, 2023, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> 

```
*Используя команду `\h`, получите список управляющих команд*.

*Найдите команду для выдачи статуса БД и приведите в ответе из её вывода версию сервера БД*.

```bash
mysql> \s
--------------
mysql  Ver 8.0.32 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:          71
Current database:       test_db
Current user:           mysql_adm@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         8.0.32 MySQL Community Server - GPL
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8mb4
Db     characterset:    utf8mb4
Client characterset:    latin1
Conn.  characterset:    latin1
UNIX socket:            /var/lib/mysql/mysql.sock
Binary data as:         Hexadecimal
Uptime:                 37 min 25 sec

Threads: 2  Questions: 186  Slow queries: 0  Opens: 160  Flush tables: 3  Open tables: 78  Queries per second avg: 0.082
--------------

```

*Подключитесь к восстановленной БД и получите список таблиц из этой БД*

*Приведите в ответе количество записей с `price` > 300*.

```bash 
mysql> \u test_db
Database changed
mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| performance_schema |
| test_db            |
+--------------------+
3 rows in set (0.00 sec)

mysql> SHOW TABLES;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.00 sec)

mysql> select * from orders where price >300;
+----+----------------+-------+
| id | title          | price |
+----+----------------+-------+
|  2 | My little pony |   500 |
+----+----------------+-------+
1 row in set (0.00 sec)

mysql> \q
Bye

```

*В следующих заданиях мы будем продолжать работу с этим контейнером*.

***

## Задание 2

*Создайте пользователя test в БД c паролем test-pass, используя*:

 + плагин авторизации mysql_native_password
 + срок истечения пароля — 180 дней
 + количество попыток авторизации — 3
 + максимальное количество запросов в час — 100
 + аттрибуты пользователя:
     - Фамилия "Pretty"
     - Имя "James".

*Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`*.

*Используя таблицу **INFORMATION_SCHEMA.USER_ATTRIBUTES**, получите данные по пользователю `test` и приведите в ответе к задаче*.
 
***

## Задание 3

*Установите профилирование `SET profiling = 1`. Изучите вывод профилирования команд `SHOW PROFILES;`*.

*Исследуйте, `какой engine` используется в таблице БД `test_db` и приведите в ответе*.

*Измените `engine` и приведите время выполнения и запрос на изменения из профайлера в ответе*:

 - на `MyISAM`,
 - на `InnoDB`.

***

## Задание 4

*Изучите файл `my.cnf` в директории* **/etc/mysql**.

*Измените его согласно ТЗ (движок InnoDB)*:

 - скорость IO важнее сохранности данных;
 - нужна компрессия таблиц для экономии места на диске;
 - размер буффера с незакомиченными транзакциями 1 Мб;
 - буффер кеширования 30% от ОЗУ;
 - размер файла логов операций 100 Мб.
 - Приведите в ответе изменённый файл `my.cnf`.
