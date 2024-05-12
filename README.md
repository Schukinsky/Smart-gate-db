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
Проект Smart-gate-db представляет собой модель базы данных для системы управления доступом, которая позволяет контролировать въезд и выезд транспортных средств на основе звонка с телефона или распознавания номера транспортного средства с помощью камер. Эта система использует базу данных PostgreSQL для хранения информации о пользователях, пропусках и событиях.
Пропуск может иметь дату начала и окончания действия, а также статус активности. События фиксируют дату и время проезда, тип события (въезд или выезд), номер транспортного средства и факт успешного доступа.

Основные функции:  
- Управление доступом: Позволяет автоматически разрешать или запрещать въезд и выезд транспортных средств на основе данных, хранящихся в базе данных PostgreSQL.  
- Интеграция с телефоном: Пользователи могут запросить доступ к шлагбауму путем звонка с зарегистрированного номера телефона.  
- Распознавание номеров транспортных средств: Система также способна распознавать номера транспортных средств с помощью камер на въезде и выезде, позволяя автоматически разрешать доступ на основе зарегистрированных данных в базе.  
- Управление пользователями: Позволяет администраторам добавлять, и редактировать пользователей и их привязанные данные.  

## <a id="title2">ER-диаграмма</a>

## <a id="title3">Сущности</a>
#### 1. Address (Адреса)  
- id (Primary Key)
- name  (наименование адреса)

#### 2. User (Пользователи)
- id (Primary Key)
- last_name (фамилия)
- first_name (имя)
- middle_name (отчество)
- phone (номер телефона пользователя, уникальный)
- email (email адрес)
- FK_address (внешний ключ, связанный с таблицей Address)

#### 3. AccessEntity (Объекты доступа)
- id (Primary Key)
- FK_user (внешний ключ, связанный с таблицей User)
- entity_type (тип сущности: 'phone' или 'vehicle')
- entity_number (номер телефона или номер транспортного средства, уникальный)
- start_dt (дата начала)
- end_dt (дата окончания)
- blocked (блокировка: да/нет)

#### 4. Event (Журнал событий)
- id (Primary Key)
- FK_AccessEntity (внешний ключ, связанный с таблицей AccessEntity)
- access_time (время доступа)
- vehicle_number (номер транспортного средства)
- FK_camera (внешний ключ, связанный с таблицей Camera)
- photo_url (cсылка на фотографию)
- success (успешный доступ: да/нет)

## <a id="title4">Типы данных</a>

## <a id="title5">Индексы</a>

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
    id SERIAL PRIMARY KEY,
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


