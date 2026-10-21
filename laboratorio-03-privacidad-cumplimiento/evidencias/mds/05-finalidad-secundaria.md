# LABORATORIO 3: PRIVACIDAD Y CUMPLIMIENTO
#### DBA
#### Camacho Castañeda Angélica María 4-1

# Actividad 5 — Analizar una finalidad secundaria
La empresa propone utilizar los datos de clientes para una nueva finalidad:

“Enviar promociones personalizadas basadas en la edad, ciudad y comportamiento de compra.”

**1. ¿El hecho de que la organización ya tenga los datos significa automáticamente que puede utilizarlos para cualquier finalidad?** 
 No, ya que se necesita el consentimiento del usuario para que se utilicen estos datos y también se necesita el consentimiento para que se le envíen estas promociones ya que para algunos puede resultar molesto.

**2. ¿Qué preguntas debería realizar la organización antes de implementar este tratamiento?**
 Pedirle consentimiento al usuario, si quiere proporcionar sus datos para que se creen promociones y si quiere recibirlos.

**3. ¿Qué datos serían realmente necesarios?**
 Solamente el comportamiento de compra y edad, ya que de esta forma se pueden crear promociones más adecuadas para cada rango de edad.

**4. ¿Necesitaría el área de marketing acceso directo a clientes?**
No, necesitaría acceso solamente a edad, correo y pues el comportamiento de compra, lo cual se podría crear con otra vista que solo contenga esa información

**5. ¿Qué controles técnicos podrían limitar la información entregada?**
Una vista y un rol, igual que en el caso del analista.

# Actividad 6 — Derechos ARCO y la base de datos

**¿Qué información adicional debería proporcionar la organización además del resultado de esta consulta?**
La consulta que permite localizar su información un SELECT que extraiga los campos de la tabla filtrando por un identificador único del usuario, por ejemplo:
SELECT id, nombre, correo, telefono, rfc, edad, ciudad, codigo_postal, fecha_alta FROM clientes WHERE rfc = 'ACRF0602'; (o utilizando su ID del sistema, o RFC como condición en la cláusula WHERE).

# Actividad 7 — Derecho de rectificación
**¿Cómo podría comprobarse que el cambio fue autorizado?**
Pues para verificar que el cambio se realizó con un simple select, pero va más allá de solo mostrarlo, si no que también se debe de marcar como completada la solicitud del cliente si es que se abrió un ticket a soporte pidiendo la correción.

**¿Debería registrarse quién realizó el cambio?**
Sí, es muy importante registrarlo ya que si por alguna razón, falla, pone un dato erróneo o cualquier cosa, debe haber un responsable.

**¿Por qué la trazabilidad será importante?**
Por que es muy importante tener registro de quién hizo que cambio, cuándo lo hizo, por qué lo hizo, ya que si ocurre un error es de vital importancia saber por qué fallo y encontrar a un responsable para que se haga cargo del error.
