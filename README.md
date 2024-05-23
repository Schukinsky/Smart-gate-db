# Data base for smart gate

## Навигация:
[Описание](#title1)
[ER-диаграмма](#title2)
[Сущности](#title3)
[Типы данных](#title4)
[Индексы](#title5)
[DDL](#title6)
[DML](#title7)
[Хранимые процедуры](#title8)
[Функции](#title9)
[Представления](#title10)


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
## <a id="title3">Сущности</a>
#### 1. User (Пользователи)
- id (Primary Key)
- last_name (фамилия)
- first_name (имя)
- middle_name (отчество)
- phone (номер телефона пользователя, уникальный)
- email (email адрес)
- address (наименование адреса)

#### 2. Pass (Объекты доступа)
- id (Primary Key)
- FK_user (внешний ключ, связанный с таблицей user)
- phone_number (номер телефона)
- vehicle_number (номер транспортного средства)
- start_date (дата начала)
- end_date (дата окончания)
- blocked (блокировка: да/нет)

#### 3. Camera (Камеры)  
- id (Primary Key)
- name  (наименование камеры)

#### 4. Event (Журнал событий)
- id (Primary Key)
- FK_pass (внешний ключ, связанный с таблицей pass)
- event_time (время события)
- vehicle_number (номер транспортного средства)
- FK_camera (внешний ключ, связанный с таблицей camera)
- photo_url (cсылка на фотографию)
- success (успешный доступ: да/нет)
- note (примечание)

## <a id="title4">Типы данных</a>

## <a id="title5">Индексы</a>

## <a id="title6">DDL</a>
[DDL.sql](DDL.sql)
## <a id="title7">DML</a>
[DML.sql](DML.sql)
## <a id="title8">Хранимые процедуры</a>
#### 1. Управление доступом:
- Создание пользователя [procedure_create_user.sql](procedure_create_user.sql)
      
  ```sql
  CALL gate01.create_user('Иванов', 'Иван', 'Иванович', '79260000000', 'ivan.@example.com', 'ул. Лесная, д.162');
  ```
- Добавление пропуска по номеру телефона [procedure_add_pass_phone.sql](procedure_add_pass_phone.sql)
   ```sql
  CALL gate01.add_pass_phone ('79260000000', '79260000000', '2024-05-23', '2024-12-31');
  ```
- Добавление пропуска по номеру траспортного средства [procedure_add_pass_vehicle.sql](procedure_add_pass_vehicle.sql)
  ```sql
  CALL gate01.add_pass_vehicle('79260000000', 'А111АА77', '2024-05-23', '2024-12-31');
  ```
- Изменение пропуска по номеру телефона [procedure_edit_pass_phone.sql](procedure_edit_pass_phone.sql)
  ```sql
  CALL gate01.edit_pass_phone('79260000000', '2024-05-23', '2024-12-31', TRUE); --TRUE - блокировка
  ```
- Изменение пропуска по номеру траспортного средства [procedure_edit_pass_vehicle.sql](procedure_edit_pass_vehicle.sql)
  ```sql
  CALL gate01.edit_pass_vehicle('А111АА77', '2024-05-23', '2024-12-31', TRUE); --TRUE - блокировка
  ```
- Блокировка всех объектов доступа по номеру телефона пользователя [procedure_block_allpass.sql](procedure_block_allpass.sql)
   ```sql
  CALL gate01.block_allpass ('79260000000');
  ```
- Разблокировка всех объектов доступа по номеру телефона пользователя [procedure_unblock_allpass.sql](procedure_unblock_allpass.sql)
  ```sql
  CALL gate01.unblock_allpass ('79260000000');
  ```
#### 2. Статистика:
- Статистика по событиям отказа доступа [stat_event.sql](stat_event.sql)
- Отчет о транспортных средствах на территории [stat_entries.sql](stat_entries.sql)

#### 3. Добавление событий
- Въезд по камере [procedure_add_event_camera_in.sql](procedure_add_event_camera_in.sql)
  
  ```sql
  CALL gate01.add_event_camera_in('А111АА77');
  ```
  ```sql
  CALL gate01.add_event_camera_in('А111АА77', 'http://fileserver.org/images/img_0000000001.jpg');
  ```
- Выезд по камере [procedure_add_event_camera_out.sql](procedure_add_event_camera_out.sql)
  ```sql
  CALL gate01.add_event_camera_out('А111АА77');
  ```
  ```sql
  CALL gate01.add_event_camera_out('А111АА77', 'http://fileserver.org/images/img_0000000002.jpg');
  ```
- Въезд/выезд по номеру телефона [procedure_add_event_call.sql](procedure_add_event_call.sql)
  ```sql
  CALL gate01.add_event_call('79260000000', 1); --въезд
  ```
  ```sql
  CALL gate01.add_event_call('79260000000', 2); --выезд
  ```
  ```sql
  CALL gate01.add_event_call('79260000000', 1, 'А000АА77', 'http://fileserver.org/images/img_0000000003.jpg');
  ```
## <a id="title9">Функции</a>
- Функция получения информации о пропусках [function_get_passes_info.sql](function_get_passes_info.sql)
  
  ```sql
  SELECT * FROM gate01.get_passes_info(FALSE); -- все пропуска
  ```
  ```sql
  SELECT * FROM gate01.get_passes_info(TRUE); -- только активные пропуска
  ```
  ```sql
  SELECT * FROM gate01.get_passes_info(FALSE, '79260000000'); -- все пропуска пользователя с номером телефона
  ```
    ```sql
  SELECT * FROM gate01.get_passes_info(TRUE, '79260000000'); -- только активные пропуска пользователя с номером телефона
  ```
- Функция генерации имени фото [generate_photo_name.sql](function_generate_photo_name.sql)
## <a id="title10">Представления</a>
- Вывод всех пропусков [view_all_passes.sql](view_all_passes.sql)
- Вывод всех действующих пропусков [view_active_passes.sql](view_active_passes.sql)
