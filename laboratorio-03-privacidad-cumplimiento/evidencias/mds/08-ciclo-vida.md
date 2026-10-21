# LABORATORIO 3: PRIVACIDAD Y CUMPLIMIENTO
#### DBA
#### Camacho Castañeda Angélica María 4-1

# Actividad 8 — Derecho de cancelación y ciclo de vida
**Mapa de relación**
## Mapa de relaciones: dónde puede existir información de un cliente

```
                               clientes
                                  │
       ┌─────────────┬────────────┼─────────────┬─────────────┐
       ▼             ▼            ▼             ▼             ▼
 otras tablas    registros     réplicas    copias para   exportaciones
 relacionadas  de auditoría       │         analítica          │
                                  ▼             │              ▼
                              respaldos         ▼          sistemas
                                             reportes      externos
```

1. clientes se relacionan otras tablas relacionadas y se conectan por llaves foráneas; borrar sin revisar puede fallar o dejar registros huérfanos

2. clientes se relaciona con registros de auditoría ya que guardan quién consultó o cambió al cliente; pueden contener datos personales y a la vez ser evidencia que debe conservarse 
3. clientes se relaciona con réplicas ya que son copias de la base de datos con información de los clientes; el borrado debe propagarse a ellas
4. réplicas se relaciona con respaldos por que los respaldos guardan copias anteriores y conservan al cliente hasta que expiran 
5.  clientes se relacionan con copias para analítica ya que son datos derivados de clientes; deben actualizarse o anonimizarse 
6. copias para analítica se relaciona con reportes por que los reportes ya generados siguen incluyendo al cliente aunque se borre el origen 
7.  clientes se relaciona con exportaciones ya que son archivos (por ejemplo CSV) con datos del cliente, fuera del control de la base 
8. exportaciones se relaciona con sistemas externos ya que los datos enviados a terceros ya no dependen de la empresa; hay que solicitarles la cancelación 


**¿Por qué eliminar un registro de una tabla no necesariamente significa que toda la información relacionada con esa persona haya desaparecido de la organización?**
La información aun no desaparece ya que pueden quedar registros de ella en respaldos anteriores, réplicas de la base de datos, reportes, archivos, etc. 

# Actividad 9 — Derecho de oposición
* **qué información podría necesitar mantenerse:**
  Debe mantenerse su id, nombre, correo y teléfono, para poder darle soporte técnico o por si después requiere nuevamente ser cliente, que se niegue a que se use su información no significa que se deban borrar sus datos. También es importante que se mantenga algunos datos fiscales, ya que debe pasar cierto tiempo para la eliminación de algunos datos como estos.
* **qué información podría dejar de utilizarse para determinada finalidad:**
  Dejan de utilizarse los datos que se utilizan en la finalidad secundaria sobre la que el cliente se opuso, por ejemplo para fines de mercadotecnia y promociones pueden ser correo, teléfono, dejan de incluirse en listas de envíos de promociones. Otro caso puede ser para análisis y estadísticas, se puede dejar de usar la edad, código postal, ciudad.

* **qué mecanismos técnicos podrían separar finalidades:**
  Pueden ser mecanismos como banderas de consentimiento, vistas de solo los clientes que sí den consentimiento del uso de sus datos, etc. 

* **por qué la decisión final no debe ser tomada únicamente por el DBA:**
  El DBA solamente se encarga de la parte técnica, pero también se debe tener en cuenta al cliente y su consentimiento, además debe analizar como esta decisión afecta al negocio, y no es solo borrar datos por borrar, si borra sin autorización puede borrar evidencia para audítorias.