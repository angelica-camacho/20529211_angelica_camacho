## LAB-02 — Trazabilidad en MongoDB Community
_Gestión de seguridad y desempeño de bases de datos_

**Camacho Castañeda Angélica María 4-1**

**¿Quién cambió el RFC de María García en la Actividad 2 y en la 3?** En la Actividad 2 lo cambié con el usuario app_ventas a GAMA780912XXX, pero no lo puedo demostrar con evidencia del servidor, porque el perfilador estaba apagado (was: 0), system.profile tenía 0 documentos y la bitácora solo registra que app_ventas se conectó, no lo que modificó. En la Actividad 3 también fue app_ventas, y aquí sí quedó demostrado por que system.profile registró un update con user: 'app_ventas@comercial', el filtro { _id: 3 } y el nuevo valor GAMA780912XYZ.

**¿Cuándo y desde qué aplicación?**
 En la Actividad 2 fue alrededor de las 13:29, hora local, pero eso lo sé por que tomé una captura y no de un registro del cambio. La aplicación que declaré en la cadena de conexión fue app-ventas-web, aunque eso lo escribí yo y ningún registro lo une con el cambio. En la Actividad 3 el update quedó a las 2026-11-08 21:05:54.231Z (14:05:54 hora local), desde 127.0.0.1 y con appName: 'app-ventas-web'. De esto si hay prueba en la bitácora.

**¿Qué valor tenía antes?** Antes de la Actividad 2 el RFC era GAMA780912GHI, el valor con el que inserté a María García al inicio, y eso lo sé por los datos iniciales y no porque el servidor lo registre. Antes de la Actividad 3 era GAMA780912XXX. system.profile solo guarda el valor nuevo ($set) y el filtro, así que en ninguno de los dos casos se puede recuperar el valor anterior.

**¿Cambió alguien los privilegios de app_ventas** 

Sí, yo, con el usuario admin, en la Actividad 7 ya que le otorgué el rol dbAdmin sobre comercial con grantRolesToUser. Lo puedo probar con las dos instantáneas, porque en la primera app_ventas tenía solo readWrite y en la segunda tenía readWrite y dbAdmin. Lo que no puedo demostrar es quién lo hizo ni cuándo exactamente, porque el perfilador (incluso en nivel 2) y la bitácora dieron 0 coincidencias para grantRoles. 