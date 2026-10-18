# PREGUNTAS UNIDAD 2: ANÁLISIS DE UN ESCENARIO DE SEGURIDAD
_Camacho Castañeda Angélica María 4-1 Lic. En Informática_

**Pregunta 1**
#### ¿Cuáles son los principales riesgos?
Algunos riesgos pueden ser:
* Exposición de credenciales: Al tener las contraseñas en texto plano, cualquier acceso no autorizado a la tabla permite que puedan obtener la clave directa de los usuarios, facilitando ataques.
* Violación de privacidad y robo de identidad: El RFC y información financiera en la tabla sin métodos de enmascaramiento o seudonimización expone esta información directamente al atacante y puede darle uso para cometer delitos, también viola la privacidad del usuario.
* Vulnerabilidad en copias de seguridad (Respaldos): Almacenar los respaldos sin protección significa que una copia robada o extraviada de la base de datos contiene toda la información crítica expuesta en texto plano.a
* Compromiso de la seguridad por claves expuestas: Guardar las claves criptográficas en archivos SQL vulnera el principio de separación de secretos, permitiendo que cualquier persona con acceso al repositorio o los scripts tenga control total para descifrar la información.

**Pregunta 2**
#### ¿Qué mecanismo utilizarías para cada elemento?
* Contraseñas: Hashing irreversible con salt usando funciones como crypt y gen_salt para que genere una nueva cadena aleatoria única y encriptarla con crypt.
* RFC & Información financiera: Cifrado simétrico (pgp_sym_encrypt)reversible o técnicas de enmascaramiento para limitar la visualización.
* Conexiones: Cifrado de la red mediante TLS utilizando la validación completa de sslmode=verify-full
* Claves criptográficas: Gestor de secretos (como HashiCorp Vault) para evitar que las claves queden en archivos SQL o código fuente.
* Respaldos de la base de datos: Cifrado de respaldos a nivel de almacenamiento/archivo (cifrado GPG/PGP).
  
**Pregunta 3**
#### ¿Cuál de los problemas consideras más crítico y por qué?
Personalmente, el más crítico es guardar las claves criptográficas en archivos SQL, pero también considero que guardar contraseñas en texto claro es igual de crítico. 
La razón es por que las claves criptográficas son la llave de toda la información sensible, por lo que si un atacante obtiene las claves de los archivos SQL, ya no sirve de nada que todo esté cifrado por qué es como dejarle todo al descubierto, por que podrá descifrar toda la información. 

**Pregunta 4**
#### ¿Tener correctamente configurados los usuarios y permisos elimina estos riesgos?
No, no los elimina, ya que el control de accesos badados en roles y permisos en la base de datos solo regula quién puede consultar o modificar datos dentro de la base de datos y los permisos no protegen contra la exposición de datos en reposo. 

