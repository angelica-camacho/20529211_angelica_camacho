# LABORATORIO 3: PRIVACIDAD Y CUMPLIMIENTO
#### DBA
#### Camacho Castañeda Angélica María 4-1

# Actividad 11 — Diseñar una matriz de gobierno de datos

| Dato | Finalidad | Responsable | Usuarios autorizados | Protección | Retención | Acción al finalizar |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **nombre** | Identificación del titular para atención de solicitudes y gestión de tickets de soporte | Atención al cliente | Atención al cliente, DBA, Dirección (acceso consolidado) | Cifrado en reposo/tránsito, control de acceso basado en roles (RBAC) | Mientras la cuenta permanezca activa + 1 año tras el cierre | Anonimización o borrado seguro de la base de datos |
| **correo** | Vía de contacto con el cliente, notificaciones de servicio | Atención al cliente | Atención al cliente, DBA | Cifrado TLS/SSL en tránsito, enmascaramiento en vistas públicas | Durante la atención del ticket o mientras la cuenta esté activa | Borrado seguro de listas de contacto |
| **telefono** | Contacto de urgencia o verificación de seguridad | Atención al cliente | Atención al cliente, DBA | Cifrado en reposo y restricción de visibilidad por perfil de usuario | Mientras la cuenta esté activa o durante la resolución del caso | Borrado definitivo |
| **rfc** | Emisión de facturas y cumplimiento de obligaciones tributarias | Facturación | Facturación, DBA | Cifrado fuerte en reposo y restricción estricta de acceso por rol | 5 años (por mandato y regulaciones fiscales) | Depuración y borrado seguro una vez cumplido el plazo legal |
| **edad** | Analítica, estudios demográficos y segmentación estadística de mercado | Analítica / Negocio | Analítica, DBA | Seudonimización, agregación de datos o almacenamiento en rangos (ej. 20-30) | Durante la vigencia de los estudios analíticos o según la política de analítica de la empresa | Anonimización completa o agregación estadística final |
| **ciudad** | Asignación de zona de servicio local, envíos o logística | Atención al cliente | Atención al cliente, Analítica, DBA | Control de acceso restringido a la tabla operativa | Hasta la conclusión del servicio o vencimiento de garantía | Desvinculación del id del cliente / Anonimización |
| **codigo_postal** | Determinación de cobertura de servicio y cálculo de fletes | Atención al cliente | Atención al cliente, Analítica (solo algunos), DBA | Almacenamiento seudonimizado para procesamiento analítico | Solo mientras se necesite para cuestiones estadísticas | Agregación estadística anonimizada para estudio demográfico |