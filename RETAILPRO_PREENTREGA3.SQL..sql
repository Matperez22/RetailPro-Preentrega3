USE RetailPro;

-- =========================================================
-- PRE-ENTREGA 3 - RETAILPRO
-- Modelo de Ventas de Tecnologia
-- Alumno: Matias Perez
-- =========================================================


-- =========================================================
-- 1. ELIMINACION DE TABLAS SI YA EXISTEN
-- Se borran en orden inverso por las claves foraneas
-- =========================================================

DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS territorios;


-- =========================================================
-- 2. CREACION DE TABLAS
-- =========================================================


-- TABLA TERRITORIOS
CREATE TABLE territorios (
    id_territorio INT IDENTITY (1,1) PRIMARY KEY,
    region VARCHAR(50) NOT NULL,
    pais VARCHAR(50) NOT NULL,
    zona VARCHAR(50)
);


-- TABLA CLIENTES
CREATE TABLE clientes (
    id_cliente INT IDENTITY (1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    ciudad VARCHAR(100) NOT NULL,
    segmento VARCHAR(50),
    fecha_registro DATE,
    id_territorio INT,

    CONSTRAINT fk_cliente_territorio
        FOREIGN KEY (id_territorio)
        REFERENCES territorios(id_territorio)
);


-- TABLA CATEGORIAS
CREATE TABLE categorias (
    id_categoria INT IDENTITY (1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);


-- TABLA PRODUCTOS
CREATE TABLE productos (
    id_producto INT IDENTITY (1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    categoria_id INT NOT NULL,

    CONSTRAINT fk_producto_categoria
        FOREIGN KEY (categoria_id)
        REFERENCES categorias(id_categoria)
);


-- TABLA VENTAS
CREATE TABLE ventas (
    id_venta INT IDENTITY(1,1) PRIMARY KEY,
    fecha DATE NOT NULL,
    cliente_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,

    CONSTRAINT fk_venta_cliente
        FOREIGN KEY (cliente_id)
        REFERENCES clientes(id_cliente),

    CONSTRAINT fk_venta_producto
        FOREIGN KEY (producto_id)
        REFERENCES productos(id_producto)
);


-- =========================================================
-- 3. CARGA INICIAL DE DATOS
-- =========================================================


-- TERRITORIOS
INSERT INTO territorios (region, pais, zona)
VALUES
('Buenos Aires', 'Argentina', 'AMBA'),
('Centro', 'Argentina', 'Interior'),
('Litoral', 'Argentina', 'Interior');
SELECT * FROM territorios

-- CATEGORIAS
-- La consigna solicita al menos 3 categorias diferentes

INSERT INTO categorias (nombre)
VALUES
('Celulares'),
('Computacion'),
('Audio y TV');


-- PRODUCTOS
-- La consigna solicita al menos 5 productos

INSERT INTO productos (nombre, precio, categoria_id)
VALUES
('Samsung Galaxy A55', 650000.00, 1),
('Motorola Edge 50', 720000.00, 1),
('Notebook Lenovo IdeaPad', 950000.00, 2),
('Notebook HP Pavilion', 1100000.00, 2),
('Smart TV Samsung 50 pulgadas', 780000.00, 3);


-- CLIENTES
-- La consigna solicita al menos 3 clientes

INSERT INTO clientes
(nombre, email, ciudad, segmento, fecha_registro, id_territorio)
VALUES
('Juan Perez', 'juan.perez@email.com', 'Ciudadela', 'Particular', '2026-01-10', 1),
('Maria Gomez', 'maria.gomez@email.com', 'Rosario', 'Particular', '2026-02-15', 3),
('Carlos Lopez', 'carlos.lopez@email.com', 'Cordoba', 'Empresa', '2026-03-05', 2);


-- VENTAS
-- La consigna solicita al menos 10 transacciones

INSERT INTO ventas
(fecha, cliente_id, producto_id, cantidad)
VALUES
('2026-03-10', 1, 1, 1),
('2026-03-20', 2, 3, 1),
('2026-04-05', 3, 5, 2),
('2026-04-18', 1, 4, 1),
('2026-05-02', 2, 2, 1),
('2026-05-21', 3, 3, 2),
('2026-06-10', 1, 5, 1),
('2026-06-25', 2, 1, 1),
('2026-07-14', 3, 4, 1),
('2026-08-01', 1, 2, 1);
SELECT * FROM VENTAS;

-- =========================================================
-- 4. CONSULTAS DE CONTROL
-- Permiten verificar que los datos fueron cargados
-- correctamente.
-- =========================================================

SELECT * FROM territorios;
SELECT * FROM clientes;
SELECT * FROM categorias;
SELECT * FROM productos;
SELECT * FROM ventas;

-- =========================================================
-- 5. CONSULTA DE ANALISIS
-- Unir ventas con clientes, productos y categorias
-- =========================================================

SELECT
    v.id_venta,
    v.fecha,
    c.nombre AS cliente,
    p.nombre AS producto,
    cat.nombre AS categoria,
    v.cantidad,
    p.precio
FROM ventas v
INNER JOIN clientes c
    ON v.cliente_id = c.id_cliente
INNER JOIN productos p
    ON v.producto_id = p.id_producto
INNER JOIN categorias cat
    ON p.categoria_id = cat.id_categoria;


-- =========================================================
-- 6. PRUEBA DE INTEGRIDAD REFERENCIAL
-- =========================================================
-- Esta prueba intenta registrar una venta con un cliente
-- inexistente (cliente_id = 99).
-- SQL Server la rechaza por la FOREIGN KEY fk_venta_cliente.

/*
INSERT INTO ventas
(fecha, cliente_id, producto_id, cantidad)
VALUES
('2026-08-20', 99, 1, 1);
*/

