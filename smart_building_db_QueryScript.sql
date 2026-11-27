
CREATE SCHEMA IF NOT EXISTS `smart_building_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `smart_building_db` ;

-- -----------------------------------------------------
-- Table `smart_building_db`.`buildings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `smart_building_db`.`buildings` (
  `building_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `location` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`building_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;
-- -----------------------------------------------------
-- Table `smart_building_db`.`zones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `smart_building_db`.`zones` (
  `zone_id` INT NOT NULL AUTO_INCREMENT,
  `building_id` INT NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `tariff_per_kwh` DECIMAL(10,4) NOT NULL,
  PRIMARY KEY (`zone_id`),
  INDEX `fk_zones_buildings` (`building_id` ASC)  ,
  CONSTRAINT `fk_zones_buildings`
    FOREIGN KEY (`building_id`)
    REFERENCES `smart_building_db`.`buildings` (`building_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;
-- -----------------------------------------------------
-- Table `smart_building_db`.`devices`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `smart_building_db`.`devices` (
  `device_id` INT NOT NULL AUTO_INCREMENT,
  `zone_id` INT NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `device_type` VARCHAR(255) NOT NULL,
  `status` ENUM('ACTIVE', 'FAULTY') NOT NULL,
  PRIMARY KEY (`device_id`),
  INDEX `fk_devices_zones` (`zone_id` ASC)  ,
  CONSTRAINT `fk_devices_zones`
    FOREIGN KEY (`zone_id`)
    REFERENCES `smart_building_db`.`zones` (`zone_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;
-- -----------------------------------------------------
-- Table `smart_building_db`.`threshold_rules`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `smart_building_db`.`threshold_rules` (
  `rule_id` INT NOT NULL AUTO_INCREMENT,
  `device_id` INT NOT NULL,
  `metric_type` VARCHAR(255) NOT NULL,
  `min_value` DECIMAL(10,4) NOT NULL,
  `max_value` DECIMAL(10,4) NOT NULL,
  PRIMARY KEY (`rule_id`),
  INDEX `fk_threshold_rules_devices` (`device_id` ASC)  ,
  CONSTRAINT `fk_threshold_rules_devices`
    FOREIGN KEY (`device_id`)
    REFERENCES `smart_building_db`.`devices` (`device_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `smart_building_db`.`alerts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `smart_building_db`.`alerts` (
  `alert_id` INT NOT NULL AUTO_INCREMENT,
  `device_id` INT NOT NULL,
  `threshold_rules_rule_id` INT NOT NULL,
  `reading_id` INT NOT NULL,
  `message` VARCHAR(255) NOT NULL,
  `resolved` TINYINT(1) NOT NULL,
  `created_at` TIMESTAMP NOT NULL,
  PRIMARY KEY (`alert_id`),
  INDEX `fk_alerts_devices` (`device_id` ASC)  ,
  INDEX `fk_alerts_threshold_rules` (`threshold_rules_rule_id` ASC)  ,
  INDEX `fk_alerts_sensor_readings` (`reading_id` ASC)  ,
  CONSTRAINT `fk_alerts_devices`
    FOREIGN KEY (`device_id`)
    REFERENCES `smart_building_db`.`devices` (`device_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_alerts_threshold_rules`
    FOREIGN KEY (`threshold_rules_rule_id`)
    REFERENCES `smart_building_db`.`threshold_rules` (`rule_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;
-- -----------------------------------------------------
-- Table `smart_building_db`.`sensor_readings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `smart_building_db`.`sensor_readings` (
  `reading_id` INT NOT NULL AUTO_INCREMENT,
  `device_id` INT NOT NULL,
  `metric_type` DECIMAL(10,4) NOT NULL,
  `energy_kwh` DECIMAL(10,4) NOT NULL,
  `recorded_at` TIMESTAMP NOT NULL,
  PRIMARY KEY (`reading_id`),
  INDEX `fk_sensor_readings_devices` (`device_id` ASC)  ,
  CONSTRAINT `fk_sensor_readings_devices`
    FOREIGN KEY (`device_id`)
    REFERENCES `smart_building_db`.`devices` (`device_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `smart_building_db`.`technicians`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `smart_building_db`.`technicians` (
  `technician_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `specialty` VARCHAR(255) NOT NULL,
  `available` TINYINT(1) NOT NULL,
  PRIMARY KEY (`technician_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `smart_building_db`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `smart_building_db`.`user` (
  `User_id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `roles` ENUM('ADMIN', 'TECHNICIAN') NOT NULL,
  `technicians_technician_id` INT NULL DEFAULT NULL,
  PRIMARY KEY (`User_id`),
  UNIQUE INDEX `username` (`username` ASC)  ,
  INDEX `fk_user_technicians` (`technicians_technician_id` ASC)  ,
  CONSTRAINT `fk_user_technicians`
    FOREIGN KEY (`technicians_technician_id`)
    REFERENCES `smart_building_db`.`technicians` (`technician_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `smart_building_db`.`work_orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `smart_building_db`.`work_orders` (
  `order_id` INT NOT NULL AUTO_INCREMENT,
  `device_id` INT NOT NULL,
  `technician_id` INT NULL DEFAULT NULL,
  `issue_desc` VARCHAR(255) NOT NULL,
  `status` ENUM('OPEN', 'ASSIGNED') NOT NULL,
  `created_at` TIMESTAMP NOT NULL,
  `closed_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  INDEX `fk_work_orders_devices` (`device_id` ASC)  ,
  INDEX `fk_work_orders_technicians` (`technician_id` ASC)  ,
  CONSTRAINT `fk_work_orders_devices`
    FOREIGN KEY (`device_id`)
    REFERENCES `smart_building_db`.`devices` (`device_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_work_orders_technicians`
    FOREIGN KEY (`technician_id`)
    REFERENCES `smart_building_db`.`technicians` (`technician_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;
;
