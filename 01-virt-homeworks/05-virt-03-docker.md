# Домашнее задание к занятию 5.3. «Введение. Экосистема. Архитектура. Жизненный цикл Docker-контейнера»

***

## Задание 1

<details><summary><b>Сценарий выполнения задачи:</b></summary>

> + создайте свой репозиторий на https://hub.docker.com;
> + выберите любой образ, который содержит веб-сервер Nginx;
> + создайте свой fork образа;
> + реализуйте функциональность: запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
>```
> <html>
> <head>
> Hey, Netology
> </head>
> <body>
> <h1>I’m DevOps Engineer!</h1>
> </body>
> </html>
>```
>Опубликуйте созданный fork в своём репозитории и предоставьте ответ в виде ссылки на  
>https://hub.docker.com/username_repo.

</details>

***

## Задание 2

*Посмотрите на сценарий ниже и ответьте на вопрос*: «*Подходит ли в этом сценарии использование Docker-контейнеров* 
*или лучше подойдёт виртуальная машина, физическая машина? Может быть, возможны разные варианты*?»

*Детально опишите и обоснуйте свой выбор*.

<b>Сценарий</b>

> Высоконагруженное монолитное Java веб-приложение

Целесообразно использовать виртуальные или физические машины, т.к. типичное монолитное приложение обычно тяжеловесно и высоконагруженно что требует прямого доступа к ресурсам.

> Nodejs веб-приложение

Это веб приложение, для таких приложений достаточно докера. Простота развертывания приложения, лёгковесность и масштабирование.

> Мобильное приложение c версиями для Android и iOS

Необходим GUI, так что подойдет виртуалка.

> Шина данных на базе Apache Kafka

Т.к. шина данных является специфическим связующим звеном, в проектах мы используем физические и виртуальные сервера - в основном связано с тем что при переконфигурировании шины велика вероятность потери отправленных данных.

> Elasticsearch-кластер для реализации логирования продуктивного веб-приложения — три ноды elasticsearch, два logstash и две ноды kibana

Elasticsearch лучше на VM, отказоустойчивость решается на уровне кластера, kibana и logstash можно вынести в Docker.

> Мониторинг-стек на базе Prometheus и Grafana

 Docker, так как данные не хранятся, и масштабировать легко, лёгкость и скорость развёртывания.

> MongoDB как основное хранилище данных для Java-приложения

Можно использовать виртуальную машину, можно физический сервер. Разница вероятно всего в нагруженности сервиса при большой нагрузке лучше использовать физический сервер.

> Gitlab-сервер для реализации CI/CD-процессов и приватный (закрытый) Docker Registry

Docker не подходит в данном случае, т.к. при потере контейнера будет сложно восстановить частоизменяемые данные. Здесь больше подходят физические или виртуальные сервера.

***

## Задание 3

 + *Запустите первый контейнер из образа* **centos** *c любым тегом в фоновом режиме, подключив папку `/data` из текущей рабочей директории на хостовой машине в `/data` контейнера*.
 + *Запустите второй контейнер из образа* **debian** *в фоновом режиме, подключив папку `/data` из текущей рабочей директории на хостовой машине в `/data` контейнера*.
 + *Подключитесь к первому контейнеру с помощью `docker exec` и создайте текстовый файл любого содержания в `/data`*.
 + *Добавьте ещё один файл в папку `/data` на хостовой машине*.
 + *Подключитесь во второй контейнер и отобразите листинг и содержание файлов в `/data` контейнера*.

```shell
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
vagrant@server1:~$ docker run -v /data:/data -dt --name centos centos
Unable to find image 'centos:latest' locally
latest: Pulling from library/centos
a1d0c7532777: Pull complete 
Digest: sha256:a27fd8080b517143cbbbab9dfb7c8571c40d67d534bbdee55bd6c473f432b177
Status: Downloaded newer image for centos:latest
58793b2710d7ec02de98828f21ca0cade9b361f7fb0dedc837e07b3e1c83f3be
vagrant@server1:~$ docker run -v /data:/data -dt --name debian debian
Unable to find image 'debian:latest' locally
latest: Pulling from library/debian
bd73737482dd: Pull complete 
Digest: sha256:432f545c6ba13b79e2681f4cc4858788b0ab099fc1cca799cc0fae4687c69070
Status: Downloaded newer image for debian:latest
fc621565d45259471f673d437b879faae83f30be4c87552c960fa48c4523e7aa
vagrant@server1:~$ docker exec -it centos /bin/sh
sh-4.4# echo 'it from centos'>/data/from-centos
sh-4.4# exit
exit
vagrant@server1:~$ su
Password: 
root@server1:/home/vagrant# cd
root@server1:~# echo 'from localhost'>/data/localhost
root@server1:~# exit
exit
vagrant@server1:~$ docker exec -it debian /bin/sh
# cat /data/from-centos
it from centos
# ls -la /data
total 16
drwxr-xr-x 2 root root 4096 May 23 14:20 .
drwxr-xr-x 1 root root 4096 May 23 14:16 ..
-rw-r--r-- 1 root root   15 May 23 14:19 from-centos
-rw-r--r-- 1 root root   15 May 23 14:20 localhost
# exit
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND       CREATED         STATUS         PORTS     NAMES
fc621565d452   debian    "bash"        7 minutes ago   Up 7 minutes             debian
58793b2710d7   centos    "/bin/bash"   7 minutes ago   Up 7 minutes             centos
```
***

## Задание 4(*)

*Воспроизведите практическую часть лекции самостоятельно*.

*Соберите Docker-образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам*.
