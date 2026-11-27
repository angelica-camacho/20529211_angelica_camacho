-- Camacho Castañeda Angélica María 4-1
-- Gestión de seguridad y desempeño de bases de datos
-- LAB-03 — Políticas prácticas, gobierno de datos y evidencias

| # | Hallazgo | Registros | Regla de calidad | ¿Quién decide la corrección? | Acción propuesta |
|---|----------|-----------|------------------|------------------------------|------------------|
| C1 | Posible cliente duplicado | 1, 7 | Unicidad del correo | Dueño del dato (responsable de clientes / ventas) | Confirmar si es la misma persona; si lo es, fusionar los registros y conservar el más completo y reciente |
| C2 | RFC incompleto | 7 | Formato del RFC | Dueño del dato, con validación del cliente | Contactar al cliente para obtener el RFC completo (13 caracteres, el actual tiene 12) y corregirlo |
| C3 | RFC faltante (nulo) | 8 | Completitud del RFC | Dueño del dato (responsable de clientes / ventas) | Solicitar el RFC al cliente y capturarlo; evaluar si el campo debe ser obligatorio |
| C4 | Edad fuera de rango (-3) | 8 | Rango válido de edad (18 a 120) | Dueño del dato | Verificar la fecha de nacimiento real y corregir la edad; agregar un `CHECK (edad BETWEEN 18 AND 120)` para evitar que se repita |

**¿Por qué el DBA no debe corregir por su cuenta el RFC del registro 7?**

Porque el DBA es custodio del dato, no su propietario. El RFC LOAA850315AB tiene 12 caracteres entonces no es correcto y el DBA no puede deducirla ya que es un dato fiscal que solo conoce el cliente y si la inventa o la adivina, introduce un dato falso que pasaría la validación de formato pero seguiría siendo incorrecto, y eso es peor que un dato incompleto. Además, el registro 7 es posible duplicado del 1, así que primero hay que decidir cuál es el registro válido. Esa decisión le corresponde al dueño del dato (responsable de clientes), y el DBA solo ejecuta la corrección una vez autorizada y documentada.  

**¿Qué restricción (CHECK, UNIQUE) habría evitado cada hallazgo? ¿Quién debería aprobar agregarla?**

Un índice UNIQUE sobre lower(correo) habría evitado el duplicado de los registros 1 y 7, un CHECK con el patrón del RFC habría bloqueado el RFC incompleto del registro 7, NOT NULL en rfc habría evitado el RFC faltante del registro 8, y CHECK (edad BETWEEN 18 AND 120) habría impedido la edad de -3. Como estas restricciones cambian las reglas del negocio, no las decide solo el DBA, las debe aprobar el dueño del dato, y el DBA las implementa.

**Si el DBA corrige un dato, ¿qué mecanismo del LAB-01 (Parte B) dejará evidencia del cambio?**

La auditoría configurada en el laboratorio 1. Normalmente es el trigger que registra los UPDATE en el esquema de auditoria. Además, con log_statement = mod el servidor registra en su bitácora cada sentencia que modifica datos, y eso es lo que se consulta mediante la vista dba.bitacora. Así, la corrección queda registrada con usuario, fecha y sentencia, y se puede demostrar que se hizo con autorización.