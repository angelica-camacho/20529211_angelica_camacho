## POL-06 — Cambios en producción

**Objetivo:** Evitar cambios no autorizados o que no se puedan revertir en producción.

**Alcance:** Cambios de datos, estructura, privilegios y configuración (por ejemplo, parámetros del motor como log_statement) en el ambiente de producción. Según la Unidad I, un ambiente es un conjunto independiente de infraestructura, configuración y datos sobre el cual se ejecuta un sistema, para un propósito específico dentro del ciclo de vida del software. Producción es el ambiente donde el sistema trabaja con los datos reales de los clientes. En este laboratorio, es la base comercial en su servidor, con su configuración.

**Regla:** Antes: todo cambio se registra en gobierno.solicitudes_cambio con su descripción y su plan de reversión, y lo aprueba el Comité de cambios. Durante: el DBA ejecuta solo lo aprobado. Después: el DBA anota el resultado y revisa en la bitácora que las sentencias ejecutadas son las mismas que se aprobaron. Los cambios de configuración siguen el mismo proceso que los cambios de datos.

**Responsable:** Decide: Comité de cambios, con el propietario del dato afectado. Ejecuta: DBA. Verifica: responsable de seguridad.

**Excepciones:** Cambio de emergencia para recuperar el servicio, autorizado por Dirección. La solicitud se registra dentro de las 24 horas siguientes y el Comité la ratifica.

**Evidencia:** gobierno.solicitudes_cambio (LAB-03; hoy sin solicitudes registradas) + dba.bitacora (LAB-01, Actividad 6) + auditoria.cambios_clientes (LAB-01, Parte B). Hoy no existe un registro de los cambios de configuración que no pasan por sentencias SQL (por ejemplo, ediciones al archivo de configuración).

**Revisión:** Cada año y después de cada cambio de emergencia.