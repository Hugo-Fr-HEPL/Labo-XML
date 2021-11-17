
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


CREATE OR REPLACE DIRECTORY MYDIR AS '/home/hugo/Documents/Ecole/B3/E-Commerce/Labo-E-Commerce';


CREATE TABLE ventes
(
    idVente NUMERIC(4),
    idClient NUMERIC(4),
    nomClient VARCHAR(30),
    prenomClient VARCHAR(30),
    mailClient VARCHAR(30),
    
    idMagasin NUMERIC(4),
    nomMagasin VARCHAR(30),
    codePostal NUMERIC(4),

    --articles
    dateAchat DATE,
    URLTicket VARCHAR(30)
)
ORGANIZATION EXTERNAL
(
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY MYDIR
    ACCESS PARAMETERS
    (
        --commentaires
        RECORDS DELIMITED BY NEWLINE
        characterset "AL32UTF8"
        FIELDS TERMINATED BY ';'
        MISSING FIELD VALUES ARE NULL
        (
            idVente unsigned integer external(2),
            idClient unsigned integer external(2),
            nomClient char(50),
            prenomClient char(50),
            mailClient char(50),
            
            idMagasin unsigned integer external(2),
            nomMagasin char(50),
            codePostal unsigned integer,

            --articles
            dateAchat char(10) date_format date mask "dd-mm-yyyy",
            URLTicket char(50)
        )
    )
    LOCATION('ventes.txt')
)
REJECT LIMIT UNLIMITED;
