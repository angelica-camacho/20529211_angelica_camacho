## POL-05 — Uso de datos sensibles

**Objetivo:** Evitar que se expongan datos personales o secretos que aparecen en las bitácoras.

**Alcance:** rfc, correo, telefono, nombre y edad de clientes en los dos motores, auditoria.cambios_clientes, system.profile y las bitácoras que guardan sentencias completas.

**Regla:** El RFC solo lo ven Facturación y el DBA (como custodio). Soporte usa la vista enmascarada (Unidad II). Cada acceso a datos sensibles debe tener una justificación ligada a la finalidad de la matriz, y toda modificación queda registrada con log_statement = 'mod' y en auditoria.cambios_clientes. Las bitácoras solo las leen Seguridad y Auditoría, y el DBA solo las lee para diagnóstico.

**Responsable:** Decide: propietario del dato. Ejecuta: DBA. Supervisa: responsable de seguridad.

**Excepciones:** Acceso a datos sin enmascarar para atender un incidente, autorizado por el responsable de seguridad y solo para ese caso.

**Evidencia:** auditoria.cambios_clientes (LAB-01, Parte B) + dba.bitacora (LAB-03) + matriz de gobierno (LAB-03). Hoy no existe un registro de lecturas (SELECT), porque log_statement = 'mod' no las guarda.

**Revisión:** Cada 6 meses y después de cualquier incidente.
