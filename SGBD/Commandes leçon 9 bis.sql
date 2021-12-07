-- Si problèmes de connection avec Oracle XE, impossible d'utiliser les DB links
-- ==> passer par un simple GRANT

-- Dans SYS
GRANT SELECT, INSERT, UPDATE, DELETE ON DB2.TEST TO DB1;

-- Dans DB1
INSERT INTO DB2.test values ('Mon test');
commit;

SELECT * FROM DB2.test;