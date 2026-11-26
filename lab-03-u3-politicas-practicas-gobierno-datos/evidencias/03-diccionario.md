-- Camacho Castañeda Angélica María 4-1
-- Gestión de seguridad y desempeño de bases de datos
-- LAB-03 — Políticas prácticas, gobierno de datos y evidencias

| Columna | Clasificación (Unidad II) | Finalidad | Control aplicado | ¿Cambios auditados? | Regla de calidad |
|---|---|---|---|---|---|
| rfc | Dato personal | Facturación | Vista enmascarada para soporte (U2) | Sí, LAB-01 Parte B | Formato RFC |
| correo | Dato personal | Notificaciones y contacto con el cliente | TLS en tránsito, enmascarado en vistas públicas | Solo en bitácora (log_statement = mod) | Unicidad `lower(correo)) |
| id | Dato interno (no personal) | Identificador interno del cliente | Generado por el sistema (secuencia); no editable | Solo en bitácora | Unicidad y no nulo (PK) |
| nombre | Dato personal (identificador directo) | Identificación del titular y atención de solicitudes | Acceso por rol (RBAC) | Solo en bitácora | Completitud (no nulo) |
| telefono | Dato personal | Contacto de urgencia y verificación de seguridad | Visibilidad restringida por perfil | Solo en bitácora | Completitud y formato de teléfono |
| edad | Dato personal | Analítica agregada | Uso en rangos o agregado (seudonimización) | Solo en bitácora | Rango válido (18 a 120) |
| ciudad | Dato personal (ubicación) | Zona de servicio y logística | Acceso restringido a la tabla operativa | Solo en bitácora | Completitud, valor de catálogo |
| codigo_postal | Dato personal (ubicación) | Cobertura de servicio y cálculo de fletes | Seudonimizado para analítica | Solo en bitácora | Formato (5 dígitos) |
| fecha_alta | Dato operativo | Antigüedad del cliente y plazos de retención | Asignada por el sistema (DEFAULT) | Solo en bitácora | No nula y no futura |
| segmento | Dato derivado | Analítica y estrategia de ventas | Acceso por rol (Analítica / Gerencia Comercial) | Solo en bitácora | Valor dentro de un catálogo definido |

**1. ¿Qué ventaja tiene guardar el significado en `COMMENT` en lugar de solo en un documento aparte?**

El significado queda dentro del motor, junto al dato y se respalda con la base, se consulta con SQL (col_description) y lo ve cualquiera que use la tabla, así que es más difícil que se desactualice o se pierda. Además, cada cambio a un COMMENT queda en la bitácora, lo que da historial al diccionario.

**2. ¿Quedaron registrados los COMMENT en la bitácora? ¿Con qué nivel de `log_statement`?**

Sí. COMMENT ON es una sentencia DDL, y con log_statement = mod se registran las sentencias DDL y las que modifican datos. También se registraría con ddl y all, pero no con none. Se puede comprobar buscando COMMENT ON en dba.bitacora.

**3. ¿Qué información del diccionario debe mantenerse fuera del motor? ¿Por qué?**

Deben quedar fuera las aprobaciones de acceso y su evidencia, el fundamento legal de los plazos de retención, los datos de contacto de los responsables y cualquier credencial o secreto. Quien tiene privilegios en la base, incluido el DBA, puede leer y a veces modificar el catálogo, así que la evidencia de quién autorizó qué debe guardarse en un lugar independiente que el DBA no pueda alterar. Los secretos nunca deben ir en un COMMENT, porque terminarían en la bitácora.