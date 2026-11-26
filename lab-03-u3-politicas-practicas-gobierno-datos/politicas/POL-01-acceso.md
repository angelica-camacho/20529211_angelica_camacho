### POL-01 — Acceso

**Objetivo:** Evitar que alguien tenga acceso a los datos sin autorización o que siga teniéndolo cuando ya no lo necesita.

**Alcance:** Roles y privilegios de PostgreSQL (comercial: public, auditoria, gobierno) y de MongoDB (comercial), en producción.

**Regla:** El jefe del área del usuario pide el acceso y el propietario del dato lo aprueba, según la matriz de gobierno. El DBA solo hace el GRANT o REVOKE si hay solicitud aprobada, y cada mes compara la bitácora de GRANT y REVOKE con las solicitudes aprobadas. Cada trimestre el propietario revisa quién tiene acceso a sus datos y el DBA quita lo que no se confirme.

**Responsable:** Decide: propietario del dato. Ejecuta: DBA. Verifica: responsable de seguridad.
Excepciones:   Acceso de emergencia por máximo 24 horas, autorizado por el responsable de seguridad. Se registra la solicitud y el acceso se revoca al vencer.

**Evidencia:** Líneas "statement: GRANT/REVOKE" de la bitácora (LAB-01, Actividad 6, con dba.bitacora`) + solicitudes aprobadas en gobierno.solicitudes_cambio + matriz de la Actividad 2. El acta de la revisión trimestral hoy no existe.

**Revisión:** Cada año y después de cualquier incidente de acceso.