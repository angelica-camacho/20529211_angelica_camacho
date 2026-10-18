-- ACTIVIDAD 5 ANONIMIZACION
-- 12/10/2026 CAMACHO CASTAÑEDA ANGÉLICA MARÍA 4-1
-- GENERALIZAR EDAD
SELECT
    CASE
        WHEN edad BETWEEN 18 AND 30 THEN '18-30'
        WHEN edad BETWEEN 31 AND 45 THEN '31-45'
        ELSE '46+'
    END AS rango_edad,
    COUNT(*) AS total
FROM clientes
GROUP BY 1;
-- GENERALIZAR LA REGION
SELECT
    LEFT(codigo_postal, 2) AS region,
    COUNT(*) AS total
FROM clientes
GROUP BY 1;
-- COMBINAR ATRIBUTOS
SELECT
    CASE
        WHEN edad BETWEEN 18 AND 30 THEN '18-30'
        WHEN edad BETWEEN 31 AND 45 THEN '31-45'
        ELSE '46+'
    END AS rango_edad,

    LEFT(codigo_postal, 2) AS region,

    COUNT(*) AS total

FROM clientes
GROUP BY 1, 2;
-- SUPRIMIR GRUPOS PEQUEÑOS
SELECT
    CASE
        WHEN edad BETWEEN 18 AND 30 THEN '18-30'
        WHEN edad BETWEEN 31 AND 45 THEN '31-45'
        ELSE '46+'
    END AS rango_edad,

    LEFT(codigo_postal, 2) AS region,

    COUNT(*) AS total

FROM clientes
GROUP BY 1, 2
HAVING COUNT(*) >= 5;
-- RETO (REDUCIR EL RIESGO DE REIDENTIFICACIÓN)
SELECT 
	CASE
		WHEN edad BETWEEN 18 AND 35 THEN '18-35'
		ELSE '36+'
	END AS rango_edad,
	LEFT(codigo_postal, 1) AS region,
	COUNT  (*) AS total
FROM clientes
GROUP BY 1,2
HAVING COUNT (*) >=10;
-- ACTIVIDAD 7: RETENCIÓN DE DATOS
SELECT *
FROM clientes
WHERE fecha_alta <
      CURRENT_DATE - INTERVAL '5 years';
-- VERIFICACIÓN FINAL (ÁREA SOPORTE) (REALIZADO EN EL ROL DE SOPORTE)
-- (ACCESO PERMITIDO)
SELECT * FROM v_clientes_soporte;
-- (ACCESO DENEGADO)
SELECT * FROM clientes;
-- VERIFICACIÓN FINAL (ÁREA DE ANÁLITICA) (REALIZADO EN EL ROL DE ANALITICA)
-- (ACCESO PERMITIDO)
SELECT * FROM analitica.clientes;
-- (ACCESO DENEGADO)
SELECT * FROM pii.mapa_cliente;
SELECT * FROM public.clientes;