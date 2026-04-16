USE TecnomaticMav;
 
-- ============================================================
--  SECCIÓN 2: CONSULTAS CON JOIN
--  Combinación de dos o más tablas relacionadas
-- ============================================================
 
-- 1. Mostrar los usuarios con el nombre de su rol
SELECT U.Nombres, U.Apellidos, R.Nombre_rol
FROM Usuarios U
JOIN Roles R ON U.Roles_idRoles = R.idRoles;

-- 2. Listar los productos con el nombre de su categoría
SELECT P.Nombre_Producto, C.nombre AS Categoria
FROM Productos P
JOIN Categoria_productos C 
ON P.Categoria_producto_idCategoria = C.idCategorias;

-- 3. Mostrar las solicitudes de cotización con el nombre del cliente
SELECT S.idSolicitud_cotizaciones, U.Nombres, S.Estado
FROM Solicitud_Cotizaciones S
JOIN Usuarios U 
ON S.Usuarios_idUsuarios = U.idUsuarios;

-- 4. Ver qué administrador hizo cada cotización
SELECT C.idCotizaciones, U.Nombres, C.Total_Estimado
FROM Cotizaciones C
JOIN Usuarios U 
ON C.Usuarios_idUsuarios = U.idUsuarios;

-- 5. Mostrar las facturas junto con el cliente
SELECT F.idFacturas, U.Nombres, F.Total, F.Estado
FROM Facturas F
JOIN Usuarios U 
ON F.Usuarios_idUsuarios = U.idUsuarios;

-- 6. Mostrar el detalle de cotizaciones con el nombre del producto
SELECT DC.Cantidad, P.Nombre_Producto
FROM Detalle_Cotizaciones DC
JOIN Productos P 
ON DC.Productos_idProductos = P.idProductos;

-- 7. Mostrar facturas con los productos que tienen (JOIN múltiple)
SELECT F.idFacturas, P.Nombre_Producto, DF.Cantidad
FROM Facturas F
JOIN Detalle_Facturas DF 
ON F.idFacturas = DF.Factura_idFactura
JOIN Productos P 
ON DF.Productos_idProductos = P.idProductos;

-- 8. Mostrar entregas con el nombre del cliente
SELECT E.idEntregas, U.Nombres, E.Fecha_entrega
FROM Entregas E
JOIN Usuarios U 
ON E.Usuarios_idUsuarios = U.idUsuarios;

-- 9. Mostrar devoluciones con nombre del producto
SELECT D.idDevoluciones, P.Nombre_Producto, D.Motivo
FROM Devoluciones D
JOIN Productos P 
ON D.Productos_idProductos = P.idProductos;

-- 10. Mostrar garantías con el nombre del cliente y producto
SELECT G.idGarantias, U.Nombres, P.Nombre_Producto, G.Estado
FROM Garantias G
JOIN Usuarios U 
ON G.Usuarios_idUsuarios = U.idUsuarios
JOIN Productos P 
ON G.Productos_idProductos = P.idProductos;
