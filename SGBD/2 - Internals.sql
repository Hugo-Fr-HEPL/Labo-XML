-- Create internal table from external one
DROP TABLE VentesInternal;

CREATE TABLE VentesInternal AS
SELECT
    idVente,
    idClient,
    nomClient,
    prenomClient,
    mailClient,
    idMagasin,
    nomMagasin,
    codePostal,
    dateAchat,
    URLTicket
FROM VentesExternal;
SELECT * FROM VentesInternal;



DROP TABLE ArticlesTmp;
CREATE TABLE ArticlesTmp (
    numArticle NUMBER(4),
    nomArticle VARCHAR(50),
    prix    FLOAT(8)
);

DECLARE
    TYPE nt_Article   IS TABLE OF VARCHAR (50);
    arti     nt_Article;
BEGIN
    SELECT article BULK COLLECT INTO arti FROM VentesExternal;
    
    FOR i IN 1..arti.COUNT LOOP
        FOR j IN 1..2 LOOP
            INSERT INTO ArticlesTmp
            VALUES (
                CAST(REGEXP_SUBSTR(
                    REGEXP_SUBSTR(arti(i), '(.*)&|(.*)$', 1, j, NULL),
                    '[^.&]*', 1, 1, NULL) AS INTEGER),
                REGEXP_SUBSTR(
                    REGEXP_SUBSTR(arti(i), '(.*)&|(.*)$', 1, j, NULL),
                    '[^.&]*', 1, 3, NULL),
                CAST(REPLACE(REGEXP_SUBSTR(
                    REGEXP_SUBSTR(arti(i), '(.*)&|(.*)$', 1, j, NULL),
                    '[^.&]*', 1, 5, NULL), ',', '.') AS FLOAT)
            );
        END LOOP;
    END LOOP;
END;
/
DROP TABLE Articles;
CREATE TABLE Articles AS
SELECT DISTINCT * FROM ArticlesTmp WHERE numArticle IS NOT NULL;

SELECT * FROM Articles;
DROP TABLE ArticlesTmp;



DROP TABLE AchatsTmp;
CREATE TABLE AchatsTmp (
    idCLient    NUMBER(4),
    numArticle  NUMBER(4),
    quantite    NUMBER(4)
);

DECLARE
    TYPE nt_Article   IS TABLE OF VARCHAR (50);
    TYPE nt_Client    IS TABLE OF INTEGER (4);
    arti     nt_Article;
    cli      nt_Client;
BEGIN
    SELECT article, idClient BULK COLLECT INTO arti, cli FROM VentesExternal;
    
    FOR i IN 1..arti.COUNT LOOP
        FOR j IN 1..2 LOOP
            INSERT INTO AchatsTmp
            VALUES (
                cli(i),
                CAST(REGEXP_SUBSTR(
                    REGEXP_SUBSTR(arti(i), '(.*)&|(.*)$', 1, j, NULL),
                    '[^.&]*', 1, 1, NULL)AS INTEGER),
                CAST(REGEXP_SUBSTR(
                    REGEXP_SUBSTR(arti(i), '(.*)&|(.*)$', 1, j, NULL),
                    '[^.&]*', 1, 7, NULL)AS INTEGER)
            );
        END LOOP;
    END LOOP;
END;
/
DROP TABLE Achats;
CREATE TABLE Achats AS
SELECT * FROM AchatsTmp WHERE numArticle IS NOT NULL;

SELECT * FROM Achats;
DROP TABLE AchatsTmp;