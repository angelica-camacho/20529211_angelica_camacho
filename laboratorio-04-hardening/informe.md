# LAB-04 — Hardening y configuración segura de PostgreSQL

**1. ¿Cuál era la principal superficie de ataque?**
El puerto 5432 expuesto en todas las interfaces (listen_addresses = '*'), junto con las reglas de acceso amplias como 0.0.0.0/0 por que  permitía que cualquier equipo de la red intentara conectarse.

**2. ¿Qué configuración representaba el mayor riesgo?**
La regla host all all 0.0.0.0/0 scram-sha-256 en pg_hba.conf, combinada con el uso de una cuenta SUPERUSER (postgres), ya que cualquiera podía intentar entrar a cualquier base con el usuario con todos los permisos.

**3. ¿Qué cambio produjo la mayor reducción de exposición?**
Limitar listen_addresses a localhost (o a la IP privada necesaria) de esa forma el puerto deja de responder en las interfaces que no se necesitan.

**4. ¿Qué diferencia existe entre firewall y pg_hba.conf?**
El firewall filtra el tráfico de red (IP, puerto) antes de que llegue a PostgreSQL, mientras que pg_hba.conf actúa dentro del motor y decide por base, usuario, origen y método de autenticación. Usuaslmente se usan juntos como defensa en profundidad.

**5. ¿Qué diferencia existe entre autenticación y autorización?**
La autenticación verifica quién eres (usuario y contraseña). La autorización define qué puedes hacer una vez dentro (roles y privilegios).

**6. ¿Por qué una cuenta de aplicación no debe ser SUPERUSER?**
Porque un SUPERUSER omite todas las verificaciones de permisos. Si la aplicación se compromete, el atacante controla todo el servidor. Con mínimo privilegio, el daño queda limitado a una base.

**7. ¿Por qué cambiar el puerto de PostgreSQL no constituye hardening suficiente?**
Por que un escaneo de puertos encuentra el nuevo puerto fácilmente. No restringe quién accede, ni cifra, ni limita privilegios.

**8. ¿Por qué listen_addresses = '*' puede ser innecesario?**
Porque hace que el servicio acepte conexiones por todas las interfaces, aunque solo se use una (por ejemplo, localhost). Esto amplía la superficie de ataque innecesariamente.

**9. ¿Qué papel tiene el sistema operativo en la seguridad de PostgreSQL?**
Protege los archivos fuera del motor (datos, configuración, logs, respaldos). GRANT y REVOKE no impiden que un usuario del sistema lea esos archivos directamente, por eso se necesitan permisos.

**10. ¿Qué controles deberían revisarse periódicamente?**
pg_hba.conf y las redes permitidas, listen_addresses y puertos abiertos, roles y privilegios (superusuarios), extensiones instaladas, TLS, logs de conexión, permisos del sistema operativo, respaldos y actualizaciones de seguridad.

#### ¿Qué cambiarías primero si recibieras la responsabilidad de asegurar un servidor PostgreSQL que ya se encuentra funcionando en producción?
Primero documentaría el estado actual del servidor, revisando pg_hba_file_rules, los roles, las conexiones activas y los puertos abiertos, para no bloquear a usuarios que si lo necesitan, y haría un respaldo de los datos y la configuración para poder revertir cualquier cambio. Después restringiría quién puede conectarse, reemplazando reglas amplias por reglas específicas en pg_hba.conf y limitando el firewall a las redes autorizadas, ya que esto reduce mucho la exposición. Luego quitaría los privilegios a usuarios que no lo necesitan, y por último, limitaría listen_addresses, activaría TLS y los logs de conexión para que se puedan hacer auditorías.