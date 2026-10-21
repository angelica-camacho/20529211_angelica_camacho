# LABORATORIO 3: PRIVACIDAD Y CUMPLIMIENTO
#### DBA
#### Camacho Castañeda Angélica María 4-1

# INFORME FINAL
### 1. Introducción
En este laboratorio, el principal problema abordado fue la privacidad y finalidad de los datos de los clientes. Se abordó qué datos si son necesarios y por qué siempre se debe tener bien clara cual es la finalidad de almacenarlos, para después analizar cómo es que se protegerán. También se analizó la importancia de las obligaciones de privacidad y por qué es importante que el DBA sepa identificar las implicaciones técnicas.

### 2. Inventario de datos
| Campo | ¿Es un dato personal? | Clasificación 
| :--- | :--- | :--- 
| **id** | No | Identificador interno asignado por la BD | Identificar y organizar los registros de clientes 
| **nombre** | Sí | Identificador directo | Identificar al usuario, personalizar la atención y prevenir suplantación | Sí |
| **correo** | Sí | Identificador directo (único por persona) |
| **telefono** | Sí | Identificador directo (vinculado a una CURP) | Contacto directo para soporte | 
| **rfc** | Sí | Dato fiscal identificable (iniciales y fecha de nacimiento) | Facturación y obligaciones tributarias |
| **edad** | Sí | Atributo no identificable por sí solo | Verificar mayoría de edad o fines estadísticos |
| **ciudad** | Sí | Dato de ubicación, no identificable por sí solo | Análisis demográfico y personalización de servicios | 
| **codigo_postal** | Sí | Ubicación aproximada; junto con la ciudad es más precisa | Costos de envío, validación de dirección, cobertura del servicio |
| **fecha_alta** | No | Dato de registro del sistema | Registrar cuándo se dio de alta el usuario | 

### 3. Finalidades
Los datos personales solo deben utilizarse para la finalidad por la que fueron almacenados. Que la organización ya tenga los datos no significa que pueda usarlos para cualquier otra cosa, ya que cuando se propone una finalidad nueva, como enviar promociones personalizadas según edad, ciudad y comportamiento de compra, se necesita el consentimiento del titular, tanto para usar sus datos con ese fin como para recibir las promociones.
En el inventario de datos de la actividad uno, se asignó una finalidad a cada campo:
* id: identificar y organizar los registros de clientes en la base de datos.
* nombre: identificar al usuario, verificar su identidad en solicitudes de soporte y prevenir suplantación.
* correo y teléfono: contacto directo con el cliente y seguimiento de casos de soporte.
* rfc: emisión de facturas y cumplimiento de obligaciones tributarias.
* edad: verificar mayoría de edad o fines estadísticos.
* ciudad y código postal: análisis demográfico, cobertura del servicio, costos de envío y logística.
* fecha_alta: registrar cuándo se dio de alta el usuario, para analítica y auditorías.

### 4. Minimización
El principio de minimización establece que los datos recopilados deben ser adecuados, pertinentes y limitados a lo estrictamente necesario para cumplir la finalidad del servicio.
Atención al cliente. Para gestionar un ticket solo se necesitan el nombre, el correo, el teléfono y, si la empresa lo usa para llevar el registro, el id. El resto de los campos son innecesarios para esa función:
* RFC: solo se requiere si el cliente solicita una factura o un trámite fiscal.
* Edad: no es relevante para resolver un caso de soporte.
* Código postal: depende de si hay envíos físicos, garantías o logística local, de lo contrario no se necesita.
También eliminaría algunos datos como:
* Dirección: es un dato de ubicación que no se justifica para el negocio.
* Fecha de nacimiento: no se necesita la fecha exacta si se tiene la edad.
* Ocupación y estado civil: no tienen relevancia para la operación ni para la analítica.
* Salario: solo se conservaría si existe una justificación adicional, por ejemplo para estadísticas de ingresos y compras.

Para aplicar privacidad por defecto, la recopilación debe ser mínima, no se debe asumir que el usuario da permiso para finalidades distintas a la principal, y el acceso a datos personales debe limitarse a personal autorizado.

#### 5. Control de acceso
Los permisos relaciones se otorgan de acuerdo a las funciones de cada área, de forma que cada rol solo vea unicamente lo que necesitar para trabajar. 
* Rol analista: no tiene permisos sobre la tabla base clientes. Sus privilegios son solo SELECT sobre la vista analítica y USAGE sobre el esquema. La vista no incluye columnas con datos identificables, por lo que desde ese rol es imposible obtener nombre, correo o RFC.
* Rol de marketing: no necesita acceso directo a clientes. Se le puede crear otra vista que contenga solo edad, correo y comportamiento de compra, con su propio rol, igual que en el caso del analista.
* Soporte, facturación y logística: acceden solo a los campos de su finalidad (por ejemplo, facturación al RFC y soporte a nombre, correo y teléfono).
  
### 6. Derechos ARCO
Cada derecho tiene implicaciones técnicas para el DBA:
* Acceso. Debe poder localizarse toda la información de una persona con una consulta que filtre por un identificador único (id o RFC), como un select que de los datos del titular utilizando la clausula where.
* Rectificación. El cambio puede verificarse con un SELECT, pero también debe cerrarse la solicitud (por ejemplo, el ticket de soporte donde el cliente pidió la corrección). Debe registrarse quién hizo el cambio, cuándo y por qué. Esta trazabilidad es esencial: si ocurre un error, hay que saber qué falló y quién es responsable de corregirlo.
* Cancelación. Eliminar un registro de una tabla no significa que la información haya desaparecido de la organización: pueden quedar copias en respaldos anteriores, réplicas de la base de datos, reportes y archivos. Por eso la eliminación debe contemplar todo el ciclo de vida del dato, incluyendo respaldos. Además, algunos datos (como los fiscales) deben conservarse durante el plazo legal.
* Oposición. Oponerse a un uso no implica borrar todos los datos. Debe seguir conservándose lo necesario para soporte y obligaciones fiscales (id, nombre, correo, teléfono y datos fiscales), y dejar de usarse lo asociado a la finalidad a la que el cliente se opuso (por ejemplo, correo y teléfono en listas de promociones, o edad, código postal y ciudad en análisis). 

#### 7. Retención
El periodo de conservación de los datos no debe fijarse de manera improvisada ni indefinida por que conservar datos innecesarios contradice la minimización y genera riesgos. 
Conservar datos innecesarios contradice la minimización y genera riesgos: problemas legales y, ante un ataque o filtración, un impacto mucho mayor porque se expondría información incluso de personas que ya no tienen relación con la organización.
Para determinar el periodo, la organización debe:
1. Definir qué información se almacena y con qué finalidad.
2. Identificar las leyes y marcos normativos que obligan a conservarla.
3. Documentar la justificación del periodo seleccionado: finalidad, fundamento legal, ciclo de vida del dato, cómo se protegerá mientras se almacene y cómo se eliminará cuando ya no sea necesario.

#### 8. Gobierno de datos
| Dato | Finalidad | Responsable | Usuarios autorizados | Protección | Retención | Acción al finalizar |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **nombre** | Identificación del titular para atención de solicitudes y gestión de tickets de soporte | Atención al cliente | Atención al cliente, DBA, Dirección (acceso consolidado) | Cifrado en reposo/tránsito, control de acceso basado en roles (RBAC) | Mientras la cuenta permanezca activa + 1 año tras el cierre | Anonimización o borrado seguro de la base de datos |
| **correo** | Vía de contacto con el cliente, notificaciones de servicio | Atención al cliente | Atención al cliente, DBA | Cifrado TLS/SSL en tránsito, enmascaramiento en vistas públicas | Durante la atención del ticket o mientras la cuenta esté activa | Borrado seguro de listas de contacto |
| **telefono** | Contacto de urgencia o verificación de seguridad | Atención al cliente | Atención al cliente, DBA | Cifrado en reposo y restricción de visibilidad por perfil de usuario | Mientras la cuenta esté activa o durante la resolución del caso | Borrado definitivo |
| **rfc** | Emisión de facturas y cumplimiento de obligaciones tributarias | Facturación | Facturación, DBA | Cifrado fuerte en reposo y restricción estricta de acceso por rol | 5 años (por mandato y regulaciones fiscales) | Depuración y borrado seguro una vez cumplido el plazo legal |
| **edad** | Analítica, estudios demográficos y segmentación estadística de mercado | Analítica / Negocio | Analítica, DBA | Seudonimización, agregación de datos o almacenamiento en rangos (ej. 20-30) | Durante la vigencia de los estudios analíticos o según la política de analítica de la empresa | Anonimización completa o agregación estadística final |
| **ciudad** | Asignación de zona de servicio local, envíos o logística | Atención al cliente | Atención al cliente, Analítica, DBA | Control de acceso restringido a la tabla operativa | Hasta la conclusión del servicio o vencimiento de garantía | Desvinculación del id del cliente / Anonimización |
| **codigo_postal** | Determinación de cobertura de servicio y cálculo de fletes | Atención al cliente | Atención al cliente, Analítica (solo algunos), DBA | Almacenamiento seudonimizado para procesamiento analítico | Solo mientras se necesite para cuestiones estadísticas | Agregación estadística anonimizada para estudio demográfico |

#### 9. Evaluación integral

|  | Problema | Principio afectado | Riesgo | Control propuesto |
| :-: | :--- | :--- | :--- | :--- |
| 1 | Todos los empleados de analítica pueden consultar directamente la tabla clientes | Responsabilidad / Confidencialidad (mínimo privilegio) | Acceso innecesario a datos personales, uso indebido | Control de acceso basado en roles (RBAC) y principio de mínimo privilegio |
| 2 | Analítica solo genera estadísticas mensuales, pero accede a datos identificables | Minimización | Se utilizan más datos de los necesarios para la finalidad | Entregar vistas que permitan ver solamente los datos necesarios para su trabajo |
| 3 | Los datos se conservan desde hace 12 años | Limitación del plazo de conservación | Almacenamiento innecesario, mayor superficie de exposición en caso de brecha | Definir plazos de conservación y eliminar o bloquear los datos vencidos |
| 4 | No existe una política documentada de retención | Responsabilidad  | Incumplimiento normativo | Elaborar y aprobar una política de retención con fechas de depuración |
| 5 | Los desarrolladores reciben copias completas de la base de datos | Confidencialidad / Minimización | Exposición de datos a personal que no lo necesita | Entregar pequeños conjuntos de las bd que no comprometan la información |
| 6 | Las copias de desarrollo contienen datos reales | Seguridad / Finalidad | Entornos menos protegidos, mayor probabilidad de filtración o pérdida | Anonimización, enmascaramiento (masking) |
| 7 | Marketing usa los correos para campañas promocionales sin evidencia de consentimiento | Consentimiento | Uso para un fin distinto al original, sanciones y quejas de los titulares | Registrar el consentimiento de los clientes
| 8 | No hay documentación clara de la finalidad de cada dato | Finalidad / Transparencia (aviso de privacidad) | No se puede justificar por qué se recopila cada dato ni para que se utiliza | Crear un inventario de datos con finalidad, si hay finalidades secundarias, se necesita consentimiento |
| 9 | Se almacenan datos de identificación directa (nombre, correo, teléfono, RFC) en una sola tabla sin separación | Seguridad / Minimización | Una sola brecha expone toda la identidad de los clientes | Separar identificadores de los datos analíticos, usar seudonimización y cifrado |
| 10 | No hay trazabilidad de quién consulta o copia los datos | Responsabilidad / Seguridad | No se pueden detectar ni investigar accesos indebidos | Registro de auditoría y monitoreo de accesos |

#### 10.  Conclusiones
En este laboratorio aprendí que privacidad, seguridad y administración de bases de datos están estrechamente relacionadas, pero no son lo mismo. La privacidad define qué datos se pueden recopilar, para qué y por cuánto tiempo (finalidad, minimización, consentimiento, retención). La seguridad proporciona los mecanismos para proteger esos datos (mínimo privilegio, cifrado, enmascaramiento, auditoría). La administración de bases de datos es donde ambas se unen: el DBA traduce principios en roles, vistas, banderas de consentimiento, procesos de borrado y bitácoras.
También aprendí que el DBA no puede ni debe decidir solo. Tienen que tomar decisiones como cuánto tiempo conservar un dato, atender una oposición o eliminar información requieren la participación de las áreas de negocio, el área legal y el titular, y deben quedar documentadas. 
Finalmente, entendí que diseñar con privacidad desde el inicio es más efectivo y barato que corregir después: recopilar lo mínimo, separar los datos por finalidad, limitar los accesos y documentar cada decisión reduce el impacto de una brecha.

# PREGUNTAS DE REFLEXIÓN
**1. ¿Una base de datos técnicamente segura necesariamente cumple con todos los requisitos de privacidad?**
No, ya que una base de datos puede estar configurada para que sea segura, pero si los datos dentro de esa base de datos, no están almacenados de manera correcta, si no se almacena solamente la información necesaria, no es del todo segura, ya que no se trata solamente de configuraciones, si no de buenas prácticas también.

**2. ¿Por qué el principio de mínimo privilegio también contribuye a la privacidad?**
Contribuye por que los datos no están expuestos a que los vean todas las personas de la organización, si no que solamente quiénes los necesitan para su trabajo.

**3. ¿Por qué el DBA no debería decidir por sí solo la finalidad del tratamiento de los datos?**
Porque el DBA conoce la parte técnica (cómo se almacenan, protegen y consultan los datos), pero no necesariamente el negocio, las obligaciones legales ni lo que el titular autorizó.

**4. ¿Por qué los desarrolladores no deberían recibir automáticamente copias completas de bases de datos productivas?**
Porque los desarrolladores no necesitan los datos reales de todos los clientes para hacer su trabajo. Entregarlos contradice los principios de minimización y de mínimo privilegio: expone a personal que no lo necesita a nombres, correos, teléfonos y RFC.

**5. ¿Por qué una copia utilizada para desarrollo también puede representar un riesgo de privacidad?**
Porque una copia con datos reales sigue siendo información personal, pero suele vivir en entornos menos protegidos que producción: menos controles de acceso, sin auditoría y en equipos de más personas. Esto aumenta la probabilidad de filtración, pérdida o uso indebido.

**6. ¿Por qué la retención debe formar parte del ciclo de vida de los datos?**
Porque los datos no deben existir indefinidamente tienen un inicio (recolección), un uso, un almacenamiento y un final (eliminación, anonimización o agregación). Si la retención no se define desde el inicio, los datos se acumulan sin justificación, y eso va en contra de la minimización y aumenta el impacto de una brecha o exposición de datos.

**7. ¿Qué relación existe entre privacidad por diseño y diseño de bases de datos?**
La privacidad por diseño significa que la protección de los datos se incorpora desde el diseño y no se agrega después. En una base de datos esto se plantea en decisiones correctas: no crear columnas innecesarias (como salario, estado civil u ocupación sin justificación), guardar edad en lugar de fecha de nacimiento, separar los datos por finalidad (operación, analítica, auditoría), diseñar vistas y roles desde el inicio, y prever banderas de consentimiento y campos para controlar la retención. También implica privacidad por defecto: recopilación mínima y acceso restringido a personal autorizado.

**8. ¿Qué controles técnicos implementarías para reducir el riesgo de exposición de datos personales?** 
Principalmente implementaría el control de accesos, vistas de acuerdo a roles asignados, cifrado, enmascaramiento u seudonimización,etc.

**9. ¿Qué información debería conocer un DBA para responder técnicamente a una solicitud ARCO?**
Debe saber dónde están los datos del titular, con qué identificador se localizan, que la identidad fue verificada y qué derecho se está ejercitando (acceso, rectificación, cancelación u oposición), qué finalidad tiene cada dato y si hay consentimiento registrado.

**10. ¿Qué responsabilidades deberían corresponder al DBA, al responsable de privacidad, al área jurídica y al propietario de los datos?**
DBA: implementar los controles técnicos (roles, vistas, cifrado, enmascaramiento, bitácoras), localizar y ejecutar los cambios técnicos en las solicitudes ARCO, respaldar y eliminar datos de forma segura, y mantener la trazabilidad.
Área jurídica: identificar las leyes y plazos aplicables (por ejemplo, los fiscales), validar los periodos de retención y evaluar el riesgo legal de cada tratamiento.
Propietario de los datos: definir para qué necesita cada dato y quién debe usarlo, aprobar los accesos de su área y justificar la finalidad y el periodo de conservación.