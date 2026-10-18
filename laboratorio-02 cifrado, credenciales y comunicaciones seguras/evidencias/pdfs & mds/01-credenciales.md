# PREGUNTAS UNIDAD 2: CREDENCIALES
_Camacho Castañeda Angélica María 4-1 Lic. En Informática_
#### ¿Qué ocurriría si una persona obtiene acceso de lectura a esta tabla?
Una persona que no está autorizada podrá ver las contraseñas almacenadas en esta tabla, ya que están como texto plano en un registro, lo cual provocaría una exposición de secretos.
## 7.3 Preguntas Protección de credenciales
#### ¿Son iguales? 
No, aunque el inicio solamente los primeros 4 caracteres son iguales, después de esos, todos son completamente diferentes.
#### Si no son iguales, ¿por qué?
No son iguales ya que al ejecutarse nuevamente se crea una nueva aleatoria y única cadena salt, lo que asegura que es completamente diferente a alguna otra que se cree después.
#### ¿Qué función cumple gen_salt()?
Su función es generar cadenas únicas que puedan proteger las contraseñas de los usuarios cuando se almacenan en una base de datos, evitando que un atacante pueda descifrarlas fácilmente si logra robar la tabla de usuarios.
#### ¿Qué función cumple crypt()?
Crypt tiene la función de generar, verificar y comparar contraseñas de forma segura utilizando funciones hash adaptadas para claves.
#### ¿Esto es cifrado reversible? 
No es reversible por que utiliza funciones de hashing lo que significa que aplica técnicas matemáticas complejas paara poder destruir parte de la información original, asi hace difícil el proceso para poder recuperar la contraseña en texto plano. 
## 7.5 Preguntas Verificar contraseñas
#### ¿Qué resultado obtuviste con la contraseña correcta?
Se obtuvo un campo donde es de tipo booleano que indica si la contraseña es correcta, y como si es correcta da un true.
#### ¿Qué resultado obtuviste con la contraseña incorrecta?
Se obtuvo un campo también de tipo bool que indica que la contraseña no es correcta ya que en la consulta se puede ver que es una contraseña diferente a la original.
#### ¿Por qué no es necesario recuperar la contraseña original?
Porque para validar el inicio de sesión el sistema no necesita leer la contraseña en texto plano, sino únicamente comparar que el hash generado en el intento de acceso coincida de forma idéntica con el hash almacenado en la base de datos.
#### ¿Por qué un hash no debe confundirse con cifrado?
Por que operan bajo diferentes principios y sus métodos mátemáticos son muy diferentes, ya que el cifrado reversible solo oculta la información de forma temporal que se puede recuperar con una clave o llave de descifrado, mientras que el hash busca transformar los datos de forma definitiva. 