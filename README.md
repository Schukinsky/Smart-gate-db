# Smart-gate-db
Data base for smart gate

Address
id
name

User
id
last_name
first_name
middle_name
phone
email
FK_address

Таблица Users (Пользователи):
user_id (идентификатор пользователя, первичный ключ)
username (имя пользователя)
phone_number (номер телефона пользователя, уникальный)
phone_number_start_date (дата начала действия номера телефона)
phone_number_end_date (дата окончания действия номера телефона)
phone_number_blocked (блокировка номера телефона: да/нет)
Таблица AccessEntities (Доступные сущности):
entity_id (идентификатор сущности, первичный ключ)
entity_type (тип сущности: 'phone' или 'vehicle')
entity_number (номер телефона или номер транспортного средства, уникальный)
start_date (дата начала действия сущности)
end_date (дата окончания действия сущности)
blocked (блокировка сущности: да/нет)
Таблица AccessLogs (Журнал доступа):
log_id (идентификатор записи в журнале, первичный ключ)
user_id (идентификатор пользователя, внешний ключ связанный с таблицей Users)
entity_id (идентификатор сущности, внешний ключ связанный с таблицей AccessEntities)
access_time (время доступа)
success (успешный доступ: да/нет)


- Создание пользователя:

- Статистика:
вывод всех пользователей и всех AccessEntities со статусом
вывод всех пользователей и всех AccessEntities по адресу со статусом
вывод всех AccessEntities по пользователю со статусом
статистика Въезд/выезд по камере
статистика Въезд/выезд  по номеру телефона

- Блокировка:

Добавления события
- Въезд/выезд по камере

- Въезд/выезд по номеру телефона

В данной модели базы данных каждый пользователь имеет свою запись с персональными данными, пропуском и событиями прохода через шлагбаум. Пропуск может иметь дату начала и окончания действия, а также статус активности. События фиксируют дату и время проезда, тип события (въезд или выезд) и номер номерного знака автомобиля.
