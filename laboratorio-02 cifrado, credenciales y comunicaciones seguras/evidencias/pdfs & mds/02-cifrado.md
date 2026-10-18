# PREGUNTAS UNIDAD 2: CIFRADO DE INFORMACIÓN SENSIBLE
_Camacho Castañeda Angélica María 4-1 Lic. En Informática_
#### ¿Qué diferencia existe entre crypt() y pgp_sym_encrypt()?
La diferencia que hay es que con crypt se vuelve un proceso irreversible, su único propósito es almacenar y verificar las contraseñas y no es posible recuperar la contraseña en texto plano, mientras que con pgp_sym_encrypt, es reversible ya que solo protege datos sensibles cifrándolos con una clave, y con este si se puede leer la contraseña en texto plano con un pgp_sym_decrypt
#### ¿Cuál de los dos mecanismos permite recuperar el dato original?
El pgp sym encrypt puede recuperar el dato con la función de decrypt ya que es reversible. 
#### ¿Qué ocurre si se utiliza una clave incorrecta?
Va a generar un error y postgre detendrá la operación y manda un mensaje de error. 
#### ¿Qué problema de seguridad representa colocar la clave directamente en una consulta?
Si se deja una clave en una consulta esta se puede almacenar en los logs del servidor y va a quedar expuesta, también si la consulta está escrita directamente en el código, cualquier persona o atacante que obtenga acceso al repositorio podrá leer la clave sin restricciones.