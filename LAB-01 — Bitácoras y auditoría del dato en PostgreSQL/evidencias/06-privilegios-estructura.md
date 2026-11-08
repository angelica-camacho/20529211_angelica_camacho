# LAB-01 — Bitácoras y auditoría del dato en PostgreSQL
_Gestión de seguridad y desempeño de bases de datos_

**Camacho Castañeda Angélica María 4-1** 
![alt text](image-3.png)
### Actividad 6 — Cambios de privilegios y de estructura

**¿Qué tipo de evento es cada una de las tres primeras sentencias (privilegio o estructura)?**

* REVOKE UPDATE ON clientes FROM soporte_ana es un evento de privilegio: le quita a soporte_ana el permiso de modificar clientes.

* GRANT UPDATE ON clientes TO app_ventas es un evento de privilegio: le da ese permiso a app_ventas.

* ALTER TABLE clientes ADD COLUMN segmento VARCHAR(20) es un evento de estructura: cambia la definición de la tabla.

**¿Por qué GRANT y REVOKE quedan registrados con log_statement = 'ddl'?**
PostgreSQL clasifica GRANT y REVOKE como DDL porque modifican el catálogo del sistema, donde se guardan las listas de privilegios de cada objeto. No son solo CREATE, ALTER y DROP. Por eso aparecen en la bitácora con fecha, usuario (postgres) y cliente, lo que permite auditar cada cambio de permisos.

**Si la bitácora contiene contraseñas, ¿quién debería poder leerla? Relaciónalo con la gestión de secretos de la Unidad II.**
En la fila 5 de la bitácora se ve el CREATE ROLE rol_temporal LOGIN PASSWORD 'Temporal_Practica_2026' con la contraseña completa en texto plano. Por eso la bitácora debe tratarse como un secreto: solo debería leerla un rol de auditoría o administración, con permisos restringidos sobre la carpeta log y sin acceso para roles de aplicación como app_ventas o soporte_ana.
Lo cual se relaciona con la gestión de secretos de la Unidad II, ya que las contraseñas no deben escribirse dentro de sentencias. Se asignan con \password, que las cifra en el cliente y evita que lleguen en claro a la bitácora, ya que si una contraseña aparece en la bitácora, se considera comprometida y se debe rotar.
