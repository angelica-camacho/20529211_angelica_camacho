## POL-03 — Retención

**Objetivo:** Evitar guardar datos personales más tiempo del necesario, sin perder la evidencia que hace falta para investigar un incidente.

**Alcance:** Los datos de CAT-01 a CAT-05 y sus bitácoras, en producción y en las copias exportadas.

**Regla:** Los datos de clientes se guardan mientras la cuenta esté activa y 1 año después del cierre. El RFC se guarda 5 años, pero ese plazo se debe confirmar con el área jurídica, revisando la obligación fiscal y la normativa de protección de datos personales. Las bitácoras se guardan así: accesos 6 meses, modificaciones de datos 12 meses, cambios de privilegios y estructura 24 meses y system.profile 30 días. En auditoria.cambios_clientes los valores personales se dejan completos 12 meses y después se enmascaran. Lo que queda (quién, cuándo y qué columna cambió) se guarda hasta 24 meses, plazo que también se confirma con el área jurídica. Cuando vence un plazo se hace borrado seguro, salvo lo que diga Excepciones.

**Responsable:** Decide: propietario del dato, junto con el área jurídica. Ejecuta: DBA.

**Excepciones:** Si hay un incidente o una investigación abierta, no se borran los registros relacionados hasta que se cierre. Lo autoriza Dirección / responsable de gobierno de datos y se documenta el caso.

**Evidencia:** Columna "Conservación" del catálogo (CAT-01 a CAT-05, LAB-03) + tabla de retención de bitácoras (LAB-03). Hoy no existe un registro de los borrados hechos ni un manifiesto de hashes de las bitácoras exportadas.

**Revisión:** Cada año y cuando cambie alguna obligación normativa.
