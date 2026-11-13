## LAB-02 — Trazabilidad en MongoDB Community
_Gestión de seguridad y desempeño de bases de datos_

**Camacho Castañeda Angélica María 4-1**

**¿Por qué un cambio de privilegios es uno de los eventos auditables más importantes?**

Porque los privilegios determinan todo lo que un usuario puede hacer después. Quien se otorga o recibe un rol más importante puede leer, modificar o borrar datos que antes no podía, y también puede cambiar los controles que registran su actividad. 

**¿Con qué frecuencia tomarías instantáneas? ¿Qué factores influyen?**

Depende de cuánto tiempo se tolera que un cambio pase sin detectarse. Para una base con datos personales o financieros tomaría instantáneas cada pocos minutos (por ejemplo cada 5) o cada hora, automatizadas, y para un entorno de bajo riesgo bastaría una vez al día. Los factores que influyen son la sensibilidad de los datos y la normativa aplicable, el número de usuarios y la frecuencia con que cambian los roles, el costo en almacenamiento y rendimiento. Además, la instantánea solo dice que algo cambió entre dos momentos, así que cuanto menor sea el intervalo, más se puede decir en que momento ocurrió laguún incidente.

**¿Quién debería poder escribir en auditoria.instantaneas_privilegios?**

Solo un proceso o una cuenta de servicio dedicada, con permiso de inserción únicamente en esa colección, que nadie use para otra cosa. Ni los administradores que son quienes vigilan, ni la aplicación deberían poder escribir, modificar o borrar ahí, porque quien controla la evidencia puede alterarla. Lo ideal es que los administradores solo tengan lectura, que existan copias en un almacén separado y que los registros no puedan editarse después de guardados. 