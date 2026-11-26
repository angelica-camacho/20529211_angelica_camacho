-- Camacho Castañeda Angélica María 4-1
-- Gestión de seguridad y desempeño de bases de datos
-- LAB-03 — Políticas prácticas, gobierno de datos y evidencias

COMMENT ON TABLE clientes IS 'Clientes de Comercializadora Norte. Propietario: Gerencia Comercial. Custodio: DBA. Clasificación: confidencial (contiene datos personales).';
COMMENT ON COLUMN clientes.id IS 'Identificador interno del cliente. Generado por el sistema.';
COMMENT ON COLUMN clientes.nombre IS 'Nombre completo. Dato personal identificador directo.';
COMMENT ON COLUMN clientes.correo IS 'Correo de contacto. Dato personal. Uso: notificaciones al cliente.';
COMMENT ON COLUMN clientes.rfc IS 'RFC del cliente. Dato personal. Uso: facturación. Cambios auditados en auditoria.cambios_clientes.';
COMMENT ON COLUMN clientes.edad IS 'Edad en años cumplidos. Dato personal. Uso: analítica agregada.';
COMMENT ON COLUMN clientes.telefono IS 'Teléfono de contacto. Dato personal. Uso: contacto de urgencia y verificación de seguridad. Acceso restringido por perfil.';
COMMENT ON COLUMN clientes.ciudad IS 'Ciudad de residencia o servicio. Dato personal (ubicación). Uso: asignación de zona de servicio y logística.';
COMMENT ON COLUMN clientes.codigo_postal IS 'Código postal del cliente. Dato personal (ubicación). Uso: cobertura de servicio, cálculo de fletes y estadística agregada.';
COMMENT ON COLUMN clientes.fecha_alta IS 'Fecha de alta del cliente. Dato operativo, asignado por el sistema. Uso: antigüedad del cliente y cálculo de plazos de retención.';
COMMENT ON COLUMN clientes.segmento IS 'Segmento comercial del cliente. Dato derivado, asignado por Gerencia Comercial. Uso: analítica y estrategia de ventas. Puede asociarse a un titular, por lo que se trata con la misma reserva que los datos personales.';

SELECT c.ordinal_position          AS pos,
       c.column_name               AS columna,
       c.data_type                 AS tipo,
       c.character_maximum_length  AS longitud,
       c.is_nullable               AS acepta_nulos,
       c.column_default            AS valor_por_defecto,
       col_description('public.clientes'::regclass, c.ordinal_position) AS descripcion
FROM information_schema.columns c
WHERE c.table_schema = 'public'
  AND c.table_name = 'clientes'
ORDER BY c.ordinal_position;