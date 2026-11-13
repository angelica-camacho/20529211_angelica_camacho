## LAB-02 — Trazabilidad en MongoDB Community
_Gestión de seguridad y desempeño de bases de datos_

**Camacho Castañeda Angélica María 4-1**

**¿Qué campo distingue un acceso fallido de uno exitoso?**

El campo msg ("Failed to authenticate" frente a "Successfully authenticated") y el campo attr.result. En un éxito vale 0, y en un fallo trae un código distinto de cero junto con el texto del error. También cambia el id del evento: 5286307 para los fallos y 5286306 para los éxitos.


**¿Qué diferencia hay entre el error de contraseña incorrecta y el de usuario inexistente? ¿Por qué el cliente recibe el mismo mensaje?**

Con contraseña incorrecta el usuario existe pero la prueba SCRAM no coincide. Con un usuario inexistente el servidor no encuentra la cuenta: UserNotFound: Could not find user "usuario_inexistente" for db "comercial", result: 11. El cliente recibe el mismo Authentication failed. en ambos casos para no revelar qué usuarios existen. Si los mensajes fueran distintos, un atacante podría probar nombres hasta encontrar uno válido y después centrarse en adivinar su contraseña. El detalle solo queda en la bitácora del servidor, que lee el administrador.


**¿Por qué el nombre de la aplicación del intento fallido es mongosh 2.10.0 y no app-ventas-web?**

Porque la cadena de conexión de los intentos fallidos no llevaba ?appName=app-ventas-web. Lo que pasa es que cuando el cliente no declara ese parámetro, mongosh se identifica con su propio nombre y versión. Además, el appName lo declara el propio cliente y el servidor no lo verifica, así que sirve para ordenar la evidencia pero no es una prueba de identidad ya que cualquiera puede ponerle el nombre que quiera.