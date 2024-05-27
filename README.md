# Data base for smart gate in PostgreSQL with Apache Superset visualization
##Модель базы данных в PostgreSQL для системы контроля и управления доступом транспорта с визуализацией Apache Superset

## Навигация:
[Описание](#title1)
[ER-диаграмма](#title2)
[Таблицы](#title3)
[Индексы](#title4)
[DDL](#title5)
[DML](#title6)
[Хранимые процедуры](#title7)
[Функции](#title9)
[Представления](#title9)
[Apache Superset](#title10)

## <a id="title1">Описание</a>
Проект Smart-gate-db представляет собой модель базы данных для системы управления доступом, которая позволяет контролировать въезд и выезд транспортных средств на основе звонка с телефона или распознавания номера транспортного средства с помощью камер. Эта система использует базу данных PostgreSQL для хранения информации о пользователях, пропусках и событиях.
Пропуск может иметь дату начала и окончания действия, а также статус активности. События фиксируют дату и время проезда, тип события (въезд или выезд), номер транспортного средства и факт успешного доступа.

Основные функции:  
- Управление доступом: Позволяет автоматически разрешать или запрещать въезд и выезд транспортных средств на основе данных, хранящихся в базе данных PostgreSQL.  
- Интеграция с телефоном: Пользователи могут запросить доступ к шлагбауму путем звонка с зарегистрированного номера телефона.  
- Распознавание номеров транспортных средств: Система также способна распознавать номера транспортных средств с помощью камер на въезде и выезде, позволяя автоматически разрешать доступ на основе зарегистрированных данных в базе.  
- Управление пользователями: Позволяет администраторам добавлять, и редактировать пользователей и их привязанные данные.  

## <a id="title2">ER-диаграмма</a>
![](erd.png)

## <a id="title3">Таблицы</a>

### Таблица `user`

| Столбец     | Тип данных   | Описание                    |
|-------------|--------------|-----------------------------|
| id          | SERIAL       | Первичный ключ              |
| last_name   | VARCHAR(32)  | Фамилия                     |
| first_name  | VARCHAR(32)  | Имя                         |
| middle_name | VARCHAR(32)  | Отчество                    |
| phone       | VARCHAR(20)  | Номер телефона (уникальный) |
| email       | VARCHAR(32)  | Электронная почта           |
| address     | VARCHAR(255) | Адрес                       |

### Таблица `pass`

| Столбец        | Тип данных   | Описание                                   |
|----------------|--------------|--------------------------------------------|
| id             | SERIAL       | Первичный ключ                             |
| FK_user        | INTEGER      | Внешний ключ на `user(id)`                 |
| phone_number   | VARCHAR(20)  | Номер телефона (уникальный)                |
| vehicle_number | VARCHAR(20)  | Номер транспортного средства (уникальный)  |
| start_date     | DATE         | Дата начала действия пропуска              |
| end_date       | DATE         | Дата окончания действия пропуска           |
| blocked        | BOOLEAN      | Заблокирован ли пропуск                    |

### Таблица `camera`

| Столбец | Тип данных  | Описание       |
|---------|-------------|----------------|
| id      | SERIAL      | Первичный ключ |
| name    | VARCHAR(10) | Название камеры|

### Таблица `event`

| Столбец        | Тип данных   | Описание                         |
|----------------|--------------|----------------------------------|
| id             | SERIAL       | Первичный ключ                   |
| FK_pass        | INTEGER      | Внешний ключ на `pass(id)`       |
| event_time     | TIMESTAMP    | Время события                    |
| vehicle_number | VARCHAR(20)  | Номер транспортного средства     |
| FK_camera      | INTEGER      | Внешний ключ на `camera(id)`     |
| photo_url      | VARCHAR(255) | URL фото                         |
| success        | BOOLEAN      | Успешность события               |
| note           | VARCHAR(255) | Заметка                          |


## <a id="title4">Индексы</a>


## <a id="title5">DDL</a>
[DDL.sql](DDL.sql)
## <a id="title6">DML</a>
[DML.sql](DML.sql)
## <a id="title7">Хранимые процедуры</a>

#### 1. Управление доступом:
- Создание пользователя [procedure_create_user.sql](procedure_create_user.sql)
- Добавление пропуска по номеру телефона [procedure_add_pass_phone.sql](procedure_add_pass_phone.sql) 
- Добавление пропуска по номеру траспортного средства [procedure_add_pass_vehicle.sql](procedure_add_pass_vehicle.sql)
- Изменение пропуска по номеру телефона [procedure_edit_pass_phone.sql](procedure_edit_pass_phone.sql)
- Изменение пропуска по номеру траспортного средства [procedure_edit_pass_vehicle.sql](procedure_edit_pass_vehicle.sql)
- Блокировка всех объектов доступа по номеру телефона пользователя [procedure_block_allpass.sql](procedure_block_allpass.sql)
- Разблокировка всех объектов доступа по номеру телефона пользователя [procedure_unblock_allpass.sql](procedure_unblock_allpass.sql) 

#### 2. Добавление событий:
- Въезд по камере [procedure_add_event_camera_in.sql](procedure_add_event_camera_in.sql)
- Выезд по камере [procedure_add_event_camera_out.sql](procedure_add_event_camera_out.sql)
- Въезд/выезд по номеру телефона [procedure_add_event_call.sql](procedure_add_event_call.sql)
 
## <a id="title8">Функции</a>
- Функция получения информации о пропусках [function_get_passes_info.sql](function_get_passes_info.sql)
- Функция генерации имени фото [generate_photo_name.sql](function_generate_photo_name.sql)

## <a id="title9">Представления</a>
- Вывод всех пропусков [view_all_passes.sql](view_all_passes.sql)
- Вывод всех действующих пропусков [view_active_passes.sql](view_active_passes.sql)

## <a id="title10">Визуализация [Apache Superset](https://github.com/Schukinsky/Smart-gate-db/tree/main/Superset)</a> 
- Отчет по событиям отказа доступа [dataset_stat_event.sql](dataset_stat_event.sql)
- Отчет о транспортных средствах на территории [dataset_stat_entries.sql](dataset_stat_entries.sql)
