-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: bdfacturas_mariadb_local
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cliente`
--

DROP TABLE IF EXISTS `cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cliente` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `credito` decimal(18,2) NOT NULL DEFAULT 0.00,
  `fkcodpersona` varchar(10) NOT NULL,
  `fkcodempresa` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_cliente_persona` (`fkcodpersona`),
  KEY `fk_cliente_empresa` (`fkcodempresa`),
  CONSTRAINT `fk_cliente_empresa` FOREIGN KEY (`fkcodempresa`) REFERENCES `empresa` (`codigo`),
  CONSTRAINT `fk_cliente_persona` FOREIGN KEY (`fkcodpersona`) REFERENCES `persona` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente`
--

LOCK TABLES `cliente` WRITE;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
INSERT INTO `cliente` VALUES (1,520000.00,'P001','E001'),(2,250000.00,'P003','E002'),(3,400000.00,'P005','E001'),(5,700000.00,'P006','E001');
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `empresa`
--

DROP TABLE IF EXISTS `empresa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `empresa` (
  `codigo` varchar(10) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `empresa`
--

LOCK TABLES `empresa` WRITE;
/*!40000 ALTER TABLE `empresa` DISABLE KEYS */;
INSERT INTO `empresa` VALUES ('E001','Comercial Los Andes S.A.'),('E002','Distribuciones El Centro S.A.'),('E999','Empresa Test');
/*!40000 ALTER TABLE `empresa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `factura`
--

DROP TABLE IF EXISTS `factura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `factura` (
  `numero` int(11) NOT NULL AUTO_INCREMENT,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp(),
  `total` decimal(18,2) NOT NULL DEFAULT 0.00,
  `estado` varchar(10) NOT NULL DEFAULT 'activa',
  `fkidcliente` int(11) NOT NULL,
  `fkidvendedor` int(11) NOT NULL,
  PRIMARY KEY (`numero`),
  KEY `fk_factura_cliente` (`fkidcliente`),
  KEY `fk_factura_vendedor` (`fkidvendedor`),
  CONSTRAINT `fk_factura_cliente` FOREIGN KEY (`fkidcliente`) REFERENCES `cliente` (`id`),
  CONSTRAINT `fk_factura_vendedor` FOREIGN KEY (`fkidvendedor`) REFERENCES `vendedor` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `factura`
--

LOCK TABLES `factura` WRITE;
/*!40000 ALTER TABLE `factura` DISABLE KEYS */;
INSERT INTO `factura` VALUES (1,'2025-12-03 17:57:19',5000000.00,'activa',1,1),(2,'2025-12-03 17:57:19',1250000.00,'activa',2,2),(3,'2025-12-03 17:57:19',2030000.00,'activa',3,3),(4,'2025-12-03 18:04:59',950000.00,'activa',1,1),(5,'2025-12-03 18:05:17',2740000.00,'activa',2,2),(6,'2025-12-03 18:05:35',4850000.00,'activa',3,3);
/*!40000 ALTER TABLE `factura` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `persona`
--

DROP TABLE IF EXISTS `persona`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `persona` (
  `codigo` varchar(10) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `telefono` varchar(20) NOT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `persona`
--

LOCK TABLES `persona` WRITE;
/*!40000 ALTER TABLE `persona` DISABLE KEYS */;
INSERT INTO `persona` VALUES ('P001','Ana Torres','ana.torres@correo.com','3011111111'),('P002','Carlos Pérez','carlos.perez@correo.com','3022222222'),('P003','María Gómez','maria.gomez@correo.com','3033333333'),('P004','Juan Díaz','juan.diaz@correo.com','3044444444'),('P005','Laura Rojas','laura.rojas@correo.com','3055555555'),('P006','Pedro Castillo','pedro.castillo@correo.com','3066666666');
/*!40000 ALTER TABLE `persona` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `producto`
--

DROP TABLE IF EXISTS `producto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `producto` (
  `codigo` varchar(10) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `stock` int(11) NOT NULL,
  `valorunitario` decimal(18,2) NOT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `producto`
--

LOCK TABLES `producto` WRITE;
/*!40000 ALTER TABLE `producto` DISABLE KEYS */;
INSERT INTO `producto` VALUES ('PR001','Laptop Lenovo IdeaPad',17,2500000.00),('PR002','Monitor Samsung 24\"',27,800000.00),('PR003','Teclado Logitech K380',42,150000.00),('PR004','Mouse HP',55,90000.00),('PR005','Impresora Epson EcoTank1',14,1100000.00),('PR006','Auriculares Sony WH-CH510',23,240000.00),('PR007','Tablet Samsung Tab A9',15,950000.00),('PR008','Disco Duro Seagate 1TB',32,280000.00);
/*!40000 ALTER TABLE `producto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productosporfactura`
--

DROP TABLE IF EXISTS `productosporfactura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `productosporfactura` (
  `fknumfactura` int(11) NOT NULL,
  `fkcodproducto` varchar(10) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `subtotal` decimal(18,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`fknumfactura`,`fkcodproducto`),
  KEY `fk_prodfact_producto` (`fkcodproducto`),
  CONSTRAINT `fk_prodfact_factura` FOREIGN KEY (`fknumfactura`) REFERENCES `factura` (`numero`) ON DELETE CASCADE,
  CONSTRAINT `fk_prodfact_producto` FOREIGN KEY (`fkcodproducto`) REFERENCES `producto` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productosporfactura`
--

LOCK TABLES `productosporfactura` WRITE;
/*!40000 ALTER TABLE `productosporfactura` DISABLE KEYS */;
INSERT INTO `productosporfactura` VALUES (1,'PR001',2,5000000.00),(2,'PR002',1,800000.00),(2,'PR003',3,450000.00),(3,'PR004',5,450000.00),(3,'PR005',1,1100000.00),(3,'PR006',2,480000.00),(4,'PR007',1,950000.00),(5,'PR007',2,1900000.00),(5,'PR008',3,840000.00),(6,'PR001',1,2500000.00),(6,'PR002',2,1600000.00),(6,'PR003',5,750000.00);
/*!40000 ALTER TABLE `productosporfactura` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_prodfact_before_insert
BEFORE INSERT ON productosporfactura
FOR EACH ROW
BEGIN
    DECLARE v_precio DECIMAL(18,2);
    DECLARE v_stock INT;
    DECLARE v_msg VARCHAR(500);

    SELECT valorunitario, stock INTO v_precio, v_stock
    FROM producto WHERE codigo = NEW.fkcodproducto;

    IF v_stock < NEW.cantidad THEN
        SET v_msg = CONCAT('Stock insuficiente para producto ', NEW.fkcodproducto,
            '. Stock disponible: ', v_stock, ', cantidad solicitada: ', NEW.cantidad);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_msg;
    END IF;

    SET NEW.subtotal = NEW.cantidad * v_precio;
    UPDATE producto SET stock = stock - NEW.cantidad WHERE codigo = NEW.fkcodproducto;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_prodfact_after_insert
AFTER INSERT ON productosporfactura
FOR EACH ROW
BEGIN
    UPDATE factura
    SET total = (SELECT COALESCE(SUM(subtotal), 0) FROM productosporfactura WHERE fknumfactura = NEW.fknumfactura)
    WHERE numero = NEW.fknumfactura;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_prodfact_before_update
BEFORE UPDATE ON productosporfactura
FOR EACH ROW
BEGIN
    DECLARE v_precio DECIMAL(18,2);
    DECLARE v_stock INT;
    DECLARE v_msg VARCHAR(500);

    SELECT valorunitario INTO v_precio FROM producto WHERE codigo = NEW.fkcodproducto;
    SELECT stock INTO v_stock FROM producto WHERE codigo = NEW.fkcodproducto;

    IF v_stock + OLD.cantidad < NEW.cantidad THEN
        SET v_msg = CONCAT('Stock insuficiente para producto ', NEW.fkcodproducto,
            '. Stock disponible: ', v_stock + OLD.cantidad, ', cantidad solicitada: ', NEW.cantidad);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_msg;
    END IF;

    SET NEW.subtotal = NEW.cantidad * v_precio;
    UPDATE producto
    SET stock = stock + OLD.cantidad - NEW.cantidad
    WHERE codigo = NEW.fkcodproducto;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_prodfact_after_update
AFTER UPDATE ON productosporfactura
FOR EACH ROW
BEGIN
    UPDATE factura
    SET total = (SELECT COALESCE(SUM(subtotal), 0) FROM productosporfactura WHERE fknumfactura = NEW.fknumfactura)
    WHERE numero = NEW.fknumfactura;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_prodfact_before_delete
BEFORE DELETE ON productosporfactura
FOR EACH ROW
BEGIN
    UPDATE producto
    SET stock = stock + OLD.cantidad
    WHERE codigo = OLD.fkcodproducto;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_prodfact_after_delete
AFTER DELETE ON productosporfactura
FOR EACH ROW
BEGIN
    UPDATE factura
    SET total = (SELECT COALESCE(SUM(subtotal), 0) FROM productosporfactura WHERE fknumfactura = OLD.fknumfactura)
    WHERE numero = OLD.fknumfactura;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `rol`
--

DROP TABLE IF EXISTS `rol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rol` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rol`
--

LOCK TABLES `rol` WRITE;
/*!40000 ALTER TABLE `rol` DISABLE KEYS */;
INSERT INTO `rol` VALUES (1,'Administrador'),(2,'Vendedor'),(3,'Cajero'),(4,'Contador'),(5,'Cliente');
/*!40000 ALTER TABLE `rol` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rol_usuario`
--

DROP TABLE IF EXISTS `rol_usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rol_usuario` (
  `fkemail` varchar(100) NOT NULL,
  `fkidrol` int(11) NOT NULL,
  PRIMARY KEY (`fkemail`,`fkidrol`),
  KEY `fk_rolusuario_rol` (`fkidrol`),
  CONSTRAINT `fk_rolusuario_rol` FOREIGN KEY (`fkidrol`) REFERENCES `rol` (`id`),
  CONSTRAINT `fk_rolusuario_usuario` FOREIGN KEY (`fkemail`) REFERENCES `usuario` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rol_usuario`
--

LOCK TABLES `rol_usuario` WRITE;
/*!40000 ALTER TABLE `rol_usuario` DISABLE KEYS */;
INSERT INTO `rol_usuario` VALUES ('admin@correo.com',1),('carlos.castro@usbmed.edu.co',1),('carlos.castro@usbmed.edu.co',2),('carlos.castro@usbmed.edu.co',3),('carlos.castro@usbmed.edu.co',4),('carlos.castro@usbmed.edu.co',5),('carloscastro5033@correo.itm.edu.co',1),('carloscastro5033@correo.itm.edu.co',2),('carloscastro5033@correo.itm.edu.co',3),('carloscastro5033@correo.itm.edu.co',4),('carloscastro5033@correo.itm.edu.co',5),('cliente1@correo.com',5),('jefe@correo.com',1),('jefe@correo.com',3),('jefe@correo.com',4),('nuevo@correo.com',1),('nuevo@correo.com',2),('nuevo@correo.com',3),('test_encript@correo.com',1),('vendedor1@correo.com',2),('vendedor1@correo.com',3);
/*!40000 ALTER TABLE `rol_usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ruta`
--

DROP TABLE IF EXISTS `ruta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ruta` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ruta` varchar(100) NOT NULL,
  `descripcion` varchar(200) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_ruta` (`ruta`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ruta`
--

LOCK TABLES `ruta` WRITE;
/*!40000 ALTER TABLE `ruta` DISABLE KEYS */;
INSERT INTO `ruta` VALUES (1,'/home','Página principal - Dashboard'),(2,'/usuario','Gestión de usuarios'),(3,'/factura','Gestión de facturas'),(4,'/cliente','Gestión de clientes'),(5,'/vendedor','Gestión de vendedores'),(6,'/persona','Gestión de personas'),(7,'/empresa','Gestión de empresas'),(8,'/producto','Gestión de productos'),(9,'/rol','Gestión de roles'),(10,'/permiso','Gestión de permisos (asignación rol-ruta)'),(11,'/permiso/crear','Crear permiso (POST)'),(12,'/permiso/eliminar','Eliminar permiso (POST)'),(13,'/ruta','Gestión de rutas del sistema'),(14,'/ruta/crear','Crear ruta (POST)'),(15,'/ruta/eliminar','Eliminar ruta (POST)');
/*!40000 ALTER TABLE `ruta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rutarol`
--

DROP TABLE IF EXISTS `rutarol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rutarol` (
  `fkidruta` int(11) NOT NULL,
  `fkidrol` int(11) NOT NULL,
  PRIMARY KEY (`fkidruta`,`fkidrol`),
  KEY `fk_rutarol_rol` (`fkidrol`),
  CONSTRAINT `fk_rutarol_rol` FOREIGN KEY (`fkidrol`) REFERENCES `rol` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_rutarol_ruta` FOREIGN KEY (`fkidruta`) REFERENCES `ruta` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rutarol`
--

LOCK TABLES `rutarol` WRITE;
/*!40000 ALTER TABLE `rutarol` DISABLE KEYS */;
INSERT INTO `rutarol` VALUES (1,1),(1,2),(1,3),(1,4),(1,5),(2,1),(3,1),(3,2),(3,3),(4,1),(4,2),(4,4),(5,1),(6,1),(7,1),(8,1),(8,4),(8,5),(9,1),(10,1),(11,1),(12,1),(13,1),(14,1),(15,1);
/*!40000 ALTER TABLE `rutarol` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usuario` (
  `email` varchar(100) NOT NULL,
  `contrasena` varchar(200) NOT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES ('admin@correo.com','$2a$12$3UgI.Eof.FhzsYUWESI9n.qFaqkV2JPhvW3L/1GTKowNJnGaD8F.G'),('carlos.castro@usbmed.edu.co','$2a$10$YYl6bHCflCnk8suUrms3ie.rnpLvfD9nHJtehZwhcSkINelGwt6iC'),('carloscastro5033@correo.itm.edu.co','$2a$10$YYl6bHCflCnk8suUrms3ie.rnpLvfD9nHJtehZwhcSkINelGwt6iC'),('cliente1@correo.com','cli123'),('jefe@correo.com','jefe123'),('nuevo@correo.com','$2a$11$cmtGBxllwc7MCzpnKVSWuumiOgCaG6PaKWcN1z9N0bjjnkobbFDzO'),('test_encript@correo.com','$2a$11$Ci0J2yBltDgQHfjadgkl0OtbcF5pUf97vTq/4Xr0KEU/86l8ybjBe'),('vendedor1@correo.com','$2a$12$Dgog4VaHqMzhliPVJy1BcOMd6.izEGNeRDtZ.O7SPmBLc6UVthVTG');
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vendedor`
--

DROP TABLE IF EXISTS `vendedor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vendedor` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `carnet` int(11) NOT NULL,
  `direccion` varchar(100) NOT NULL,
  `fkcodpersona` varchar(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_vendedor_persona` (`fkcodpersona`),
  CONSTRAINT `fk_vendedor_persona` FOREIGN KEY (`fkcodpersona`) REFERENCES `persona` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vendedor`
--

LOCK TABLES `vendedor` WRITE;
/*!40000 ALTER TABLE `vendedor` DISABLE KEYS */;
INSERT INTO `vendedor` VALUES (1,1001,'Calle 10 #5-33','P002'),(2,1002,'Carrera 15 #7-20','P004'),(3,1003,'Avenida 30 #18-09','P006');
/*!40000 ALTER TABLE `vendedor` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-08-09 23:00:22
