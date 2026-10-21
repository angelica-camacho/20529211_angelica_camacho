# LABORATORIO 3: PRIVACIDAD Y CUMPLIMIENTO
#### DBA
#### Camacho Castañeda Angélica María 4-1

# Actividad 1 — Inventario y finalidad de los datos
| Campo | ¿Es dato personal? | Finalidad | ¿Es necesario? | Nivel de acceso | Retención | 
| ----- | ----- | ----- | ----- | ----- | ----- | 
| **id** | No, ya que es un dato que puede ser asignado aleatoriamente en la base de datos | Identificar al usuario en la base de datos | Sí, ya que se necesita poder tener una organización sobre los registros de los clientes  | Sistema / Desarrolladores | Permanente (durante la vida del sistema) | 
| **nombre** | Sí, permite identificar a una persona física y distinguirla del resto de las personas de manera inmediata. | Identificar al usuario en el sistema, personalizar atención a clientes. | Sí, ya que permite verificar la identidad en solicitudes de soporte y prevenir la creación de cuentas falsas o suplantación de identidad. | Soporte técnico / Ventas / Administración | Mientras la cuenta esté activa + tiempo legal posterior dado por marcos normativos | 
| **correo** | Sí, también funciona como un identificador a una persona, ya que cada correo es único y solo puede pertenecer a una persona. | Tener una vía de contacto con el cliente, darle seguimiento a sus casos de soporte | Sí, para poder comunicarse con el cliente y tener una atención directa. | Soporte | Mientras la cuenta esté activa | 
| **telefono** | Sí, ya que actualmente cada número de teléfono está vinculado a una CURP que ese si es un identificador directo hacia una persona | Estar en contacto directo para soporte | Opcional, se pueden tener otras vías de contacto con el cliente como el correo | Soporte / Logística | Mientras el servicio esté activo | 
| **rfc** | Sí, ya que es un dato fiscal y está compuesto de iniciales de una persona y de su fecha de nacimiento| Emisión de facturas fiscales y cumplimiento de obligaciones tributarias | Opcional, solo como para casos donde el cliente requiere una factura | Administración / Contabilidad | Según el plazo fiscal legal (ej. 5 años) | 
| **edad** | Sí, por que es un atributo de una persona más no es identificable| Verificar la mayoría de edad (si aplica) o fines estadísticos del perfil de usuario | Opcional, depende que función tenga en el sistema, pero no es estrictamente necesario. | Analítica | Hasta la baja de la cuenta | 
| **ciudad** | Sí, ya que es la ubicación donde reside el cliente, pero al igual que la edad no es identificable. | Análisis demográfico de la base de clientes y personalización de servicios | Opcional, depende si la comercializadora ofrece diferentes servicios por regiones/ciudades | Analítica / Ventas | Hasta la baja de la cuenta | 
| **codigo_postal** | Sí, ya que es un aproximado de la ubicación, y en conjunto con la ciudad, se puede volver mucho más precisa la ubicación del cliente | Estimar costos de envío, validación de dirección de facturación o cobertura del servicio. | Opcional, sí la comercializadora realiza cuestiones de logística. | Logística / Facturación | Hasta la baja de la cuenta o hasta que no sea necesario en algún pedido | 
| **fecha_alta** | No, ya que es solo la fecha en la que su registro entró a la base de datos. | Registrar el momento exacto en que el usuario se dio de alta en la plataforma | Sí, solo para cuestiones de analítica y usos del sistema | Sistema / Auditorías | Permanente | 

# Actividad 2 — Principio de minimización
**¿Todos los campos son necesarios para atención al cliente?**

No, no todos los campos son necesarios para la atención al cliente, ya que solo se necesitaría el nombre, correo, teléfono y tal vez el ID si la comercializadora lleva un registro de los clientes que acuden a soporte donde incluyen su identificador, mientras que los demás datos resultan innecesarios e irrelevantes para la gestión de un ticket.

**¿Por qué soporte necesitaría conocer el RFC?**

Soporte solo necesitaría conocer el RFC si el cliente requiere realizar facturas o trámites fiscales relacionados con su compra, pues fuera de ese contexto resulta un dato prescindible.

**¿Necesita conocer la edad?**

No, la empresa no necesita conocer la edad porque no es un dato relevante para la atención ni para la resolución de un caso de soporte técnico.

**¿Necesita conocer el código postal?**

La necesidad de conocer el código postal depende exclusivamente de si se requiere para cuestiones de envíos físicos, garantías o logística local, ya que de lo contrario resulta innecesario.

**¿Qué principio de privacidad está relacionado con esta decisión?**

Esta decisión está directamente relacionada con el Principio de Minimización de Datos, el cual establece que los datos personales recopilados deben ser adecuados, pertinentes y limitados estrictamente a lo necesario para cumplir con la finalidad del servicio, evitando almacenar información excesiva o injustificada.

# Actividad 3 — Separación por finalidad 
**¿Por qué esta información puede ser más apropiada para analítica que entregar directamente la tabla completa de clientes?**

Es más apropiado por que no tendrán los datos originales que se encuentran en la tabla clientes, entonces no podrá ver la información de cada persona individualmente, e igual esta información es más útil para calcular estadísticas. 

# Actividad 4 — Control de acceso relacionado con la finalidad
**Preguntas**

**¿Qué información puede consultar el rol?**

La información a la que puede consultar el analista es ciudad y rangos de edad mediante la vista.
**¿Puede consultar directamente clientes?**

No. El rol no tiene permisos directos sobre la tabla base clientes; sus privilegios de lectura (SELECT) están restringidos exclusivamente a la vista analítica.

**¿Puede obtener nombre, correo y RFC?**

No. La estructura de la vista no incluye columnas con datos personales identificables (como nombre, correo o RFC), por lo que es imposible acceder a esa información confidencial desde este rol.

**¿Qué principio de privacidad estás aplicando?**

El principio de minimización de datos y la generalización/agregación, ya que se limita la exposición de información personal transformando los datos exactos (edades) en rangos genéricos y omitiendo por completo los datos sensibles del usuario.

**¿Qué principio de seguridad estás aplicando?**

El principio de mínimo privilegio (Least Privilege), dado que al rol analista se le otorgan únicamente los permisos estrictamente necesarios (SELECT en la vista específica y USAGE en el esquema) para cumplir con su función de análisis, bloqueando cualquier acceso innecesario a los datos crudos o tablas principales.
