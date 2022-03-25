README file added here just to keep the overall structure of 5GMETA WP3 Repository. Can be deleted once the foler is populated.

For importing a CSV file directly from within the Container

    docker cp ../utils/known_dataflowtypes.csv dataflow_sd_db:known_dataflowtypes.csv

    docker exec -it dataflow_sd_db bash

    mysql --local-infile=1 -u root -p -D dataflow_db
    
    SHOW GLOBAL VARIABLES LIKE 'local_infile';
    
    SET GLOBAL local_infile = true;
    
    mysql --local-infile=1 -u db_user -p -D dataflow_db
    
    LOAD DATA local INFILE 'countries_codes_iso.csv'  INTO TABLE utilsCountryCodes  FIELDS TERMINATED BY ','  ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;