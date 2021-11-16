
CREATE USER hugo IDENTIFIED BY hugo
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP
PROFILE DEFAULT ACCOUNT UNLOCK;
ALTER USER hugo QUOTA UNLIMITED ON USERS;

GRANT CONNECT TO hugo;
GRANT RESOURCE TO hugo;
GRANT EXECUTE ON SYS.DBMS_LOCK TO hugo;
GRANT EXECUTE ON SYS.OWA_OPT_LOCK TO hugo;
GRANT CREATE ANY DIRECTORY TO hugo;

CREATE OR REPLACE DIRECTORY MYDIR AS 'D:\Programmation\SQL';

CREATE TABLE etudiants_ext
(
    id NUMBER(4),
    nom VARCHAR(30),
    prenom VARCHAR(30),
    dateNaiss DATE
)

ORGANIZATION EXTERNAL
(
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY MYDIR
    ACCESS PARAMETERS
    (
        RECORDS DELIMITED BY NEWLINE
        characterset "AL32UTF8"
        FIELDS TERMINATED BY ';'
        MISSING FIELD VALUES ARE NULL
        (
            id unsigned integer external(2),
            nom char(50),
            prenom char(50),
            dateNaiss char(10) date_format date mask "dd-mm-yyyy"
        )
    )
    LOCATION('ext_tab_etudiants.txt')
)
REJECT LIMIT UNLIMITED;