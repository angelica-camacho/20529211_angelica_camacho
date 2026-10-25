# LAB-04 — Hardening y configuración segura de PostgreSQL

## Objetivo
Revisar la configuración de un servidor PostgreSQL, identificar su superficie de ataque y aplicar controles de hardening basados en el principio de mínimo privilegio y la defensa en profundidad.

## Entorno
| Elemento | Valor |
|---|---|
| Sistema operativo | Windows |
| Versión de PostgreSQL | 18 |
| Directorio de datos | C:\Program Files\PostgreSQL\18\data |
| Puerto | 5432/TCP |
| Base de datos de práctica | pruebas_DBA |
| Herramientas | pgAdmin, PowerShell (netstat, icacls) |

## Superficie de ataque inicial
- listen_addresses = '*': el servicio escucha en 0.0.0.0 y [::] (verificado con netstat -ano, PID 6944).
- Puerto 5432 accesible en todas las interfaces.
- postgres es el único rol con login y es SUPERUSER.
- ssl = off: conexión sin cifrar.
- statement_timeout = 0 e idle_in_transaction_session_timeout = 0.
- log_connections vacío y log_disconnections = off: sin auditoría de conexiones.
- Regla analizada de riesgo: host all all 0.0.0.0/0 scram-sha-256.

## Hallazgos
| # | Hallazgo | Riesgo |
|---|---|---|
| 1 | Escucha en todas las interfaces | Exposición innecesaria del servicio |
| 2 | Solo existe el superusuario postgres | Sin separación DBA / APP / CONSULTA |
| 3 | Sin TLS | Credenciales y datos sin cifrar en tránsito |
| 4 | Sin timeouts | Sesiones colgadas que consumen recursos |
| 5 | Sin logs de conexión | Intentos de intrusión que no se pueden detectar |
| 6 | Sin respaldos documentados | No hay forma de recuperar ni revertir los errores. |

Aspectos correctos: pg_hba.conf solo con reglas locales, scram-sha-256 en todas las reglas, solo la extensión plpgsql y permisos del directorio de datos sin everyone ni users.

## Cambios realizados
| Control | Antes | Después |
|---|---|---|
| listen_addresses | * | localhost |
| pg_hba.conf | Reglas all all | host pruebas_DBA lab_user 127.0.0.1/32 y ::1/128 |
| statement_timeout | 0 | 30s (propuesta)|
| idle_in_transaction_session_timeout | 0 | 60s (propuesta) |
| Logs de conexión | Desactivados | Activados |

## Justificación de los cambios
- **listen_addresses:** solo se necesita acceso local, por lo que se elimina la exposición en otras interfaces.
- **pg_hba.conf:** una regla específica (base + usuario + origen + método) reduce quién puede intentar conectarse.
- **Timeouts:** evitan consultas colgadas y sesiones inactivas que agotan conexiones.
- **Logs:** permiten auditar quién se conecta, cuándo y desde dónde.

## Verificación
#### SQL
SHOW listen_addresses;
SELECT line_number, type, database, user_name, address, auth_method, error FROM pg_hba_file_rules;
SELECT rolname, rolsuper, rolcanlogin FROM pg_roles WHERE rolname = 'lab_user';
SHOW statement_timeout;
SHOW idle_in_transaction_session_timeout;
SHOW log_connections;
SHOW log_disconnections;

#### Powershell
netstat -ano | findstr 5432
icacls "C:\Program Files\PostgreSQL\18\data"

Resultado esperado: solo 27.0.0.1:5432 y [::1]:5432 en netstat, reglas sin errores, y sin everyone ni users en icacls.

## Checklist de hardening
| # | Control | Verificado |
|---|---|---|
| 1 | Puerto documentado | Sí |
| 2 | Interfaces de escucha justificadas | Sí |
| 3 | pg_hba.conf revisado | Sí |
| 4 | Redes autorizadas restringidas | Sí |
| 5 | Autenticación segura (scram-sha-256) | Sí |
| 6 | Superusuarios identificados | Sí |
| 7 | Cuentas de aplicación separadas | Sí |
| 8 | Privilegios mínimos | Sí |
| 9 | Extensiones revisadas | Sí |
| 10 | TLS verificado | Sí (desactivado, por que se trabajó en local) |
| 11 | Configuración protegida | Sí |
| 12 | Directorio de datos protegido | Sí |
| 13 | Firewall documentado | Sí |
| 14 | Actualizaciones documentadas | Pendiente (por que no se realizaron)|
| 15 | Configuración registrada | Sí |
| 16 | Límites de conexión y timeouts | Sí (propuesto)|
| 17 | Logs de conexión habilitados | Sí |
| 18 | Respaldos | No aplica ( ya que es solo el laboratorio) |

## Conclusiones
El servidor tenía una exposición muy grande e innecesaria, ya que escuchaba en todas las interfaces y dependía de un único superusuario (que es postgre ya que se trabaja de manera local). El cambio de mayor impacto fue limitar listen_addresses y restringir pg_hba.conf con una cuenta de mínimo privilegio. La seguridad no depende de un solo factor como contraseñas fuertes, red, firewall, pg_hba.conf, roles, TLS, logs y permisos del sistema operativo se complementan como defensa en profundidad.