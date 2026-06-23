USE TecnomaticMav;
 
-- ============================================================
--  SECCIÓN 3: CONSULTAS CON SUBCONSULTAS
--  Consultas anidadas para análisis más complejos
-- ============================================================
 
-- 11. Mostrar productos que tienen inventario mayor a 100
SELECT Nombre_Producto
FROM Productos
WHERE idProductos IN (
    SELECT Productos_idProductos
    FROM Inventarios
    WHERE Cantidad > 100
);

-- 12. Mostrar clientes que han hecho solicitudes aprobadas
SELECT Nombres, Apellidos
FROM Usuarios
WHERE idUsuarios IN (
    SELECT Usuarios_idUsuarios
    FROM Solicitud_Cotizaciones
    WHERE Estado = 'Aprobada'
);

-- 13. Mostrar facturas con total mayor al promedio
SELECT idFacturas, Total
FROM Facturas
WHERE Total > (
    SELECT AVG(Total)
    FROM Facturas
);

-- 14. Mostrar productos que han sido devueltos
SELECT Nombre_Producto
FROM Productos
WHERE idProductos IN (
    SELECT Productos_idProductos
    FROM Devoluciones
);

-- 15. Mostrar usuarios que tienen facturas pendientes
SELECT Nombres
FROM Usuarios
WHERE idUsuarios IN (
    SELECT Usuarios_idUsuarios
    FROM Facturas
    WHERE Estado = 'Pendiente'
);

-- 16. Mostrar cotizaciones que pertenecen a solicitudes aprobadas
SELECT idCotizaciones
FROM Cotizaciones
WHERE Solicitud_Cotizaciones_idSolicitud IN (
    SELECT idSolicitud_cotizaciones
    FROM Solicitud_Cotizaciones
    WHERE Estado = 'Aprobada'
);

-- 17. Mostrar productos que aparecen en detalle de facturas
SELECT Nombre_Producto
FROM Productos
WHERE idProductos IN (
    SELECT Productos_idProductos
    FROM Detalle_Facturas
);

-- 18. Mostrar clientes que han hecho devoluciones
SELECT Nombres
FROM Usuarios
WHERE idUsuarios IN (
    SELECT Usuarios_idUsuarios
    FROM Devoluciones
);

-- 19. Mostrar facturas que tienen más de 1 producto (uso de COUNT)
SELECT idFacturas
FROM Facturas
WHERE idFacturas IN (
    SELECT Factura_idFactura
    FROM Detalle_Facturas
    GROUP BY Factura_idFactura
    HAVING COUNT(Productos_idProductos) > 1
);

-- 20. Mostrar productos que tienen garantía activa
SELECT Nombre_Producto
FROM Productos
WHERE idProductos IN (
    SELECT Productos_idProductos
    FROM Garantias
    WHERE Estado = 'Activa'
);