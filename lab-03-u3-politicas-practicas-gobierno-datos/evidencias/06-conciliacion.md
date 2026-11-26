-- Camacho Castañeda Angélica María 4-1
-- Gestión de seguridad y desempeño de bases de datos
-- LAB-03 — Políticas prácticas, gobierno de datos y evidencias

| Momento (bitácora) | Usuario | Sentencia | Folio que autoriza | ¿Autorizado? | Hallazgo |
|---|---|---|---|---|---|
| 2026-10-25 22:54:26 (num 216) | postgres | ALTER TABLE clientes ADD COLUMN canal_alta ... | CAM-2026-014 | Sí | — |
| 2026-10-25 22:50:53 (num 169) | postgres | ALTER TABLE clientes DISABLE TRIGGER trg_auditoria_clientes | Ninguno | No | Se desactivó el trigger de auditoría sin solicitud. Mientras estuvo desactivado, los cambios en clientes no quedaron en auditoria.cambios_clientes. |
| 2026-10-25 22:50:09 (num 35) | postgres | GRANT UPDATE ON clientes TO app_ventas | Ninguno | No | Privilegio de modificación otorgado sin solicitud aprobada del propietario del dato. |

**1. ¿Qué cambios de la bitácora no tienen folio? Clasifícalos: ¿son de preparación del laboratorio o representan hallazgos?**

De los tres que tienes en la tabla, no tienen folio el GRANT UPDATE ON clientes TO app_ventas y el DISABLE TRIGGER trg_auditoria_clientes ejecutado por postgres. Los dos son hallazgos, porque cambian los controles de producción (quién puede modificar clientes y si se audita) y ninguno tiene solicitud aprobada. En el fragmento de la guía también aparecen sin folio el ALTER TABLE ... ADD COLUMN segmento y el CREATE ROLE rol_temporal ... PASSWORD, que son de preparación del laboratorio porque arman el escenario. El CREATE ROLE además deja una contraseña visible en la bitácora, y eso conviene señalarlo como hallazgo aparte. En cambio, el ADD COLUMN canal_alta sí tiene folio (CAM-2026-014) y no es hallazgo.

**2. La desactivación del disparador del LAB-01 (Actividad 14), ¿qué tan grave es como hallazgo? ¿Por qué? ¿Qué distingue la línea 163 de la 169?**

Es grave, de severidad alta, porque el disparador es lo que registra los cambios de clientes en auditoria.cambios_clientes. Mientras estuvo desactivado, cualquier modificación a clientes pudo hacerse sin dejar rastro en esa tabla, y quien lo hizo puede haber borrado su propia evidencia. Además no tiene folio, así que nadie lo aprobó. La diferencia entre las líneas es quién lo ejecutó. La línea 163 la ejecutó app_ventas, un rol de aplicación que no debería poder cambiar la estructura de la tabla, así que es un intento de saltarse el control. La línea 169 la ejecutó postgres, que tiene los privilegios para hacerlo, y esa sí desactivó el control. Revisa si después de la línea 163 hay un ERROR. Si lo hay, el intento falló y solo se documenta. Si no, el hallazgo es todavía más grave. La línea 171 vuelve a activar el disparador y marca el final del periodo sin auditoría.

**3. ¿Qué limitación tiene esta conciliación si `log_statement` estuvo en `none` durante algún periodo?**

La conciliación solo puede comprobar lo que quedó en la bitácora, y con none no se registra ninguna sentencia. Que no aparezca un cambio en ese periodo no significa que no ocurrió, y no se pueden saber quién, cuándo ni qué se cambió. Es el mismo hueco que la guía señala con la creación de dba.bitacora. Hay que declarar ese periodo como un hueco de evidencia y comparar el estado actual del servidor (privilegios, columnas y triggers en el catálogo) contra lo autorizado, para detectar diferencias que la bitácora no muestra. Así se puede ver que algo cambió, pero no quién lo hizo.

**4. ¿Quién debería realizar la conciliación: el DBA que hizo los cambios u otra persona?**

Otra persona, que según POL-01 y POL-06 es el responsable de seguridad, o un auditor. El DBA es quien ejecuta los cambios y por eso no debe revisarse a sí mismo ya que tendría un conflicto de intereses y podría pasar por alto o justificar sus propios cambios sin autorización. El DBA puede apoyar con el acceso a la vista dba.bitacora y con aclaraciones técnicas, pero la conclusión de qué está autorizado y qué es un hallazgo la debe dar alguien independiente. Esto aplica la misma separación de funciones que se usa en toda la unidad.