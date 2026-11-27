# Expediente de auditoría interna — Base comercial
 **Camacho Castañeda Angélica María 4-1**

_Gestión de seguridad y desempeño de bases de datos_

_LAB-03 — Políticas prácticas, gobierno de datos y evidencias_

## 1. Alcance

| Sistema | Versión | Despliegue | Objetos revisados |
|---|---|---|---|
| PostgreSQL | 18 | Servidor local en Windows, administrado con pgAdmin 4 y psql. Las conexiones vienen de la propia computadora | Base comercial: esquemas public, auditoria, gobierno y dba |
| MongoDB Community | 7 | Servidor local del LAB-02 | Base comercial: colecciones clientes, system.profile y auditoria.instantaneas_privilegios |

**Periodo revisado:** octubre-noviembre de 2026. La vista dba.bitacora cubre desde noviembre de 2026. 

**Responsable del expediente:** Angélica María Camacho Castañeda.

**Revisión independiente:** Angélica María Camacho Castañeda (No es correcto que el DBA sea la misma persona que auditor, pero es una práctica de tarea). El DBA no concilia sus propios cambios, según POL-01 y POL-06.

## 2. Configuración de auditoría (A3)

| Mecanismo | Qué hace | Evidencia |
|---|---|---|
| Parámetros de registro de PostgreSQL (logging_collector, log_connections, log_disconnections, log_statement = mod, log_line_prefix, log_min_error_statement) | Guarda en archivo las conexiones, los errores y las sentencias que modifican datos o estructura. Cada línea incluye fecha, usuario, base, aplicación y cliente. | E1 |
| Disparador trg_auditoria_clientes | Registra cada cambio en clientes dentro de auditoria.cambios_clientes: quién, cuándo, aplicación, operación y valores antes y después. | E3, E4 |
| Vista dba.bitacora | Permite consultar con SQL el archivo de bitácora (columnas num y linea). | E5 |
| Exportación de bitácora con hash | Copia del archivo con la contraseña redactada y su SHA-256, para detectar si se altera. | E5 |
| Privilegios por rol | Lista de lo que cada rol puede hacer sobre las tablas. Se compara con la matriz de roles de la Unidad II. | E2 |
| MongoDB: system.profile, bitácora de mongod e instantáneas de privilegios | Registra consultas lentas, eventos del servidor y el estado de los privilegios en cada captura. No es una auditoría nativa. | E6 |

## 3. Bitácora interpretada (A3, A5)

### Evento 1: incidente del RFC de María García

| Pregunta | Respuesta |
|---|---|
| Quién | app_ventas |
| Cuándo | 2026-11-06 22:59:11 |
| Desde dónde | Aplicación app-ventas-web |
| Qué ocurrió | UPDATE del cliente 3 (María García [confirmar que el cliente 3 es ella]). RFC anterior: GAMA780912XYZ. |
| Tipo de evento | Modificación de un dato personal (cambio de datos). |
| Qué prueba | La fila en auditoria.cambios_clientes y la línea statement: UPDATE en la bitácora. Juntas muestran que el cambio ocurrió y que ambos mecanismos lo registraron. |

### Evento 2: cambio de RFC con el disparador de auditoría desactivado
 
| Pregunta | Respuesta |
|---|---|
| Quién | postgres |
| Cuándo | 2026-11-06 de 23:20:25 a 23:20:31|
| Desde dónde | pgAdmin 4, base comercial |
| Qué ocurrió | Se desactivó trg_auditoria_clientes, se cambió el RFC del cliente 3 a GAMA780912GHI y se volvió a activar el disparador. |
| Tipo de evento | Cambio de configuración de un control de seguridad y modificación de un dato personal sin rastro en la auditoría. |
| Qué prueba | Las tres líneas del archivo 2026-11-06, la ausencia de un evento del cliente 3 entre el id_evento 3 y el 4 y el RFC anterior del id_evento 8. El estado actual del disparador está en  (tgenabled debe ser O). |

### Evento 3: privilegio de modificación para app_ventas
 
| Pregunta | Respuesta |
|---|---|
| Quién | postgres |
| Cuándo | 2026-11-06 22:03:37 (línea 98) |
| Desde dónde | pgAdmin 4, cliente ::1, base comercial |
| Qué ocurrió | GRANT UPDATE ON clientes TO app_ventas;. Tres segundos antes se había quitado el mismo privilegio a soporte_ana. |
| Tipo de evento | Cambio de privilegios. |
| Qué prueba | Líneas 96 y 98 de la bitácora (E5) y los privilegios actuales de app_ventas |
 

## 4. Elementos de gobierno (A1, A2)

### Responsables (Actividad 2)

| Conjunto de datos | Propietario | Custodio | Quién aprueba accesos |
|---|---|---|---|
| public.clientes (PostgreSQL) | Gerencia Comercial (rfc: Facturación; edad: Analítica) | DBA | El propietario de cada campo, con visto bueno de Dirección |
| auditoria.cambios_clientes | Dirección / responsable de gobierno de datos | DBA | Dirección / responsable de gobierno de datos |
| Bitácora de PostgreSQL | Dirección / responsable de seguridad | DBA | Dirección / responsable de seguridad |
| comercial.clientes (MongoDB) | Gerencia Comercial | DBA | El propietario de cada campo, con visto bueno de Dirección |
| system.profile (MongoDB) | Dirección / responsable de seguridad | DBA | Dirección / responsable de seguridad |

El DBA es custodio de todos los conjuntos y nunca aprueba accesos.

### Catálogo (Actividad 4)

| ID | Conjunto de datos | Motor | Propietario | Clasificación | Datos personales |
|---|---|---|---|---|---|
| CAT-01 | Clientes | PostgreSQL | Gerencia Comercial | Confidencial | Sí |
| CAT-02 | Auditoría de clientes | PostgreSQL | Dirección / gobierno de datos | Confidencial | Sí (guarda valores anteriores y nuevos) |
| CAT-03 | Registro de cambios (gobierno.solicitudes_cambio) | PostgreSQL | Comité de cambios | Interno | Posible |
| CAT-04 | Clientes (tienda) | MongoDB | Gerencia Comercial | Confidencial | Sí |
| CAT-05 | Perfilado (system.profile) | MongoDB | Dirección / seguridad | Confidencial | Posible (las consultas pueden traer correos o RFC) |

### Diccionario (Actividad 3)

El diccionario de clientes está en el motor mediante COMMENT ON TABLE y COMMENT ON COLUMN, y se exportó como diccionario-clientes.csv. Las tres tablas del catálogo de PostgreSQL (public.clientes, auditoria.cambios_clientes y gobierno.solicitudes_cambio) tienen descripción. Para cada columna se definió clasificación, finalidad, control aplicado, si sus cambios se auditan y su regla de calidad.

## 5. Conservación (A3)

| Registro | Sensibilidad | Período | Dónde se conserva | Quién lo lee | Al vencer |
|---|---|---|---|---|---|
| Accesos de PostgreSQL | Media | 6 meses | Copia exportada con hash, fuera del servidor | Seguridad y Auditoría | Borrado seguro |
| Cambios de privilegios y estructura | Alta | 24 meses (a confirmar con el área jurídica) | Copia exportada, de solo lectura | Seguridad y Auditoría | Revisión del propietario y borrado seguro |
| Modificaciones de datos (log_statement = mod) | Alta | 12 meses | Copia exportada, con acceso restringido | Seguridad y Auditoría | Borrado seguro |
| auditoria.cambios_clientes | Datos personales | Valores completos 12 meses; después se enmascaran y se conserva quién, cuándo y qué columna hasta 24 meses (a confirmar con el área jurídica) | Tabla con permisos restringidos y exportación con hash | Auditoría y Dirección | Enmascarar o anonimizar |
| Bitácora de mongod | Media | 6 meses | Copia en almacenamiento separado | Seguridad y DBA | Borrado seguro |
| system.profile | Media-alta | 30 días | Exportación solo cuando hay un caso | DBA y Seguridad | Descartar |
| Instantáneas de privilegios (MongoDB) | Alta | 24 meses (a confirmar con el área jurídica) | Colección restringida y exportación con hash | Seguridad y Auditoría | Archivo o borrado seguro |


## 6. Políticas (A4)

| ID | Política | Regla en una línea | Evidencia que la respalda | Evidencia que hoy no existe |
|---|---|---|---|---|
| POL-01 | Acceso | El propietario aprueba cada acceso, el DBA lo ejecuta y cada mes se concilia GRANT/REVOKE con las solicitudes. | Bitácora de GRANT/REVOKE (dba.bitacora), gobierno.solicitudes_cambio, matriz de la Actividad 2, E2 | Acta de revisión trimestral |
| POL-02 | Respaldo | Respaldo diario fuera del servidor, con prueba trimestral de restauración hecha por una persona distinta al DBA. | Ninguna en LAB-01 a LAB-03 | Registro de respaldos y de pruebas de restauración |
| POL-03 | Retención | Plazos por tipo de dato y de bitácora, con borrado seguro al vencer y suspensión si hay un incidente abierto. | Catálogo (columna Conservación) y tabla de retención | Registro de borrados y manifiesto de hashes |
| POL-04 | Restauración | Restaurar en producción requiere solicitud aprobada y prueba previa en otro ambiente. | gobierno.solicitudes_cambio, dba.bitacora, auditoria.cambios_clientes | Registro de restauraciones |
| POL-05 | Uso de datos sensibles | RFC solo para Facturación y DBA; soporte usa la vista enmascarada; las bitácoras las leen Seguridad y Auditoría. | auditoria.cambios_clientes, dba.bitacora, matriz de gobierno | Registro de lecturas (SELECT) |
| POL-06 | Cambios en producción | Todo cambio de datos, estructura, privilegios o configuración se registra, se aprueba y se verifica contra la bitácora. | gobierno.solicitudes_cambio, dba.bitacora, auditoria.cambios_clientes | Registro de cambios de configuración hechos fuera de SQL |

**Las seis políticas son coherentes entre sí. POL-03 no elimina nada que POL-05 necesite para investigar, y POL-04 y POL-01 usan el proceso de POL-06. Un ambiente es un conjunto independiente de infraestructura, configuración y datos sobre el cual se ejecuta un sistema, para un propósito específico dentro del ciclo de vida del software. Producción es la base comercial en su servidor.**

## 7. Conciliación de cambios (A5)

| Momento (bitácora) | Usuario | Sentencia | Folio que autoriza | ¿Autorizado? | Hallazgo |
|---|---|---|---|---|---|
| 2026-10-25 22:54:26 | postgres | ALTER TABLE clientes ADD COLUMN canal_alta ... | CAM-2026-014 | Sí | — |
| 2026-10-25 22:50:53 | postgres | ALTER TABLE clientes DISABLE TRIGGER trg_auditoria_clientes | Ninguno | No | Se desactivó el trigger de auditoría sin solicitud. Mientras estuvo desactivado, los cambios en clientes no quedaron en auditoria.cambios_clientes. |
| 2026-10-25 22:50:09 | postgres | GRANT UPDATE ON clientes TO app_ventas | Ninguno | No | Privilegio de modificación otorgado sin solicitud aprobada del propietario del dato. |


**Resultado:** de los cambios conciliados, solo uno tiene folio comprobable. Los demás se hicieron sin solicitud aprobada. Como la tabla de solicitudes está vacía, aun los cambios que sí fueron autorizados no se pueden demostrar con el registro actual.

**Quién concilia:** una persona distinta al DBA. Todos los cambios aparecen con el usuario postgres, así que la bitácora no permite saber qué persona los hizo.

## 8. Hallazgos

 Hallazgo | Fuente | Severidad | Impacto | Recomendación | Decisión requerida de |
|---|---|---|---|---|---|
| Posible cliente duplicado: los registros 1 y 7 comparten el mismo correo (comparando en minúsculas). | Actividad 1, consulta por lower(correo) | Media | Datos repetidos, contactos y facturas duplicados. | Confirmar si es la misma persona y fusionar los registros. Crear un índice UNIQUE sobre lower(correo). | Gerencia Comercial (propietario) |
| RFC incompleto en el registro 7: tiene 12 caracteres y le falta la homoclave. | Actividad 1, validación del formato | Alta | Una factura emitida con ese RFC puede ser rechazada, con consecuencias fiscales. | Pedir el RFC completo al cliente. El DBA no debe inventarlo. Agregar un CHECK de formato (con NOT VALID hasta corregir los datos). | Facturación (propietario del RFC) |
| RFC faltante (nulo) en el registro 8. | Actividad 1 | Media | No se puede facturar a ese cliente. | Pedir el RFC. Decidir si el campo debe ser obligatorio. | Facturación |
| Edad fuera de rango (-3) en el registro 8. | Actividad 1 | Media | Estadísticas de analítica incorrectas. | Verificar el dato real y corregirlo. Agregar CHECK (edad BETWEEN 18 AND 120). | Analítica (propietario de edad) |
| Cambios sin folio: GRANT a app_ventas, DISABLE TRIGGER y cambios en el esquema gobierno. | Actividad 7, conciliación | Alta | Cambios en producción sin autorización demostrable. | Exigir solicitud en gobierno.solicitudes_cambio antes de cada cambio (POL-06) y conciliar cada mes. | Comité de cambios |
| Se desactivó el trigger de auditoría. Primero lo intentó app_ventas (línea 163) y después postgres (línea 169). | LAB-01, Actividad 14; E3 | Alta | Periodo sin auditoría en clientes. Quien lo hizo pudo ocultar sus cambios. | Revisar si la línea 163 falló. Reconstruir el periodo con la bitácora y revocar a app_ventas el permiso de cambiar estructura. | Responsable de seguridad |
| La bitácora guardó una contraseña (CREATE ROLE rol_temporal ... PASSWORD). | LAB-01; E5 | Alta | Quien lea la bitácora conoce una credencial. | Redactar la contraseña antes de compartir (hecho en E5), cambiarla y limitar quién lee la bitácora. | Responsable de seguridad |
| La conciliación depende de la bitácora, que tiene huecos: la vista dba.bitacora empieza en `num` 52, hay archivos de 0 bytes y días sin archivo. | dba.bitacora, pg_ls_logdir(), E1 | Media | No se puede demostrar que el registro estuvo activo todo el periodo. | Declarar los huecos y guardar capturas de E1 con fecha y hash. | Responsable de seguridad |
| No existe registro de respaldos, restauraciones ni lecturas (SELECT). | Sección 6 | Media | POL-02, POL-04 y POL-05 no se pueden demostrar. | Crear esos registros. El procedimiento técnico se define en la Unidad V. | Dirección / gobierno de datos |


## 9. Limitaciones conocidas y riesgos aceptados (A6)

| Limitación | Riesgo | Control compensatorio | Quién debe aceptar el riesgo |
|---|---|---|---|
| MongoDB Community no tiene auditoría nativa. | Los accesos y cambios en MongoDB no quedan registrados como en PostgreSQL. | Bitácora de mongod, system.profile e instantáneas de privilegios, con sus límites. | Dirección / responsable de seguridad |
| Las lecturas (SELECT) no se auditan sin pgaudit. log_statement = mod solo registra sentencias que modifican. | Alguien puede consultar datos personales sin dejar rastro. | Control de acceso por rol y vista enmascarada para soporte. | Dirección y propietarios de los datos |
| La auditoría la puede desactivar el administrador (por ejemplo, con DISABLE TRIGGER o cambiando log_statement). | Un cambio puede quedar sin registro. El caso de H-06 lo muestra. | Conciliación mensual por una persona independiente, y cambios de configuración solo con solicitud (POL-06). | Dirección / responsable de seguridad |
| system.profile es una colección de 1 MB que se sobrescribe sola. | Se pierden eventos antiguos. | Exportar cuando haya un caso e investigar pronto. | Responsable de seguridad |
| La bitácora contiene sentencias completas, que pueden incluir contraseñas y datos personales. | Exposición al compartir la evidencia. | Redactar antes de compartir, volver a calcular el hash y declarar que se redactó. | Responsable de seguridad y propietarios de los datos |

## 10. Índice de evidencias

Los hashes se calculan con SHA-256, después de redactar y revisar cada archivo.

| ID | Archivo | Contenido | 
|---|---|---|
| E1 | evidencias/E1-configuracion-registro.txt | Parámetros de registro de PostgreSQL|
| E2 | evidencias/E2-privilegios.txt | Privilegios por rol y tabla |
| E3 | evidencias/E3-disparadores.txt | Estado de los disparadores | 
| E4 | evidencias/E4-muestra-auditoria.txt | Últimos 10 eventos de auditoria.cambios_clientes, sin valores |
| E5 | evidencias/E5-bitacora-postgresql.log | Bitácora actual, con la contraseña redactada | 
| E5 | evidencias/E5-bitacora-postgresql-2.log y siguientes | Archivos de bitácora rotados con contenido |
| E5 | evidencias/E5-indice-archivos.txt | Nombre original de cada archivo rotado | 
| E6 | evidencias/system-profile.json | Perfilado de MongoDB  |
| E6 | evidencias/bitacora-mongod.log | Bitácora de mongod |
| E6 | Comparación de la Actividad 9 (LAB-02) | Comparación de privilegios |

**Los hashes se encuentran en el respectivo archivo**