-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema automotive_purchase_orders
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema automotive_purchase_orders
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `automotive_purchase_orders` ;
USE `automotive_purchase_orders` ;

-- -----------------------------------------------------
-- Table `automotive_purchase_orders`.`MARCAS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `automotive_purchase_orders`.`MARCAS` (
  `marca` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`marca`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `automotive_purchase_orders`.`MODELOS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `automotive_purchase_orders`.`MODELOS` (
  `modelo` VARCHAR(45) NOT NULL,
  `marca` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`modelo`),
  INDEX `fk_MODELOS_1_idx` (`marca` ASC) VISIBLE,
  CONSTRAINT `fk_MODELOS_1`
    FOREIGN KEY (`marca`)
    REFERENCES `automotive_purchase_orders`.`MARCAS` (`marca`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `automotive_purchase_orders`.`VERSIONES`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `automotive_purchase_orders`.`VERSIONES` (
  `modelo` VARCHAR(45) NOT NULL,
  `version` VARCHAR(45) NOT NULL,
  `puertas` INT(1) NOT NULL,
  `cambio` VARCHAR(45) NOT NULL,
  `combustible` VARCHAR(45) NOT NULL,
  `potencia` VARCHAR(45) NOT NULL,
  `year` INT(4) NOT NULL,
  `precio_base` FLOAT NOT NULL,
  PRIMARY KEY (`version`),
  INDEX `fk_VERSIONES_1_idx` (`modelo` ASC) VISIBLE,
  CONSTRAINT `fk_VERSIONES_1`
    FOREIGN KEY (`modelo`)
    REFERENCES `automotive_purchase_orders`.`MODELOS` (`modelo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `automotive_purchase_orders`.`EQUIPAMIENTOS_OPCIONALES`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `automotive_purchase_orders`.`EQUIPAMIENTOS_OPCIONALES` (
  `codigo_equipamiento` CHAR(4) NOT NULL,
  `descripcion` VARCHAR(100) NOT NULL,
  `precio_unitario` FLOAT NOT NULL,
  PRIMARY KEY (`codigo_equipamiento`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `automotive_purchase_orders`.`USADOS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `automotive_purchase_orders`.`USADOS` (
  `matricula` CHAR(7) NOT NULL,
  `version` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`matricula`),
  INDEX `fk_USADOS_1_idx` (`version` ASC) VISIBLE,
  CONSTRAINT `fk_USADOS_1`
    FOREIGN KEY (`version`)
    REFERENCES `automotive_purchase_orders`.`VERSIONES` (`version`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `automotive_purchase_orders`.`CONCESIONARIOS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `automotive_purchase_orders`.`CONCESIONARIOS` (
  `NIF` CHAR(9) NOT NULL,
  `razon_social` VARCHAR(45) NOT NULL,
  `gerente` VARCHAR(45) NOT NULL,
  `ciudad` VARCHAR(45) NOT NULL,
  `direccion` VARCHAR(100) NOT NULL,
  `telefono` INT(9) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`NIF`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `automotive_purchase_orders`.`CLIENTES`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `automotive_purchase_orders`.`CLIENTES` (
  `DNI` CHAR(9) NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `apellido_1` VARCHAR(45) NOT NULL,
  `apellido_2` VARCHAR(45) NOT NULL,
  `ciudad` VARCHAR(45) NOT NULL,
  `direccion` VARCHAR(100) NOT NULL,
  `telefono` INT(9) NOT NULL,
  `email` VARCHAR(45) NULL,
  PRIMARY KEY (`DNI`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `automotive_purchase_orders`.`PEDIDOS_NUEVOS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `automotive_purchase_orders`.`PEDIDOS_NUEVOS` (
  `id_pedido` INT NOT NULL AUTO_INCREMENT,
  `NIF_concesionario` CHAR(9) NOT NULL,
  `DNI_cliente` CHAR(9) NOT NULL,
  `version` VARCHAR(45) NOT NULL,
  `fecha` DATE NOT NULL,
  `importe` FLOAT NOT NULL,
  PRIMARY KEY (`id_pedido`),
  INDEX `fk_PEDIDOS_NUEVOS_1_idx` (`version` ASC) VISIBLE,
  INDEX `fk_PEDIDOS_NUEVOS_2_idx` (`NIF_concesionario` ASC) VISIBLE,
  INDEX `fk_PEDIDOS_NUEVOS_3_idx` (`DNI_cliente` ASC) VISIBLE,
  CONSTRAINT `fk_PEDIDOS_NUEVOS_1`
    FOREIGN KEY (`version`)
    REFERENCES `automotive_purchase_orders`.`VERSIONES` (`version`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PEDIDOS_NUEVOS_2`
    FOREIGN KEY (`NIF_concesionario`)
    REFERENCES `automotive_purchase_orders`.`CONCESIONARIOS` (`NIF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PEDIDOS_NUEVOS_3`
    FOREIGN KEY (`DNI_cliente`)
    REFERENCES `automotive_purchase_orders`.`CLIENTES` (`DNI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `automotive_purchase_orders`.`VENTAS_USADOS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `automotive_purchase_orders`.`VENTAS_USADOS` (
  `matricula` CHAR(7) NOT NULL,
  `NIF_concesionario` CHAR(9) NOT NULL,
  `DNI_cliente` CHAR(9) NOT NULL,
  `importe` FLOAT NOT NULL,
  `fecha` DATE NOT NULL,
  INDEX `fk_VENTAS_USADOS_2_idx` (`NIF_concesionario` ASC) VISIBLE,
  INDEX `fk_VENTAS_USADOS_3_idx` (`DNI_cliente` ASC) VISIBLE,
  PRIMARY KEY (`matricula`),
  CONSTRAINT `fk_VENTAS_USADOS_1`
    FOREIGN KEY (`matricula`)
    REFERENCES `automotive_purchase_orders`.`USADOS` (`matricula`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_VENTAS_USADOS_2`
    FOREIGN KEY (`NIF_concesionario`)
    REFERENCES `automotive_purchase_orders`.`CONCESIONARIOS` (`NIF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_VENTAS_USADOS_3`
    FOREIGN KEY (`DNI_cliente`)
    REFERENCES `automotive_purchase_orders`.`CLIENTES` (`DNI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `automotive_purchase_orders`.`cruce_VERSIONES_EQUIPA`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `automotive_purchase_orders`.`cruce_VERSIONES_EQUIPA` (
  `VERSIONES_version` VARCHAR(45) NOT NULL,
  `EQUIPAMIENTOS_OPCIONALES_codigo_equipamiento` CHAR(4) NOT NULL,
  PRIMARY KEY (`VERSIONES_version`, `EQUIPAMIENTOS_OPCIONALES_codigo_equipamiento`),
  INDEX `fk_VERSIONES_has_EQUIPAMIENTOS_OPCIONALES_EQUIPAMIENTOS_OPC_idx` (`EQUIPAMIENTOS_OPCIONALES_codigo_equipamiento` ASC) VISIBLE,
  INDEX `fk_VERSIONES_has_EQUIPAMIENTOS_OPCIONALES_VERSIONES1_idx` (`VERSIONES_version` ASC) VISIBLE,
  CONSTRAINT `fk_VERSIONES_has_EQUIPAMIENTOS_OPCIONALES_VERSIONES1`
    FOREIGN KEY (`VERSIONES_version`)
    REFERENCES `automotive_purchase_orders`.`VERSIONES` (`version`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_VERSIONES_has_EQUIPAMIENTOS_OPCIONALES_EQUIPAMIENTOS_OPCIO1`
    FOREIGN KEY (`EQUIPAMIENTOS_OPCIONALES_codigo_equipamiento`)
    REFERENCES `automotive_purchase_orders`.`EQUIPAMIENTOS_OPCIONALES` (`codigo_equipamiento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `automotive_purchase_orders`.`cruce_PEDIDOS_EQUIPA`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `automotive_purchase_orders`.`cruce_PEDIDOS_EQUIPA` (
  `PEDIDOS_NUEVOS_id_pedido` INT NOT NULL,
  `EQUIPAMIENTOS_OPCIONALES_codigo_equipamiento` CHAR(4) NOT NULL,
  PRIMARY KEY (`PEDIDOS_NUEVOS_id_pedido`, `EQUIPAMIENTOS_OPCIONALES_codigo_equipamiento`),
  INDEX `fk_PEDIDOS_NUEVOS_has_EQUIPAMIENTOS_OPCIONALES_EQUIPAMIENTO_idx` (`EQUIPAMIENTOS_OPCIONALES_codigo_equipamiento` ASC) VISIBLE,
  INDEX `fk_PEDIDOS_NUEVOS_has_EQUIPAMIENTOS_OPCIONALES_PEDIDOS_NUEV_idx` (`PEDIDOS_NUEVOS_id_pedido` ASC) VISIBLE,
  CONSTRAINT `fk_PEDIDOS_NUEVOS_has_EQUIPAMIENTOS_OPCIONALES_PEDIDOS_NUEVOS1`
    FOREIGN KEY (`PEDIDOS_NUEVOS_id_pedido`)
    REFERENCES `automotive_purchase_orders`.`PEDIDOS_NUEVOS` (`id_pedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PEDIDOS_NUEVOS_has_EQUIPAMIENTOS_OPCIONALES_EQUIPAMIENTOS_1`
    FOREIGN KEY (`EQUIPAMIENTOS_OPCIONALES_codigo_equipamiento`)
    REFERENCES `automotive_purchase_orders`.`EQUIPAMIENTOS_OPCIONALES` (`codigo_equipamiento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
