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
	
	
	CREATE TABLE AccessEntities (
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