# Домашнее задание к занятию 5.3. «Введение. Экосистема. Архитектура. Жизненный цикл Docker-контейнера»

***

## Задание 1

<details><summary><b>Сценарий выполнения задания:</b></summary>

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

</details>

<details><summary><b>Выполнение задания:</b></summary>

```SHELL
netology@deb11-vm1:~/docker$ sudo docker pull nginx:1.24.0-alpine
1.24.0-alpine: Pulling from library/nginx
Digest: sha256:b7db705c8986070be8aa99ec0886886ddb3c75b1e46301f54865b16db79e9e52
Status: Image is up to date for nginx:1.24.0-alpine
docker.io/library/nginx:1.24.0-alpine

netology@deb11-vm1:~/docker$ sudo docker images
REPOSITORY   TAG             IMAGE ID       CREATED       SIZE
nginx        1.24.0-alpine   1266a3a46e96   5 weeks ago   41.1MB

netology@deb11-vm1:~/docker$ sudo docker build -t vs813/devops27-nginx:v1 .
[+] Building 0.2s (7/7) FINISHED                                                                                                                                                                                               
 => [internal] load build definition from Dockerfile                                                                                                                                                                      0.0s
 => => transferring dockerfile: 100B                                                                                                                                                                                      0.0s
 => [internal] load .dockerignore                                                                                                                                                                                         0.0s
 => => transferring context: 2B                                                                                                                                                                                           0.0s
 => [internal] load metadata for docker.io/library/nginx:1.24.0-alpine                                                                                                                                                    0.0s
 => [internal] load build context                                                                                                                                                                                         0.0s
 => => transferring context: 128B                                                                                                                                                                                         0.0s
 => [1/2] FROM docker.io/library/nginx:1.24.0-alpine                                                                                                                                                                      0.1s
 => [2/2] COPY index.html /usr/share/nginx/html                                                                                                                                                                           0.0s
 => exporting to image                                                                                                                                                                                                    0.0s
 => => exporting layers                                                                                                                                                                                                   0.0s
 => => writing image sha256:d70aa10cbf02ffdf951cbc143cf82c7072d1ef7c5bc4ced8b05bcce803f1e822                                                                                                                              0.0s
 => => naming to docker.io/vs813/devops27-nginx:v1
                                                                                                                                                                        0.0s
netology@deb11-vm1:~/docker$ sudo docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
netology@deb11-vm1:~/docker$ sudo docker run --name test-nginx -p 80:80 -d vs813/devops27-nginx:v1
6644f9415342d9584ef773bfed3a471a9488eb5fdffcb9b33ed44fb8208a0c7c

netology@deb11-vm1:~/docker$ curl localhost
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>

netology@deb11-vm1:~/docker$ sudo docker push vs813/devops27-nginx:v1
The push refers to repository [docker.io/vs813/devops27-nginx]
fe85fd490026: Pushed 
24e414d9930b: Mounted from library/nginx 
e43c8ee2056a: Mounted from library/nginx 
effffea84b55: Mounted from library/nginx 
b42e5b255ff1: Mounted from library/nginx 
d9c63c119ee8: Mounted from library/nginx 
f33d2eed4384: Mounted from library/nginx 
f1417ff83b31: Mounted from library/nginx 
v1: digest: sha256:0b5effaf72d3487fab5fd31db309a12fafc521f237353c99cfb1c5bec00b91ad size: 1988

netology@deb11-vm1:~/docker$ sudo docker ps
CONTAINER ID   IMAGE                     COMMAND                  CREATED          STATUS          PORTS                               NAMES
6644f9415342   vs813/devops27-nginx:v1   "/docker-entrypoint.…"   14 minutes ago   Up 14 minutes   0.0.0.0:80->80/tcp, :::80->80/tcp   test-nginx

netology@deb11-vm1:~/docker$ sudo docker stop test-nginx
test-nginx

netology@deb11-vm1:~/docker$ sudo docker rm test-nginx
test-nginx

netology@deb11-vm1:~/docker$ sudo docker system prune -a -f
Deleted Images:
untagged: vs813/devops27-nginx:v1
untagged: vs813/devops27-nginx@sha256:0b5effaf72d3487fab5fd31db309a12fafc521f237353c99cfb1c5bec00b91ad
deleted: sha256:d70aa10cbf02ffdf951cbc143cf82c7072d1ef7c5bc4ced8b05bcce803f1e822
deleted: sha256:bc41aae6b3bb5d1b46e55f578b29321e764991c1b9baae4a4ead6fd09c7b7731
deleted: sha256:96275441808f3158c334ea893e187a2b44c8b399be46379f56e72821c9cf4237
deleted: sha256:e6882e669fdea1d171566bf051ea65f83761e0b82729896ecb4c88807d0b1297
deleted: sha256:cea6277e7b8ab26d2488ecb2a94977fff005300c48fd4796247c16d621ea88da
deleted: sha256:87e887e054f5e3716dbc4e2e8fd84a9a1c7b1b980f7a64e07ae01eb7c638ebd5
deleted: sha256:e1ec1364fa848f4f4420f77c68e689f657841ec8cd38de2c596ea938aa227fb9
deleted: sha256:511b6b9b5ab8dba49d5baaebec34a86366612e579685e71f2b6e9f9adcc5160c
deleted: sha256:f1417ff83b319fbdae6dd9cd6d8c9c88002dcd75ecf6ec201c8c6894681cf2b5
Total reclaimed space: 41.07MB

netology@deb11-vm1:~/docker$ sudo docker images
REPOSITORY   TAG       IMAGE ID   CREATED   SIZE

netology@deb11-vm1:~/docker$ sudo docker pull vs813/devops27-nginx:v1
v1: Pulling from vs813/devops27-nginx
f56be85fc22e: Pull complete 
81234aecc257: Pull complete 
bb5936af66b7: Pull complete 
f7c8639dc75e: Pull complete 
d0071b96733a: Pull complete 
b6b60f9051a8: Pull complete 
44286d6df869: Pull complete 
ea930c81c494: Pull complete 
Digest: sha256:0b5effaf72d3487fab5fd31db309a12fafc521f237353c99cfb1c5bec00b91ad
Status: Downloaded newer image for vs813/devops27-nginx:v1
docker.io/vs813/devops27-nginx:v1

netology@deb11-vm1:~/docker$ sudo docker images
REPOSITORY             TAG       IMAGE ID       CREATED          SIZE
vs813/devops27-nginx   v1        d70aa10cbf02   23 minutes ago   41.1MB

```

</details>

[Dockerfile](./src/503)

Опубликуйте созданный fork в своём репозитории и предоставьте ответ в виде ссылки на  
https://hub.docker.com/username_repo.

https://hub.docker.com/r/vs813/devops27-nginx

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

<details><summary><b>Выполнение задания:</b></summary>

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

</details>

***

## Задание 4(*)

*Воспроизведите практическую часть лекции самостоятельно*.

<details><summary><b>Выполнение задания:</b></summary>

```SHELL
netology@deb11-vm1:~/docker/ansible$ sudo docker build -t vs813/devops27-ansible:2.9.24 .
[+] Building 25.1s (5/8)                                                                                                                                                                                                   [+] Building 25.2s (5/8)                                                                                                                                                                                                   
 => [internal] load build definition from Dockerfile                                                                                                                                                                  0.0ss
 => => transferring dockerfile: 1.10kB                                                                                                                                                                                0.0ss
 => [internal] load .dockerignore                                                                                                                                                                                     0.0ss
 => => transferring context: 2B                                                                                                                                                                                       0.0ss
 => [internal] load metadata for docker.io/library/alpine:3.14                                                                                                                                                        2.6ss
 => [auth] library/alpine:pull token for registry-1.docker.io                                                                                                                                                         0.0ss
 => [1/4] FROM docker.io/library/alpine:3.14@sha256:0f2d5c38dd7a4f4f733e688e3a6733cb5ab1ac6e3cb4603a5dd564e5bfb80eed                                                                                                  1.2ss
 => => resolve docker.io/library/alpine:3.14@sha256:0f2d5c38dd7a4f4f733e688e3a6733cb5ab1ac6e3cb4603a5dd564e5bfb80eed                                                                                                  0.0ss
 => => sha256:9e179bacf43c4d3428d57cf459799ba0285b901945f9eccb17b6da056d3532c7 1.47kB / 1.47kB                                                                                                                        0.0ss
 => => sha256:f7dab3ab2d6ec29aa28769bec35331fb485b5837501b1e8556413d8b5a79c9c8 2.83MB / 2.83MB                                                                                                                        1.0s[[+] Building 195.0s (9/9) FINISHED                                                                                                                                                                                         
 => [internal] load build definition from Dockerfile                                                                                                                                                                  0.0s  => => transferring dockerfile: 1.10kB                                                                                                                                                                                0.0s
 => [internal] load .dockerignore                                                                                                                                                                                     0.0s  => => transferring context: 2B                                                                                                                                                                                       0.0s
 => [internal] load metadata for docker.io/library/alpine:3.14                                                                                                                                                        2.6s  => [auth] library/alpine:pull token for registry-1.docker.io                                                                                                                                                         0.0s
 => [1/4] FROM docker.io/library/alpine:3.14@sha256:0f2d5c38dd7a4f4f733e688e3a6733cb5ab1ac6e3cb4603a5dd564e5bfb80eed                                                                                                  1.2s  => => resolve docker.io/library/alpine:3.14@sha256:0f2d5c38dd7a4f4f733e688e3a6733cb5ab1ac6e3cb4603a5dd564e5bfb80eed                                                                                                  0.0s
 => => sha256:9e179bacf43c4d3428d57cf459799ba0285b901945f9eccb17b6da056d3532c7 1.47kB / 1.47kB                                                                                                                        0.0s  => => sha256:f7dab3ab2d6ec29aa28769bec35331fb485b5837501b1e8556413d8b5a79c9c8 2.83MB / 2.83MB                                                                                                                        1.0s
 => => sha256:0f2d5c38dd7a4f4f733e688e3a6733cb5ab1ac6e3cb4603a5dd564e5bfb80eed 1.64kB / 1.64kB                                                                                                                        0.0s  => => sha256:71859b0c62df47efaeae4f93698b56a8dddafbf041778fd668bbd1ab45a864f8 528B / 528B                                                                                                                            0.0s
 => => extracting sha256:f7dab3ab2d6ec29aa28769bec35331fb485b5837501b1e8556413d8b5a79c9c8                                                                                                                             0.0s  => [2/4] RUN CARGO_NET_GIT_FETCH_WITH_CLI=1 &&     apk --no-cache add         sudo         python3        py3-pip         openssl         ca-certificates         sshpass         openssh-client         rsync     187.6s
 => [3/4] RUN mkdir /ansible &&     mkdir -p /etc/ansible &&     echo 'localhost' > /etc/ansible/hosts                                                                                                                0.3s  => [4/4] WORKDIR /ansible                                                                                                                                                                                            0.0s 
 => exporting to image                                                                                                                                                                                                3.2s  => => exporting layers                                                                                                                                                                                               3.2s 
 => => writing image sha256:6485d624f94eb472fcd5200944c38c16210b2eaf5928ac62a55d5b3d1169f4b2                                                                                                                          0.0s  => => naming to docker.io/vs813/devops27-ansible:2.9.24                                                                                                                                                              0.0s

netology@deb11-vm1:~/docker/ansible$ sudo docker push vs813/devops27-ansible:2.9.24
The push refers to repository [docker.io/vs813/devops27-ansible]
5f70bf18a086: Pushed 
5b4d122a652c: Pushed 
6256e2f25346: Pushed 
9733ccc39513: Mounted from library/alpine 
2.9.24: digest: sha256:f50a8e73c944ae75e1f1da3ac8fd6493805385a2fbacad045fc138504a140fdc size: 1153
netology@deb11-vm1:~/docker/ansible$ 

```

</details>

*Соберите Docker-образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам*.

https://hub.docker.com/r/vs813/devops27-ansible
