# INFORME 2 UNIDAD 2: CIFRADO, CREDENCIALES Y COMUNICACIONES SEGURAS
### Gestión de seguridad y desempeño de bases de datos
_Camacho Castañeda Angélica María 4-1 Lic. En Informática_

**1. Introducción**

El principal problema de seguridad abordado fue una base de datos con usuarios, roles y permisos que no estaban bien configurados. Por eso no está bien protegida: los permisos controlan quién puede consultar los datos y quién puede accesar o modificarlos, pero no protegen la información si hay un acceso no autorizado, un respaldo robado, el tráfico interceptado, o si se filtran las contraseñas o las claves en un archivo SQL.

**2. Protección de credenciales**

La diferencia entre el hashing, el texto plano y el cifrado es que el texto plano es la información o datos tal como son escritos, sin ningún tipo de protección, enmascaramiento, anonimización o encriptación, por lo que cualquier persona que tenga acceso a ellos puede leerlos.
En cambio, el cifrado es un proceso reversible que transforma el texto plano en datos ilegibles utilizando un algoritmo y una clave criptográfica. Finalmente, el hashing es un proceso irreversible que transforma cualquier cantidad de datos en una cadena de caracteres única utilizando funciones matemáticas complejas

**3. Protección de datos sensibles**

Los datos sensibles que fueron protegidos incluyeron las contraseñas. En la implementación insegura se dejó la contraseña en texto plano, mientras que en la segura se almacenó utilizando una función de sal (salt) y bcrypt: la función de salt genera un valor aleatorio y, mediante el algoritmo de bcrypt, se combina la contraseña con dicho salt para producir el hash. Al ejecutar dos veces la misma consulta se obtuvieron diferentes claves, ya que cada ejecución genera un salt nuevo.
También se protegió el RFC de los usuarios, almacenado en la tabla de clientes en una columna cifrada de tipo bytea. Como el RFC es un dato personal que permite identificar a una persona, es necesario cifrarlo; además, este debe poder recuperarse, por lo que no sirve un hash (dado que es irreversible) y se requiere un cifrado simétrico

**4. TLS**

El problema que resuelve TLS es que las consultas, los resultados y las contraseñas viajan en texto claro por la red, de modo que un atacante puede interceptarlos o modificarlos en tránsito. Lo que aporta TLS es confidencialidad y cifrado en el tráfico.
En PostgreSQL, se verificó si el servidor tiene TLS activado; también se mostró el puerto y las direcciones que escucha, esto para saber qué direcciones sí pueden conectarse a él. Asimismo, se indicó la dirección y el puerto del cliente de la sesión actual, y se utilizó un comando para comprobar si la sesión actual utilizaba TLS, qué versión y con qué algoritmo de cifrado. Sin embargo, en este caso no se pudo acceder a esa parte porque no teníamos permisos de superusuario

**5. Gestión de claves**

Es importante que las credenciales y los secretos no se almacenen en los archivos SQL ni en los scripts. Si alguien que no debe, tiene acceso a dichos archivos, puede conseguir la clave de acceso y consultar los datos descifrados mediante esa llave, lo que anularía por completo la protección del cifrado

**6. Resultados**

Los resultados obtenidos permitieron comprender cómo se cifra una contraseña, por qué es importante cifrarla y por qué es fundamental que las credenciales no se almacenen en texto plano, en repositorios ni mucho menos en el código fuente, ya que esto generaría múltiples vulnerabilidades. Asimismo, se aprendió la importancia de proteger la red, dado que los riesgos no se encuentran únicamente en la base de datos, sino también en todo el entorno donde esta se utiliza.

**7. Problemas encontrados**

La única dificultad técnica fue que no tenía permisos de superusuario para poder ver una consulta en la práctica de TLS; de ahí en fuera, todo estuvo bien. Sin embargo, también siento que es un poco complicado aprender toda la sintaxis para cifrar claves, aplicar hashing y comprender estos temas.

**8. Conclusiones**

Lo que aprendí fue la importancia de cifrar los datos y de aplicar el método de hashing, ya que actúa como una capa más de seguridad junto al cifrado. También comprendí que no solo se deben proteger los datos, sino que también se deben proteger todos los componentes que trabajan en conjunto con una base de datos y que poseen información sensible de otras personas.
Las medidas que yo aplicaría en un entorno productivo serían el cifrado y el hashing, ya que estos aportan seguridad. Asimismo, aprendí buenas prácticas como no almacenar secretos directamente en un repositorio ni en archivos SQL

## Preguntas de reflexión
**1. ¿Por qué una contraseña no debe almacenarse como texto claro?**

Una contraseña no debe almacenarse como texto claro, ya que cualquier persona que tenga acceso a la base de datos podrá verla tal cual y podría hacer mal uso de ella o incluso exponer estas credenciales.

**2. ¿Por qué un hash no es equivalente a un cifrado?**
   
El hash no es equivalente al cifrado, porque el hash es irreversible (el dato original no se puede recuperar a partir del resultado), mientras que el cifrado es reversible y la información siempre se puede descifrar si se cuenta con la clave correcta. También, no son equivalentes en su función, ya que uno procesa y verifica contraseñas mediante comparación, mientras que el otro almacena datos confidenciales permitiendo su recuperación cuando se necesita.

**3. ¿Por qué el cifrado de una columna no sustituye al control de acceso?**

El cifrado a nivel de columna no es lo mismo que el control de acceso, ya que una persona malintencionada o con permisos mal configurados aún podría tener acceso a todas las demás columnas de una tabla en la base de datos a las que no debería poder ingresar.

**4. ¿Por qué TLS no sustituye a los mecanismos de autorización de PostgreSQL?**

TLS no sustituye los mecanismos de autorización, porque TLS es el protocolo encargado exclusivamente de cifrar los datos en tránsito a través de la red por lo tanto, los mecanismos de autorización y los roles de acceso a nivel de aplicación o base de datos operan de manera independiente y no guardan relación con el cifrado del tráfico de red.

**5. ¿Qué ocurriría si una organización pierde una clave utilizada para cifrar información?**

Si una organización pierde una clave de cifrado, los datos protegidos se pueden volver completamente inaccesibles y no se podrían recuperar, lo que provoca la interrupción de las operaciones, posibles incumplimientos normativos, etc. 

**6. ¿Qué ocurriría si una clave criptográfica se publica accidentalmente en GitLab?**

Si una contraseña criptográfica se publica accidentalmente, ocurriría que quedaría totalmente expuesta; de este modo, se le otorgaría acceso a una persona que no debería tenerlo para que pueda ingresar a la tabla donde están los datos sin cifrar. En consecuencia, el cifrado perdería su sentido, ya que no habría protección de ninguna forma.

**7. ¿Por qué un repositorio privado no debe considerarse un almacén de secretos?**

Un repositorio privado no debe considerarse un almacén de secretos, ya que no posee el mismo nivel de seguridad; además, el hecho de que sea privado no garantiza que nadie ajeno pueda acceder a él.


**8. ¿Qué diferencia existe entre proteger información almacenada y proteger información durante su transmisión?**

La diferencia es el estado de los datos y los riesgos: los datos almacenados (en reposo) están en discos o bases de datos y se cuidan con cifrado o control de accesos para evitar ataques o filtraciones, mientras que los datos en transmisión viajan por la red y necesitan protocolos como TLS/HTTPS para que nadie los intercepte ni los modifique en el camino.


**9. ¿Por qué la gestión de claves es tan importante como el algoritmo criptográfico?**

Porque aunque se utilice un algoritmo súper fuerte y complejo, si se manejan mal las llaves de cifrado todo se cae y no existe la protección. No sirve un cifrado fuerte si la llave está guardada en el código fuente, en texto planos, si alguien puede accesar a ella, da igual el algoritmo porque toda la información queda expuesta.

**10.  ¿Qué mecanismo adicional implementarías en una organización para proteger los respaldos de las bases de datos?**

Cifraría los respaldos con una llave diferente a la de producción y la guardaría en un lugar completamente separado (como un bául de secretos). Además, los pondría en un almacenamiento aislado, con acceso restringido.