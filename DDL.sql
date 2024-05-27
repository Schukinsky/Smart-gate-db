-- Создание базы данных
CREATE DATABASE gate;

-- Создание схемы данных
CREATE SCHEMA IF NOT EXISTS gate01 AUTHORIZATION postgres;

-- Создание таблиц в схеме данных
CREATE TABLE IF NOT EXISTS gate01.user (
	id SERIAL PRIMARY KEY,
	last_name VARCHAR(32) NOT NULL,
	first_name VARCHAR(32) NOT NULL,
	middle_name VARCHAR(32) NOT NULL,
	phone VARCHAR(20) UNIQUE NOT NULL,
	email VARCHAR(32) NOT NULL,
	address VARCHAR(255) NOT NULL
	);
CREATE TABLE IF NOT EXISTS gate01.pass (
	id SERIAL PRIMARY KEY,
	FK_user INTEGER REFERENCES gate01.user(id),
	phone_number VARCHAR(20) UNIQUE,
	vehicle_number VARCHAR(20) UNIQUE,
	start_date DATE NOT NULL,
	end_date DATE NOT NULL,
	blocked BOOLEAN DEFAULT FALSE NOT NULL
	);
CREATE TABLE IF NOT EXISTS gate01.camera (
	id SERIAL PRIMARY KEY,
	name VARCHAR(10) NOT NULL
	);	
CREATE TABLE IF NOT EXISTS gate01.event (
	id SERIAL PRIMARY KEY,
	FK_pass INTEGER REFERENCES gate01.pass(id),
	event_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
	vehicle_number VARCHAR(20) NOT NULL,
	FK_camera INTEGER REFERENCES gate01.camera(id),
	photo_url VARCHAR(255) NOT NULL,
	success BOOLEAN NOT NULL,
	note VARCHAR(255)
	);
