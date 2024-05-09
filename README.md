# Data base for smart gate

## Навигация:
[Описание](#title1)
[ER-диаграмма](#title2)
[Сущности](#title3)
[Типы данных](#title4)
[Индексы](#title5)
[DDL](#title6)
[Хранимые процедуры](#title7)


## <a id="title1">Описание</a>
В данной модели базы данных каждый пользователь имеет свою запись с персональными данными, пропуском и событиями прохода через шлагбаум. Пропуск может иметь дату начала и окончания действия, а также статус активности. События фиксируют дату и время проезда, тип события (въезд или выезд) и номер номерного знака автомобиля.

## <a id="title2">ER-диаграмма</a>

## <a id="title3">Сущности</a>
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

## <a id="title6">DDL</a>
```sql
-- Создание базы данных
CREATE DATABASE gate;

-- Создание схемы данных
CREATE SCHEMA IF NOT EXISTS gate_01 AUTHORIZATION postgres;

-- Создание таблиц в схеме данных
CREATE TABLE IF NOT EXISTS gate_01.address (
	id SERIAL PRIMARY KEY,
	name VARCHAR(32)
	);
CREATE TABLE IF NOT EXISTS gate_01.user (
	id SERIAL PRIMARY KEY,
	last_name VARCHAR(32),
	first_name VARCHAR(32),
	middle_name VARCHAR(32),
	phone VARCHAR(32),
	email VARCHAR(32),
	FK_address INTEGER REFERENCES gate_01.address(id) ON DELETE CASCADE
	);
	
	
	CREATE TABLE Access_entities (
    entity_id SERIAL PRIMARY KEY,
    entity_type VARCHAR(10), -- 'phone' или 'vehicle'
    entity_number VARCHAR(20) UNIQUE,
    start_date DATE,
    end_date DATE,
    blocked BOOLEAN
);
	
	CREATE TABLE AccessLogs (
    log_id SERIAL PRIMARY KEY,
    user_id INT,
    entity_id INT,
    access_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    photo_url VARCHAR(255), -- Ссылка на фотографию
    success BOOLEAN,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (entity_id) REFERENCES AccessEntities(entity_id)
);
```
## <a id="title7">Хранимые процедуры</a>
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


