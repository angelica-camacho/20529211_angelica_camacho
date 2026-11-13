## LAB-02 — Trazabilidad en MongoDB Community
_Gestión de seguridad y desempeño de bases de datos_

**Camacho Castañeda Angélica María 4-1**

**¿Qué perdiste de evidencia al aplicar el filtro? ¿Qué ganaste?**

Se perdió el rastro de las lecturas, por que la consulta find({ _id: 1 }) que corrió la aplicación no quedó en system.profile. Ya no puedes saber quién consultó datos personales ni cuándo, y eso importa si el riesgo es que alguien copie o revise información de clientes. Lo que se ganó fue menos volumen y menos datos sensibles duplicados. Ahora solo se guardan insert, update y remove, que son las operaciones que cambian datos. Como system.profile es una colección de tamaño limitado, los eventos útiles tardan más en sobrescribirse. Además, se evita copiar en claro los filtros de las lecturas y se reduce el costo en rendimiento.

**¿Qué filtro usarías si solo interesaran operaciones sobre la colección clientes?**

Usaría un filtro sobre el campo ns (el namespace, con formato base.colección): db.setProfilingLevel(1, { filter: { ns: "comercial.clientes" } }), con lo que se registran todas las operaciones sobre clientes y se ignoran las demás colecciones. 