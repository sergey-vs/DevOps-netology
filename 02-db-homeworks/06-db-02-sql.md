# Домашнее задание к занятию 2. «SQL»

## Введение

Перед выполнением задания вы можете ознакомиться с [дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/virt-11/additional).

## Задание 1

*Используя Docker, поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.*

*Приведите получившуюся команду или docker-compose-манифест.*

***

## Задание 2

<details><summary><b>В БД из задачи 1:</b></summary>

 + создайте пользователя test-admin-user и БД test_db;
 + в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже);
 + предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db;
 + создайте пользователя test-simple-user;
 + предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE этих таблиц БД test_db.

</details>

<details><summary><b>Таблица orders:</b></summary>

 + id (serial primary key);
 + наименование (string);
 + цена (integer).

</details>

<details><summary><b>Таблица clients:</b></summary>

 + id (serial primary key);
 + фамилия (string);
 + страна проживания (string, index);
 + заказ (foreign key orders).

</details>

<details><summary><b>Приведите:</b></summary>

 + итоговый список БД после выполнения пунктов выше;
 + описание таблиц (describe);
 + SQL-запрос для выдачи списка пользователей с правами над таблицами test_db;
 + список пользователей с правами над таблицами test_db.

</details>

***

## Задание 3



***

## Задание 4


***

## Задание 5


***

## Задание 6
