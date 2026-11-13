## LAB-02 — Trazabilidad en MongoDB Community
_Gestión de seguridad y desempeño de bases de datos_
**Camacho Castañeda Angélica María 4-1**


## Actividad 1 — Lo que no existe en esta edición
**1. ¿Qué edición de MongoDB estás usando? ¿Qué evidencia lo demuestra?**

Uso MongoDB Community. La evidencia es que db.adminCommand({ buildInfo: 1 }).modules devuelve un arreglo vacío ([]). En una edición Enterprise, ese arreglo incluiría "enterprise".

**2.¿A dónde escribe tu servidor su bitácora? ¿Cómo lo sabes?**

Escribe a un archivo llamado C:\Program Files\MongoDB\Server\8.0\log\mongod.log. Lo sé porque db.serverCmdLineOpts().parsed.systemLog muestra lo siguiente:  destination: 'file', path con esa ruta y logAppend: true (los eventos nuevos se agregan al final del archivo en lugar de sobrescribirlo). El campo config confirma que la configuración se leyó de C:\Program Files\MongoDB\Server\8.0\bin\mongod.cfg.

**3.Según REF-U3-04, ¿qué cuatro categorías de eventos registraría la auditoría nativa?**

1. **Autenticación:** debe registrar los inicios de sesión correctos y fallidos, con usuario, origen y momento.
2. **Autorización:** debe registrar que operaciones permitidas o rechazadas según los privilegios, incluidas las acciones denegadas por falta de permisos.
3. **Administración de usuarios y roles:** la auditoría registra creación, modificación y eliminación de usuarios, roles y privilegios.
4. **Cambios de esquema y de configuración:** registra la creación o eliminación de bases, colecciones e índices, y cambios en la configuración del servidor.


**4.¿Qué tendría que evaluar una organización antes de licenciar Enterprise o migrar a Atlas solo para obtener auditoría?**
La organización debe evaluar cuáles son los requisitos reales para ver qué qué eventos hay que auditar y si una norma o política lo exige o si basta con la bitácora actual combinada con otros controles. Igualmente debe considerar qué cosas si son necesarias de auditar ya que auditar más eventos aumenta la carga y el volumen de registros (esto también se vio reflejado en el laboratorio pasado). Debe considerarse la seguridad de los datos, pensar dónde se guardan los registros, por cuánto tiempo y cómo se protegen contra alteraciones.
