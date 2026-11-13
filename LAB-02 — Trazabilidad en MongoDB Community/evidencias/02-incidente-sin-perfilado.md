## LAB-02 — Trazabilidad en MongoDB Community
_Gestión de seguridad y desempeño de bases de datos_

**Camacho Castañeda Angélica María 4-1**

**¿Puedes demostrar qué cambió? ¿Y quién se conectó a esa hora?**

No se puede demostrar qué cambió: el perfilador estaba apagado (was: 0), system.profile tiene 0 documentos y buscar GAMA780912XXX en la bitácora da 0 resultados, porque el servidor no guarda el contenido de las operaciones normales. Sí se puede saber quién se conectó a esa hora, ya que la bitácora registra eventos ACCESS con el usuario app_ventas, la base comercial, el mecanismo SCRAM-SHA-256, la hora y el appName app-ventas-web, pero eso solo prueba que entró, no que fue quien modificó el dato.
¿Por qué mongosh abre varias conexiones (conn8, conn9, …) para una sola instrucción? ¿Cuál es la que se autentica?

**¿Por qué mongosh abre varias conexiones (conn8, conn9, …) para una sola instrucción? ¿Cuál es la que se autentica?**

mongosh abre varias conexiones (conn8, conn9, …) porque su driver usa una para monitorear el estado del servidor y otra para ejecutar los comandos, y cada una aparece con su propio ctx en la bitácora. La que se autentica es la que ejecuta la operación y es la que muestra Successfully authenticated. Confírmalo comparando los ctx en tu bitácora, porque en tu captura salieron dos conexiones autenticadas (conn14 y conn15) con isSpeculative: true.