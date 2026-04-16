-- ============================================================
--  SISTEMA DE INFORMACIÓN - TECNOMATIC MAV
-- ============================================================

CREATE DATABASE IF NOT EXISTS TecnomaticMav
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE TecnomaticMav;

-- ============================================================
--  MÓDULO: SEGURIDAD
-- ============================================================

CREATE TABLE Roles (
    idRoles INT NOT NULL AUTO_INCREMENT,
    Nombre_rol VARCHAR(45)  NOT NULL,
    PRIMARY KEY (idRoles)
);

CREATE TABLE Usuarios (
    idUsuarios INT NOT NULL AUTO_INCREMENT,
    Nombres VARCHAR(45)  NOT NULL,
    Contrasena VARCHAR(256) NOT NULL,
    Correo VARCHAR(150) NOT NULL UNIQUE,
    Apellidos    VARCHAR(50)  NOT NULL,
    Roles_idRoles INT         NOT NULL,
    PRIMARY KEY (idUsuarios),
    CONSTRAINT fk_usuarios_roles
	FOREIGN KEY (Roles_idRoles)
	REFERENCES Roles (idRoles)
	ON DELETE RESTRICT
	ON UPDATE CASCADE
);

-- ============================================================
--  MÓDULO: DOTACIONES E INVENTARIO
-- ============================================================

CREATE TABLE Categoria_productos (
    idCategorias INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    PRIMARY KEY (idCategorias)
);

CREATE TABLE Productos (
    idProductos INT NOT NULL AUTO_INCREMENT,
    Nombre_Producto VARCHAR(100)  NOT NULL,
    Tipo VARCHAR(50),
    Descripcion MEDIUMTEXT,
    Estado VARCHAR(30) NOT NULL DEFAULT 'Activo',
    Categoria_producto_idCategoria INT NOT NULL,
    PRIMARY KEY (idProductos),
    CONSTRAINT fk_productos_categoria
	FOREIGN KEY (Categoria_producto_idCategoria)
	REFERENCES Categoria_productos (idCategorias)
	ON DELETE RESTRICT
	ON UPDATE CASCADE
);

CREATE TABLE Inventarios (
    idInventarios INT NOT NULL AUTO_INCREMENT,
    Cantidad INT NOT NULL DEFAULT 0,
    Tipo_Movimiento VARCHAR(20) NOT NULL DEFAULT 'Entrada',
    Productos_idProductos INT NOT NULL,
    Productos_Categoria_idCategoria INT NOT NULL,
    PRIMARY KEY (idInventarios),
    CONSTRAINT fk_inventarios_productos
	FOREIGN KEY (Productos_idProductos)
	REFERENCES Productos (idProductos)
	ON DELETE RESTRICT
	ON UPDATE CASCADE,
    CONSTRAINT fk_inventarios_categoria
	FOREIGN KEY (Productos_Categoria_idCategoria)
	REFERENCES Categoria_productos (idCategorias)
	ON DELETE RESTRICT
	ON UPDATE CASCADE
);

-- ============================================================
--  MÓDULO: COTIZACIONES
-- ============================================================

CREATE TABLE Solicitud_Cotizaciones (
    idSolicitud_cotizaciones INT NOT NULL AUTO_INCREMENT,
    Correo VARCHAR(45) NOT NULL,
    Fecha DATE NOT NULL,
    Telefono VARCHAR(45),
    Estado VARCHAR(45)  NOT NULL DEFAULT 'Pendiente',
    Usuarios_idUsuarios INT NOT NULL,
    PRIMARY KEY (idSolicitud_cotizaciones),
    CONSTRAINT fk_solicitud_usuarios
	FOREIGN KEY (Usuarios_idUsuarios)
	REFERENCES Usuarios (idUsuarios)
	ON DELETE RESTRICT
	ON UPDATE CASCADE
);

CREATE TABLE Cotizaciones (
    idCotizaciones INT NOT NULL AUTO_INCREMENT,
    Fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Total_Estimado DECIMAL(10,2) NOT NULL DEFAULT 0,
    Estado VARCHAR(45)  NOT NULL DEFAULT 'En revision',
    Usuarios_idUsuarios INT NOT NULL,
    Solicitud_Cotizaciones_idSolicitud INT NOT NULL,
    PRIMARY KEY (idCotizaciones),
    CONSTRAINT fk_cotizaciones_usuarios
	FOREIGN KEY (Usuarios_idUsuarios)
	REFERENCES Usuarios (idUsuarios)
	ON DELETE RESTRICT
	ON UPDATE CASCADE,
    CONSTRAINT fk_cotizaciones_solicitud
	FOREIGN KEY (Solicitud_Cotizaciones_idSolicitud)
	REFERENCES Solicitud_Cotizaciones (idSolicitud_cotizaciones)
	ON DELETE RESTRICT
	ON UPDATE CASCADE
);

CREATE TABLE Detalle_Cotizaciones (
    idDetalle_Cotizaciones INT NOT NULL AUTO_INCREMENT,
    Cantidad INT NOT NULL DEFAULT 1,
    Estado VARCHAR(45) NOT NULL DEFAULT 'Activo',
    Cotizaciones_idCotizaciones INT NOT NULL,
    Productos_idProductos INT NOT NULL,
    PRIMARY KEY (idDetalle_Cotizaciones),
    CONSTRAINT fk_detalle_cot_cotizaciones
	FOREIGN KEY (Cotizaciones_idCotizaciones)
	REFERENCES Cotizaciones (idCotizaciones)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
    CONSTRAINT fk_detalle_cot_productos
	FOREIGN KEY (Productos_idProductos)
	REFERENCES Productos (idProductos)
	ON DELETE RESTRICT
	ON UPDATE CASCADE
);

-- ============================================================
--  MÓDULO: FACTURACIÓN Y ENTREGAS
-- ============================================================

CREATE TABLE Facturas (
    idFacturas INT NOT NULL AUTO_INCREMENT,
    Fecha DATE NOT NULL,
    Estado VARCHAR(50) NOT NULL DEFAULT 'Pendiente',
    Total DECIMAL(10,2)  NOT NULL DEFAULT 0,
    Usuarios_idUsuarios INT NOT NULL,
    Cotizaciones_idCotizaciones INT NOT NULL,
    PRIMARY KEY (idFacturas),
    CONSTRAINT fk_facturas_usuarios
        FOREIGN KEY (Usuarios_idUsuarios)
        REFERENCES Usuarios (idUsuarios)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_facturas_cotizaciones
        FOREIGN KEY (Cotizaciones_idCotizaciones)
        REFERENCES Cotizaciones (idCotizaciones)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE Detalle_Facturas (
    idDetalles INT NOT NULL AUTO_INCREMENT,
    Cantidad INT NOT NULL DEFAULT 1,
    Precio_Unitario DECIMAL(10,2) NOT NULL,
    Factura_idFactura INT NOT NULL,
    Productos_idProductos INT NOT NULL,
    Productos_Categoria_idCategoria INT NOT NULL,
    PRIMARY KEY (idDetalles),
    CONSTRAINT fk_detalle_fact_factura
	FOREIGN KEY (Factura_idFactura)
	REFERENCES Facturas (idFacturas)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
    CONSTRAINT fk_detalle_fact_productos
	FOREIGN KEY (Productos_idProductos)
	REFERENCES Productos (idProductos)
	ON DELETE RESTRICT
	ON UPDATE CASCADE,
    CONSTRAINT fk_detalle_fact_categoria
	FOREIGN KEY (Productos_Categoria_idCategoria)
	REFERENCES Categoria_productos (idCategorias)
	ON DELETE RESTRICT
	ON UPDATE CASCADE
);

CREATE TABLE Entregas (
    idEntregas INT NOT NULL AUTO_INCREMENT,
    Fecha_entrega DATE NOT NULL,
    Observaciones VARCHAR(255),
    Inventarios_idInventarios INT NOT NULL,
    Factura_idFactura INT NOT NULL,
    Usuarios_idUsuarios INT NOT NULL,
    PRIMARY KEY (idEntregas),
    CONSTRAINT fk_entregas_inventarios
	FOREIGN KEY (Inventarios_idInventarios)
	REFERENCES Inventarios (idInventarios)
	ON DELETE RESTRICT
	ON UPDATE CASCADE,
    CONSTRAINT fk_entregas_facturas
	FOREIGN KEY (Factura_idFactura)
	REFERENCES Facturas (idFacturas)
	ON DELETE RESTRICT
	ON UPDATE CASCADE,
    CONSTRAINT fk_entregas_usuarios
	FOREIGN KEY (Usuarios_idUsuarios)
	REFERENCES Usuarios (idUsuarios)
	ON DELETE RESTRICT
	ON UPDATE CASCADE
);

-- ============================================================
--  MÓDULO: POSTVENTA
-- ============================================================

CREATE TABLE Devoluciones (
    idDevoluciones INT NOT NULL AUTO_INCREMENT,
    Fecha DATE NOT NULL,
    Motivo  VARCHAR(255) NOT NULL,
    Facturas_idFacturas  INT NOT NULL,
    Productos_idProductos INT NOT NULL,
    Usuarios_idUsuarios  INT NOT NULL,
    PRIMARY KEY (idDevoluciones),
    CONSTRAINT fk_devoluciones_facturas
	FOREIGN KEY (Facturas_idFacturas)
	REFERENCES Facturas (idFacturas)
	ON DELETE RESTRICT
	ON UPDATE CASCADE,
    CONSTRAINT fk_devoluciones_productos
	FOREIGN KEY (Productos_idProductos)
	REFERENCES Productos (idProductos)
	ON DELETE RESTRICT
	ON UPDATE CASCADE,
    CONSTRAINT fk_devoluciones_usuarios
	FOREIGN KEY (Usuarios_idUsuarios)
	REFERENCES Usuarios (idUsuarios)
	ON DELETE RESTRICT
	ON UPDATE CASCADE
);


CREATE TABLE Garantias (
    idGarantias INT NOT NULL AUTO_INCREMENT,
    Fecha_inicio DATE NOT NULL,
    Fecha_fin DATE NOT NULL,
    Descripcion VARCHAR(255),
    Estado VARCHAR(45) NOT NULL DEFAULT 'Activa',
    Facturas_idFacturas INT NOT NULL,
    Productos_idProductos INT NOT NULL,
    Usuarios_idUsuarios  INT NOT NULL,
    PRIMARY KEY (idGarantias),
    CONSTRAINT fk_garantias_facturas
	FOREIGN KEY (Facturas_idFacturas)
	REFERENCES Facturas (idFacturas)
	ON DELETE RESTRICT
	ON UPDATE CASCADE,
    CONSTRAINT fk_garantias_productos
	FOREIGN KEY (Productos_idProductos)
	REFERENCES Productos (idProductos)
	ON DELETE RESTRICT
	ON UPDATE CASCADE,
    CONSTRAINT fk_garantias_usuarios
	FOREIGN KEY (Usuarios_idUsuarios)
	REFERENCES Usuarios (idUsuarios)
	ON DELETE RESTRICT
	ON UPDATE CASCADE
);