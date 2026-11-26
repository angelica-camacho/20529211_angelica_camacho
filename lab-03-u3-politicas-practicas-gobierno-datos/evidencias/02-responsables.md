-- Camacho Castañeda Angélica María 4-1
-- Gestión de seguridad y desempeño de bases de datos
-- LAB-03 — Políticas prácticas, gobierno de datos y evidencias

| Conjunto de datos | Propietario | Custodio | Usuarios autorizados | Quién aprueba accesos |
|---|---|---|---|---|
| comercial.public.clientes (PostgreSQL) | Atención al cliente (rfc: Facturación, edad: Analítica / Negocio) | DBA | Atención al cliente, Facturación (solo rfc), Analítica (edad, ciudad, codigo_postal), DBA | El propietario de cada campo, con visto bueno de dirección |
| auditoria.cambios_clientes (PostgreSQL) | Dirección / responsable de gobierno de datos | DBA | Auditoría y Dirección (solo lectura), DBA solo mantenimiento, sin modificar registros | Dirección / responsable de gobierno de datos |
| Bitácora de PostgreSQL | Dirección / responsable de seguridad | DBA | DBA y Auditoría (lectura mediante dba.bitacora) | Dirección / responsable de seguridad |
| comercial.clientes (MongoDB) | Atención al cliente (rfc: Facturación; edad: Analítica / Negocio) | DBA | Atención al cliente, Analítica, DBA | El propietario de cada campo, con visto bueno de Dirección |
| comercial.system.profile (MongoDB) | Dirección / responsable de seguridad | DBA | DBA y Auditoría (solo lectura) | Dirección / responsable de seguridad |

**¿Por qué el propietario de auditoria.cambios_clientes no debería ser el mismo que opera clientes?**

Porque habría conflicto de intereses ya que quien opera la tabla clientes es quien modifica los datos, y auditoria.cambios_clientes existe justamente para vigilar los cambios que se hacen, y si la misma persona controla ambas, podría alterar un dato y luego borrar o editar la evidencia del cambio, y la auditoría dejaría de ser una evidencia confiable. 

**¿Quién debería poder leer las bitácoras y la vista dba.bitacora? Relaciónalo con lo observado en el LAB-01 (secretos en la bitácora).**

Solo ciertas personas como el DBA, para diagnóstico, y Auditoría o el responsable de seguridad, en modo de solo lectura, con acceso aprobado por el propietario de la bitácora (Dirección o seguridad). En el laboratorio 1 se observó que la bitácora registra las sentencias completas, y con ello se pueden ir contraseñas en texto plano, como contraseñas escritas en un CREATE ROLE ... PASSWORD o datos personales dentro de un UPDATE.

**¿Qué ocurre con la responsabilidad sobre un dato cuando nadie la tiene asignada? Relaciónalo con el problema inicial de la unidad.**

Cuando nadie es responsable de un dato, nadie lo corrige, nadie decide quién accede a él y nadie responde si algo sale mal, entonces todo recae en el DBA, que solo es custodio y no debería decidir sobre el contenido. 