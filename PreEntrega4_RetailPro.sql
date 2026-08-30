-- Consulta 1: Resumen ejecutivo mensual

SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;


-- Consulta 2: Ranking de productos Top 5

SELECT TOP 5
    id_producto,
    SUM(cantidad * precio_unitario) AS total_facturado,
    SUM(cantidad) AS unidades_vendidas
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;


-- Consulta 3: Clientes recurrentes

SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;


-- Consulta 4: Meses por encima o por debajo del promedio

WITH facturacion_mensual AS (
    SELECT
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)

SELECT
    mes,
    total_facturado,
    CASE
        WHEN total_facturado > (SELECT AVG(total_facturado) FROM facturacion_mensual)
            THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM facturacion_mensual
ORDER BY mes;


-- HALLAZGOS DE NEGOCIO

-- 1. Abril fue el mes con mayor facturación, alcanzando $2.660.000.
-- Mayo quedó muy cerca, con una facturación de $2.620.000.

-- 2. El producto con id 3 fue el de mayor facturación,
-- alcanzando un total de $2.850.000 y 3 unidades vendidas.

-- 3. El cliente con id 3 fue el que más dinero gastó,
-- con un total de $4.560.000 en 3 pedidos.

-- 4. Solo abril y mayo tuvieron una facturación
-- por encima del promedio mensual.