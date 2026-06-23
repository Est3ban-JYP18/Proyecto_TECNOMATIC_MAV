-- ============================================================
--  SISTEMA DE INFORMACIÓN - TECNOMATIC MAV
--  Script completo con datos de prueba
-- ============================================================

DROP DATABASE IF EXISTS tecnomaticmav;

CREATE DATABASE tecnomaticmav
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE tecnomaticmav;

-- ============================================================
--  MÓDULO: SEGURIDAD
-- ============================================================

CREATE TABLE Roles (
    idRoles    INT  NOT NULL AUTO_INCREMENT,
    Nombre_rol ENUM('Administrador','Contador','Cliente') NOT NULL,
    PRIMARY KEY (idRoles)
);

CREATE TABLE Usuarios (
    idUsuarios    INT          NOT NULL AUTO_INCREMENT,
    Nombres       VARCHAR(100) NOT NULL,
    Apellidos     VARCHAR(100) NOT NULL,
    Correo        VARCHAR(150) NOT NULL UNIQUE,
    Contrasena    VARCHAR(255) NOT NULL,
    Roles_idRoles INT          NOT NULL,
    PRIMARY KEY (idUsuarios),
    CONSTRAINT fk_usuarios_roles
        FOREIGN KEY (Roles_idRoles)
        REFERENCES Roles (idRoles)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- ============================================================
--  MÓDULO: PRODUCTOS E INVENTARIO
-- ============================================================

CREATE TABLE Categoria_productos (
    idCategorias INT          NOT NULL AUTO_INCREMENT,
    nombre       VARCHAR(100) NOT NULL,
    descripcion  VARCHAR(255),
    PRIMARY KEY (idCategorias)
);

CREATE TABLE Productos (
    idProductos                    INT            NOT NULL AUTO_INCREMENT,
    Nombre_Producto                VARCHAR(100)   NOT NULL,
    Tipo                           VARCHAR(50),
    Descripcion                    MEDIUMTEXT,
    Precio                         DECIMAL(10,2)  NOT NULL CHECK (Precio > 0),
    Imagen                         VARCHAR(500)   NULL,
    Estado                         ENUM('Activo','Inactivo','Agotado') DEFAULT 'Activo',
    Categoria_producto_idCategoria INT            NOT NULL,
    PRIMARY KEY (idProductos),
    CONSTRAINT fk_productos_categoria
        FOREIGN KEY (Categoria_producto_idCategoria)
        REFERENCES Categoria_productos (idCategorias)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE Movimientos_Inventario (
    idMovimiento          INT      NOT NULL AUTO_INCREMENT,
    Productos_idProductos INT      NOT NULL,
    Tipo_Movimiento       ENUM('Entrada','Salida') NOT NULL,
    Cantidad              INT      NOT NULL CHECK (Cantidad > 0),
    Fecha                 DATETIME DEFAULT CURRENT_TIMESTAMP,
    Observacion           VARCHAR(255),
    PRIMARY KEY (idMovimiento),
    CONSTRAINT fk_movimientos_productos
        FOREIGN KEY (Productos_idProductos)
        REFERENCES Productos (idProductos)
        ON DELETE CASCADE
);

CREATE TABLE Stock (
    Productos_idProductos INT      NOT NULL,
    Cantidad_Actual       INT      NOT NULL DEFAULT 0 CHECK (Cantidad_Actual >= 0),
    Ultima_Actualizacion  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (Productos_idProductos),
    CONSTRAINT fk_stock_productos
        FOREIGN KEY (Productos_idProductos)
        REFERENCES Productos (idProductos)
        ON DELETE CASCADE
);

-- ============================================================
--  MÓDULO: FACTURACIÓN Y ENTREGAS
-- ============================================================

CREATE TABLE Facturas (
    idFacturas          INT           NOT NULL AUTO_INCREMENT,
    Fecha               DATETIME      DEFAULT CURRENT_TIMESTAMP,
    Estado              ENUM('Pendiente','Pagada','Cancelada') DEFAULT 'Pendiente',
    Total               DECIMAL(10,2) NOT NULL DEFAULT 0,
    Usuarios_idUsuarios INT           NOT NULL,
    PRIMARY KEY (idFacturas),
    CONSTRAINT fk_facturas_usuarios
        FOREIGN KEY (Usuarios_idUsuarios)
        REFERENCES Usuarios (idUsuarios)
        ON DELETE RESTRICT
);

CREATE TABLE Detalle_Facturas (
    idDetalles            INT           NOT NULL AUTO_INCREMENT,
    Factura_idFactura     INT           NOT NULL,
    Productos_idProductos INT           NOT NULL,
    Cantidad              INT           NOT NULL CHECK (Cantidad > 0),
    Precio_Unitario       DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (idDetalles),
    CONSTRAINT fk_detalle_fact_factura
        FOREIGN KEY (Factura_idFactura)
        REFERENCES Facturas (idFacturas)
        ON DELETE CASCADE,
    CONSTRAINT fk_detalle_fact_productos
        FOREIGN KEY (Productos_idProductos)
        REFERENCES Productos (idProductos)
        ON DELETE RESTRICT
);

CREATE TABLE Entregas (
    idEntregas          INT  NOT NULL AUTO_INCREMENT,
    Factura_idFactura   INT  NOT NULL,
    Usuarios_idUsuarios INT  NOT NULL,
    Fecha_entrega       DATE NOT NULL,
    Estado_Entrega      ENUM('En Proceso','Entregado','Devuelto') DEFAULT 'En Proceso',
    Observaciones       VARCHAR(255),
    PRIMARY KEY (idEntregas),
    CONSTRAINT fk_entregas_facturas
        FOREIGN KEY (Factura_idFactura)
        REFERENCES Facturas (idFacturas)
        ON DELETE CASCADE,
    CONSTRAINT fk_entregas_usuarios
        FOREIGN KEY (Usuarios_idUsuarios)
        REFERENCES Usuarios (idUsuarios)
        ON DELETE RESTRICT
);

-- ============================================================
--  MÓDULO: POSTVENTA
-- ============================================================

CREATE TABLE Devoluciones (
    idDevoluciones        INT  NOT NULL AUTO_INCREMENT,
    Facturas_idFacturas   INT  NOT NULL,
    Productos_idProductos INT  NOT NULL,
    Usuarios_idUsuarios   INT  NOT NULL,
    Fecha                 DATE NOT NULL,
    Motivo                VARCHAR(255) NOT NULL,
    Cantidad              INT  NOT NULL DEFAULT 1,
    PRIMARY KEY (idDevoluciones),
    CONSTRAINT fk_devoluciones_facturas
        FOREIGN KEY (Facturas_idFacturas)
        REFERENCES Facturas (idFacturas)
        ON DELETE RESTRICT,
    CONSTRAINT fk_devoluciones_productos
        FOREIGN KEY (Productos_idProductos)
        REFERENCES Productos (idProductos)
        ON DELETE RESTRICT,
    CONSTRAINT fk_devoluciones_usuarios
        FOREIGN KEY (Usuarios_idUsuarios)
        REFERENCES Usuarios (idUsuarios)
        ON DELETE RESTRICT
);

CREATE TABLE Garantias (
    idGarantias           INT  NOT NULL AUTO_INCREMENT,
    Facturas_idFacturas   INT  NOT NULL,
    Productos_idProductos INT  NOT NULL,
    Usuarios_idUsuarios   INT  NOT NULL,
    Fecha_inicio          DATE NOT NULL,
    Fecha_fin             DATE NOT NULL,
    Estado                ENUM('Activa','En Reclamación','Finalizada','Anulada') DEFAULT 'Activa',
    Descripcion           VARCHAR(255),
    PRIMARY KEY (idGarantias),
    CONSTRAINT fk_garantias_facturas
        FOREIGN KEY (Facturas_idFacturas)
        REFERENCES Facturas (idFacturas)
        ON DELETE RESTRICT,
    CONSTRAINT fk_garantias_productos
        FOREIGN KEY (Productos_idProductos)
        REFERENCES Productos (idProductos)
        ON DELETE RESTRICT,
    CONSTRAINT fk_garantias_usuarios
        FOREIGN KEY (Usuarios_idUsuarios)
        REFERENCES Usuarios (idUsuarios)
        ON DELETE RESTRICT
);

-- ============================================================
--  DATOS: ROLES
-- ============================================================

INSERT INTO Roles (Nombre_rol) VALUES
('Administrador'),
('Contador'),
('Cliente');

-- ============================================================
--  DATOS: USUARIOS
-- ============================================================

INSERT INTO Usuarios (Nombres, Apellidos, Correo, Contrasena, Roles_idRoles) VALUES
('Admin',     'Tecnomatic',  'admin@tecnomatic.com',    'admin123',    1),
('Carlos',    'Ramirez',     'contador@tecnomatic.com', 'contador123', 2),
('Laura',     'Gomez',       'laura@gmail.com',         'cliente123',  3),
('Santiago',  'Torres',      'santiago@gmail.com',      'cliente123',  3),
('Valentina', 'Cruz',        'valentina@gmail.com',     'cliente123',  3);

-- ============================================================
--  DATOS: CATEGORÍAS
-- ============================================================

INSERT INTO Categoria_productos (nombre, descripcion) VALUES
('Protección Corporal',  'Ropa de trabajo y overoles de seguridad industrial'),
('Protección de Pies',   'Calzado de seguridad y botas industriales'),
('Protección de Manos',  'Guantes de seguridad para diferentes riesgos'),
('Protección de Cabeza', 'Cascos y elementos de protección craneal');

-- ============================================================
--  DATOS: PRODUCTOS (con imagen)
-- ============================================================

INSERT INTO Productos (Nombre_Producto, Tipo, Descripcion, Precio, Imagen, Estado, Categoria_producto_idCategoria) VALUES
(
  'Overol Tela Jean Reforzado', 'Overol',
  'Overol de trabajo en tela jean 100% algodón con refuerzo en rodillas y codos. Ideal para trabajos de alto desgaste.',
  89900, 'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?w=500&q=80', 'Activo', 1
),
(
  'Overol Tyvek Desechable', 'Overol',
  'Overol desechable en material Tyvek, resistente a partículas y salpicaduras de líquidos.',
  25000, 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=500&q=80', 'Activo', 1
),
(
  'Chaleco Reflectivo Alta Visibilidad', 'Chaleco',
  'Chaleco de seguridad vial con cintas reflectivas de 5 cm. Norma ANSI/ISEA 107.',
  32000, 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=500&q=80', 'Activo', 1
),
(
  'Camisa Manga Larga Ignífuga', 'Camisa',
  'Camisa FR con protección contra arco eléctrico y llama directa. Certificación NFPA 70E.',
  145000, 'https://images.unsplash.com/photo-1598300042247-d088f8ab3a91?w=500&q=80', 'Activo', 1
),
(
  'Pantalón de Trabajo Reforzado', 'Pantalón',
  'Pantalón industrial ripstop con rodilleras extraíbles. Resistente a rasgaduras y abrasión.',
  75000, 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=500&q=80', 'Agotado', 1
),
(
  'Bota de Seguridad Punta de Acero', 'Bota',
  'Bota industrial con puntera de acero certificada 200 J de impacto. Suela antideslizante.',
  189000, 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&q=80', 'Activo', 2
),
(
  'Bota Caucho PVC Caña Alta', 'Bota',
  'Bota de caucho PVC para trabajos en zonas húmedas y productos químicos. Tallas 36 a 46.',
  65000, 'https://images.unsplash.com/photo-1608256246200-53e635b5b65f?w=500&q=80', 'Activo', 2
),
(
  'Zapato Dieléctrico Antideslizante', 'Zapato',
  'Zapato sin partes metálicas. Protección contra descargas eléctricas hasta 18 kV.',
  210000, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=500&q=80', 'Inactivo', 2
),
(
  'Guante de Vaqueta Reforzado', 'Guante',
  'Guante de cuero vaqueta con refuerzo en palma y dedos. Uso en construcción y soldadura ligera.',
  18500, 'https://images.unsplash.com/photo-1585771724684-38269d6639fd?w=500&q=80', 'Activo', 3
),
(
  'Guante Nitrilo Negro Calibre 15', 'Guante',
  'Guante de nitrilo resistente a químicos, aceites e hidrocarburos. Sin látex.',
  12000, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=500&q=80', 'Activo', 3
),
(
  'Casco de Seguridad Tipo II Ratchet', 'Casco',
  'Casco con ajuste ratchet de 6 puntos en HDPE de alta densidad. Norma ANSI Z89.1.',
  45000, 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=500&q=80', 'Activo', 4
),
(
  'Casco con Careta Facial Integrada', 'Casco',
  'Casco con protector facial abatible en policarbonato transparente contra impactos y salpicaduras.',
  98000, 'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=500&q=80', 'Activo', 4
);

-- ============================================================
--  DATOS: STOCK
-- ============================================================

INSERT INTO Stock (Productos_idProductos, Cantidad_Actual) VALUES
(1, 50), (2, 100), (3, 75),  (4, 30),
(5, 0),  (6, 40),  (7, 60),  (8, 0),
(9, 80), (10, 120),(11, 55), (12, 25);

-- ============================================================
--  DATOS: MOVIMIENTOS DE INVENTARIO
-- ============================================================

INSERT INTO Movimientos_Inventario (Productos_idProductos, Tipo_Movimiento, Cantidad, Observacion) VALUES
(1,  'Entrada', 50,  'Stock inicial overol jean'),
(2,  'Entrada', 100, 'Stock inicial overol tyvek'),
(3,  'Entrada', 75,  'Stock inicial chaleco reflectivo'),
(4,  'Entrada', 30,  'Stock inicial camisa ignífuga'),
(5,  'Entrada', 20,  'Stock inicial pantalón reforzado'),
(5,  'Salida',  20,  'Venta corporativa - agotado'),
(6,  'Entrada', 40,  'Stock inicial botas punta acero'),
(7,  'Entrada', 60,  'Stock inicial botas caucho'),
(9,  'Entrada', 80,  'Stock inicial guantes vaqueta'),
(10, 'Entrada', 120, 'Stock inicial guantes nitrilo'),
(11, 'Entrada', 55,  'Stock inicial casco ratchet'),
(12, 'Entrada', 25,  'Stock inicial casco con careta');

-- ============================================================
--  DATOS: FACTURAS
-- ============================================================

INSERT INTO Facturas (Fecha, Estado, Total, Usuarios_idUsuarios) VALUES
('2026-04-01 10:30:00', 'Pagada',    342900, 3),
('2026-04-15 14:00:00', 'Pagada',    107500, 4),
('2026-05-02 09:15:00', 'Pendiente', 189000, 5),
('2026-05-10 16:45:00', 'Cancelada',  57500, 3),
('2026-05-12 11:00:00', 'Pendiente', 143000, 4);

-- ============================================================
--  DATOS: DETALLE DE FACTURAS
-- ============================================================

-- Factura 1: Laura — overol + chaleco + bota + guante
INSERT INTO Detalle_Facturas (Factura_idFactura, Productos_idProductos, Cantidad, Precio_Unitario) VALUES
(1, 1,  1, 89900),
(1, 3,  2, 32000),
(1, 6,  1, 189000),
(1, 10, 1, 12000);

-- Factura 2: Santiago — guantes + casco + nitrilo
INSERT INTO Detalle_Facturas (Factura_idFactura, Productos_idProductos, Cantidad, Precio_Unitario) VALUES
(2, 9,  2, 18500),
(2, 11, 1, 45000),
(2, 10, 3, 12000);

-- Factura 3: Valentina — botas punta acero
INSERT INTO Detalle_Facturas (Factura_idFactura, Productos_idProductos, Cantidad, Precio_Unitario) VALUES
(3, 6,  1, 189000);

-- Factura 4: Laura canceló — chaleco + guantes
INSERT INTO Detalle_Facturas (Factura_idFactura, Productos_idProductos, Cantidad, Precio_Unitario) VALUES
(4, 3,  1, 32000),
(4, 10, 2, 12000);

-- Factura 5: Santiago pendiente — overol tyvek + guante vaqueta
INSERT INTO Detalle_Facturas (Factura_idFactura, Productos_idProductos, Cantidad, Precio_Unitario) VALUES
(5, 2,  3, 25000),
(5, 9,  4, 18500);

-- ============================================================
--  DATOS: ENTREGAS
-- ============================================================

INSERT INTO Entregas (Factura_idFactura, Usuarios_idUsuarios, Fecha_entrega, Estado_Entrega, Observaciones) VALUES
(1, 3, '2026-04-03', 'Entregado',  'Entrega en sede principal'),
(2, 4, '2026-04-17', 'Entregado',  'Entrega a domicilio'),
(3, 5, '2026-05-06', 'En Proceso', 'Pendiente despacho'),
(5, 4, '2026-05-15', 'En Proceso', 'En preparación');

-- ============================================================
--  DATOS: DEVOLUCIONES
-- ============================================================

INSERT INTO Devoluciones (Facturas_idFacturas, Productos_idProductos, Usuarios_idUsuarios, Fecha, Motivo, Cantidad) VALUES
(1, 3, 3, '2026-04-10', 'Talla incorrecta del chaleco',       1),
(2, 9, 4, '2026-04-20', 'Guante defectuoso en costura',       1);

-- ============================================================
--  DATOS: GARANTÍAS
-- ============================================================

INSERT INTO Garantias (Facturas_idFacturas, Productos_idProductos, Usuarios_idUsuarios, Fecha_inicio, Fecha_fin, Estado, Descripcion) VALUES
(1, 6,  3, '2026-04-03', '2027-04-03', 'Activa',           'Garantía 1 año bota punta acero'),
(1, 1,  3, '2026-04-03', '2026-10-03', 'Activa',           'Garantía 6 meses overol jean'),
(2, 11, 4, '2026-04-17', '2027-04-17', 'Activa',           'Garantía 1 año casco ratchet'),
(1, 3,  3, '2026-04-03', '2026-07-03', 'En Reclamación',   'Chaleco con falla en cinta reflectiva');

-- ============================================================
--  VERIFICACIÓN FINAL
-- ============================================================

SELECT 'Roles'        AS Tabla, COUNT(*) AS Registros FROM Roles       UNION ALL
SELECT 'Usuarios',               COUNT(*)              FROM Usuarios    UNION ALL
SELECT 'Categorías',             COUNT(*)              FROM Categoria_productos UNION ALL
SELECT 'Productos',              COUNT(*)              FROM Productos   UNION ALL
SELECT 'Stock',                  COUNT(*)              FROM Stock       UNION ALL
SELECT 'Movimientos',            COUNT(*)              FROM Movimientos_Inventario UNION ALL
SELECT 'Facturas',               COUNT(*)              FROM Facturas    UNION ALL
SELECT 'Detalle Facturas',       COUNT(*)              FROM Detalle_Facturas UNION ALL
SELECT 'Entregas',               COUNT(*)              FROM Entregas    UNION ALL
SELECT 'Devoluciones',           COUNT(*)              FROM Devoluciones UNION ALL
SELECT 'Garantías',              COUNT(*)              FROM Garantias;

ALTER TABLE Devoluciones 
ADD COLUMN Estado ENUM('Pendiente', 'Aprobada', 'Rechazada') NOT NULL DEFAULT 'Pendiente';