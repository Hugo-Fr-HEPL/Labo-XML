-- Création utilisateur (dans sys)
CREATE USER TestGest IDENTIFIED BY oracle   
  DEFAULT TABLESPACE USERS 
  TEMPORARY TABLESPACE TEMP 	
  PROFILE DEFAULT ACCOUNT UNLOCK;
ALTER USER TestGest QUOTA UNLIMITED ON USERS;

GRANT CONNECT TO TestGest;
GRANT RESOURCE TO TestGest;
GRANT EXECUTE ON SYS.DBMS_LOCK TO TestGest;
GRANT EXECUTE ON SYS.OWA_OPT_LOCK TO TestGest;

-- Création des directories (dans sys)
GRANT CREATE ANY DIRECTORY TO TestGest;
GRANT DROP ANY DIRECTORY TO TestGest;

-- Création du directory
CREATE OR REPLACE DIRECTORY MYDIR AS 'C:\HEPL\Coding';

-- Creation de la table externe
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
		--commentaires
		RECORDS DELIMITED BY NEWLINE
		characterset "AL32UTF8"
		FIELDS TERMINATED BY ';'
		MISSING FIELD VALUES ARE NULL
		(
			id unsigned integer external(2),
			nom char(50),
			prenom char(50),
			dateNaiss char(10) date_format date mask "dd-mm-yy"
		)
	)
	LOCATION('ext_tab_etudiants.txt')
)
REJECT LIMIT UNLIMITED;

-- Juste pour vérifier le contenu
SELECT * FROM etudiants_ext;

-- DOES NOT WORK
INSERT INTO etudiants_ext VALUES (14,'Pierre', 'Defooz',TO_DATE('01/01/1970'));

-- Export de table extérieure via data pump
CREATE TABLE etudiants_ext_2
    ORGANIZATION EXTERNAL
    (
      TYPE ORACLE_DATAPUMP
      DEFAULT DIRECTORY MYDIR
      LOCATION ('ext_tab_etudiants2.dmp')
    )
    AS SELECT * FROM etudiants_ext;

-- Vérification
SELECT * FROM etudiants_ext_2;

-- DOES NOT WORK EITHER
INSERT INTO etudiants_ext_2 VALUES (14,'Pierre', 'Defooz',TO_DATE('01/01/1970'));    

-- CREATE INTERNAL TABLE FROM EXTERNAL ONE
CREATE TABLE etudiants_int AS SELECT * FROM etudiants_ext;

-- Vérification
SELECT * FROM etudiants_int;

-- GRANT SUR LES ACL (à faire en SYS sur le même conteneur)
BEGIN
	DBMS_NETWORK_ACL_ADMIN.CREATE_ACL (
		acl => 'aclLabo4.xml', 
		description => 'Acces a internet pour les images', 
		principal => 'TESTGEST',
		is_grant => true,
		privilege => 'connect'
	);

	DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL(
		acl => 'aclLabo4.xml',
		host => 'image.tmdb.org');
END;
	
-- Pour supprimer l'ACL
BEGIN
	DBMS_NETWORK_ACL_ADMIN.DROP_ACL (
		acl => 'aclLabo4.xml'
	);
END;

-- Dans TestGest
create table blobtest
(
	id NUMBER(5) PRIMARY KEY,
	img blob
);

DECLARE
	image blob;
	url varchar2(200) := 'http://image.tmdb.org/t/p/w185';
BEGIN
	url := concat (url ,'/sav0jxhqiH0bPr2vZFU0Kjt2nZL.jpg');
	image := httpuritype.createuri(url).getblob();
	insert into blobtest values (10,image);
COMMIT;
END;

-- To view the blob

-- Open data window of your table.
-- The BLOB cell will be named as (BLOB).
-- Double click the cell.
-- You will see a pencil icon. Click on it.
-- It will open a blob editor window.
-- You would find two check boxes against the option View as : Image or Text.
-- Select the appropriate check box.
-- If above step is still not convincing, then use the Download option.