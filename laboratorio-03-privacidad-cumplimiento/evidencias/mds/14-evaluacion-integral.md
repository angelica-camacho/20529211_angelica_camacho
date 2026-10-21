# LABORATORIO 3: PRIVACIDAD Y CUMPLIMIENTO
#### DBA
#### Camacho Castañeda Angélica María 4-1

# Actividad 14 — Escenario integral

Considera la siguiente situación:
* La empresa tiene una base de datos con información de 50,000 clientes.
* Todos los empleados del área de analítica pueden consultar directamente la tabla clientes.
* La tabla contiene nombre, correo, teléfono, RFC, edad, ciudad y código postal.
* El área de analítica únicamente genera estadísticas mensuales.
* Los datos se conservan desde hace 12 años.
* No existe una política documentada de retención.
* Los desarrolladores reciben copias completas de la base de datos para realizar pruebas.
* Las copias de desarrollo contienen información real.
* El área de marketing utiliza los correos electrónicos para campañas promocionales.
* No existe documentación clara sobre qué finalidad corresponde a cada dato.

## 20. Actividad 14 — Escenario integral

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