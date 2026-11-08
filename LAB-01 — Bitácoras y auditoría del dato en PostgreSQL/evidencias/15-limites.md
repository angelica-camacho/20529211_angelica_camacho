# LAB-01 — Bitácoras y auditoría del dato en PostgreSQL
_Gestión de seguridad y desempeño de bases de datos_

**Camacho Castañeda Angélica María 4-1** 

### Actividad 15 — Límites: lecturas y volumen

**Si clientes tuviera un millón de registros, ¿qué ocurriría con la auditoría tras un UPDATE sin WHERE?**
La bitácora registraría una sola línea, porque es una sola sentencia, pero el disparador es FOR EACH ROW y se ejecutaría un millón de veces. Eso escribiría un millón de filas en auditoria.cambios_clientes, cada una con la fila completa antes y después en JSONB, así que la tabla de auditoría crecería más que la original. El UPDATE tardaría mucho más, la transacción se mantendría abierta por más tiempo y se generaría tanta escritura en disco que incluso podría llenarse. Además, si algo fallara a la mitad, se cancelaría todo el cambio.

**Propón quién podría autorizar la depuración de auditoria.cambios_clientes.**
Yo propongo que la autorice el responsable de los datos de clientes, con la aprobación del área de seguridad o auditoría y del área legal o de cumplimiento, que son quienes definen el plazo de retención. El DBA solo ejecutaría la depuración, con una solicitud de cambio documentada y, de preferencia, con una segunda persona que la verifique. Así respeto la separación de funciones, porque quien opera la base de datos no decide qué evidencia se borra.

**¿Por qué log_statement = 'all' puede convertir la bitácora en un nuevo depósito de datos sensibles?**
Porque con 'all' se guarda el texto completo de cada sentencia, con los valores que lleva escritos, como un WHERE rfc = 'GAMA780912XYZ', un INSERT con nombre y correo, o un CREATE ROLE ... PASSWORD '...' con la contraseña en claro. Esos datos quedan copiados en archivos de texto que no tienen los controles de acceso de las tablas, y los puede leer cualquiera que tenga acceso a la carpeta log. Además, esas copias se replican en los respaldos y en los sistemas a los que se envía la bitácora, y duran lo que dure su retención. Por eso, si activo 'all', tengo que tratar la bitácora con la misma clasificación y protección que clientes.