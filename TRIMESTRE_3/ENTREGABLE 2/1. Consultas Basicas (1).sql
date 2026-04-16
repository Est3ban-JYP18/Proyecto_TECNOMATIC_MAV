USE TecnomaticMav;
 
-- ============================================================
--  SECCIÓN 1: CONSULTAS BÁSICAS
--  Operaciones simples sobre una sola tabla
-- ============================================================
 
-- Consulta 1
-- Enunciado: Listar todos los usuarios registrados en el sistema
--            mostrando su nombre completo, correo y rol asignado.
SELECT
    idUsuarios,
    CONCAT(Nombres, ' ', Apellidos) AS Nombre_Completo,
    Correo,
    Roles_idRoles                   AS Rol
FROM Usuarios
ORDER BY Apellidos ASC;
 
-- ------------------------------------------------------------
 
-- Consulta 2
-- Enunciado: Mostrar todos los productos que están actualmente
--            en estado 'Activo', ordenados alfabéticamente
--            por nombre de producto.
SELECT
    idProductos,
    Nombre_Producto,
    Tipo,
    Estado
FROM Productos
WHERE Estado = 'Activo'
ORDER BY Nombre_Producto ASC;
 
-- ------------------------------------------------------------
 
-- Consulta 3
-- Enunciado: Consultar todas las facturas que están pendientes
--            de pago, mostrando el ID, la fecha y el total a cobrar,
--            ordenadas de mayor a menor valor.
SELECT
    idFacturas,
    Fecha,
    Estado,
    Total
FROM Facturas
WHERE Estado = 'Pendiente'
ORDER BY Total DESC;
 
-- ------------------------------------------------------------
 
-- Consulta 4
-- Enunciado: Listar todas las cotizaciones realizadas durante
--            el primer semestre del año 2025 (enero a junio),
--            mostrando su estado y total estimado.
SELECT
    idCotizaciones,
    Fecha,
    Total_Estimado,
    Estado
FROM Cotizaciones
WHERE Fecha BETWEEN '2025-01-01' AND '2025-06-30'
ORDER BY Fecha ASC;
 
-- ------------------------------------------------------------
 
-- Consulta 5
-- Enunciado: Mostrar el inventario actual de todos los productos,
--            indicando cuáles tienen menos de 30 unidades disponibles
--            para identificar posibles quiebres de stock.
SELECT
    idInventarios,
    Productos_idProductos,
    Cantidad,
    Tipo_Movimiento,
    CASE
        WHEN Cantidad < 30 THEN 'Stock crítico'
        WHEN Cantidad < 60 THEN 'Stock bajo'
        ELSE 'Stock normal'
    END AS Alerta_Stock
FROM Inventarios
ORDER BY Cantidad ASC;
 
-- ------------------------------------------------------------
 
-- Consulta 6
-- Enunciado: Listar todas las devoluciones registradas en el sistema
--            mostrando la fecha, el motivo y la factura asociada,
--            ordenadas por fecha de devolución más reciente.
SELECT
    idDevoluciones,
    Fecha,
    Motivo,
    Facturas_idFacturas,
    Productos_idProductos
FROM Devoluciones
ORDER BY Fecha DESC;
 
-- ------------------------------------------------------------
 
-- Consulta 7
-- Enunciado: Consultar cuántas solicitudes de cotización hay
--            por cada estado (Aprobada, Pendiente, Rechazada)
--            para conocer el volumen de gestión comercial.
SELECT
    Estado,
    COUNT(*) AS Total_Solicitudes
FROM Solicitud_Cotizaciones
GROUP BY Estado
ORDER BY Total_Solicitudes DESC;
 
-- ------------------------------------------------------------
 
-- Consulta 8
-- Enunciado: Mostrar todas las garantías que se encuentran
--            actualmente activas y cuya fecha de vencimiento
--            es dentro del próximo año.
SELECT
    idGarantias,
    Fecha_inicio,
    Fecha_fin,
    Estado,
    Descripcion
FROM Garantias
WHERE Estado = 'Activa'
ORDER BY Fecha_fin ASC;
 
-- ------------------------------------------------------------
 
-- Consulta 9
-- Enunciado: Calcular el total facturado por mes durante el año 2025,
--            para analizar el comportamiento de ventas a lo largo del año.
SELECT
    MONTH(Fecha)      AS Mes,
    MONTHNAME(Fecha)  AS Nombre_Mes,
    COUNT(*)          AS Cantidad_Facturas,
    SUM(Total)        AS Total_Facturado
FROM Facturas
WHERE YEAR(Fecha) = 2025
GROUP BY MONTH(Fecha), MONTHNAME(Fecha)
ORDER BY Mes ASC;
 
-- ------------------------------------------------------------
 
-- Consulta 10
-- Enunciado: Listar todos los productos agrupados por categoría,
--            mostrando cuántos productos pertenecen a cada una
--            para conocer la distribución del catálogo.
SELECT
    Categoria_producto_idCategoria AS ID_Categoria,
    COUNT(*)                       AS Total_Productos
FROM Productos
GROUP BY Categoria_producto_idCategoria
ORDER BY Total_Productos DESC;