-- =====================================================================
-- ALIGLOBAL S.A.C. - Base de datos comercial (version enriquecida)
-- Grupo 08 - Entregable Parcial / SQL Server for Analytics
-- =====================================================================
-- IMPORTANTE: este bloque elimina cualquier base de datos previa con
-- alguno de estos nombres, para garantizar una creacion 100% limpia y
-- evitar los errores de "already exists" / llaves duplicadas.
-- Ajusta la lista de nombres si tu equipo uso otro nombre distinto.
USE master;
GO
DECLARE @dbNames TABLE (Nombre SYSNAME);
INSERT INTO @dbNames (Nombre) VALUES ('ALIGLOBAL_BD'), ('ALIGLOBAL_BD_Actualizada');

DECLARE @db SYSNAME, @sql NVARCHAR(MAX);
DECLARE cur CURSOR FOR SELECT Nombre FROM @dbNames WHERE Nombre IN (SELECT name FROM sys.databases);
OPEN cur;
FETCH NEXT FROM cur INTO @db;
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql = N'ALTER DATABASE [' + @db + N'] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE [' + @db + N'];';
    EXEC sp_executesql @sql;
    FETCH NEXT FROM cur INTO @db;
END
CLOSE cur;
DEALLOCATE cur;
GO

CREATE DATABASE ALIGLOBAL_BD;
GO
USE ALIGLOBAL_BD;
GO

CREATE TABLE Categorias (
    ID_Categoria INT IDENTITY(1,1) PRIMARY KEY,
    Nombre_Categoria VARCHAR(50) NOT NULL,
    Descripcion VARCHAR(200) NULL
);
GO

CREATE TABLE Clientes (
    ID_Cliente INT IDENTITY(1,1) PRIMARY KEY,
    Razon_Social VARCHAR(120) NOT NULL,
    RUC CHAR(11) NOT NULL UNIQUE,
    Ciudad VARCHAR(50) NOT NULL,
    Tipo_Canal VARCHAR(30) NOT NULL,
    Dias_Credito INT NOT NULL DEFAULT 0
);
GO

CREATE TABLE Productos (
    ID_Producto INT IDENTITY(1,1) PRIMARY KEY,
    Codigo_SKU VARCHAR(20) NOT NULL UNIQUE,
    Nombre_Producto VARCHAR(100) NOT NULL,
    ID_Categoria INT NOT NULL,
    Unidad_Medida VARCHAR(20) NOT NULL,
    Precio_Unitario DECIMAL(10,2) NOT NULL,
    Costo_Referencial DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_Productos_Categorias FOREIGN KEY (ID_Categoria)
        REFERENCES Categorias(ID_Categoria)
);
GO

CREATE TABLE Pedidos (
    ID_Pedido INT IDENTITY(1,1) PRIMARY KEY,
    ID_Cliente INT NOT NULL,
    Fecha_Pedido DATE NOT NULL,
    Estado_Entrega VARCHAR(25) NOT NULL,
    Metodo_Pago VARCHAR(30) NOT NULL,
    CONSTRAINT FK_Pedidos_Clientes FOREIGN KEY (ID_Cliente)
        REFERENCES Clientes(ID_Cliente)
);
GO

CREATE TABLE Detalle_Pedidos (
    ID_Detalle INT IDENTITY(1,1) PRIMARY KEY,
    ID_Pedido INT NOT NULL,
    ID_Producto INT NOT NULL,
    Cantidad INT NOT NULL,
    Precio_Venta DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_Detalle_Pedidos FOREIGN KEY (ID_Pedido)
        REFERENCES Pedidos(ID_Pedido),
    CONSTRAINT FK_Detalle_Productos FOREIGN KEY (ID_Producto)
        REFERENCES Productos(ID_Producto)
);
GO

INSERT INTO Categorias (Nombre_Categoria, Descripcion) VALUES
('Aceites Comestibles', 'Aceites vegetales de soya, girasol y mezclas'),
('Fideos y Pastas', 'Fideos cortos, largos y pastas fortificadas'),
('Salsas y Condimentos', 'Mayonesas, ketchup, mostaza y pastas de aji'),
('Detergentes en Polvo', 'Detergentes para lavado manual y automatico'),
('Jabones de Lavar', 'Barras de jabon para el lavado de ropa'),
('Galletas Dulces', 'Galletas rellenas, banadas y wafer'),
('Galletas Saladas', 'Galletas de soda y crackers aperitivas'),
('Harinas Industriales', 'Harina de trigo para panificacion y pasteleria'),
('Premezclas de Panaderia', 'Mezclas listas para reposteria y panaderia'),
('Margarinas y Mantecas', 'Grasas industriales y margarinas de mesa'),
('Cuidado del Cabello', 'Champus, acondicionadores y tratamientos capilares'),
('Jabones de Tocador', 'Jabon de barra antibacterial y cosmetico'),
('Lavavajillas', 'Lavavajillas en pasta y geles liquidos'),
('Limpiadores de Superficie', 'Desinfectantes multiusos y ceras para pisos'),
('Conservas de Pescado', 'Atunes, sardinas y caballa enlatada'),
('Cereales de Desayuno', 'Cereales expandidos a base de maiz y avena'),
('Nutricion Animal', 'Alimento balanceado para caninos y felinos'),
('Chocolateria y Confites', 'Barras con sabor a chocolate y coberturas'),
('Bebidas Instantaneas', 'Refrescos en polvo enriquecidos con vitaminas'),
('Leches y Derivados', 'Mezclas lacteas compuestas y evaporadas');
GO

-- 35 clientes en total (20 originales + 15 nuevos) para mayor variedad de plazas y canales
INSERT INTO Clientes (Razon_Social, RUC, Ciudad, Tipo_Canal, Dias_Credito) VALUES
('Distribuidora El Sol S.A.C.', '20100456781', 'Lima', 'Mayorista', 30),
('Supermercados del Centro S.A.', '20233455612', 'Huancayo', 'Supermercados', 45),
('Comercializadora Los Andes E.I.R.L.', '20455677890', 'Arequipa', 'Mayorista', 15),
('Bodegas Unidas del Norte S.R.L.', '20566788901', 'Trujillo', 'Tradicional', 0),
('Hipermercados Costa Peru S.A.', '20600122345', 'Lima', 'Supermercados', 60),
('Corporacion Belen S.A.C.', '20344566789', 'Iquitos', 'Mayorista', 30),
('Abarrotes Don Lucho S.A.', '20122344556', 'Piura', 'Tradicional', 0),
('Distribuidora San Martin S.R.L.', '20499877665', 'Tarapoto', 'Mayorista', 30),
('Mercados Mayoristas del Sur S.A.', '20511233445', 'Cusco', 'Mayorista', 45),
('Minimarket La Esquina S.A.C.', '20600988771', 'Lima', 'Tradicional', 0),
('Cadena Comercial Selva Central', '20444555667', 'Pucallpa', 'Supermercados', 30),
('Distribuidora Imperial E.I.R.L.', '20333444555', 'Cusco', 'Mayorista', 15),
('Grupo Logistico Chimor S.A.C.', '20555666778', 'Chimbote', 'Mayorista', 30),
('Mega Abarrotero Grau S.A.', '20111222334', 'Piura', 'Mayorista', 45),
('Comercial Santa Rosa S.R.L.', '20488999001', 'Chiclayo', 'Tradicional', 0),
('Super Mayorista Mantaro S.A.C.', '20522334455', 'Huancayo', 'Mayorista', 30),
('Bodegon Chiclayano S.A.', '20311223344', 'Chiclayo', 'Tradicional', 0),
('Distribuidora Mistiana S.A.C.', '20600445566', 'Arequipa', 'Mayorista', 45),
('Comercial El Dorado E.I.R.L.', '20477889900', 'Tarapoto', 'Mayorista', 15),
('Tiendas del Pacifico S.A.', '20533445566', 'Lima', 'Supermercados', 60),
('Distribuidora Amazonica S.R.L.', '20611223301', 'Iquitos', 'Mayorista', 30),
('Supermercados Andinos S.A.', '20611223302', 'Cusco', 'Supermercados', 45),
('Abarrotes La Familia E.I.R.L.', '20611223303', 'Lima', 'Tradicional', 0),
('Comercial Piurana del Norte S.A.C.', '20611223304', 'Piura', 'Mayorista', 30),
('Mayorista San Jose S.R.L.', '20611223305', 'Trujillo', 'Mayorista', 15),
('Hiper Market Sur S.A.', '20611223306', 'Tacna', 'Supermercados', 60),
('Bodega Central Chincha S.A.C.', '20611223307', 'Chincha', 'Tradicional', 0),
('Distribuidora Huanuco Express S.R.L.', '20611223308', 'Huanuco', 'Mayorista', 30),
('Comercial Lambayeque S.A.', '20611223309', 'Chiclayo', 'Mayorista', 45),
('Minimarket Los Olivos S.A.C.', '20611223310', 'Lima', 'Tradicional', 0),
('Mayorista Cajamarca S.R.L.', '20611223311', 'Cajamarca', 'Mayorista', 15),
('Supermercados del Valle S.A.', '20611223312', 'Ica', 'Supermercados', 45),
('Distribuidora Selva Norte E.I.R.L.', '20611223313', 'Tarapoto', 'Mayorista', 30),
('Comercial Puno Andino S.A.C.', '20611223314', 'Puno', 'Mayorista', 30),
('Tiendas Express Callao S.A.', '20611223315', 'Callao', 'Tradicional', 0);
GO

-- 35 productos en total (20 originales + 15 nuevos), cubriendo las 20 categorias
INSERT INTO Productos (Codigo_SKU, Nombre_Producto, ID_Categoria, Unidad_Medida, Precio_Unitario, Costo_Referencial) VALUES
('SKU-ACE-01', 'Aceite Vegetal Puro 1L', 1, 'Caja 12 Unid', 78.50, 58.00),
('SKU-ACE-02', 'Aceite Mezcla Familiar 900ml', 1, 'Caja 12 Unid', 65.00, 48.20),
('SKU-FID-01', 'Fideo Spaghetti Clasico 500g', 2, 'Paquete 20 Unid', 42.00, 29.50),
('SKU-FID-02', 'Fideo Corto Codito 250g', 2, 'Paquete 20 Unid', 24.50, 16.80),
('SKU-SAL-01', 'Mayonesa Alacena Tradicional 400g', 3, 'Caja 24 Unid', 96.00, 68.00),
('SKU-SAL-02', 'Crema de Aji Tare 400g', 3, 'Caja 24 Unid', 108.00, 75.50),
('SKU-DET-01', 'Detergente Polvo Floral 800g', 4, 'Paquete 15 Unid', 85.00, 59.00),
('SKU-DET-02', 'Detergente Antibacterial 4.5kg', 4, 'Saco 4 Unid', 115.00, 82.00),
('SKU-JAB-01', 'Jabon de Lavar Azul 200g', 5, 'Caja 36 Unid', 62.00, 41.00),
('SKU-GAL-01', 'Galleta Vainilla Familiar 6pk', 6, 'Caja 12 Unid', 32.00, 21.00),
('SKU-GAL-02', 'Galleta Rellena Fresa 40g', 6, 'Caja 24 Unid', 28.50, 18.00),
('SKU-GAL-03', 'Galleta Soda Crocante 35g', 7, 'Caja 24 Unid', 22.00, 14.50),
('SKU-HAR-01', 'Harina Trigo Extra Saco 50kg', 8, 'Saco 50kg', 145.00, 112.00),
('SKU-HAR-02', 'Harina Trigo Pastelera 1kg', 8, 'Paquete 10 Unid', 38.00, 26.00),
('SKU-MAR-01', 'Margarina de Mesa con Sal 200g', 10, 'Caja 24 Unid', 54.00, 36.50),
('SKU-JAB-02', 'Jabon Tocador Almendras 90g', 12, 'Display 12 Unid', 26.00, 17.20),
('SKU-LAV-01', 'Lavavajillas Pasta Limon 450g', 13, 'Caja 24 Unid', 58.00, 38.00),
('SKU-LIM-01', 'Limpiador Multiuso Lavanda 900ml', 14, 'Caja 12 Unid', 44.00, 28.50),
('SKU-CON-01', 'Filete de Atun en Aceite 170g', 15, 'Caja 48 Unid', 185.00, 135.00),
('SKU-LEC-01', 'Mezcla Lactea Compuesta 395g', 20, 'Caja 24 Unid', 79.00, 56.00),
('SKU-ACE-03', 'Aceite de Girasol Premium 5L', 1, 'Caja 4 Unid', 145.00, 108.00),
('SKU-FID-03', 'Fideo Tallarin Ancho 500g', 2, 'Paquete 20 Unid', 43.50, 30.20),
('SKU-GAL-04', 'Galleta Soda Integral 35g', 7, 'Caja 24 Unid', 23.50, 15.20),
('SKU-PRE-01', 'Premezcla para Panque de Vainilla 400g', 9, 'Caja 12 Unid', 36.00, 24.00),
('SKU-MAR-02', 'Margarina Vegetal Multiuso 100g', 10, 'Display 24 Unid', 21.00, 13.80),
('SKU-CAB-01', 'Shampoo Manzanilla Suave 750ml', 11, 'Caja 12 Unid', 68.00, 47.50),
('SKU-JAB-03', 'Jabon Tocador Glicerina 90g', 12, 'Display 12 Unid', 27.50, 18.00),
('SKU-LAV-02', 'Lavavajillas Gel Manzana 500ml', 13, 'Caja 12 Unid', 61.00, 40.50),
('SKU-LIM-02', 'Cera Liquida para Pisos 900ml', 14, 'Caja 12 Unid', 52.00, 34.00),
('SKU-CON-02', 'Conserva de Caballa en Salsa de Tomate 425g', 15, 'Caja 48 Unid', 172.00, 126.00),
('SKU-CER-01', 'Cereal de Maiz Tostado 320g', 16, 'Caja 12 Unid', 46.00, 31.00),
('SKU-PET-01', 'Alimento Balanceado para Perro Adulto 3kg', 17, 'Bolsa 6 Unid', 132.00, 96.00),
('SKU-CHO-01', 'Barra de Chocolate con Leche 100g', 18, 'Caja 24 Unid', 39.00, 26.50),
('SKU-BEB-01', 'Refresco Instantaneo Sabor Naranja 25g', 19, 'Caja 36 Unid', 30.00, 19.50),
('SKU-LEC-02', 'Leche Evaporada Entera 400g', 20, 'Caja 24 Unid', 74.00, 52.00);
GO

-- 150 pedidos en total (20 originales + 130 nuevos), distribuidos entre enero y agosto 2026
INSERT INTO Pedidos (ID_Cliente, Fecha_Pedido, Estado_Entrega, Metodo_Pago) VALUES
(1, '2026-08-01', 'Entregado', 'Factura a 30d'),
(2, '2026-08-02', 'Entregado', 'Factura a 45d'),
(3, '2026-08-03', 'Entregado', 'Factura a 15d'),
(4, '2026-08-03', 'Entregado', 'Transferencia'),
(5, '2026-08-05', 'Entregado', 'Factura a 60d'),
(6, '2026-08-06', 'Entregado', 'Factura a 30d'),
(7, '2026-08-08', 'Cancelado', 'Transferencia'),
(8, '2026-08-10', 'Entregado', 'Factura a 30d'),
(9, '2026-08-12', 'Entregado', 'Factura a 45d'),
(10, '2026-08-13', 'Entregado', 'Transferencia'),
(11, '2026-08-15', 'Entregado', 'Factura a 30d'),
(12, '2026-08-16', 'Entregado', 'Factura a 15d'),
(13, '2026-08-18', 'En Ruta', 'Factura a 30d'),
(14, '2026-08-20', 'Entregado', 'Factura a 45d'),
(15, '2026-08-21', 'Entregado', 'Transferencia'),
(16, '2026-08-22', 'En Ruta', 'Factura a 30d'),
(17, '2026-08-25', 'Pendiente', 'Transferencia'),
(18, '2026-08-26', 'En Ruta', 'Factura a 45d'),
(19, '2026-08-27', 'Pendiente', 'Factura a 15d'),
(20, '2026-08-28', 'Pendiente', 'Factura a 60d'),
(22, '2026-01-01', 'Cancelado', 'Factura a 45d'),
(16, '2026-01-02', 'Entregado', 'Factura a 30d'),
(14, '2026-01-03', 'Entregado', 'Factura a 45d'),
(4, '2026-01-03', 'Entregado', 'Transferencia'),
(28, '2026-01-03', 'Entregado', 'Factura a 30d'),
(5, '2026-01-04', 'Pendiente', 'Factura a 60d'),
(3, '2026-01-08', 'Entregado', 'Factura a 15d'),
(6, '2026-01-08', 'Entregado', 'Factura a 30d'),
(19, '2026-01-10', 'Entregado', 'Factura a 15d'),
(13, '2026-01-18', 'Pendiente', 'Factura a 30d'),
(15, '2026-01-19', 'En Ruta', 'Transferencia'),
(28, '2026-01-23', 'Entregado', 'Factura a 30d'),
(30, '2026-01-24', 'Entregado', 'Transferencia'),
(22, '2026-01-28', 'Entregado', 'Factura a 45d'),
(18, '2026-02-01', 'Entregado', 'Factura a 45d'),
(30, '2026-02-01', 'En Ruta', 'Contado'),
(15, '2026-02-02', 'Cancelado', 'Transferencia'),
(26, '2026-02-02', 'Cancelado', 'Factura a 60d'),
(35, '2026-02-02', 'Entregado', 'Transferencia'),
(35, '2026-02-03', 'Entregado', 'Contado'),
(10, '2026-02-04', 'Entregado', 'Transferencia'),
(15, '2026-02-08', 'Entregado', 'Transferencia'),
(12, '2026-02-09', 'En Ruta', 'Factura a 15d'),
(33, '2026-02-10', 'Pendiente', 'Factura a 30d'),
(23, '2026-02-12', 'En Ruta', 'Transferencia'),
(27, '2026-02-12', 'En Ruta', 'Contado'),
(25, '2026-02-13', 'En Ruta', 'Factura a 15d'),
(3, '2026-02-13', 'Entregado', 'Factura a 15d'),
(13, '2026-02-13', 'Entregado', 'Factura a 30d'),
(34, '2026-02-14', 'Entregado', 'Factura a 30d'),
(27, '2026-02-15', 'En Ruta', 'Contado'),
(28, '2026-02-19', 'Entregado', 'Factura a 30d'),
(35, '2026-02-22', 'Cancelado', 'Transferencia'),
(28, '2026-02-22', 'Entregado', 'Factura a 30d'),
(20, '2026-02-24', 'Entregado', 'Factura a 60d'),
(18, '2026-02-25', 'Entregado', 'Factura a 45d'),
(15, '2026-02-28', 'Entregado', 'Transferencia'),
(20, '2026-02-28', 'En Ruta', 'Factura a 60d'),
(33, '2026-03-02', 'Entregado', 'Factura a 30d'),
(5, '2026-03-03', 'Pendiente', 'Factura a 60d'),
(31, '2026-03-05', 'En Ruta', 'Factura a 15d'),
(34, '2026-03-09', 'En Ruta', 'Factura a 30d'),
(1, '2026-03-13', 'Entregado', 'Factura a 30d'),
(9, '2026-03-14', 'Entregado', 'Factura a 45d'),
(1, '2026-03-15', 'Cancelado', 'Factura a 30d'),
(16, '2026-03-18', 'Entregado', 'Factura a 30d'),
(34, '2026-03-18', 'Entregado', 'Factura a 30d'),
(3, '2026-03-18', 'Entregado', 'Factura a 15d'),
(20, '2026-03-20', 'Entregado', 'Factura a 60d'),
(17, '2026-03-21', 'Entregado', 'Contado'),
(28, '2026-03-23', 'Entregado', 'Factura a 30d'),
(31, '2026-03-24', 'Entregado', 'Factura a 15d'),
(28, '2026-03-26', 'En Ruta', 'Factura a 30d'),
(27, '2026-03-29', 'Entregado', 'Transferencia'),
(16, '2026-03-30', 'Entregado', 'Factura a 30d'),
(35, '2026-04-02', 'Entregado', 'Contado'),
(7, '2026-04-05', 'Pendiente', 'Contado'),
(24, '2026-04-05', 'Cancelado', 'Factura a 30d'),
(27, '2026-04-06', 'Entregado', 'Transferencia'),
(30, '2026-04-07', 'Entregado', 'Transferencia'),
(2, '2026-04-08', 'Pendiente', 'Factura a 45d'),
(32, '2026-04-09', 'Entregado', 'Factura a 45d'),
(11, '2026-04-09', 'Pendiente', 'Factura a 30d'),
(28, '2026-04-12', 'Entregado', 'Factura a 30d'),
(8, '2026-04-13', 'En Ruta', 'Factura a 30d'),
(22, '2026-04-13', 'Entregado', 'Factura a 45d'),
(29, '2026-04-18', 'Entregado', 'Factura a 45d'),
(3, '2026-04-19', 'En Ruta', 'Factura a 15d'),
(21, '2026-04-22', 'Cancelado', 'Factura a 30d'),
(16, '2026-04-22', 'Pendiente', 'Factura a 30d'),
(20, '2026-04-23', 'Entregado', 'Factura a 60d'),
(22, '2026-04-23', 'Entregado', 'Factura a 45d'),
(25, '2026-04-23', 'Entregado', 'Factura a 15d'),
(5, '2026-04-28', 'Entregado', 'Factura a 60d'),
(26, '2026-04-28', 'Entregado', 'Factura a 60d'),
(7, '2026-05-02', 'En Ruta', 'Transferencia'),
(14, '2026-05-05', 'Cancelado', 'Factura a 45d'),
(23, '2026-05-05', 'Entregado', 'Transferencia'),
(21, '2026-05-07', 'Entregado', 'Factura a 30d'),
(13, '2026-05-08', 'Entregado', 'Factura a 30d'),
(3, '2026-05-12', 'Entregado', 'Factura a 15d'),
(9, '2026-05-13', 'Pendiente', 'Factura a 45d'),
(24, '2026-05-15', 'Entregado', 'Factura a 30d'),
(21, '2026-05-15', 'Cancelado', 'Factura a 30d'),
(12, '2026-05-17', 'Entregado', 'Factura a 15d'),
(32, '2026-05-17', 'Entregado', 'Factura a 45d'),
(9, '2026-05-18', 'Entregado', 'Factura a 45d'),
(34, '2026-05-20', 'Entregado', 'Factura a 30d'),
(27, '2026-05-22', 'Entregado', 'Transferencia'),
(5, '2026-05-23', 'En Ruta', 'Factura a 60d'),
(28, '2026-05-24', 'En Ruta', 'Factura a 30d'),
(1, '2026-05-26', 'Cancelado', 'Factura a 30d'),
(30, '2026-05-30', 'Entregado', 'Transferencia'),
(7, '2026-05-30', 'Entregado', 'Transferencia'),
(4, '2026-06-02', 'En Ruta', 'Transferencia'),
(16, '2026-06-03', 'Pendiente', 'Factura a 30d'),
(6, '2026-06-04', 'Entregado', 'Factura a 30d'),
(19, '2026-06-04', 'Entregado', 'Factura a 15d'),
(32, '2026-06-07', 'Entregado', 'Factura a 45d'),
(11, '2026-06-10', 'Entregado', 'Factura a 30d'),
(14, '2026-06-12', 'Pendiente', 'Factura a 45d'),
(34, '2026-06-15', 'Entregado', 'Factura a 30d'),
(2, '2026-06-16', 'Entregado', 'Factura a 45d'),
(13, '2026-06-19', 'Pendiente', 'Factura a 30d'),
(21, '2026-06-20', 'Pendiente', 'Factura a 30d'),
(21, '2026-06-24', 'Entregado', 'Factura a 30d'),
(7, '2026-06-26', 'Entregado', 'Transferencia'),
(27, '2026-06-26', 'Pendiente', 'Contado'),
(20, '2026-06-29', 'Entregado', 'Factura a 60d'),
(19, '2026-07-03', 'En Ruta', 'Factura a 15d'),
(18, '2026-07-06', 'Entregado', 'Factura a 45d'),
(29, '2026-07-08', 'En Ruta', 'Factura a 45d'),
(10, '2026-07-08', 'Pendiente', 'Contado'),
(5, '2026-07-09', 'Entregado', 'Factura a 60d'),
(15, '2026-07-12', 'Entregado', 'Contado'),
(30, '2026-07-14', 'Cancelado', 'Transferencia'),
(35, '2026-07-22', 'Entregado', 'Transferencia'),
(25, '2026-07-22', 'Pendiente', 'Factura a 15d'),
(21, '2026-07-26', 'Entregado', 'Factura a 30d'),
(14, '2026-07-31', 'Entregado', 'Factura a 45d'),
(4, '2026-08-03', 'Entregado', 'Transferencia'),
(17, '2026-08-05', 'Entregado', 'Transferencia'),
(13, '2026-08-05', 'Entregado', 'Factura a 30d'),
(18, '2026-08-13', 'En Ruta', 'Factura a 45d'),
(14, '2026-08-15', 'Entregado', 'Factura a 45d'),
(17, '2026-08-17', 'En Ruta', 'Transferencia'),
(28, '2026-08-18', 'En Ruta', 'Factura a 30d'),
(27, '2026-08-26', 'Entregado', 'Transferencia'),
(11, '2026-08-26', 'Pendiente', 'Factura a 30d'),
(5, '2026-08-27', 'Cancelado', 'Factura a 60d');
GO

-- 297 lineas de detalle en total (20 originales + 277 nuevas)
INSERT INTO Detalle_Pedidos (ID_Pedido, ID_Producto, Cantidad, Precio_Venta) VALUES
(1, 1, 50, 78.50),
(1, 3, 40, 42.00),
(2, 5, 30, 96.00),
(2, 7, 25, 85.00),
(3, 2, 60, 65.00),
(4, 4, 15, 24.50),
(5, 8, 45, 115.00),
(5, 13, 20, 145.00),
(6, 9, 35, 62.00),
(8, 10, 50, 32.00),
(9, 11, 40, 28.50),
(10, 12, 10, 22.00),
(11, 14, 25, 38.00),
(12, 15, 30, 54.00),
(13, 16, 20, 26.00),
(14, 17, 35, 58.00),
(15, 18, 15, 44.00),
(16, 19, 25, 185.00),
(18, 20, 30, 79.00),
(20, 1, 80, 77.00),
(22, 7, 24, 84.43),
(23, 34, 25, 29.15),
(23, 30, 17, 171.57),
(24, 9, 38, 61.91),
(24, 30, 56, 170.00),
(24, 34, 37, 29.90),
(24, 21, 45, 144.26),
(25, 11, 50, 28.29),
(25, 31, 59, 45.00),
(25, 29, 50, 51.25),
(25, 17, 38, 56.68),
(26, 19, 31, 180.75),
(27, 35, 34, 72.11),
(27, 6, 55, 107.01),
(27, 9, 36, 60.54),
(28, 22, 23, 42.74),
(28, 35, 34, 73.63),
(28, 30, 47, 171.51),
(29, 25, 32, 20.67),
(30, 25, 57, 20.71),
(30, 27, 48, 27.13),
(31, 32, 41, 129.12),
(31, 15, 31, 52.43),
(32, 11, 44, 28.48),
(32, 30, 35, 166.98),
(32, 9, 52, 61.24),
(33, 6, 18, 106.84),
(34, 12, 39, 21.56),
(34, 4, 58, 24.01),
(34, 17, 27, 57.79),
(34, 25, 36, 20.84),
(35, 6, 44, 104.82),
(35, 31, 32, 44.69),
(36, 5, 25, 95.29),
(36, 3, 11, 40.99),
(39, 16, 17, 25.59),
(39, 9, 23, 61.19),
(40, 17, 20, 57.61),
(40, 24, 16, 35.96),
(40, 11, 29, 28.14),
(40, 8, 34, 113.54),
(41, 13, 59, 141.09),
(41, 5, 53, 93.99),
(41, 16, 17, 25.69),
(42, 23, 52, 23.17),
(43, 5, 36, 93.16),
(43, 33, 16, 38.79),
(43, 22, 33, 42.76),
(44, 10, 27, 31.97),
(44, 28, 44, 60.30),
(44, 12, 39, 21.85),
(44, 34, 56, 29.49),
(45, 21, 15, 144.26),
(45, 16, 38, 25.44),
(46, 30, 41, 168.58),
(46, 25, 21, 20.91),
(47, 14, 48, 37.18),
(47, 23, 27, 23.29),
(47, 17, 43, 57.23),
(47, 22, 15, 43.43),
(48, 27, 25, 27.13),
(48, 32, 51, 130.77),
(49, 29, 54, 50.79),
(49, 2, 52, 63.52),
(49, 6, 40, 106.64),
(49, 19, 32, 182.52),
(50, 22, 26, 42.55),
(50, 23, 56, 22.96),
(50, 30, 17, 167.83),
(51, 13, 27, 143.86),
(51, 14, 58, 37.69),
(52, 7, 33, 83.21),
(52, 13, 10, 141.43),
(54, 18, 45, 43.97),
(54, 3, 18, 41.11),
(55, 7, 31, 83.67),
(55, 1, 13, 76.58),
(55, 19, 40, 180.85),
(55, 31, 14, 44.78),
(56, 32, 46, 128.64),
(56, 5, 15, 95.85),
(56, 4, 17, 24.50),
(57, 15, 38, 53.11),
(57, 34, 47, 29.37),
(57, 25, 29, 20.99),
(58, 7, 23, 84.87),
(59, 17, 21, 56.53),
(59, 6, 20, 106.55),
(60, 27, 48, 27.05),
(61, 19, 24, 179.85),
(61, 3, 60, 41.90),
(61, 15, 47, 53.66),
(61, 30, 22, 170.25),
(62, 8, 27, 113.78),
(62, 35, 14, 73.62),
(62, 15, 60, 52.48),
(63, 19, 54, 180.14),
(63, 29, 35, 50.91),
(64, 33, 15, 38.41),
(64, 35, 37, 73.11),
(66, 17, 53, 56.66),
(66, 2, 46, 64.68),
(66, 6, 11, 106.66),
(67, 3, 51, 41.33),
(67, 12, 27, 21.63),
(68, 28, 40, 60.94),
(68, 32, 31, 129.42),
(69, 7, 41, 83.50),
(69, 11, 35, 27.89),
(69, 22, 45, 43.26),
(70, 30, 26, 167.29),
(71, 8, 10, 114.40),
(71, 26, 44, 67.30),
(71, 33, 13, 38.37),
(72, 34, 41, 29.66),
(72, 24, 58, 35.60),
(73, 14, 18, 37.16),
(74, 29, 50, 50.63),
(74, 32, 25, 130.45),
(75, 20, 15, 77.94),
(75, 1, 17, 76.67),
(76, 8, 27, 113.31),
(76, 10, 40, 31.44),
(76, 32, 25, 131.92),
(76, 19, 19, 181.99),
(77, 13, 27, 144.41),
(77, 33, 36, 38.73),
(77, 9, 60, 60.77),
(79, 1, 47, 77.85),
(79, 19, 52, 182.67),
(80, 10, 45, 31.37),
(80, 29, 34, 51.63),
(80, 35, 30, 72.79),
(80, 31, 54, 45.82),
(81, 25, 36, 20.91),
(81, 15, 57, 52.45),
(82, 25, 47, 20.45),
(82, 10, 16, 31.36),
(82, 32, 38, 131.50),
(82, 3, 39, 40.87),
(83, 10, 51, 31.43),
(84, 5, 26, 95.37),
(84, 31, 54, 45.09),
(85, 6, 30, 105.99),
(85, 22, 58, 43.01),
(85, 35, 44, 72.86),
(86, 5, 53, 93.80),
(87, 15, 16, 53.08),
(87, 6, 55, 107.22),
(88, 29, 29, 50.70),
(90, 3, 13, 41.15),
(91, 23, 25, 23.10),
(91, 24, 46, 35.49),
(92, 11, 34, 27.71),
(92, 12, 25, 21.75),
(93, 10, 52, 31.48),
(93, 15, 39, 52.40),
(93, 30, 53, 171.49),
(93, 17, 14, 57.21),
(94, 23, 29, 23.12),
(94, 20, 34, 77.10),
(94, 28, 16, 60.73),
(94, 17, 46, 56.67),
(95, 19, 46, 180.97),
(95, 2, 59, 64.74),
(95, 26, 13, 67.48),
(96, 19, 53, 182.90),
(96, 15, 59, 53.60),
(96, 23, 18, 23.26),
(96, 13, 50, 143.38),
(98, 20, 12, 78.50),
(99, 9, 36, 60.75),
(99, 6, 18, 105.33),
(99, 19, 33, 183.82),
(100, 11, 40, 28.43),
(100, 17, 28, 57.94),
(101, 8, 24, 112.04),
(101, 30, 56, 171.28),
(101, 5, 35, 95.06),
(102, 6, 17, 105.62);
INSERT INTO Detalle_Pedidos (ID_Pedido, ID_Producto, Cantidad, Precio_Venta) VALUES
(102, 26, 53, 66.89),
(102, 1, 26, 77.91),
(103, 24, 49, 35.43),
(103, 7, 45, 84.70),
(103, 15, 49, 52.91),
(105, 5, 29, 95.74),
(105, 30, 17, 170.19),
(106, 3, 17, 41.99),
(106, 20, 44, 76.86),
(107, 25, 57, 20.60),
(107, 30, 44, 170.43),
(108, 10, 49, 31.84),
(108, 27, 27, 27.01),
(108, 7, 33, 82.53),
(109, 29, 16, 51.77),
(109, 16, 33, 25.99),
(110, 4, 17, 23.90),
(110, 26, 39, 67.90),
(110, 18, 23, 42.80),
(111, 4, 25, 24.34),
(113, 14, 45, 37.81),
(113, 5, 23, 93.72),
(114, 22, 48, 43.22),
(114, 10, 19, 31.04),
(115, 35, 17, 73.55),
(115, 17, 11, 57.41),
(116, 1, 25, 78.01),
(116, 23, 11, 23.21),
(117, 17, 36, 56.48),
(117, 4, 57, 24.15),
(118, 31, 33, 45.24),
(119, 29, 49, 51.23),
(120, 34, 51, 29.37),
(121, 4, 35, 24.50),
(122, 7, 15, 82.64),
(122, 32, 19, 129.32),
(122, 29, 27, 50.54),
(123, 25, 48, 20.66),
(123, 34, 60, 29.49),
(123, 19, 51, 183.34),
(124, 28, 36, 60.80),
(124, 29, 39, 50.97),
(125, 27, 52, 27.03),
(125, 7, 19, 83.10),
(125, 21, 40, 143.64),
(126, 6, 15, 107.45),
(127, 7, 47, 83.87),
(127, 24, 45, 35.95),
(127, 9, 17, 60.75),
(128, 23, 48, 23.48),
(128, 28, 16, 59.74),
(128, 4, 23, 24.19),
(129, 31, 32, 45.79),
(129, 15, 33, 53.75),
(130, 18, 37, 43.44),
(131, 18, 27, 42.72),
(132, 22, 19, 42.20),
(132, 23, 35, 23.19),
(133, 10, 11, 31.75),
(134, 34, 36, 29.29),
(135, 22, 59, 43.14),
(135, 11, 48, 28.45),
(135, 24, 13, 35.01),
(135, 20, 58, 77.00),
(137, 6, 52, 105.64),
(138, 32, 58, 129.12),
(138, 29, 32, 51.24),
(138, 27, 28, 27.03),
(139, 34, 48, 29.46),
(139, 20, 23, 76.76),
(139, 3, 23, 41.12),
(139, 15, 58, 53.62),
(140, 19, 41, 180.12),
(140, 21, 21, 143.90),
(141, 25, 42, 20.81),
(141, 35, 52, 73.02),
(142, 5, 39, 94.38),
(142, 26, 30, 67.84),
(142, 3, 46, 41.47),
(143, 27, 30, 27.01),
(143, 19, 49, 180.40),
(143, 8, 54, 113.14),
(144, 6, 47, 105.55),
(144, 28, 15, 59.90),
(144, 7, 29, 83.46),
(145, 15, 50, 52.50),
(145, 22, 42, 42.34),
(145, 11, 59, 27.81),
(146, 23, 26, 22.87),
(146, 10, 48, 31.23),
(146, 16, 58, 25.34),
(147, 12, 50, 21.97),
(148, 30, 40, 169.11),
(148, 29, 29, 51.13),
(148, 21, 47, 144.11),
(148, 10, 42, 31.09),
(149, 20, 12, 77.72);
GO

-- Verificacion rapida de conteos por tabla
SELECT 'Categorias' AS Tabla, COUNT(*) AS Total FROM Categorias
UNION ALL
SELECT 'Clientes', COUNT(*) FROM Clientes
UNION ALL
SELECT 'Productos', COUNT(*) FROM Productos
UNION ALL
SELECT 'Pedidos', COUNT(*) FROM Pedidos
UNION ALL
SELECT 'Detalle_Pedidos', COUNT(*) FROM Detalle_Pedidos;
GO

-- =====================================================================
-- ANALISIS DE RESULTADOS - GRUPO 08 - PROYECTO ALIGLOBAL S.A.C.
-- A continuacion se desarrollan las consultas que responden a los 4
-- indicadores (KPIs) definidos en el objetivo del proyecto:
--   1) Ticket Promedio de Venta por Pedido (AOV)
--   2) Ventas Totales por Categoria
--   3) Nivel de Exposicion Crediticia
--   4) Efectividad de Entrega (Fill-Rate / OTIF)
-- =====================================================================


-- =====================================================================
-- OBJETIVO 1: TICKET PROMEDIO DE VENTA POR PEDIDO (AOV)
-- =====================================================================

-- 1.1 AOV GENERAL
-- Se calcula dividiendo la facturacion total entre el numero de pedidos
-- que registran al menos una linea de detalle (pedidos efectivamente
-- facturados).
SELECT
    CONCAT('S/ ', FORMAT(SUM(dp.Cantidad * dp.Precio_Venta), 'N2')) AS Facturacion_Total,
    COUNT(DISTINCT p.ID_Pedido) AS Total_Pedidos,
    CONCAT('S/ ', FORMAT(SUM(dp.Cantidad * dp.Precio_Venta) / COUNT(DISTINCT p.ID_Pedido), 'N2')) AS AOV
FROM Pedidos p
INNER JOIN Detalle_Pedidos dp ON p.ID_Pedido = dp.ID_Pedido;
GO

-- 1.2 AOV POR CANAL COMERCIAL
-- Fusiona PEDIDOS, CLIENTES y DETALLE_PEDIDOS para segmentar el ticket
-- promedio segun el canal (Mayorista, Supermercados, Tradicional).
SELECT
    c.Tipo_Canal,
    COUNT(DISTINCT p.ID_Pedido) AS Total_Pedidos,
    CONCAT('S/ ', FORMAT(SUM(dp.Cantidad * dp.Precio_Venta), 'N2')) AS Facturacion_Total,
    CONCAT('S/ ', FORMAT(SUM(dp.Cantidad * dp.Precio_Venta) / COUNT(DISTINCT p.ID_Pedido), 'N2')) AS AOV
FROM Pedidos p
INNER JOIN Clientes c ON p.ID_Cliente = c.ID_Cliente
INNER JOIN Detalle_Pedidos dp ON p.ID_Pedido = dp.ID_Pedido
GROUP BY c.Tipo_Canal
ORDER BY SUM(dp.Cantidad * dp.Precio_Venta) / COUNT(DISTINCT p.ID_Pedido) DESC;
GO

-- 1.3 EVOLUCION MENSUAL DEL AOV
-- Permite observar la tendencia del ticket promedio mes a mes durante
-- el periodo de analisis (enero - agosto 2026).
SELECT
    CASE MONTH(p.Fecha_Pedido)
        WHEN 1 THEN 'Enero'  WHEN 2 THEN 'Febrero' WHEN 3 THEN 'Marzo'
        WHEN 4 THEN 'Abril'  WHEN 5 THEN 'Mayo'     WHEN 6 THEN 'Junio'
        WHEN 7 THEN 'Julio'  WHEN 8 THEN 'Agosto'
    END AS Mes,
    COUNT(DISTINCT p.ID_Pedido) AS Total_Pedidos,
    CONCAT('S/ ', FORMAT(SUM(dp.Cantidad * dp.Precio_Venta) / COUNT(DISTINCT p.ID_Pedido), 'N2')) AS AOV
FROM Pedidos p
INNER JOIN Detalle_Pedidos dp ON p.ID_Pedido = dp.ID_Pedido
GROUP BY MONTH(p.Fecha_Pedido)
ORDER BY MONTH(p.Fecha_Pedido);
GO


-- =====================================================================
-- OBJETIVO 2: VENTAS TOTALES POR CATEGORIA
-- =====================================================================

-- 2.1 MONTO Y VOLUMEN FACTURADO POR CATEGORIA
-- Vista que consolida el desempeño comercial de cada linea de negocio.
-- Se reutiliza para dashboards y para el ranking del punto 2.2.
CREATE OR ALTER VIEW Ventas_Por_Categoria AS
SELECT
    cat.Nombre_Categoria,
    SUM(dp.Cantidad) AS Volumen_Vendido,
    SUM(dp.Cantidad * dp.Precio_Venta) AS Monto_Vendido
FROM Detalle_Pedidos dp
INNER JOIN Productos pr ON dp.ID_Producto = pr.ID_Producto
INNER JOIN Categorias cat ON pr.ID_Categoria = cat.ID_Categoria
GROUP BY cat.Nombre_Categoria;
GO

SELECT
    Nombre_Categoria,
    Volumen_Vendido,
    CONCAT('S/ ', FORMAT(Monto_Vendido, 'N2')) AS Monto_Vendido
FROM Ventas_Por_Categoria
ORDER BY Monto_Vendido DESC;
GO

-- 2.2 TOP 5 PRODUCTOS CON MAYOR FACTURACION
-- Identifica los SKUs que mas aportan a la venta total, insumo clave
-- para la gestion de stock y las negociaciones con proveedores.
SELECT TOP 5
    pr.Nombre_Producto,
    cat.Nombre_Categoria,
    SUM(dp.Cantidad) AS Volumen_Vendido,
    CONCAT('S/ ', FORMAT(SUM(dp.Cantidad * dp.Precio_Venta), 'N2')) AS Monto_Vendido
FROM Detalle_Pedidos dp
INNER JOIN Productos pr ON dp.ID_Producto = pr.ID_Producto
INNER JOIN Categorias cat ON pr.ID_Categoria = cat.ID_Categoria
GROUP BY pr.Nombre_Producto, cat.Nombre_Categoria
ORDER BY SUM(dp.Cantidad * dp.Precio_Venta) DESC;
GO

-- 2.3 MARGEN DE RENTABILIDAD POR CATEGORIA (TOP 8)
-- Compara el monto vendido contra el costo referencial para conocer
-- que categorias son mas rentables, no solo las de mayor volumen.
SELECT TOP 8
    cat.Nombre_Categoria,
    CONCAT('S/ ', FORMAT(SUM(dp.Cantidad * dp.Precio_Venta), 'N2')) AS Monto_Vendido,
    CONCAT('S/ ', FORMAT(SUM(dp.Cantidad * pr.Costo_Referencial), 'N2')) AS Costo_Total,
    CONCAT('S/ ', FORMAT(SUM(dp.Cantidad * dp.Precio_Venta) - SUM(dp.Cantidad * pr.Costo_Referencial), 'N2')) AS Margen,
    CONCAT(FORMAT((SUM(dp.Cantidad * dp.Precio_Venta) - SUM(dp.Cantidad * pr.Costo_Referencial))
        * 100.0 / SUM(dp.Cantidad * dp.Precio_Venta), 'N2'), '%') AS Margen_Porcentual
FROM Detalle_Pedidos dp
INNER JOIN Productos pr ON dp.ID_Producto = pr.ID_Producto
INNER JOIN Categorias cat ON pr.ID_Categoria = cat.ID_Categoria
GROUP BY cat.Nombre_Categoria
ORDER BY SUM(dp.Cantidad * dp.Precio_Venta) - SUM(dp.Cantidad * pr.Costo_Referencial) DESC;
GO


-- =====================================================================
-- OBJETIVO 3: NIVEL DE EXPOSICION CREDITICIA
-- =====================================================================

-- 3.1 EXPOSICION CREDITICIA GENERAL
-- % de pedidos colocados a clientes con mas de 30 dias de financiamiento.
SELECT
    SUM(CASE WHEN c.Dias_Credito > 30 THEN 1 ELSE 0 END) AS Pedidos_Alto_Riesgo,
    COUNT(*) AS Total_Pedidos,
    CONCAT(FORMAT(SUM(CASE WHEN c.Dias_Credito > 30 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 'N2'), '%') AS Pct_Exposicion
FROM Pedidos p
INNER JOIN Clientes c ON p.ID_Cliente = c.ID_Cliente;
GO

-- 3.2 EXPOSICION CREDITICIA POR CANAL
SELECT
    c.Tipo_Canal,
    COUNT(*) AS Total_Pedidos,
    SUM(CASE WHEN c.Dias_Credito > 30 THEN 1 ELSE 0 END) AS Pedidos_Alto_Riesgo,
    CONCAT(FORMAT(SUM(CASE WHEN c.Dias_Credito > 30 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 'N2'), '%') AS Pct_Exposicion
FROM Pedidos p
INNER JOIN Clientes c ON p.ID_Cliente = c.ID_Cliente
GROUP BY c.Tipo_Canal
ORDER BY Pct_Exposicion DESC;
GO

-- 3.3 PEDIDOS Y MONTO EXPUESTO POR RANGO DE DIAS DE CREDITO
-- Usa una subconsulta para obtener el monto facturado por pedido y
-- luego lo agrupa por rango de dias de credito (sentencia CASE WHEN).
SELECT
    CASE
        WHEN c.Dias_Credito = 0 THEN 'Contado (0d)'
        WHEN c.Dias_Credito BETWEEN 1 AND 15 THEN '1-15 dias'
        WHEN c.Dias_Credito BETWEEN 16 AND 30 THEN '16-30 dias'
        WHEN c.Dias_Credito BETWEEN 31 AND 45 THEN '31-45 dias'
        ELSE '46-60 dias'
    END AS Rango_Credito,
    COUNT(*) AS Total_Pedidos,
    CONCAT('S/ ', FORMAT(SUM(dp.Monto), 'N2')) AS Monto_Expuesto
FROM Pedidos p
INNER JOIN Clientes c ON p.ID_Cliente = c.ID_Cliente
INNER JOIN (
    SELECT ID_Pedido, SUM(Cantidad * Precio_Venta) AS Monto
    FROM Detalle_Pedidos
    GROUP BY ID_Pedido
) dp ON p.ID_Pedido = dp.ID_Pedido
GROUP BY
    CASE
        WHEN c.Dias_Credito = 0 THEN 'Contado (0d)'
        WHEN c.Dias_Credito BETWEEN 1 AND 15 THEN '1-15 dias'
        WHEN c.Dias_Credito BETWEEN 16 AND 30 THEN '16-30 dias'
        WHEN c.Dias_Credito BETWEEN 31 AND 45 THEN '31-45 dias'
        ELSE '46-60 dias'
    END
ORDER BY Total_Pedidos DESC;
GO

-- 3.4 TOP 10 CLIENTES CON MAYOR EXPOSICION CREDITICIA
-- Cruza los clientes con financiamiento mayor a 30 dias contra su
-- facturacion acumulada, para priorizar el seguimiento de cobranzas.
SELECT TOP 10
    c.Razon_Social,
    c.Tipo_Canal,
    c.Dias_Credito,
    CONCAT('S/ ', FORMAT(SUM(dp.Cantidad * dp.Precio_Venta), 'N2')) AS Monto_Facturado
FROM Pedidos p
INNER JOIN Clientes c ON p.ID_Cliente = c.ID_Cliente
INNER JOIN Detalle_Pedidos dp ON p.ID_Pedido = dp.ID_Pedido
WHERE c.Dias_Credito > 30
GROUP BY c.Razon_Social, c.Tipo_Canal, c.Dias_Credito
ORDER BY SUM(dp.Cantidad * dp.Precio_Venta) DESC;
GO


-- =====================================================================
-- OBJETIVO 4: EFECTIVIDAD DE ENTREGA (FILL-RATE / OTIF)
-- =====================================================================

-- 4.1 EFECTIVIDAD DE ENTREGA GENERAL
SELECT
    Estado_Entrega,
    COUNT(*) AS Total_Pedidos,
    CONCAT(FORMAT(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Pedidos), 'N2'), '%') AS Pct_Sobre_Total
FROM Pedidos
GROUP BY Estado_Entrega
ORDER BY Total_Pedidos DESC;
GO

-- 4.2 FILL-RATE POR CANAL COMERCIAL
SELECT
    c.Tipo_Canal,
    COUNT(*) AS Total_Pedidos,
    SUM(CASE WHEN p.Estado_Entrega = 'Entregado' THEN 1 ELSE 0 END) AS Entregados,
    CONCAT(FORMAT(SUM(CASE WHEN p.Estado_Entrega = 'Entregado' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 'N2'), '%') AS Fill_Rate
FROM Pedidos p
INNER JOIN Clientes c ON p.ID_Cliente = c.ID_Cliente
GROUP BY c.Tipo_Canal
ORDER BY Fill_Rate DESC;
GO

-- 4.3 TOP 10 CIUDADES POR VOLUMEN DE PEDIDOS Y SU FILL-RATE
SELECT TOP 10
    c.Ciudad,
    COUNT(*) AS Total_Pedidos,
    SUM(CASE WHEN p.Estado_Entrega = 'Entregado' THEN 1 ELSE 0 END) AS Entregados,
    CONCAT(FORMAT(SUM(CASE WHEN p.Estado_Entrega = 'Entregado' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 'N2'), '%') AS Fill_Rate
FROM Pedidos p
INNER JOIN Clientes c ON p.ID_Cliente = c.ID_Cliente
GROUP BY c.Ciudad
ORDER BY Total_Pedidos DESC;
GO

-- 4.4 EVOLUCION MENSUAL DEL FILL-RATE
SELECT
    CASE MONTH(Fecha_Pedido)
        WHEN 1 THEN 'Enero'  WHEN 2 THEN 'Febrero' WHEN 3 THEN 'Marzo'
        WHEN 4 THEN 'Abril'  WHEN 5 THEN 'Mayo'     WHEN 6 THEN 'Junio'
        WHEN 7 THEN 'Julio'  WHEN 8 THEN 'Agosto'
    END AS Mes,
    COUNT(*) AS Total_Pedidos,
    SUM(CASE WHEN Estado_Entrega = 'Entregado' THEN 1 ELSE 0 END) AS Entregados,
    CONCAT(FORMAT(SUM(CASE WHEN Estado_Entrega = 'Entregado' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 'N2'), '%') AS Fill_Rate
FROM Pedidos
GROUP BY MONTH(Fecha_Pedido)
ORDER BY MONTH(Fecha_Pedido);
GO


-- =====================================================================
-- ANALISIS COMPLEMENTARIO: FIDELIZACION Y PREFERENCIA DE CONSUMO
-- (funcion de ventana RANK() OVER PARTITION BY, tal como exige el curso)
-- =====================================================================

-- 5.1 CLIENTES RECURRENTES (5 pedidos o mas durante el periodo)
-- Utiles para disenar un plan de fidelizacion o descuentos por volumen.
SELECT
    c.Razon_Social,
    c.Tipo_Canal,
    COUNT(p.ID_Pedido) AS Total_Pedidos
FROM Clientes c
INNER JOIN Pedidos p ON c.ID_Cliente = p.ID_Cliente
GROUP BY c.Razon_Social, c.Tipo_Canal
HAVING COUNT(p.ID_Pedido) >= 5
ORDER BY Total_Pedidos DESC;
GO

-- 5.2 PRODUCTO CON MAYOR DEMANDA POR CANAL COMERCIAL
-- Se particiona por canal y se rankea el volumen comprado por producto;
-- solo se conserva el producto en la posicion 1 de cada canal.
SELECT
    Tipo_Canal,
    Nombre_Producto,
    Cantidad_Comprada
FROM (
    SELECT
        c.Tipo_Canal,
        pr.Nombre_Producto,
        SUM(dp.Cantidad) AS Cantidad_Comprada,
        RANK() OVER (PARTITION BY c.Tipo_Canal ORDER BY SUM(dp.Cantidad) DESC) AS Ranking_Producto
    FROM Pedidos p
    INNER JOIN Clientes c ON p.ID_Cliente = c.ID_Cliente
    INNER JOIN Detalle_Pedidos dp ON p.ID_Pedido = dp.ID_Pedido
    INNER JOIN Productos pr ON dp.ID_Producto = pr.ID_Producto
    GROUP BY c.Tipo_Canal, pr.Nombre_Producto
) AS Ranking
WHERE Ranking_Producto = 1
ORDER BY Tipo_Canal;
GO


-- =====================================================================
-- PROCEDIMIENTO ALMACENADO: AUTOMATIZACION DEL REGISTRO DE CLIENTES
-- Evita duplicar el RUC de un cliente y valida que tenga los 11
-- caracteres numericos exigidos por SUNAT, reduciendo errores de tipeo
-- en el registro comercial.
-- =====================================================================
CREATE OR ALTER PROCEDURE Registrar_Cliente
    @Razon_Social VARCHAR(120),
    @RUC CHAR(11),
    @Ciudad VARCHAR(50),
    @Tipo_Canal VARCHAR(30),
    @Dias_Credito INT
AS
BEGIN
    IF EXISTS (SELECT RUC FROM Clientes WHERE RUC = @RUC)
        PRINT 'El RUC ingresado ya se encuentra registrado.';
    ELSE
    BEGIN
        IF LEN(@RUC) <> 11
            PRINT 'El RUC debe contener 11 caracteres.';
        ELSE
        BEGIN
            INSERT INTO Clientes (Razon_Social, RUC, Ciudad, Tipo_Canal, Dias_Credito)
            SELECT @Razon_Social, @RUC, @Ciudad, @Tipo_Canal, @Dias_Credito
            WHERE NOT EXISTS (SELECT RUC FROM Clientes WHERE RUC = @RUC);
        END;
    END;
END;
GO

-- Ejemplo de ejecucion:
-- EXECUTE Registrar_Cliente 'Distribuidora Nueva Era S.A.C.', '20699887766', 'Lima', 'Mayorista', 30;