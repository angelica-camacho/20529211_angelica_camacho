# LAB-01 — Bitácoras y auditoría del dato en PostgreSQL
_Gestión de seguridad y desempeño de bases de datos_

**Camacho Castañeda Angélica María 4-1** 

### Actividad 13 — Altas y bajas

**El cliente Pedro Ruiz ya no existe en clientes. ¿Dónde queda evidencia de que existió y de sus datos?**
En auditoria.cambios_clientes. El evento 2 (INSERT) guardó en valores_despues la fila completa, y el evento 3 (DELETE) guardó en valores_antes la fila completa tal como estaba al borrarse, con nombre, correo, RFC, edad, ciudad y código postal. Por eso todavía puedo ver el RFC RUPE950101AAA y restaurar al cliente si hiciera falta. Con log_statement = 'mod', la bitácora también conserva el texto del INSERT y del DELETE con sus valores.

**¿Por qué ip_cliente está vacía en los eventos 2 y 3?**
Porque esos cambios los ejecuté como postgres desde psql con una conexión local por socket, y esas conexiones no tienen dirección IP. inet_client_addr() devuelve NULL y el campo queda vacío. Los eventos de app_ventas sí traen 127.0.0.1 porque se conectaron por TCP. Si psql se hubiera conectado por TCP a localhost, habría salido 127.0.0.1 o ::1.

**La política de retención de la Unidad II pedía eliminar datos cuando ya no fueran necesarios. ¿Qué conflicto aparece? ¿Quién debe resolverlo?**
El conflicto es que borrar a alguien de clientes no borra sus datos, porque la tabla de auditoría conserva una copia completa de su fila, incluido el RFC. La política pide eliminar, pero la auditoría necesita conservar la evidencia sin alterarla. Si se borra la auditoría, se pierde trazabilidad, y si se conservo para siempre, se incumple la política de eliminación y se acumularían datos personales innecesarios.
No es solo problema del DBA, lo resuelve el responsable de los datos, junto con seguridad y el área legal o de cumplimiento, que definen cuánto tiempo se conserva la auditoría y qué se hace al vencer ese plazo (borrarla o anonimizar los datos personales). El DBA implementa esa decisión.
