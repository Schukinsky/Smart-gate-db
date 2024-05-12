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