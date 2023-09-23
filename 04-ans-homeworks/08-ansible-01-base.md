# Домашнее задание к занятию 1 «Введение в Ansible»

***

## Подготовка к выполнению

 1. Установите Ansible версии 2.10 или выше
 2. Создайте свой публичный репозиторий на GitHub с произвольным именем.
 3. Скачайте [Playbook](./src/401) из репозитория с домашним заданием и перенесите его в свой репозиторий.

***

## Основная часть

 1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте значение, которое имеет факт `some_fact` для указанного хоста при выполнении playbook.

<details><summary><b>Terminal</b></summary>

```zsh
┌──(sergey㉿kali)-[~/ansible/hw_ans1/playbook]
└─$ ansible-playbook site.yml -i inventory/test.yml

PLAY [Print os facts] ********************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************
ok: [localhost]

TASK [Print OS] **************************************************************************************************************
ok: [localhost] => {
    "msg": "Kali"
}

TASK [Print fact] ************************************************************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP *******************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
</details>

 2. Найдите файл с переменными (group_vars), в котором задаётся найденное в первом пункте значение, и поменяйте его на `all default fact`.

<details><summary><b>Terminal</b></summary>

```zsh
┌──(sergey㉿kali)-[~/ansible/hw_ans1/playbook]
└─$ ansible-playbook site.yml -i inventory/test.yml

PLAY [Print os facts] ********************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************
ok: [localhost]

TASK [Print OS] **************************************************************************************************************
ok: [localhost] => {
    "msg": "Kali"
}

TASK [Print fact] ************************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP *******************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
</details>

 3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.

 + Centos7:

```bash
docker run -d -i --name centos7 centos:7 /bin/bash
```
 + Ubuntu (установим python3, так как в базовой [сборке Ubuntu](https://hub.docker.com/_/ubuntu) Python нет):

```bash
docker run -d -i --name ubuntu ubuntu /bin/bash
docker exec -it ubuntu apt-get update
docker exec -it ubuntu apt-get install python3
```

 4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из managed `host`.

<details><summary><b>Terminal</b></summary>

```bash
┌──(sergey㉿kali)-[~/ansible/hw_ans1/playbook]
└─$ ansible-playbook site.yml -i inventory/prod.yml

PLAY [Print os facts] ********************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] **************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ************************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP *******************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
</details>

 5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились значения: для `deb` — `deb default fact`, для `el` — `el default fact`.

```zsh
┌──(sergey㉿kali)-[~/ansible/hw_ans1/playbook]
└─$ cat group_vars/{deb,el}/*
---
  some_fact: "deb default fact"---
  some_fact: "el default fact"
```

 6. Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.

<details><summary><b>Terminal</b></summary>

```bash
┌──(sergey㉿kali)-[~/ansible/hw_ans1/playbook]
└─$ ansible-playbook -i inventory/prod.yml site.yml

PLAY [Print os facts] ********************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] **************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP *******************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
</details>


 7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.

```bash
┌──(sergey㉿kali)-[~/ansible/hw_ans1/playbook]
└─$ ansible-vault encrypt group_vars/deb/examp.yml
New Vault password: 
Confirm New Vault password: 
Encryption successful

┌──(sergey㉿kali)-[~/ansible/hw_ans1/playbook]
└─$ ansible-vault encrypt group_vars/el/examp.yml
New Vault password: 
Confirm New Vault password: 
Encryption successful
```

 8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.

<details><summary><b>Terminal</b></summary>

```bash
┌──(sergey㉿kali)-[~/ansible/hw_ans1/playbook]
└─$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] ********************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] **************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP *******************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
</details>


 9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.


 *Можем использовать команду* `ansible-doc -t connection -l`  
 *Подойдет плагин* `local`


 10. В `prod.yml` добавьте новую группу хостов с именем `local`, в ней разместите localhost с необходимым типом подключения.

<details><summary><b>Terminal</b></summary>

```bash
┌──(sergey㉿kali)-[~/ansible/hw_ans1/playbook]
└─$ cat inventory/prod.yml
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
  local:
    hosts:
      localhost:
        ansible_connection: local
```
</details>
 
 11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь, что факты `some_fact` для каждого из хостов определены из верных `group_vars`. 

<details><summary><b>Terminal</b></summary>

```bash
┌──(sergey㉿kali)-[~/ansible/hw_ans1/playbook]
└─$ ansible-playbook -i inventory/prod.yml --ask-vault-pass site.yml
Vault password: 

PLAY [Print os facts] *****************************************************************************************

TASK [Gathering Facts] ****************************************************************************************
ok: [localhost]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ***********************************************************************************************
ok: [localhost] => {
    "msg": "Kali"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}

TASK [Print fact] *********************************************************************************************
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP ****************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
</details>

***

## Необязательная часть

 1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.
 2. Зашифруйте отдельное значение PaSSw0rd для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`
 3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.
 4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать этот вариант.
 5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.
 6. Все изменения должны быть зафиксированы и отправлены в ваш личный репозиторий.
