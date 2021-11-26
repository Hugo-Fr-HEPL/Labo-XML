CREATE OR REPLACE DIRECTORY MYDIR AS 'C:\';
DROP TABLE ventesTxt;

CREATE TABLE ventesTxt
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
            idVente unsigned integer external(4),
            idClient unsigned integer external(4),
            nomClient char(30),
            prenomClient char(30),
            mailClient char(60),
            
            idMagasin unsigned integer external(4),
            nomMagasin char(30),
            codePostal unsigned integer,

            article char(50),
            dateAchat char(10) date_format date mask "dd-mm-yyyy",
            URLTicket char(50)
        )
    )
    LOCATION('Ventes.txt')
)
REJECT LIMIT UNLIMITED;

select * from ventesTxt;