ALTER SESSION set "_ORACLE_SCRIPT" = true;



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



CREATE OR REPLACE DIRECTORY MYDIR AS 'C:\';
CREATE OR REPLACE DIRECTORY MYDIR AS 'D:\Ecole\B3\XML\Labo-XML\SGBD';


DROP TABLE VentesInternal;

CREATE TABLE VentesInternal
(
    idVente NUMBER(4),
    
    idClient NUMBER(4),
    nomClient VARCHAR(30),
    prenomClient VARCHAR(30),
    mailClient VARCHAR(50),
    
    idMagasin NUMBER(4),
    nomMagasin VARCHAR(30),
    codePostal NUMBER(4),

    article VARCHAR(50),
    dateAchat DATE,
    URLTicket VARCHAR(50)
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
            idVente char(4),

            idClient unsigned integer external(4),
            nomClient char(30),
            prenomClient char(30),
            mailClient char(60),
            
            idMagasin unsigned integer external(4),
            nomMagasin char(30),
            codePostal char(4),

            article char(50),
            dateAchat char(10) date_format date mask "dd/mm/yy",
            URLTicket char(50)
        )
    )
    LOCATION('Ventes.txt')
)
REJECT LIMIT UNLIMITED;

-- Verif
select * from VentesInternal;



-- Create internal table from external one
CREATE TABLE VentesExternal AS SELECT * FROM VentesInternal;

-- Verif
SELECT * FROM VentesExternal;

