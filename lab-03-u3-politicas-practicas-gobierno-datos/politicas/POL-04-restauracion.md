## POL-04 — Restauración

**Objetivo:** Evitar que una restauración sobrescriba datos vigentes o borre evidencia.

**Alcance:** Restauraciones de comercial en PostgreSQL y MongoDB, en producción.

**Regla:** Para restaurar sobre producción se necesita una solicitud aprobada por el propietario del dato y por el Comité de cambios. Primero se prueba la restauración en un ambiente distinto a producción. Después se vuelven a aplicar los borrados de POL-03 y se revisa auditoria.cambios_clientes, porque la restauración puede borrar lo registrado después del respaldo.

**Responsable:** Decide: propietario del dato y Comité de cambios. Ejecuta: DBA. Verifica: responsable de seguridad.

**Excepciones:** Restauración urgente si se pierde todo el servicio, autorizada por Dirección. La solicitud se registra dentro de las 24 horas siguientes.

**Evidencia:** Solicitud en gobierno.solicitudes_cambio (LAB-03) + sentencias en la bitácora (dba.bitacora) + auditoria.cambios_clientes (LAB-01, Parte B). Hoy no existe un registro de restauraciones hechas.

**Revisión:** Cada año y después de cada restauración en producción.

**Nota:** El procedimiento técnico se definirá en la Unidad V.