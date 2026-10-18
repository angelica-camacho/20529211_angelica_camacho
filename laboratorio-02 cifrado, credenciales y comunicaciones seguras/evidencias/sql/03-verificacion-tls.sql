-- LABORATORIO 2: VERIFICAR EL ESTADO DE TLS EN POSTGRESQL
-- CAMACHO CASTAÑEDA ANGÉLICA MARÍA 4-1
-- 15/10/2026

SHOW ssl;
-- MOSTRAR EL PROTOCOLO DE SSL
SHOW ssl_min_protocol_version;
-- CONSULTAR EL PUERTO
SHOW port;
-- CONSULTAR QUE DIRECCIONES ESCUCHA
SHOW listen_addresses;
-- VERIFICAR LA CONEXIÓN ACTUAL
SELECT
    inet_client_addr(),
    inet_client_port();
-- VERIFICAR SI LA SESIÓN ACTUAL USA TLS
SELECT
    ssl,
    version,
    cipher
FROM pg_stat_ssl
WHERE pid = pg_backend_pid();