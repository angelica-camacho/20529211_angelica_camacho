## LAB-02 — Trazabilidad en MongoDB Community
_Gestión de seguridad y desempeño de bases de datos_

**Camacho Castañeda Angélica María 4-1**

## 9.1 Interpretar los documentos

| # | op | Usuario | Cliente | Aplicación | Momento | Qué hizo | Documentos afectados |
|---|---|---|---|---|---|---|---|
| 1 | query | app_ventas@comercial | 127.0.0.1 | app-ventas-web | 2026-11-08 21:05:54.223Z | Consultó los clientes con ciudad: 'Culiacán', pidiendo solo nombre y ciudad | 5 examinados, 3 devueltos |
| 2 | update | app_ventas@comercial | 127.0.0.1 | app-ventas-web | 2026-11-08 21:05:54.231Z | Cambió el rfc del cliente _id: 3 a GAMA780912XYZ con $set | 1 examinado, 1 modificado |
| 3 | remove | app_ventas@comercial | 127.0.0.1 | app-ventas-web | 2026-11-08 21:05:54.237Z | Borró el cliente _id: 2 (limit: 1) | 1 examinado, 1 eliminado |

**¿Puedes saber el RFC antes del cambio?**

 No ya que el update solo guarda el filtro (_id: 3) y el valor nuevo (GAMA780912XYZ). El valor anterior no se registra.


**¿Puedes saber qué datos tenía el documento eliminado?**

 No por que el remove solo muestra el filtro (que es { _id: 2 }) y que se borró 1 documento (ndeleted: 1). Este no guarda nombre, correo ni RFC.

 **A diferencia de log_statement = 'mod' en PostgreSQL, el nivel 2 sí registró la consulta. ¿Qué ventaja y qué riesgo tiene eso?**

La ventaja es que también registra las lecturas, así que se ve quién consultó qué y cuándo. El riesgo es que guarda filtros y valores en claro (por ejemplo el RFC nuevo), duplicando datos sensibles en system.profile, además del costo en rendimiento y almacenamiento.

**¿Por qué user incluye @comercial?**

 Porque en Mongo un usuario se identifica por nombre y base de datos donde se creó. app_ventas@comercial es el usuario app_ventas definido en comercial, el cual es diferente de cualquier otro app_ventas que exista en otra base.