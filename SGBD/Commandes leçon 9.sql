-- Dans SYS, cr�ation des utilisateurs
CREATE USER DB1 IDENTIFIED BY oracle   
  DEFAULT TABLESPACE USERS 
  TEMPORARY TABLESPACE TEMP 	
  PROFILE DEFAULT ACCOUNT UNLOCK;
ALTER USER DB1 QUOTA UNLIMITED ON USERS;

GRANT CONNECT TO DB1;
GRANT RESOURCE TO DB1;
GRANT EXECUTE ON SYS.DBMS_LOCK TO DB1;
GRANT EXECUTE ON SYS.OWA_OPT_LOCK TO DB1;

CREATE USER DB2 IDENTIFIED BY oracle   
  DEFAULT TABLESPACE USERS 
  TEMPORARY TABLESPACE TEMP 	
  PROFILE DEFAULT ACCOUNT UNLOCK;
ALTER USER DB2 QUOTA UNLIMITED ON USERS;

GRANT CONNECT TO DB2;
GRANT RESOURCE TO DB2;
GRANT EXECUTE ON SYS.DBMS_LOCK TO DB2;
GRANT EXECUTE ON SYS.OWA_OPT_LOCK TO DB2;

-- Dans DB1, Cr�ation d'une table TEST  et ajout d'un tuple
CREATE TABLE test (
   Attribut VARCHAR2(50) NOT NULL
);
INSERT INTO test VALUES('Coucou');
commit;

-- Dans DB2, Cr�ation d'une table TEST et ajout d'un tuple
CREATE TABLE test (
   Attribut VARCHAR2(50) NOT NULL
);
INSERT INTO test VALUES('C''est nous');
commit;

-- Dans DB1, cr�ation d'un DBLink
create database link local_link CONNECT TO DB2 IDENTIFIED BY oracle using '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1521))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=xepdb1)))';
-- (erreur, privil�ges insuffisants)

-- Dans SYS, accord des droits de cr�ation de DBLink
GRANT CREATE DATABASE LINK TO DB1;
GRANT CREATE DATABASE LINK TO DB2;

-- Dans DB1, deuxi�me essai cr�ation d'un DBLink
create database link local_link CONNECT TO DB2 IDENTIFIED BY oracle using '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1521))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=xepdb1)))';

-- Dans DB1, tentative d'acc�s
SELECT *
FROM test;

SELECT *
FROM test@local_link;

-- Dans DB2, cr�ationd d'un DBLink d�fectueux
create database link local_link CONNECT TO DB1 IDENTIFIED BY oracle using 'unknown';
-- Pas d'erreur!

-- Dans DB2, tentative d'acc�s
SELECT *
FROM test@local_link;
-- erreur! Ne connait pas le nom "unknown" dans TNSNames.ora

-- Dans DB2, suppression du DBLink
DROP DATABASE LINK local_link;

-- Dans DB2, recr�ation du link et test
create database link local_link CONNECT TO DB1 IDENTIFIED BY oracle using '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1521))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=xepdb1)))';
SELECT *
FROM test@local_link;