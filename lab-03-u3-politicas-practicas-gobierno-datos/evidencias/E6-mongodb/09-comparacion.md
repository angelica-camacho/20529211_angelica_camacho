## LAB-02 — Trazabilidad en MongoDB Community
_Gestión de seguridad y desempeño de bases de datos_

**Camacho Castañeda Angélica María 4-1**

## Tabla de comparación

| Evento auditable | PostgreSQL (bitácora + disparador) | MongoDB Community (perfilador + bitácora) | MongoDB Enterprise/Atlas (auditoría nativa) |
|---|---|---|---|
| **Acceso exitoso** | **Sí (observado, Act. 5 y 9).** Con log_connections/log_disconnections en on y un prefijo con usuario, base, aplicación e IP, queda la conexión y la desconexión. Con la configuración por defecto no se registra nada. | **Sí (observado).** Evento ACCESS con Successfully authenticated: usuario, base, mecanismo, cliente y hora. | Documentado, no practicado |
| **Acceso fallido** | **Sí (observado, Act. 5).** FATAL: password authentication failed con usuario, base, IP y regla de pg_hba.conf. Si el rol no existe, el DETAIL solo queda en la bitácora. | **Sí (observado).** Failed to authenticate con result: 18 (contraseña) u 11 (usuario inexistente). Un intento puede dejar varias líneas. | Documentado, no practicado |
| **Cambio de privilegios** | **Sí (observado, Act. 6).** GRANT y REVOKE quedan con log_statement = 'ddl'. | **No (observado).** grantRolesToUser dio 0 en perfilador y bitácora. Solo las instantáneas detectan qué cambió, no quién ni cuándo. | Documentado, no practicado |
| **Cambio de estructura** | **Sí (observado, Act. 6).** ALTER TABLE ... ADD COLUMN quedó con 'ddl' o 'mod'. | **Parcial (no probado).** Con nivel 2 el perfilador registra comandos, pero el filtro de insert/update/remove los dejaría fuera. | Documentado, no practicado |
| **Modificación de datos** | **Sí (observado, Act. 7, 12 y 13).** La bitácora guarda el UPDATE/INSERT/DELETE y el disparador guarda la fila. Límite: solo audita mientras está activo (Act. 14). | **Parcial (observado).** system.profile registró update y remove con usuario, appName, cliente y hora, solo si el perfilador está activo. | Documentado, no practicado (CRUD requiere auditAuthorizationSuccess: true) |
| **Valor anterior del dato** | **Sí (observado, Act. 12 y 13).** valores_antes y valores_despues en JSONB. No cubre cambios previos al disparador ni con el disparador apagado. | **No (observado).** El update guarda solo el valor nuevo y el remove solo el filtro. | Documentado, no practicado |
| **Lectura de datos sensibles** | **No (observado, Act. 7 y 9).** Con 'mod' los SELECT no se registran. Solo 'all', con alto volumen y riesgo de datos sensibles. | **Parcial (observado).** Nivel 2 registró el find con el filtro dejó de registrarse. Guarda filtros en claro. | Documentado, no practicado |
| **Cambio de configuración del registro** | **Parcial (observado, Act. 4).** El proceso principal escribe parameter ... changed to ... sin usuario. El autor solo queda si log_statement ya era ddl o all. | **Parcial (observado).** Profiler settings changed` sin usuario; el autor se obtiene uniendo el ctx con la autenticación. | Documentado, no practicado |