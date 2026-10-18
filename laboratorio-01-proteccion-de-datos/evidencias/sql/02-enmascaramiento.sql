-- 11/10/2026, CAMACHO CASTAÑEDA ANGÉLICA MARÍA 4-1
-- ENMASCARAMIENTO
-- CREAR EL ROL
CREATE ROLE soporte_angelica_camacho LOGIN;
-- CREAR UNA VISTA DE ACCESO RESTRINGIDO
CREATE VIEW v_clientes_soporte AS
SELECT
    id,
    nombre,

    CONCAT(
        LEFT(correo, 2),
        '*****',
        SUBSTRING(correo FROM POSITION('@' IN correo))
    ) AS correo,

    CONCAT(
        '******',
        RIGHT(telefono, 4)
    ) AS telefono,

    CONCAT(
        '*********',
        RIGHT(rfc, 4)
    ) AS rfc

FROM clientes;
-- CONSULTAR LA VISTA
SELECT * FROM v_clientes_soporte;
-- CONCEDER ACCESO A LA VISTA
GRANT USAGE
ON SCHEMA public
TO soporte;

GRANT SELECT
ON v_clientes_soporte
TO soporte;
-- REVOCAR EL ACCESO 
REVOKE ALL
ON clientes
FROM soporte;
-- VERIFICAR RESULTADO
SELECT *
FROM v_clientes_soporte;
-- ACCESO RESTRINGIDO
SELECT * FROM clientes;