-- LABORATORIO 2: CIFRADO DE INFORMACIÓN SENSIBLE
-- CAMACHO CASTAÑEDA ANGÉLICA MARÍA 4-1
-- 15/10/2026

-- CREAR TABLA DE DEMOSTRACIÓN
CREATE TABLE clientes_protegidos (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    rfc_cifrado BYTEA NOT NULL
);
-- INSERTAR REGISTROS
INSERT INTO clientes_protegidos (
    nombre,
    rfc_cifrado
)
VALUES (
    'Ana López',
    pgp_sym_encrypt('LOPA900101ABC', 'CLAVE-DE-PRUEBA')
);
-- ¨CONSULTAR TABLA
SELECT * FROM clientes_protegidos;
-- RECUPERAR EL DATO
SELECT
    id,
    nombre,
    pgp_sym_decrypt(
        rfc_cifrado,
        'CLAVE-DE-PRUEBA'
    ) AS rfc
FROM clientes_protegidos;