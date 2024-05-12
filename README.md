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
![](erd.png)
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
- FK_address (внешний ключ, связанный с таблицей address)

#### 3. Pass_type (Тыпы объектов доступа)  
- id (Primary Key)
- name  (наименование объекта доступа)

#### 4. Pass (Объекты доступа)
- id (Primary Key)
- FK_user (внешний ключ, связанный с таблицей user)
- FK_pass_type (тип сущности: 'phone' или 'vehicle')
- pass_number (номер телефона или номер транспортного средства)
- start_dt (дата начала)
- end_dt (дата окончания)
- blocked (блокировка: да/нет)

#### 5. Camera (Камеры)  
- id (Primary Key)
- name  (наименование камеры)

#### 6. Event (Журнал событий)
- id (Primary Key)
- FK_pass (внешний ключ, связанный с таблицей pass)
- access_time (время доступа)
- vehicle_number (номер транспортного средства)
- FK_camera (внешний ключ, связанный с таблицей camera)
- photo_url (cсылка на фотографию)
- success (успешный доступ: да/нет)

## <a id="title4">Типы данных</a>

## <a id="title5">Индексы</a>

## <a id="title6">DDL</a>
```sql
-- Создание базы данных
CREATE DATABASE gate;

-- Создание схемы данных
CREATE SCHEMA IF NOT EXISTS gate01 AUTHORIZATION postgres;

-- Создание таблиц в схеме данных
CREATE TABLE IF NOT EXISTS gate01.address (
	id SERIAL PRIMARY KEY,
	name VARCHAR(32)
	);
CREATE TABLE IF NOT EXISTS gate01.user (
	id SERIAL PRIMARY KEY,
	last_name VARCHAR(32),
	first_name VARCHAR(32),
	middle_name VARCHAR(32),
	phone VARCHAR(32),
	email VARCHAR(32),
	FK_address INTEGER REFERENCES gate01.address(id) ON DELETE CASCADE
	);
CREATE TABLE gate01.pass_type (
	id SERIAL PRIMARY KEY,
	name VARCHAR(10)
	);	
CREATE TABLE gate01.pass (
	id SERIAL PRIMARY KEY,
	FK_user INTEGER REFERENCES gate01.user(id) ON DELETE CASCADE,
	FK_pass_type INTEGER REFERENCES gate01.pass_type(id) ON DELETE CASCADE,
	pass_number VARCHAR(20) UNIQUE,
	start_date DATE,
	end_date DATE,
	blocked BOOLEAN
	);
CREATE TABLE gate01.camera (
	id SERIAL PRIMARY KEY,
	name VARCHAR(10)
	);	
CREATE TABLE gate01.event (
	id SERIAL PRIMARY KEY,
	FK_pass INTEGER REFERENCES gate01.pass(id) ON DELETE CASCADE,
	access_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	vehicle_number VARCHAR(20),
	FK_camera INTEGER REFERENCES gate01.camera(id) ON DELETE CASCADE,
	photo_url VARCHAR(255),
	success BOOLEAN,
	);
```
## <a id="title7">Хранимые процедуры</a>
#### 1. Управление доступом:
- Создание пользователя
- Добавление объектов доступа ('phone','vehicle') для user.id
- Блокировка всех объектов доступа по adress.id
- Блокировка всех объектов доступа по user.id
- Блокировка объекта доступа по pass.id

#### 2. Статистика:
- Вывод всех пользователей и всех объектов доступа со статусом
- Вывод всех пользователей и всех объектов доступа по адресу со статусом
- Вывод всех объектов доступа по пользователю со статусом
- Въезд/выезд по камере
- Въезд/выезд  по номеру телефона

#### 3. Добавления события
- Въезд/выезд по камере
- Въезд/выезд по номеру телефона


