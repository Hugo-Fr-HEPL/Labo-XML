-- GET
CREATE OR REPLACE PROCEDURE GETid(venteId INT) AS

    ven     ventes.idVente%TYPE;
    dat     ventes.dateAchat%TYPE;
    cli     clients.prenomclient%TYPE;
    mag     magasins.nommagasin%TYPE;
    
    TYPE nt_Art IS RECORD (
        nom         articles.nomarticle%TYPE,
        quantite    ventes.quantite%TYPE,
        prix        articles.prix%TYPE
    );
    TYPE nt_ArtList IS TABLE OF nt_Art INDEX BY BINARY_INTEGER;
    art     nt_ArtList;

BEGIN
    SELECT DISTINCT idVente, dateAchat, nomClient, nomMagasin INTO ven, dat, cli, mag
    FROM ventes
    INNER JOIN  clients USING(idClient)
    INNER JOIN  magasins USING(idMagasin)
    WHERE       venteId = idVente
        UNION
    SELECT DISTINCT idVente, dateAchat, nomClient, nomMagasin
    FROM ventes@local_link
    INNER JOIN  clients USING(idClient)
    INNER JOIN  magasins@local_link USING(idMagasin)
    WHERE       venteId = idVente;

    SELECT DISTINCT nomArticle, quantite, prix BULK COLLECT INTO art
    FROM ventes
    INNER JOIN  articles USING(numArticle)
    WHERE       venteId = idVente
        UNION
    SELECT DISTINCT nomArticle, quantite, prix
    FROM ventes@local_link
    INNER JOIN  articles USING(numArticle)
    WHERE       venteId = idVente;


-- Display
    DBMS_OUTPUT.PUT_LINE('Identifiant de la vente : ' || ven);
    DBMS_OUTPUT.PUT_LINE('Prenom de l''acheteur : ' || cli);
    DBMS_OUTPUT.PUT_LINE('Nom du magasin : ' || mag);
    DBMS_OUTPUT.PUT_LINE('Date de l''achat : ' || dat);
    DBMS_OUTPUT.PUT_LINE('------------- Liste des articles achetés -------------');
    DBMS_OUTPUT.PUT_LINE(' + Quantité - prix unitaire (total) - nom article');
    FOR i IN art.FIRST .. art.LAST LOOP
        DBMS_OUTPUT.PUT_LINE(
            ' + ' || RPAD(art(i).quantite, 13, ' ') ||
            ' - ' || (art(i).prix || ' ') ||
            ' ('  || RPAD(((art(i).quantite * art(i).prix) || ')'), 10, ' ') ||
            ' - ' || art(i).nom
        );
    END LOOP;
END;
/

SET SERVEROUTPUT ON;
BEGIN
    GETid(2);
END;
/



----

-- POST
CREATE OR REPLACE PROCEDURE POSTmagasin(magasinId INT, newCode INT) AS

    ven     ventes.idVente%TYPE;
    dat     ventes.dateAchat%TYPE;
    cli     clients.prenomclient%TYPE;
    mag     magasins.nommagasin%TYPE;
    
    TYPE nt_Art IS RECORD (
        nom         articles.nomarticle%TYPE,
        quantite    ventes.quantite%TYPE,
        prix        articles.prix%TYPE
    );
    TYPE nt_ArtList IS TABLE OF nt_Art INDEX BY BINARY_INTEGER;
    art     nt_ArtList;

BEGIN
-- Check code postal to move in the right table
    INSERT INTO magasins@local_link
    SELECT * FROM magasins
    WHERE idMagasin = magasinId
    AND codePostal < 5000;
    
    INSERT INTO magasins
    SELECT * FROM magasins@local_link
    WHERE idMagasin = magasinId
    AND codePostal >= 5000;


-- Change code postal
    UPDATE  magasins
    SET     codePostal = newCode
    WHERE   idMagasin = magasinId;
    
    UPDATE  magasins@local_link
    SET     codePostal = newCode
    WHERE   idMagasin = magasinId;


-- Remove changed row
    DELETE FROM magasins WHERE codePostal >= 5000;
    DELETE FROM magasins@local_link WHERE codePostal < 5000;
END;
/


DELETE FROM magasins WHERE idMagasin = 4;
DELETE FROM magasins@local_link WHERE idMagasin = 4;
INSERT INTO magasins VALUES(4, 'Delhaize', 4000);
INSERT INTO magasins VALUES(1, 'Aldi', 1000);



BEGIN
    POSTmagasin(4, 6000);
END;
/
BEGIN
    POSTmagasin(4, 4000);
END;
/