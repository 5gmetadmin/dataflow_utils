-- Interesting discussion regarding JSON storage in RDBMS vs NoSQL: https://stackoverflow.com/questions/15367696/storing-json-in-database-vs-having-a-new-column-for-each-key
-- Tutorial for importing CSV with MySQL: https://www.mysqltutorial.org/import-csv-file-mysql-table/

-- SQL Script for adding the utility tables related to datatypes and country codes

CREATE TABLE IF NOT EXISTS `utilsCountryCodes` (
  `countryCode` varchar(3) PRIMARY KEY COMMENT 'ISO 3166-1 Alpha-3 Country Code',
  `countryCodeAlpha2` varchar(2) NOT NULL COMMENT 'ISO 3166-1 Alpha-2 Country Code',
  `countryName` varchar(255) NOT NULL COMMENT 'Official Country Name',
  `countryNumericCode` tinyint NOT NULL COMMENT 'ISO 3166-1 Numeric Code'
);

CREATE TABLE IF NOT EXISTS `utilsKnownDataflowTypes` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `dataflowType` varchar(255) NOT NULL COMMENT 'potential values: application, audio, cits, image, text, video',
  `dataflowSubType` varchar(255) COMMENT 'potential values: cam, denm, webrtc, jpeg...',
  `dataflowFormat` varchar(255) COMMENT 'list of semicolon seperated formats, potential values like json, asn1_jer, H264, mp4 ...'
);

SET GLOBAL local_infile = 1;

-- More information: https://dev.mysql.com/doc/refman/8.0/en/load-data.html#load-data-column-list

LOAD DATA local INFILE 'countries_codes_iso.csv' 
INTO TABLE utilsCountryCodes 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA local INFILE 'known_dataflowtypes.csv' 
INTO TABLE utilsKnownDataflowTypes
FIELDS TERMINATED BY ',' 
ENCLOSED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 ROWS (dataflowType,dataflowSubType,dataflowFormat);

SET GLOBAL local_infile = 0;