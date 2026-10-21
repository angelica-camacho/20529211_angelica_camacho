-- Actividad 2 — Principio de minimización
-- Camacho Castañeda Angélica María 18/10/2026

-- CREAR TABLA CLIENTES_SOPORTE
CREATE TABLE clientes_soporte (
    id BIGSERIAL,
    nombre VARCHAR(120),
    correo VARCHAR(150),
    telefono VARCHAR(20),
    rfc VARCHAR(13),
    edad INTEGER,
    ciudad VARCHAR(80),
    codigo_postal VARCHAR(10),
    fecha_alta DATE
);
-- DISEÑAR UNA ESTRUCTURA MINIMA 
CREATE TABLE clientes_soporte (
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    correo VARCHAR(150) NOT NULL,
    telefono VARCHAR(20)
);
-- INSERTAR DATOS A LA TABLA
INSERT INTO clientes_soporte (
    id,
    nombre,
    correo,
    telefono
)
SELECT
    id,
    nombre,
    correo,
    telefono
FROM clientes;
-- CONSULTAR TABLA
SELECT *
FROM clientes_soporte;
