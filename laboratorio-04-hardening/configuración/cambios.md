# Actividad 16 — Comparar configuración antes y después
| Control   | Antes    | Después  | Justificación  |
|-----------|----------------------|---------------|----------|
| listen_addresses         | *  (todas las interfaces) | localhost| Solo se necesita acceso local y reduce la superficie de exposición             |
| pg_hba.conf              | Reglas locales con all all | host pruebas_DBA 127.0.0.1/32 y ::1/128`  | Regla específica: base + usuario + origen + método|
| Método de autenticación  | scram-sha-256| scram-sha-256 (sin cambio)| Ya es el método más robusto basado en contraseña|
| Usuarios administrativos | postgres (único con login y SUPERUSER)| postgres, reservado solo para tareas especificas| El superusuario no se usa en aplicaciones|
| Cuentas de aplicación    | No existían (se usaba postgres)| Ningun cambio| Mínimo privilegio, si se creara un nuevo rol, pero no se hizo otro|
| Puerto| 5432, escuchando en 0.0.0.0 y [::]| 5432, escuchando solo en 127.0.0.1 y `[::1]| El puerto no cambia, pero ya no es alcanzable desde la red|
| TLS|ssl = off, conexión sin cifrar| Laboratorio local: sin cambio. Entorno real: ssl = on y hostss`| El tráfico local no sale del equipo; con clientes remotos TLS es obligatorio  |
| Permisos SO| Verificados con icacls en C:\Program Files\PostgreSQL\18\data port trabajar en windows, sin everyone ni Users| Sin cambios | GRANT/REVOKE no protegen los archivos fuera de postgre, los permisos del SO sí |
| Extensiones| Solo plpgsql 1.0| Solo plpgsql 1.0`| No hay funcionalidad innecesaria instalada|
| Conexiones| max_connections = 100, statement_timeout = 0, idle_in_transaction_session_timeout = 0`| No hubo cambios pero una propuesta es utilizar 30s para el timeout y 60 para transacciones  | Los timeouts evitan consultas colgadas y sesiones inactivas que consumen recursos |