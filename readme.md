This is the project under the university course in Data Engineering, Fall 2021.

Team: Robert Altmäe, Raul Niit, Fedor Stomakhin, Aleksandr Krylov

## Airflow setup

1) Open the command prompt/terminal

2) Locate the folder containing all the files

3) Enter the command
    docker-compose up --build

4) Find the services by entering the adress to your browser:
* http://localhost:8080/ (Airflow)
* http://localhost:5050/ (PGAdmin)
* http://localhost:7474/ (Neo4j)

5) In airflow, on the tab pane locate Admin -> Connections
There should be 2 connections present (if not they need to be created):  

    1) 
    * Conn Id - postgres_default
    * Conn Type - Postgres
    * Host - postgres
    * Schema - postgres
    * Login - airflow
    * Password - airflow
    * Port - 5432


    2)
    * Conn Id - neo4j_default
    * Conn Type - Neo4j
    * Host - neo
    * Schema - neo4j
    * Login - 
    * Password - 
    * Port - 7687

6) On the home page, clicking the unpause button next to the dag name runs the dag.

7) After the dag has finished, the data should be ready to be queried in PGAdmin and Neo4j.

GL HF :)
