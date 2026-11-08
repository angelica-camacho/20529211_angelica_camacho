# LAB-01 — Bitácoras y auditoría del dato en PostgreSQL
_Gestión de seguridad y desempeño de bases de datos_

**Camacho Castañeda Angélica María 4-1** 

### Actividad 8 — Errores y operaciones rechazadas

**¿El intento de soporte_ana causó algún daño? ¿Por qué debe auditarse de todos modos?**
No causó daño. PostgreSQL rechazó la operación por falta de permisos y los datos de clientes quedaron intactos. Aun así debe auditarse, porque un intento fallido indica que una cuenta trató de hacer algo fuera de su función. Puede ser un error, un abuso o una credencial robada. Si la bitácora no lo registra, nadie se entera ni puede investigarlo. Además, que hoy falle depende de los privilegios actuales, y si mañana alguien los cambia, el mismo intento podría salir bien.

**¿Qué diferencia hay entre un error de autorización (esta actividad) y uno de autenticación (Actividad 5)?**
La autenticación responde quién eres y la autorización responde qué puedes hacer.
* Autenticación: falló la contraseña, así que el error fue FATAL, la conexión se cerró y nunca se abrió la sesión. Por eso la línea tenía app=[unknown].
* Autorización (esta actividad): el usuario ya había entrado, pero no tenía permiso para esa acción. El error fue ERROR: permission denied, la sesión siguió abierta y la línea sí trae usuario, base, aplicación, cliente y el texto de la sentencia.

**¿Qué indica el error de DROP ROLE sobre el orden correcto para dar de baja a un usuario?**
Indica que un rol no se puede borrar mientras tenga privilegios u objetos asociados, como los permisos sobre clientes. Primero hay que quitarle los privilegios (REVOKE), reasignar o eliminar lo que posea (REASSIGN OWNED y DROP OWNED) y hasta el final ejecutar DROP ROLE.