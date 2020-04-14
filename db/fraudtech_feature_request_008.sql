-- MySQL Script generated by MySQL Workbench
-- Tue Apr 14 13:19:23 2020
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema fraudtech_feature_request
-- -----------------------------------------------------
-- Needs to be able to hold Login identities for people, perhaps some contact info that might get imported across when joined.
-- 
-- Needs to be dynamic in a few areas with refference tables
DROP SCHEMA IF EXISTS `fraudtech_feature_request` ;

-- -----------------------------------------------------
-- Schema fraudtech_feature_request
--
-- Needs to be able to hold Login identities for people, perhaps some contact info that might get imported across when joined.
-- 
-- Needs to be dynamic in a few areas with refference tables
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `fraudtech_feature_request` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin ;
USE `fraudtech_feature_request` ;

-- -----------------------------------------------------
-- Table `fraudtech_feature_request`.`people`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fraudtech_feature_request`.`people` ;

CREATE TABLE IF NOT EXISTS `fraudtech_feature_request`.`people` (
  `LOGid` INT UNSIGNED NOT NULL,
  `login` VARCHAR(45) NOT NULL,
  `firstName` VARCHAR(45) NOT NULL,
  `lastname` VARCHAR(45) NULL,
  `contact_info` VARCHAR(45) NULL,
  `notes` TEXT NULL,
  PRIMARY KEY (`LOGid`),
  UNIQUE INDEX `LOGid_UNIQUE` (`LOGid` ASC),
  UNIQUE INDEX `login_UNIQUE` (`login` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fraudtech_feature_request`.`teams`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fraudtech_feature_request`.`teams` ;

CREATE TABLE IF NOT EXISTS `fraudtech_feature_request`.`teams` (
  `TEid` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `team_name` VARCHAR(45) NULL,
  `decription` TEXT NULL,
  `notes` TEXT NULL,
  PRIMARY KEY (`TEid`),
  UNIQUE INDEX `TEid_UNIQUE` (`TEid` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fraudtech_feature_request`.`feature_request`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fraudtech_feature_request`.`feature_request` ;

CREATE TABLE IF NOT EXISTS `fraudtech_feature_request`.`feature_request` (
  `FRid` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `LOGid` INT UNSIGNED NOT NULL,
  `TEid` INT UNSIGNED NOT NULL,
  `ProcName` VARCHAR(45) NOT NULL,
  `OldDesc` VARCHAR(45) NOT NULL,
  `date` DATETIME NOT NULL,
  `NoStaff` INT UNSIGNED NOT NULL,
  `maintenance` TEXT NOT NULL,
  `report_require` TEXT NOT NULL,
  PRIMARY KEY (`FRid`),
  UNIQUE INDEX `FRid_UNIQUE` (`FRid` ASC),
  INDEX `FR_LOGid_idx` (`LOGid` ASC),
  INDEX `FR_TEid_idx` (`TEid` ASC),
  CONSTRAINT `FR_LOGid`
    FOREIGN KEY (`LOGid`)
    REFERENCES `fraudtech_feature_request`.`people` (`LOGid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FR_TEid`
    FOREIGN KEY (`TEid`)
    REFERENCES `fraudtech_feature_request`.`teams` (`TEid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fraudtech_feature_request`.`feature`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fraudtech_feature_request`.`feature` ;

CREATE TABLE IF NOT EXISTS `fraudtech_feature_request`.`feature` (
  `FEid` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `FRid` INT UNSIGNED NOT NULL,
  `description` TEXT NOT NULL,
  `notes` TEXT NULL,
  PRIMARY KEY (`FEid`),
  UNIQUE INDEX `FEid_UNIQUE` (`FEid` ASC),
  INDEX `FE_FRid_idx` (`FRid` ASC),
  CONSTRAINT `FE_FRid`
    FOREIGN KEY (`FRid`)
    REFERENCES `fraudtech_feature_request`.`feature_request` (`FRid`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fraudtech_feature_request`.`stakeholders`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fraudtech_feature_request`.`stakeholders` ;

CREATE TABLE IF NOT EXISTS `fraudtech_feature_request`.`stakeholders` (
  `SHid` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `FRid` INT UNSIGNED NOT NULL,
  `LOGid` INT UNSIGNED NULL,
  `notes` TEXT NULL,
  PRIMARY KEY (`SHid`),
  UNIQUE INDEX `SHid_UNIQUE` (`SHid` ASC),
  INDEX `SH_LOGid_idx` (`LOGid` ASC),
  INDEX `SH_FRid_idx` (`FRid` ASC),
  CONSTRAINT `SH_LOGid`
    FOREIGN KEY (`LOGid`)
    REFERENCES `fraudtech_feature_request`.`people` (`LOGid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `SH_FRid`
    FOREIGN KEY (`FRid`)
    REFERENCES `fraudtech_feature_request`.`feature_request` (`FRid`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fraudtech_feature_request`.`team_membership`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fraudtech_feature_request`.`team_membership` ;

CREATE TABLE IF NOT EXISTS `fraudtech_feature_request`.`team_membership` (
  `TMid` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `TEid` INT UNSIGNED NOT NULL,
  `LOGid` INT UNSIGNED NOT NULL,
  `Notes` TEXT NULL,
  PRIMARY KEY (`TMid`),
  UNIQUE INDEX `TMid_UNIQUE` (`TMid` ASC),
  INDEX `TM_TEid_idx` (`TEid` ASC),
  INDEX `LOGid_idx` (`LOGid` ASC),
  CONSTRAINT `TM_TEid`
    FOREIGN KEY (`TEid`)
    REFERENCES `fraudtech_feature_request`.`teams` (`TEid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `TM_LOGid`
    FOREIGN KEY (`LOGid`)
    REFERENCES `fraudtech_feature_request`.`people` (`LOGid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fraudtech_feature_request`.`stakeholder_discussions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fraudtech_feature_request`.`stakeholder_discussions` ;

CREATE TABLE IF NOT EXISTS `fraudtech_feature_request`.`stakeholder_discussions` (
  `SDid` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `SHid` INT UNSIGNED NOT NULL,
  `FRid` INT UNSIGNED NOT NULL,
  `discussion` TEXT NULL,
  `notes` TEXT NULL,
  PRIMARY KEY (`SDid`),
  UNIQUE INDEX `SDid_UNIQUE` (`SDid` ASC),
  INDEX `SD_SHid_idx` (`SHid` ASC),
  INDEX `SD_FRid_idx` (`FRid` ASC),
  CONSTRAINT `SD_SHid`
    FOREIGN KEY (`SHid`)
    REFERENCES `fraudtech_feature_request`.`stakeholders` (`SHid`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `SD_FRid`
    FOREIGN KEY (`FRid`)
    REFERENCES `fraudtech_feature_request`.`feature_request` (`FRid`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SET SQL_MODE = '';
DROP USER IF EXISTS fraudtech_client;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'fraudtech_client' IDENTIFIED BY 'Fraudulent';

GRANT SELECT, INSERT, TRIGGER ON TABLE `fraudtech_feature_request`.* TO 'fraudtech_client';
GRANT SELECT ON TABLE `fraudtech_feature_request`.* TO 'fraudtech_client';
SET SQL_MODE = '';
DROP USER IF EXISTS fraudtech_admin;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'fraudtech_admin' IDENTIFIED BY 'FraudulentExtra';

GRANT ALL ON `fraudtech_feature_request`.* TO 'fraudtech_admin';
GRANT SELECT ON TABLE `fraudtech_feature_request`.* TO 'fraudtech_admin';
GRANT SELECT, INSERT, TRIGGER ON TABLE `fraudtech_feature_request`.* TO 'fraudtech_admin';
GRANT SELECT, INSERT, TRIGGER, UPDATE, DELETE ON TABLE `fraudtech_feature_request`.* TO 'fraudtech_admin';
GRANT EXECUTE ON ROUTINE `fraudtech_feature_request`.* TO 'fraudtech_admin';

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
