# Домашнее задание к занятию "6.3. MySQL"

## Введение

Перед выполнением задания вы можете ознакомиться с [дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/virt-11/additional).

## Задание 1

*Используя Docker, поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume*.

<details><summary><b>docker-compose.yml</b></summary>

```yml
version: "3.9"
services:
  mysqldb:
    image: mysql/mysql-server:8.0
    restart: always
    environment:
      MYSQL_USER: 'mysql_adm'
      MYSQL_PASSWORD: '123'
      MYSQL_DATABASE: 'test_db'
      MYSQL_ROOT_PASSWORD: '123'
    volumes:
      - ./data:/var/lib/mysql
      - ./backup:/var/lib/mysql-backup
      - ./restore:/var/lib/mysql-restore
    ports:
      - "3306:3306"

```

</details>

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

```bash
┌──(sergey㉿kali)-[~/docker]
└─$ docker exec -it mysqltest_mysqldb_1 sh
sh-4.4# mysql -u root -p test_db
Enter password: 
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 21
Server version: 8.0.32 MySQL Community Server - GPL

Copyright (c) 2000, 2023, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> CREATE USER
    -> 'test'@'localhost' IDENTIFIED WITH mysql_native_password by 'test-pass'
    -> PASSWORD EXPIRE INTERVAL 180 DAY
    -> FAILED_LOGIN_ATTEMPTS 3
    -> PASSWORD HISTORY 100
    -> ATTRIBUTE '{"fname": "James","lname": "Pretty"}';
Query OK, 0 rows affected (0.01 sec)

mysql> GRANT SELECT ON test_db.* to 'test'@'localhost';
Query OK, 0 rows affected, 1 warning (0.00 sec)

```

*Используя таблицу **INFORMATION_SCHEMA.USER_ATTRIBUTES**, получите данные по пользователю `test` и приведите в ответе к задаче*.
 
```bash
mysql> select * from information_schema.user_attributes where user like '%test%';
+------+-----------+---------------------------------------+
| USER | HOST      | ATTRIBUTE                             |
+------+-----------+---------------------------------------+
| test | localhost | {"fname": "James", "lname": "Pretty"} |
+------+-----------+---------------------------------------+
1 row in set (0.00 sec)

```
***

## Задание 3

*Установите профилирование `SET profiling = 1`. Изучите вывод профилирования команд `SHOW PROFILES;`*.

```bash
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> show profiles;
+----------+------------+---------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                     |
+----------+------------+---------------------------------------------------------------------------+
|        1 | 0.00062925 | SHOW DATABASES                                                            |
|        2 | 0.00078000 | SHOW TABLES                                                               |
|        3 | 0.00028300 | select * from orders where price >300                                     |
|        4 | 0.00035500 | select * from information_schema.user_attributes where user like '%test%' |
|        5 | 0.00012600 | SET profiling = 1                                                         |
+----------+------------+---------------------------------------------------------------------------+
5 rows in set, 1 warning (0.00 sec)

```

*Исследуйте, какой `engine` используется в таблице БД `test_db` и приведите в ответе*.

```bash
mysql>  SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES where TABLE_SCHEMA = 'test_db';
+------------+--------+
| TABLE_NAME | ENGINE |
+------------+--------+
| orders     | InnoDB |
+------------+--------+
1 row in set (0.00 sec)

```

*Измените `engine` и приведите время выполнения и запрос на изменения из профайлера в ответе*:

 - на `MyISAM`,
 - на `InnoDB`.

```bash
mysql> ALTER TABLE orders ENGINE = MyIsam;
Query OK, 5 rows affected (0.01 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES where TABLE_SCHEMA = 'test_db';
+------------+--------+
| TABLE_NAME | ENGINE |
+------------+--------+
| orders     | MyISAM |
+------------+--------+
1 row in set (0.00 sec)

mysql> ALTER TABLE orders ENGINE = InnoDB;
Query OK, 5 rows affected (0.01 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES where TABLE_SCHEMA = 'test_db';
+------------+--------+
| TABLE_NAME | ENGINE |
+------------+--------+
| orders     | InnoDB |
+------------+--------+
1 row in set (0.00 sec)

mysql> SHOW PROFILES;
+----------+------------+-----------------------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                                   |
+----------+------------+-----------------------------------------------------------------------------------------+
|        1 | 0.00062925 | SHOW DATABASES                                                                          |
|        2 | 0.00078000 | SHOW TABLES                                                                             |
|        3 | 0.00028300 | select * from orders where price >300                                                   |
|        4 | 0.00035500 | select * from information_schema.user_attributes where user like '%test%'               |
|        5 | 0.00012600 | SET profiling = 1                                                                       |
|        6 | 0.00069825 | SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES where TABLE_SCHEMA = 'test_db' |
|        7 | 0.00870075 | ALTER TABLE orders ENGINE = MyIsam                                                      |
|        8 | 0.00077625 | SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES where TABLE_SCHEMA = 'test_db' |
|        9 | 0.01066700 | ALTER TABLE orders ENGINE = InnoDB                                                      |
|       10 | 0.00076625 | SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES where TABLE_SCHEMA = 'test_db' |
+----------+------------+-----------------------------------------------------------------------------------------+
10 rows in set, 1 warning (0.00 sec)

```

***

## Задание 4

*Изучите файл `my.cnf` в директории* **/etc/mysql**.

```bash
sh-4.4# cat /etc/my.cnf
# For advice on how to change settings please see
# http://dev.mysql.com/doc/refman/8.0/en/server-configuration-defaults.html

[mysqld]
#
# Remove leading # and set to the amount of RAM for the most important data
# cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
# innodb_buffer_pool_size = 128M
#
# Remove leading # to turn on a very important data integrity option: logging
# changes to the binary log between backups.
# log_bin
#
# Remove leading # to set options mainly useful for reporting servers.
# The server defaults are faster for transactions and fast SELECTs.
# Adjust sizes as needed, experiment to find the optimal values.
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M

# Remove leading # to revert to previous value for default_authentication_plugin,
# this will increase compatibility with older clients. For background, see:
# https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_default_authentication_plugin
# default-authentication-plugin=mysql_native_password
skip-host-cache
skip-name-resolve
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
secure-file-priv=/var/lib/mysql-files
user=mysql

pid-file=/var/run/mysqld/mysqld.pid

```

*Измените его согласно ТЗ (движок InnoDB)*:

 - скорость IO важнее сохранности данных;
 - нужна компрессия таблиц для экономии места на диске;
 - размер буффера с незакомиченными транзакциями 1 Мб;
 - буффер кеширования 30% от ОЗУ;
 - размер файла логов операций 100 Мб.
 - Приведите в ответе изменённый файл `my.cnf`.

```bash
sh-4.4# cat /etc/my.cnf
[mysqld]

skip-host-cache
skip-name-resolve
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
secure-file-priv=/var/lib/mysql-files
user=mysql

pid-file=/var/run/mysqld/mysqld.pid

innodb_flush_method = O_DSYNC
innodb_log_file_size = 100M
innodb_file_per_table = ON
innodb_log_buffer_size = 1M
innodb_buffer_pool_size = 10M
```
