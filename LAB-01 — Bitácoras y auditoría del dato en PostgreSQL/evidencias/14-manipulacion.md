# LAB-01 — Bitácoras y auditoría del dato en PostgreSQL
_Gestión de seguridad y desempeño de bases de datos_

**Camacho Castañeda Angélica María 4-1** 

### Actividad 14 — Intentar manipular la auditoría

**¿Qué evidencia permite detectar que hubo un cambio sin auditar?**
postgres con el mismo PID [260]: DISABLE TRIGGER, UPDATE clientes SET rfc = 'GAMA780912GHI' y ENABLE TRIGGER. En cambio, auditoria.cambios_clientes sigue con 3 eventos y ninguno corresponde a ese UPDATE. Si hay un cambio en la bitácora que no aparece en la tabla de auditoría, algo apagó (yo) el disparador. También deja rastro el intento de app_ventas (línea [253]), que falló por permisos pero quedó registrado.

**¿Qué control administrativo (no técnico) reduciría este riesgo?**
Un procedimiento de control de cambios, en el que desactivar un disparador o tocar la auditoría requiera una solicitud con aprobación de otra persona y quede documentado. Lo complementaría con una revisión periódica en la que alguien ajeno a la administración compare la bitácora con la tabla de auditoría para detectar diferencias como esta.

**Relaciona esta actividad con el principio de separación de funciones de la Unidad II.**
La actividad demuestra que, si la misma persona opera la base de datos y custodia la evidencia, puede cambiar un dato, apagar la auditoría y volverla a encender sin que nadie lo note desde adentro. Como postgres controla la tabla, el disparador y el servidor, ningún mecanismo interno lo detiene. La separación de funciones exige que quien administra la base no sea quien resguarda y revisa la bitácora. Por eso la bitácora se envía a un sistema externo administrado por otra área, de modo que nadie controle a la vez los datos y la evidencia de lo que hizo con ellos.
