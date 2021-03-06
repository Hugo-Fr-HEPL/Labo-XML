-- Dans SYS, création des utilisateurs
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
GRANT CREATE DATABASE LINK TO hugo;


CREATE OR REPLACE DIRECTORY MYDIR AS 'C:\';
CREATE OR REPLACE DIRECTORY MYDIR AS 'D:\Ecole\B3\XML\Labo-XML\SGBD';




CREATE USER hugo2 IDENTIFIED BY hugo
    DEFAULT TABLESPACE USERS
    TEMPORARY TABLESPACE TEMP
    PROFILE DEFAULT ACCOUNT UNLOCK;
ALTER USER hugo2 QUOTA UNLIMITED ON USERS;

GRANT CONNECT TO hugo2;
GRANT RESOURCE TO hugo2;
GRANT EXECUTE ON SYS.DBMS_LOCK TO hugo2;
GRANT EXECUTE ON SYS.OWA_OPT_LOCK TO hugo2;
GRANT CREATE DATABASE LINK TO hugo2;




CREATE USER hugoORDS IDENTIFIED BY hugoORDS
    DEFAULT TABLESPACE USERS
    TEMPORARY TABLESPACE TEMP
    PROFILE DEFAULT ACCOUNT UNLOCK;
ALTER USER hugoORDS QUOTA UNLIMITED ON USERS;

GRANT CONNECT TO hugoORDS;
GRANT RESOURCE TO hugoORDS;
GRANT EXECUTE ON SYS.DBMS_LOCK TO hugoORDS;
GRANT EXECUTE ON SYS.OWA_OPT_LOCK TO hugoORDS;
GRANT CREATE ANY DIRECTORY TO hugoORDS;
GRANT CREATE DATABASE LINK TO hugoORDS;
GRANT CREATE JOB TO hugoORDS;
GRANT MANAGE SCHEDULER TO hugoORDS;