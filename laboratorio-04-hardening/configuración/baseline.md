# Actividad 19 — Construcción de una línea base
# Baseline de seguridad para PostgreSQL 16

### Red
| Control | Valor de la línea base |
|---|---|
| Interfaces autorizadas | listen_addresses = 'localhost', o una IP privada del servidor si hay clientes remoto, nunca se debe dejar '*' |
| Puerto | 5432/TCP verificado con ss -lnt o netstat -ano|
| Firewall | Política por defecto, denegar. Permitir 5432 solo desde las redes autorizadas |
| Redes permitidas | Solo la red de aplicación/DBA (por ejemplo `10.10.10.0/24`); sin acceso desde Internet |

### Autenticación
| Control | Valor de la línea base |
|---|---|
| Método | scram-sha-256, se deben prohibir trust, password y md5 |
| password_encryption| scram-sha-256 |
| Políticas de credenciales | Contraseñas largas y únicas por cuenta, rotación periódica, fechas especificas de duración en roles, secretos fuera del código fuente |
| Cuentas administrativas | postgres solo para administración y desde local |
| pg_hba.conf | Reglas específicas: base + usuario + origen + método. Las reglas específicas van antes de las generales y no hay 0.0.0.0/0 |


### Autorización
| Control | Valor de la línea base |
|---|---|
| Roles | Tres tipos: DBA (administración), APP (aplicación) y CONSULTA (solo lectura). Los permisos se asignan a roles de grupo |
| Privilegios | Mínimo privilegio, CONNECT solo a quien lo necesita, GRANT solo sobre los objetos requeridos |
| Cuentas de aplicación | sin permisos de super usuario y solo lo necesario, una cuenta por aplicación y sin compartirla con la administración |

### Configuración
| Control | Valor de la línea base |
|---|---|
| Parámetros relevantes | ssl = on, ssl_min_protocol_version = 'TLSv1.2', log_connections = on, log_disconnections = on, log_line_prefix con usuario, base, IP y hora |
| Conexiones |max_connections ajustado a la carga real, superuser_reserved_connections = 3, statement_timeout y idle_in_transaction_session_timeout distintos de 0 (por ejemplo 30s y 60s) |
| Extensiones | Solo las necesarias (plpgsql), revisar pg_extension periódicamente |
| Logs | Rotación y retención definidas; acceso restringido |

### Sistema operativo
| Control | Valor de la línea base |
|---|---|
| Propietario de archivos | Usuario del servicio  |
| Permisos | Linux: directorio de datos con 700, postgresql.conf y pg_hba.conf con 600 mientras que para windows sin everyone ni users |
| Directorio de datos | Fuera de rutas compartidas, en un disco o volumen dedicado con espacio vigilado; respaldos y logs con las mismas restricciones |
| Servicio | PostgreSQL corre con una cuenta sin privilegios, nunca como root ni admin |

## 6. Cifrado
| Control | Valor de la línea base |
|---|---|
| TLS | ssl = on con certificados válidos, reglas hostssl para clientes remotos; verificado con `pg_stat_ssl|
| Protección de credenciales | Verificadores SCRAM en el servidor; no guardar contraseñas en texto claro en scripts, repositorios |
| Información sensible | Cifrado de disco o volumen, respaldos cifrados, pgcrypto` o cifrado a nivel de aplicación para campos críticos y datos sensibles fuera de los logs |

## 7. Mantenimiento
| Control | Valor de la línea base |
|---|---|
| Actualización | Aplicar las versiones menores de PostgreSQL 16 (parches de seguridad) con ventana de mantenimiento; registrar la versión con SELECT version();|
| Revisión periódica | Cada tres meses a pg_hba_file_rules, roles y privilegios, extensiones, exposición de red y logs |
| Respaldos | pg_dump o pg_basebackup más copia de los archivos de configuración, guardados fuera del servidor, con pruebas de restauración |
| Documentación | Línea base versionada, registro de cambios (antes/después) y checklist con evidencia |