# LABORATORIO 3: PRIVACIDAD Y CUMPLIMIENTO
#### DBA
#### Camacho Castañeda Angélica María 4-1

# Actividad 15 — Arquitectura de privacidad y cumplimiento
## Propuesta: separación de la información por finalidad

```
                  BASE DE DATOS
                       |
        ┌──────────────┼──────────────┐
        ▼              ▼              ▼
    Operación       Analítica      Auditoría
        |              |              |
        ▼              ▼              ▼
  Datos necesarios  Datos agregados  Bitácoras de
  para operación    y anonimizados   acceso y cambios
```
| Control | Decisión técnica |
| :--- | :--- |
| **Acceso** | Roles (RBAC): cada área solo ve su zona. Analítica usa vistas, no la tabla clientes. |
| **Minimización** | Cada zona guarda solo lo necesario. Analítica usa rangos de edad y región, sin identificadores. |
| **Protección de información sensible** | Cifrado, enmascaramiento de RFC, correo y teléfono, y seudonimización. |
| **Retención** | Política documentada con plazos por tipo de dato. |
| **Trazabilidad** | Bitácoras de consultas, exportaciones y cambios, con usuario y fecha. |
| **Eliminación** | Borrado seguro al vencer el plazo o a petición del titular, incluyendo respaldos. |
| **Atención de solicitudes** | Procedimiento ARCO con responsable, plazo y verificación de identidad. |
