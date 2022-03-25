# Dataflow_utils
The **dataflow_utils** repository is a utility repository, for the **dataflow database** building blocks of the 5GMETA Platform (S&D, Edge & Cloud). More specifically, it includes some **utility SQL tables** that can be easily imported by other 5GMETA Components to serve as a common knowledge and reference for the following aspects:
*   Known **dataflows Types & Subtypes**
*   ISO Alpha-3 & Alpha2 **Countries codes** (ISO 3166-1)

# Versionning
For a better tracking of version changes, the following table summarizes the changes related to each utility table, and related to both its schema & CSV data. Therefore, this table should be regularly updated whenever a changes is made 

| Utility                             | SQL Table               | Schema version | Schema last update date | CSV Data version | CSV Data last update date |
|-------------------------------------|-------------------------|:--------------:|:-----------------------:|:----------------:|:-------------------------:|
| **Country Codes**                   | utilsCountryCodes       |      V0.1      |        25/03/2022       |       V0.1       |         25/03/2022        |
| **Known Dataflow Types & Subtypes** | utilsKnownDataflowTypes |      V0.1      |        25/03/2022       |       V0.1       |         25/03/2022        |

To follow a consistent approach this table should be updated whenever:
*   a new utility table is added
*   table schema for a utility table is updated
*   CSV data related to a utility table is updated

# Prerequisites
**Docker** and **Docker-compose** are required for using this module.
# Deployment
In most case this repository will be used by other 5GMETA Components *(and mainly databases)* and thus be integrated as a Git-Submodule. In that case you should refer to the **Integrate it to your component** section. Otherwise, for testing or development purpose you can also run it as a seperate component, and therefore should refer to **Deploy it as standalone component**

## Integrate it to your component
This repository has been designed to be used as a Git-Submodule by other 5GMETA Components. Consequently, after adding it to your main component as a Git-Submodule, and **considering that the component is also a containerized MySQL database**, all what will be required is:

From the **Docker-compose** file of **dataflow_utils**, copy the lines related to the **DB service volumes**
    
    # From the Docker-compose file
    .....
    services:
        db:
        .....
            volumes:
                # Config file for allowing CSV import
                - "./mysql/mysql.cnf:/etc/mysql/conf.d/mysql.cnf"
                # CSV files to import
                - "./known_dataflowtypes.csv:/known_dataflowtypes.csv" # For Known Dataflow Types & Subtypes
                - "./countries_codes_iso.csv:/countries_codes_iso.csv" # For ISO Alpha-3 & Alpha2 Countries codes (ISO 3166-1)
                # SQL Script for creating Tables (based on DBML schema) and import CSV files
                - "./mysql/utilityTables_mysql.sql:/docker-entrypoint-initdb.d/utils.sql"

Then past them into the **Docker-compose** file of the main component, and ensure that paths to each file are correct (**each line should be prefixed with the path to dataflow_utils Git-submodule**)
## Deploy it as a standalone component
To run the **Dataflow-Utils** as a separate component, i.e, Docker container

	sudo docker-compose up -d

This will automatically populate the database with the utility tables, as you can check it at with the **PhpMyAdmin** instance at http://localhost:8888/.

Finally for stopping the containers

	docker-compose down
<!-- # How to use the **dbml_cli** tool
To use the **dbml_cli** for converting from dbml to sql formats
	
	docker-compose run dbml_cli sh -c "cd /home/sql_scripts/ && sh"

	# Inside the dbml_cli container
	UtilityTables.dbml --mysql -o mysql/utilityTables_mysql.sql
	exit

	# Navigating to the mysql folder for checking if the new file exists
	cd mysql/ && ls -->
# Miscellaneous
## Importing CSF files from MySQL CLI:
For importing a CSV file directly from within the Container


    docker cp utils/known_dataflowtypes.csv dataflow_utils_db:known_dataflowtypes.csv

    docker exec -it dataflow_utils_db bash

    mysql --local-infile=1 -u root -p -D dataflow_db
    
    SHOW GLOBAL VARIABLES LIKE 'local_infile';
    
    SET GLOBAL local_infile = true;
    
    mysql --local-infile=1 -u db_user -p -D dataflow_db
    
    LOAD DATA local INFILE 'countries_codes_iso.csv'  INTO TABLE utilsCountryCodes  FIELDS TERMINATED BY ','  ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
## Supported RDBMS
For the time being, only the **MySQL** RDBMS is supported, however the provided component can be easily deployed on concurrent **DBMS**, especially with the use of **dbml2sql** tool
## References for Data
The ISO Alpha-3 & Alpha2 **Countries codes** (ISO 3166-1) have been taken from the following [repository](https://github.com/lukes/ISO-3166-Countries-with-Regional-Codes/blob/master/all/all.csv)
# Authors 
*	Arslane HAMZA CHERIF (arslane.hamzacherif@unimore.it)
# License 
GNU GPL License