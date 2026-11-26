## POL-02 — Respaldo

**Objetivo:** Evitar perder datos de clientes por una falla, un error humano o si se recrea el servidor.

**Alcance:** La base comercial en PostgreSQL y en MongoDB, en producción. Las bitácoras no van en el respaldo, se guardan.

**Regla:** Se respalda comercial en los dos motores todos los días y el respaldo se guarda fuera del servidor de origen. Cada trimestre, una persona distinta al DBA que hace el respaldo comprueba que se puede restaurar, en un ambiente distinto a producción. Cada respaldo se guarda 30 días y después se elimina.

**Responsable:** Decide: Dirección / responsable de gobierno de datos. Ejecuta: DBA. Verifica: responsable de seguridad.

**Excepciones:** Se puede omitir un respaldo por mantenimiento si lo aprueba el Comité de cambios y se anota la omisión.

**Evidencia:** Hoy no existe en LAB-01 a LAB-03 un registro de respaldos ni de pruebas de restauración. Hay que crear uno con fecha, alcance, responsable y resultado de la verificación.

**Revisión:**Cada año. El procedimiento técnico se definirá en la Unidad V.