# PREGUNTAS UNIDAD 2: COMPARACIÓN DE PROTECCIÓN EN REPOSO Y PROTECCIÓN EN TRÁNSITO
_Camacho Castañeda Angélica María 4-1 Lic. En Informática_

| Situación | Mecanismo apropiado | ¿Qué protege? |
| :--- | :--- | :--- |
| Contraseña de usuario | Hashing con salt, crypt() & gen_salt()| Confidencialidad de las credenciales de acceso contra exposición en filtraciones. |
| RFC almacenado en una tabla | Cifrado simétrico pgp_sym_encrypt() o enmascaramiento de datos | Confidencialidad de datos personales almacenados en reposo almacenados en una base de datos. |
| Consulta enviada desde un cliente al servidor | Cifrado en tránsito mediante TLS/SSL | Interceptación de tráfico de red y manipulación de datos en transmisión. |
| Respaldo de una base de datos | Cifrado de archivos de respaldo (PGP) / Cifrado de disco | Acceso no autorizado a copias de seguridad en caso de ataques o pérdida. |
| Clave criptográfica | Gestor de secretos (Variables de entorno / HashiCorp Vault / HSM) | El acceso no autorizado al secreto principal usado para cifrar y descifrar. |