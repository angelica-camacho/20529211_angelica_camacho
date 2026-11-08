# LAB-01 — Bitácoras y auditoría del dato en PostgreSQL
_Gestión de seguridad y desempeño de bases de datos_

**Camacho Castañeda Angélica María 4-1** 


### Actividad 7 — Modificaciones de datos: ddl frente a mod

**¿Qué nivel habría registrado la lectura del RFC? ¿Qué costo tendría en un servidor con miles de consultas por minuto?**
Solo log_statement = 'all'. El nivel 'mod' registra INSERT, UPDATE y DELETE, pero no los SELECT, y 'ddl' solo registra cambios de estructura y privilegios. Con 'all' quedaría registrada cada sentencia de cada sesión, incluidas las lecturas.
En un servidor con miles de consultas por minuto el costo sería alto. La bitácora crecería muy rápido, habría más escritura en disco y el rendimiento podría verse afectado. También sería difícil encontrar un evento importante entre tanto ruido, y quedarían expuestos más datos sensibles, porque las sentencias se guardan con sus valores. Una opción más razonable sería auditar solo lo sensible, por ejemplo con pgaudit sobre la tabla clientes.

**¿Qué le falta a esta bitácora para revertir el cambio con certeza? (Lo resolverás en la Parte B.)**
Le falta el valor anterior. La bitácora guarda el texto del UPDATE con el valor nuevo, pero no dice qué había antes en el campo. Tampoco confirma cuántas filas se modificaron ni si la transacción se confirmó. Sé qué se escribió, pero no a qué valor regresar. Para poder revertir necesitaría un trigger de auditoría sobre clientes que guarde el valor anterior (OLD) y el nuevo (NEW), junto con el usuario, la fecha y el cliente.