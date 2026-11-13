## LAB-02 — Trazabilidad en MongoDB Community
_Gestión de seguridad y desempeño de bases de datos_

**Camacho Castañeda Angélica María 4-1**

**¿Qué usuario cambió la configuración del perfilador? ¿Qué dos eventos lo demuestran?**

Lo cambió el usuario admin (que este se creo en la base admin). Lo demuestran dos eventos con el mismo ctx (conn76): Profiler settings changed, que muestra el cambio (a las 14:32:50 pasó de nivel 0 a nivel 1 con el filtro de insert, update y remove en comercial) pero no dice quién lo hizo, y Successfully authenticated, que sí identifica al usuario (admin), la base, la hora y el cliente (127.0.0.1:63184). Al unirlos por ctx se atribuye el cambio a admin.

**¿Qué condición debe cumplirse para que esta correlación sea válida?**

Que ambos eventos pertenezcan a la misma ejecución del servidor. Los números de conexión (conn76, etc.) vuelven a empezar cuando el servidor se reinicia, así que después de un reinicio el mismo connN podría ser otra conexión y otro usuario, y la atribución sería falsa. También se necesita que la autenticación sea anterior al cambio (aquí lo es) y que ambos eventos sigan en la bitácora, sin haberse perdido por rotación o por el límite de líneas en memoria.


**¿Por qué es relevante que quede registrado un cambio de configuración del propio mecanismo de registro?**

Porque quien quiera ocultar lo que hace puede empezar apagando o filtrando el registro. Si ese cambio no quedara anotado, las operaciones posteriores desaparecerían sin rastro. Al quedar en la bitácora, se detecta la que alguien cambió o borró, se sabe desde cuándo hay un hueco en la evidencia y se atribuye a un usuario. 