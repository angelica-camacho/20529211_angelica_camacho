-- Camacho Castañeda Angélica María 4-1
-- Gestión de seguridad y desempeño de bases de datos
-- LAB-03 — Políticas prácticas, gobierno de datos y evidencias

| ID | Conjunto de datos | Motor | Ubicación | Propietario | Custodio | Clasificación | Contiene datos personales | Finalidad | Conservación | Diccionario |
|---|---|---|---|---|---|---|---|---|---|---|
| CAT-01 | Clientes | PostgreSQL 16 | <servidor-pg> / comercial / public.clientes | Gerencia Comercial | DBA | Confidencial | Sí | Gestión comercial, atención al cliente y facturación | Mientras la cuenta esté activa + 1 año tras el cierre; RFC: 5 años (obligación fiscal) | diccionario-clientes.csv |
| CAT-02 | Auditoría de clientes | PostgreSQL 16 | <servidor-pg> / comercial / auditoria.cambios_clientes | Dirección / responsable de gobierno de datos | DBA | Confidencial | Sí (guarda valores anteriores y nuevos, como el RFC) | Evidencia de quién cambió qué y cuándo en clientes | 5 años, alineado con el plazo del RFC | COMMENT de tabla en el motor |
| CAT-03 | Registro de cambios | PostgreSQL 16 | <servidor-pg> / comercial / gobierno.solicitudes_cambio | Comité de cambios | DBA | Interno | Posible (puede referenciar registros de clientes) | Registro de solicitudes de cambio; evidencia de POL-06 | 5 años, como evidencia de autorización | COMMENT de tabla en el motor |
| CAT-04 | Clientes (tienda) | MongoDB 7 | <servidor-mongo> / comercial / clientes | Gerencia Comercial | DBA | Confidencial | Sí | Gestión de clientes de la tienda y su atención | Mientras la cuenta esté activa + 1 año tras el cierre | Pendiente |
| CAT-05 | Perfilado | MongoDB 7 | <servidor-mongo> / comercial / `system.profile | Dirección / responsable de seguridad | DBA | Confidencial | Posible (las consultas registradas pueden incluir correo o RFC) | Diagnóstico de rendimiento y consultas lentas | Corto (por ejemplo 30 días) y con rotación | Pendiente |

**1. ¿Por qué CAT-02 y CAT-05 contienen datos personales aunque su propósito sea la auditoría?**

Porque registran copias del dato original, auditoria.cambios_clientes guarda el valor anterior y el nuevo de cada cambio (por ejemplo, el RFC o el correo de un cliente), y system.profile guarda las consultas ejecutadas, que pueden incluir filtros con correos o RFC. Que el propósito sea vigilar o diagnosticar no cambia el contenido, ya que si el dato permite identificar a una persona, sigue siendo dato personal. 

**2. ¿Qué pasa si CAT-01 y CAT-04 tienen propietarios distintos y el RFC de un cliente difiere entre ambos motores?**

No hay una fuente única de lo que es cierto, ya que nadie tiene la autoridad para decidir cuál de los dos valores es el correcto, y cada propietario podría corregir el suyo y dejar el otro igual, o incluso sobrescribirse mutuamente. Mientras tanto, facturación podría emitir un comprobante con un RFC equivocado, con consecuencias fiscales. El DBA tampoco debe elegir por su cuenta, porque es custodio y no dueño del dato. 

**3. ¿Qué información del catálogo cambia con más frecuencia y quién debe actualizarla?**

Lo que cambia más seguido es la información operativa, como el número de filas y el tamaño de cada conjunto de datos, la ubicación o el servidor si hay migraciones, y el estado del diccionario (por ejemplo, cuando se agrega una columna o se completa un COMMENT). Los datos técnicos los actualiza el DBA, como custodio, ya que puede obtenerlos del propio motor, el propietario actualiza los datos de negocio (finalidad, clasificación, conservación y responsables) y aprueba cualquier cambio en ellos. 