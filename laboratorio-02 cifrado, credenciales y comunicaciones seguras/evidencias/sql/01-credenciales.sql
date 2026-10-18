-- LABORATORIO 2: CIFRADO Y COMUNICACIONES SEGURAS
-- CAMACHO CASTAÑEDA ANGÉLICA MARÍA 4-1
-- 15/10/2026

-- VERIFICAR LA TABLA
SELECT * FROM clientes;
-- VERIFICAR QUE EXISTA LA EXTENSIÓN
SELECT extname
FROM pg_extension
WHERE extname = 'pgcrypto';
-- IMPLEMENTACIÓN INCORRECTA DE ALMACENAR INFORMACIÓN
CREATE TABLE usuarios_insegura (
    id BIGSERIAL PRIMARY KEY,
    usuario VARCHAR(50) NOT NULL,
    password VARCHAR(100) NOT NULL
);
-- INSERTAR REGISTRO 
INSERT INTO usuarios_insegura (usuario, password)
VALUES ('juan', 'Password123');
-- CONSULTAR LA TABLA
SELECT * FROM usuarios_insegura;
-- GENERAR UNA REPRESENTACIÓN NO REVERSIBLE
SELECT crypt(
    'Password123',
    gen_salt('bf')
);
-- EJECUTAR NUEVAMENTE
SELECT crypt(
    'Password123',
    gen_salt('bf')
);
-- CREAR TABLA PARA CREDENCIALES PROTEGIDAS
CREATE TABLE usuarios_segura (
    id BIGSERIAL PRIMARY KEY,
    usuario VARCHAR(50) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL
);
-- INSERTAR REGISTRO
INSERT INTO usuarios_segura (usuario, password_hash)
VALUES (
    'juan',
    crypt('Password123', gen_salt('bf'))
);
-- VERIFICAR TABLA
SELECT * FROM usuarios_segura;
-- VERIFICAR CONTRASEÑA CORRECTA
SELECT
    usuario,
    password_hash = crypt('Password123', password_hash)
        AS contraseña_correcta
FROM usuarios_segura
WHERE usuario = 'juan';
-- VERIFICAR CONTRASEÑA INCORRECTA
SELECT
    usuario,
    password_hash = crypt('OtraPassword', password_hash)
        AS contraseña_correcta
FROM usuarios_segura
WHERE usuario = 'juan';