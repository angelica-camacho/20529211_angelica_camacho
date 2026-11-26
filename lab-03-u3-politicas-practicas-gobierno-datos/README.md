# Preguntas de reflexión.
 **Camacho Castañeda Angélica María 4-1**

_Gestión de seguridad y desempeño de bases de datos_

_LAB-03 — Políticas prácticas, gobierno de datos y evidencias_

**1. ¿Por qué el gobierno de datos no es «burocracia» en el contexto del problema inicial de la unidad?**

Porque el problema inicial no fue falta de herramientas, sino falta de responsables. En clientes había un correo duplicado, un RFC incompleto, un RFC nulo y una edad de -3, y nadie decidía qué era un dato correcto ni quién podía corregirlo. El gobierno de datos pone nombre a quién es dueño de cada dato, quién lo cuida y quién aprueba los accesos y los cambios. Sin eso, o nadie corrige nada, o el DBA corrige por su cuenta y sin evidencia. Con la matriz de responsables, las reglas de calidad y las políticas, cada error tiene un dueño que decide y un registro que lo demuestra.

**2. ¿Qué diferencia hay entre el propietario técnico de una tabla en PostgreSQL y el propietario del dato?**

El propietario técnico es el rol que figura como dueño del objeto en el motor. En las tablas es postgres, y puede modificarlas, borrarlas y dar permisos. Es una propiedad del sistema y no dice nada sobre el contenido. El propietario del dato es la persona o el área responsable de ese dato para el negocio por que define para qué se usa, qué calidad debe tener y quién puede acceder. En clientes, el propietario técnico es postgres, pero el propietario del dato es Gerencia Comercial, y el del RFC es Facturación. El DBA tiene el poder técnico como custodio, pero no la autoridad para decidir sobre el contenido.

**3. ¿Por qué una política sin evidencia no supera una auditoría?**

Porque una auditoría revisa lo que se puede demostrar, no lo que se dice que se hace. Una política sin registro es solo una intencion y no se puede comprobar que se cumplió. En el expediente se ve con POL-06, que exige solicitudes aprobadas, pero gobierno.solicitudes_cambio tiene 0 solicitudes, así que ningún cambio se puede mostrar como autorizado. Lo mismo pasa con POL-02 por que no existe un registro de respaldos ni de pruebas de restauración. Por eso cada política nombra la evidencia que la respalda y declara cuando hoy no existe.

**4. ¿Qué parte del expediente sería la más difícil de mantener actualizada? ¿Cómo lo resolverías?**

La conciliación y el índice de evidencias, porque la bitácora cambia todos los días, los archivos rotan y cada vez que se modifica un archivo hay que recalcular su hash. El catálogo también se desactualiza cuando se agregan tablas o columnas. Lo resolvería con un procedimiento mensual que exporte la bitácora vigente, calcule el hash y guarde el archivo antes de que rote y con una consulta fija que liste los cambios de privilegios, estructura y configuración para compararlos con las solicitudes.

**5. ¿Qué hallazgo de tu expediente tiene mayor impacto y por qué?**

el RFC del cliente 3 se cambió con el disparador de auditoría desactivado, durante unos 5 segundos. Es el de mayor impacto porque combina un dato personal y fiscal con la pérdida del control que debía vigilarlo. El cambio no quedó en auditoria.cambios_clientes, y solo se puede probar con la línea 300 de la bitácora y con el RFC anterior. Además, muestra que quien tiene permisos de administrador puede saltarse la auditoría sin dejar autor, y eso debilita todo lo demás. Se agrava porque app_ventas ya había cambiado ese mismo RFC y porque no hay una solicitud aprobada que explique ninguno de los dos cambios.

**6. ¿Por qué documentar una limitación es preferible a ocultarla ante una auditoría?**

Porque una limitación declarada es un riesgo conocido que alguien puede aceptar de manera formal, con un control compensatorio, mientras que una oculta es una falla que se descubre después y destruye la confianza en el resto de la evidencia. Si el auditor encuentra solo, por ejemplo, que no hay auditoría de lecturas sin pgaudit o que la bitácora tiene huecos, puede dudar de todo lo demás. Declararlas muestra que se conoce el alcance real de los controles y permite decidir con información y es aceptar el riesgo, reducirlo o corregirlo. 