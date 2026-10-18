-- ACTIVIDAD 9 SEUDONIMIZACIÓN
-- 12/10/2026 CAMACHO CASTAÑEDA ANGÉLICA MARÍA 4-1

-- CREAR ESQUEMAS
CREATE SCHEMA pii;
CREATE SCHEMA analitica;
-- CREAR TABLA DE CORRESPONDENCIA 
CREATE TABLE pii.mapa_cliente (
    token UUID PRIMARY KEY,
    cliente_id BIGINT UNIQUE
        REFERENCES public.clientes(id)
);
-- GENERAR TOKENS
CREATE EXTENSION IF NOT EXISTS pgcrypto;
-- GENERAR TOKEN PARA CADA CLIENTE
INSERT INTO pii.mapa_cliente
(token, cliente_id)
SELECT
    gen_random_uuid(),
    id
FROM clientes;
-- VERIFICAR 
SELECT * FROM pii.mapa_cliente;
-- CREAR CONJUNTO DE DATOS PARA LA ANALITICA
CREATE TABLE analitica.clientes AS
SELECT
    m.token AS cliente_token,
    c.edad,
    c.ciudad,
    c.codigo_postal,
    c.fecha_alta
FROM pii.mapa_cliente m
JOIN clientes c
    ON c.id = m.cliente_id;
-- VERIFICAR
SELECT * FROM analitica.clientes;
-- SEPARACIÓN DE FUNCIONES
-- CREATE ROLE analista'; (utilicé el rol de analista que ya tenía creado)
-- CONCEDER EL ACCESO AL CONJUNTO DE DATOS ANÁLITICOS
GRANT USAGE
ON SCHEMA analitica
TO analista_angelica_camacho;

GRANT SELECT
ON analitica.clientes
TO analista_angelica_camacho;
-- VERIFICAR PERMISOS
-- PRUEBAS REALIZADAS EN EL ROL DE ANALISTA
SELECT * FROM analitica.clientes;
-- ACCESO RESTRINGIDO A MAPA DE CORRESPONDENCIA
SELECT * FROM pii.mapa_cliente;