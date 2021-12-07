-- TABLE EMP (Exportée)
--------------------------------------------------------
--  DDL for Table EMP
--------------------------------------------------------

  CREATE TABLE "TESTORDS"."EMP" 
   (	"EMPNO" NUMBER(4,0), 
	"ENAME" VARCHAR2(10 BYTE), 
	"JOB" VARCHAR2(9 BYTE), 
	"MGR" NUMBER(4,0), 
	"HIREDATE" DATE, 
	"SAL" NUMBER(7,2), 
	"COMM" NUMBER(7,2), 
	"DEPTNO" NUMBER(2,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
REM INSERTING into TESTORDS.EMP
SET DEFINE OFF;
Insert into TESTORDS.EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) values ('7900','James','Clerk','7698',to_date('03/12/81','DD/MM/RR'),'950',null,'30');
Insert into TESTORDS.EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) values ('7902','Ford','Analyst','7566',to_date('03/12/81','DD/MM/RR'),'3000',null,'20');
Insert into TESTORDS.EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) values ('7934','Miller','Clerk','7782',to_date('23/01/82','DD/MM/RR'),'1300',null,'10');
Insert into TESTORDS.EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) values ('9999','HALL','ANALYST','7782',to_date('01/01/16','DD/MM/RR'),'1000',null,'10');
--------------------------------------------------------
--  DDL for Index PK_EMP
--------------------------------------------------------

  CREATE UNIQUE INDEX "TESTORDS"."PK_EMP" ON "TESTORDS"."EMP" ("EMPNO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  Constraints for Table EMP
--------------------------------------------------------

  ALTER TABLE "TESTORDS"."EMP" ADD CONSTRAINT "PK_EMP" PRIMARY KEY ("EMPNO")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;



-- Module GET
SELECT * FROM emp WHERE empno = :empno

-- Module POST
DECLARE
   id EMP.EMPNO%type;
BEGIN

  SELECT empno into id from emp where UPPER(ename) LIKE UPPER('%' || :name || '%') AND UPPER(job) LIKE UPPER('%' || :job || '%') FETCH first 1 row only;

    htp.prn(id);

END;

-- Base64Encode
create or replace FUNCTION base64encode(p_blob IN BLOB) RETURN CLOB IS
  l_clob CLOB;
  l_step PLS_INTEGER := 12000; -- make sure you set a multiple of 3 not higher than 24573
BEGIN
 IF(p_blob is not null) THEN
  FOR i IN 0 .. TRUNC((DBMS_LOB.getlength(p_blob) - 1 )/l_step) LOOP
    l_clob := l_clob || UTL_RAW.cast_to_varchar2(UTL_ENCODE.base64_encode(DBMS_LOB.substr(p_blob, l_step, i * l_step + 1)));
  END LOOP;
  END IF;
  RETURN l_clob;
END base64encode;

-- Rappel de l'utilisation des images
-- GRANT SUR LES ACL (à faire en SYS sur le même conteneur)
BEGIN
	DBMS_NETWORK_ACL_ADMIN.CREATE_ACL (
		acl => 'aclLabo3.xml', 
		description => 'Acces a internet pour les images', 
		principal => 'TESTORDS',
		is_grant => true,
		privilege => 'connect'
	);

	DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL(
		acl => 'aclLabo3.xml',
		host => 'www.provincedeliege.be');
	END;

--ALLER CHERCHER UN BLOB
DECLARE
    image blob;
    url varchar2(200) := 'http://www.provincedeliege.be/';
BEGIN
    url := concat (url ,'sites/default/files/styles/plg_medias_800/public/media/5549/Campus%20Seraing%20-%20Parc%20des%20Marêts.png');
    image := httpuritype.createuri(url).getblob();
    insert into images values (10,image);
COMMIT;
END;

--------------------------------------------------------
--  DDL for Table IMAGES (Exported)
--------------------------------------------------------

  CREATE TABLE "TESTORDS"."IMAGES" 
   (	"IMAGE_ID" NUMBER, 
	"IMAGE" BLOB
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" 
 LOB ("IMAGE") STORE AS SECUREFILE (
  TABLESPACE "USERS" ENABLE STORAGE IN ROW CHUNK 8192
  NOCACHE LOGGING  NOCOMPRESS  KEEP_DUPLICATES 
  STORAGE(INITIAL 106496 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)) ;
--------------------------------------------------------
--  DDL for Index IMAGES_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TESTORDS"."IMAGES_PK" ON "TESTORDS"."IMAGES" ("IMAGE_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  Constraints for Table IMAGES
--------------------------------------------------------

  ALTER TABLE "TESTORDS"."IMAGES" MODIFY ("IMAGE_ID" NOT NULL ENABLE);
  ALTER TABLE "TESTORDS"."IMAGES" ADD CONSTRAINT "IMAGES_PK" PRIMARY KEY ("IMAGE_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;

-- Module GET pour les images
--SELECT image FROM images 
SELECT base64encode(image) FROM images

-- Code Java (voir fichiers joints)