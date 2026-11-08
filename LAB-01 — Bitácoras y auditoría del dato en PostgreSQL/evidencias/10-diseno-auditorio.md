# LAB-01 — Bitácoras y auditoría del dato en PostgreSQL
_Gestión de seguridad y desempeño de bases de datos_

**Camacho Castañeda Angélica María 4-1** 
| Campo propuesto | Tipo | ¿Qué pregunta responde? | ¿Puede ser nulo? ¿Por qué? |
| --- | --- | --- | --- |
| id_evento | BIGSERIAL | ¿Cuál es el identificador único de cada evento y en qué orden ocurrieron? | No. Es la llave primaria y se genera automáticamente. |
| momento | TIMESTAMPTZ | ¿Cuándo ocurrió el cambio? | No. Todo evento tiene fecha y hora, y se llena solo con now(). |
| usuario_sesion | TEXT | ¿Quién inició la sesión?  | No. Toda sesión tiene un usuario que se autenticó. |
| usuario_efectivo | TEXT | ¿Con qué rol se ejecutó el cambio?  | No. Siempre hay un rol activo, aunque puede diferir del de sesión si hubo SET ROLE o una función SECURITY DEFINER. |
| aplicacion | TEXT | ¿Desde qué aplicación se hizo el cambio? | Sí. Lo declara el cliente y puede no enviarlo, por lo que llega vacío. |
| ip_cliente | INET | ¿Desde qué dirección se conectó el cliente? | Sí. En conexiones locales por socket no hay dirección IP y el valor es NULL. |
| operacion | TEXT | ¿Qué se hizo: INSERT, UPDATE o DELETE?  | No. Todo evento corresponde a una operación. |
| id_cliente | BIGINT | ¿Qué fila de clientes fue afectada? | No. Siempre se afecta una fila: el id sale de NEW en INSERT y UPDATE, y de OLD en DELETE. |
| valores_antes | JSONB | ¿Qué contenía la fila antes del cambio? | Sí. En un INSERT no existía fila anterior. |
| valores_despues | JSONB | ¿Cómo quedó la fila después del cambio? | Sí. En un DELETE ya no existe fila resultante. |

### Actividad 10 — Diseñar y crear el registro de auditoría

**¿Por qué momento usa TIMESTAMPTZ y no TIMESTAMP?**
Porque TIMESTAMPTZ guarda el instante exacto, con la zona horaria incluida, y TIMESTAMP solo guarda fecha y hora sin zona. Si uso TIMESTAMP, un evento registrado a las 22:00 no me dice si fueron las 22:00 de Chihuahua o de UTC, y al reconstruir una cronología puedo ordenar mal los eventos o atribuir una acción a la persona equivocada. Con TIMESTAMPTZ puedo cruzar la tabla con la bitácora (que está en America/Chihuahua) y con otras fuentes sin ambigüedad.

**¿Por qué se guarda el registro completo en JSONB y no solo la columna que cambió?**
Porque con la fila completa antes y después puedo revertir el cambio con certeza y ver el contexto de lo que pasó. Si solo guardara la columna que cambió, no sabría qué otros campos tenía la fila, y en un DELETE no podría recuperarla. Además, JSONB no depende de la estructura de clientes: si mañana le agrego una columna (como segmento), la auditoría la guarda sin cambiar la tabla de auditoría.

**La tabla de auditoría también contendrá RFC. ¿Qué implica eso para su clasificación y su control de acceso?**
Implica que la tabla de auditoría debe tener la misma clasificación que clientes, es decir, que es sensible, porque el RFC es un dato personal y copiarlo a otra tabla no le quita esa importancia. Además, como guarda el valor anterior y el nuevo, contiene más RFC que la tabla original. En cuanto al acceso, solo un rol de auditoría debería poder leerla, con permiso únicamente de SELECT, y nadie con UPDATE ni DELETE, para que la evidencia no se pueda alterar, también roles como app_ventas o soporte_ana no deben tener acceso.
