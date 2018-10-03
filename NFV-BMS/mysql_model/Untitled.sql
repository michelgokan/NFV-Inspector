-- MySQL Workbench Synchronization

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

ALTER TABLE `NFV_BMS`.`quality_metric_labeling_configuration_value` 
DROP FOREIGN KEY `qualMetrLabConfQualMetrLabConfIdForeignKey`,
DROP FOREIGN KEY `qualMetrLabConfQualMetrIdForeignKey`;

CREATE TABLE IF NOT EXISTS `NFV_BMS`.`experiment_quality_metric_value` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `value` FLOAT(20,4) NOT NULL,
  `timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `experiment_id` INT(11) NULL DEFAULT NULL,
  `quality_metric_id` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `experimentQualityMetricExpIdForeignKey` (`experiment_id` ASC) VISIBLE,
  INDEX `experimentQualityMetricQMIdForeignKey` (`quality_metric_id` ASC) VISIBLE,
  CONSTRAINT `experimentQualityMetricExpIdForeignKey`
    FOREIGN KEY (`experiment_id`)
    REFERENCES `NFV_BMS`.`experiment` (`id`),
  CONSTRAINT `experimentQualityMetricQMIdForeignKey`
    FOREIGN KEY (`quality_metric_id`)
    REFERENCES `NFV_BMS`.`quality_metric` (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb4;

ALTER TABLE `NFV_BMS`.`quality_metric` 
ADD COLUMN `upper_bound` INT(11) NULL DEFAULT NULL AFTER `name`,
ADD COLUMN `lower_bound` INT(11) NULL DEFAULT NULL AFTER `upper_bound`;

ALTER TABLE `NFV_BMS`.`quality_metric_labeling_configuration_value` 
DROP INDEX `qualMetrLabConfQualMetrIdForeignKey` ,
DROP INDEX `qualMetrLabConfQualMetrLabConfIdForeignKey` ;
;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
