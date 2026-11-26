-- Camacho Castañeda Angélica María 4-1
-- Gestión de seguridad y desempeño de bases de datos
-- LAB-03 — Políticas prácticas, gobierno de datos y evidencias

| Registro | Ubicación actual | Riesgo de pérdida observado | Sensibilidad | Período propuesto | Justificación | Dónde se conserva | Quién puede leerlo | Acción al vencer |
|---|---|---|---|---|---|---|---|---|
| Accesos de PostgreSQL | Archivo del colector (pg_current_logfile()) | Rotación del archivo, reinstalación o recreación del servidor | Media (IPs y usuarios) | 6-12 meses | Sirve para investigar accesos sospechosos. Es de alto volumen y poco valor individual. | Copia exportada con hash en almacenamiento separado del servidor | Seguridad y Auditoría, DBA solo para diagnóstico | Borrado seguro |
| Cambios de privilegios y estructura | Archivo del colector | Rotación del archivo, reinstalación o recreación del servidor | Alta | 24 meses (o plazo que establezca el área jurídica) | Es evidencia de quién dio o quitó acceso. Tiene poco volumen y mucho impacto. | Copia exportada, de solo lectura, fuera del servidor | Seguridad y Auditoría, el DBA no, porque sus propios cambios aparecen ahí | Revisión del propietario y archivo o borrado seguro |
| Modificaciones de datos (log_statement = 'mod') | Archivo del colector | Rotación del archivo, reinstalación o recreación del servidor | Alta (las sentencias pueden incluir datos personales o secretos) | 12-16 meses | Permite reconstruir quién modificó qué. Se limita el tiempo porque contiene valores de datos. | Copia exportada, con acceso restringido y hash | Seguridad y Auditoría | Borrado seguro |
| auditoria.cambios_clientes | Tabla en comercial | Se pierde si se recrea la base, la puede modificar quien tenga permisos sobre ella | Contiene datos personales | Plazo a confirmar con el área jurídica (personalmente, +16 meses) | Es la evidencia de cambios en clientes, pero guarda valores personales y choca con la política de eliminación. | Tabla con permisos restringidos, más exportación periódica con hash | Auditoría y Dirección (solo lectura) | Enmascarar o anonimizar los valores personales y conservar solo quién, cuándo y qué columna cambió |
| Bitácora de mongod | systemLog.path o salida estándar, getLog solo en memoria | getLog se pierde al reiniciar, la salida estándar se pierde si no se captura | Media | 6 meses | Sirve para diagnóstico y para ver accesos al motor. | Copia del archivo en almacenamiento separado | Seguridad y DBA (lectura) | Borrado seguro |
| system.profile | Colección limitada de 1 MB | Se sobrescribe sola | Media-alta (contraseñas en texto plano o datos personales de los clientes) | 30 días, exportando si se investiga un caso | Es un registro de rendimiento, no de evidencia, y se pierde rápido. | Exportación puntual solo cuando hay un caso | DBA y Seguridad | Descartar al sobrescribirse o al terminar el caso |
| Instantáneas de privilegios (MongoDB) | auditoria.instantaneas_privilegios | Solo muestran el estado en cada captura, los cambios entre capturas no quedan registrados | Alta | 24 meses (o plazo que el área jurídica establezca) | Permiten comparar quién tenía qué acceso en cada fecha. | Colección con permisos restringidos, más exportación con hash | Seguridad y Auditoría | Archivo o borrado seguro tras revisión |


**1. ¿Por qué la bitácora de cambios de privilegios merece más tiempo de conservación que la de consultas rutinarias?**

Porque es evidencia de quién dio o quitó accesos y de cuándo, y esos cambios suelen descubrirse tiempo después, como cuando hay una investigación o una auditoría. Tiene poco volumen y un impacto muy alto, mientras que las consultas rutinarias son muchas, valen poco individualmente y pueden contener datos personales, así que conservarlas mucho tiempo cuesta más y aumenta el riesgo. Es mejor tener poca información útil que mucha información irrelevante.
**2. ¿Qué control de integridad aplicarás a las bitácoras exportadas?**

Al exportar cada archivo se podría calcular su hash SHA-256 (por ejemplo como en la práctica de MongoDB) y guardarse por separado con fecha y responsable. Los archivos pueden almacenar fuera del servidor, en modo de solo lectura, donde el DBA no pueda modificarlos. Periódicamente se vuelve a calcular el hash y se compara con el original y si no coincide, el archivo fue modificado.

**3. ¿Qué diferencia hay entre conservar una bitácora y respaldar una base de datos?**

Un respaldo guarda el estado de los datos en un momento para poder recuperarlos, y al restaurarlo se vuelve a lo que se tenía. Conservar una bitácora guarda el historial de lo que ocurrió, como evidencia para auditoría e investigación, y no se debe sobrescribir ni revertir. 