# Домашнее задание к занятию 5.1. «Введение в виртуализацию. Типы и функции гипервизоров. Обзор рынка вендоров и областей применения»

## Задание 1

*Опишите кратко, в чём основное отличие полной (аппаратной) виртуализации, паравиртуализации и виртуализации на основе ОС.*

+ При полной (аппаратной) виртуализациии гостевая ОС полностью изолирована виртуальной машиной от уровня виртуализации и аппаратного обеспечения.
+ При паравиртуализации гостевая ОС не полностью изолирована, но она частично изолирована виртуальной машиной от уровня виртуализации и аппаратного обеспечения.
+ При виртуализации средствами ОС, гостевая ОС не имеет собственного ядра, использует ядро хоста. Хостовая ОС отвечает за разделение аппаратных ресурсов 
 между несколькими виртуальными серверами и поддержку их независимости друг от друга.
***

## Задание 2

*Выберите один из вариантов использования организации физических серверов в зависимости от условий использования.*  
*Опишите, почему вы выбрали к каждому целевому использованию такую организацию.*
| Условия | Организация | Почему |
| --- | --- | --- |
| высоконагруженная база данных, чувствительная к отказу | физические сервера | Постоянно нагруженной системе требуется максимум ресурсов хоста, сервисы критичны к производительности и лучше не использовать виртуализацию, как прослойку на которую необходимо тратить ресурсы |
| различные web-приложения | виртуализация уровня ОС | Готовая среда для приложений позволяет быстро их запускать  |
| Windows-системы для использования бухгалтерским отделом | паравиртуализация | Ввиду токо что системы не нагружены и их много, лучше использовать паравиртуализацию для оптимизиции ресурсов серверов |
| системы, выполняющие высокопроизводительные расчёты на GPU | физические сервера | Данные сервисы критичны к производительности и лучше не использовать виртуализацию, как прослойку на которую необходимо тратить ресурсы. |
***

## Задание 3

*Выберите подходящую систему управления виртуализацией для предложенного сценария. Детально опишите ваш выбор*
 
>100 виртуальных машин на базе Linux и Windows, общие задачи, нет особых требований. Преимущественно Windows based-инфраструктура, требуется реализация программных балансировщиков нагрузки, репликации данных и автоматизированного механизма создания резервных копий

**VMWare VSphere** - позволяет создавать кластера серверов для большей отказоустойчивости, имеет множество сторонних решения для бэкапа. Позволяет автоматизировать создания и обслуживание виртуальных машин.

>Требуется наиболее производительное бесплатное open source-решение для виртуализации небольшой (20-30 серверов) инфраструктуры на базе Linux и Windows виртуальных машин.

**KVM** - бесплатное решение, производительное. Есть множество систем виртуализации на базе KVM, например Proxmox. Так же есть множество инструментов для резервного копирования, либо можно написать самому и бэкапить машины через скрипты.

>Необходимо бесплатное, максимально совместимое и производительное решение для виртуализации Windows-инфраструктуры.

**MS Hyper-V Server** - бесплатное решение, максимально совместим c Windows гостевыми ОС.

>Необходимо рабочее окружение для тестирования программного продукта на нескольких дистрибутивах Linux.

**Docker** - можно запустить на подавляющем большинстве дистрибутивов Linux. Сборку и развёртывание контейнеров можно автоматизировать например через docker-compose.

***

## Задание 4

*Опишите возможные проблемы и недостатки гетерогенной среды виртуализации (использования нескольких систем управления виртуализацией одновременно) и что необходимо сделать для минимизации этих рисков и проблем. Если бы у вас был выбор, создавали бы вы гетерогенную среду или нет? Мотивируйте ваш ответ примерами.*

Возможные проблемы и недостатки гетерогенной среды виртуализации:

+ в гетерогенной среде резко сокращается возможность автоматического распределения вычислительных ресурсов; 
+ сложность администрирования;
+ для автоматизации мониторинга нужно несколько различных программных продуктов, что снижает оперативность оценки состояния вычислительных ресурсов;
+ повышенный риск отказа и недоступности;
+ стоимость обслуживания выше.

Для минимизации рисков и проблем:

+ если гетерогенность не оправдана, то рассмотреть возможность отказа от нее,лучшее решение мигрировать на одну платформу.


