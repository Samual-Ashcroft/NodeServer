/*This SQL document is used to generate the initial 
fraudtech_feature_request database, create all of 
its tables and all of the foreign key relationships 
and constraints
Author - Samual Ashcroft*/

/*Creating the Schema*/
CREATE SCHEMA IF NOT EXISTS `fraudtech_feature_request` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin 

/*Creating the user fraudtech_admin with all privs*/
CREATE USER 'fraudtech_admin' IDENTIFIED BY 'FraudulentExtra';

GRANT ALL ON `fraudtech_feature_request`.* TO 'fraudtech_admin';
GRANT SELECT ON TABLE `fraudtech_feature_request`.* TO 'fraudtech_admin';
GRANT SELECT, INSERT, TRIGGER ON TABLE `fraudtech_feature_request`.* TO 'fraudtech_admin';
GRANT SELECT, INSERT, TRIGGER, UPDATE, DELETE ON TABLE `fraudtech_feature_request`.* TO 'fraudtech_admin';
GRANT EXECUTE ON ROUTINE `fraudtech_feature_request`.* TO 'fraudtech_admin';

/*Creating the webapp client user fraudtech_client with limited privs*/
CREATE USER 'fraudtech_client' IDENTIFIED BY 'Fraudulent';

GRANT SELECT, INSERT, TRIGGER ON TABLE `fraudtech_feature_request`.* TO 'fraudtech_client';
GRANT SELECT ON TABLE `fraudtech_feature_request`.* TO 'fraudtech_client';


/*Creating people table*/
CREATE TABLE IF NOT EXISTS `fraudtech_feature_request`.`people` (
  `LOGid` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `firstname` VARCHAR(45) NOT NULL,
  `lastname` VARCHAR(45) NOT NULL,
  `contact_info` VARCHAR(45) NOT NULL,
  `notes` TEXT NOT NULL,
  UNIQUE INDEX `LOGid_UNIQUE` (`LOGid` ASC) VISIBLE,
  PRIMARY KEY (`LOGid`))
ENGINE = InnoDB

/*Creating the teams table*/
CREATE TABLE IF NOT EXISTS `fraudtech_feature_request`.`teams` (
  `TEid` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `team_name` VARCHAR(45) NULL,
  `decription` TEXT NULL,
  `notes` TEXT NULL,
  UNIQUE INDEX `TEid_UNIQUE` (`TEid` ASC) VISIBLE,
  PRIMARY KEY (`TEid`))
ENGINE = InnoDB

/*Creating the team_membership relational table*/
CREATE TABLE IF NOT EXISTS `fraudtech_feature_request`.`team_membership` (
  `TMid` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `TEid` INT NOT NULL,
  `LOGid` INT NOT NULL,
  `Notes` TEXT NULL,
  PRIMARY KEY (`TMid`),
  UNIQUE INDEX `TMid_UNIQUE` (`TMid` ASC) VISIBLE,
  CONSTRAINT `TEid`
    FOREIGN KEY (`TMid`)
    REFERENCES `fraudtech_feature_request`.`teams` (`TEid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `LOGid`
    FOREIGN KEY (`TMid`)
    REFERENCES `fraudtech_feature_request`.`people` (`LOGid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB

/*Creating the feature_request table*/
CREATE TABLE IF NOT EXISTS `fraudtech_feature_request`.`feature_request` (
  `FRid` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `LOGid` INT UNSIGNED NOT NULL,
  `TEid` INT UNSIGNED NOT NULL,
  `ProcName` VARCHAR(45) NOT NULL,
  `OldDesc` VARCHAR(45) NOT NULL,
  `date` DATETIME NOT NULL,
  PRIMARY KEY (`FRid`),
  UNIQUE INDEX `FRid_UNIQUE` (`FRid` ASC, `LOGid` ASC) INVISIBLE,
  CONSTRAINT `LOGid`
    FOREIGN KEY (`FRid`)
    REFERENCES `fraudtech_feature_request`.`people` (`LOGid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `TEid`
    FOREIGN KEY (`FRid`)
    REFERENCES `fraudtech_feature_request`.`teams` (`TEid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB

/*Creating the feature table*/
CREATE TABLE IF NOT EXISTS `fraudtech_feature_request`.`feature` (
  `FEid` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `FRid` INT UNSIGNED NOT NULL,
  `description` TEXT NOT NULL,
  `notes` TEXT NULL,
  INDEX `FEid_UNIQUE` (`FEid` ASC) INVISIBLE,
  PRIMARY KEY (`FEid`),
  CONSTRAINT `FRid`
    FOREIGN KEY (`FEid`)
    REFERENCES `fraudtech_feature_request`.`feature_request` (`FRid`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB

/*Creating the stakeholders table*/
CREATE TABLE IF NOT EXISTS `fraudtech_feature_request`.`stakeholders` (
  `SHid` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `FRid` INT UNSIGNED NOT NULL,
  `LOGid` INT UNSIGNED NULL,
  `notes` TEXT NULL,
  PRIMARY KEY (`SHid`),
  UNIQUE INDEX `SHid_UNIQUE` (`SHid` ASC) VISIBLE,
  CONSTRAINT `LOGid`
    FOREIGN KEY (`SHid`)
    REFERENCES `fraudtech_feature_request`.`people` (`LOGid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FRid`
    FOREIGN KEY (`SHid`)
    REFERENCES `fraudtech_feature_request`.`feature_request` (`FRid`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB

/*Creating the stakeholder_discussions table*/
CREATE TABLE IF NOT EXISTS `fraudtech_feature_request`.`stakeholder_discussions` (
  `SDid` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `SHid` INT NOT NULL,
  `FRid` INT NOT NULL,
  `discussion` TEXT NULL,
  `notes` TEXT NULL,
  PRIMARY KEY (`SDid`),
  UNIQUE INDEX `SDid_UNIQUE` (`SDid` ASC) VISIBLE,
  CONSTRAINT `SHid`
    FOREIGN KEY (`SDid`)
    REFERENCES `fraudtech_feature_request`.`stakeholders` (`SHid`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FRid`
    FOREIGN KEY (`SDid`)
    REFERENCES `fraudtech_feature_request`.`feature_request` (`FRid`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB