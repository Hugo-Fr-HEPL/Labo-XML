-- Blob
-- GRANT SUR LES ACL (� faire en SYS sur le m�me conteneur)
BEGIN
	DBMS_NETWORK_ACL_ADMIN.CREATE_ACL (
		acl => 'aclLabo4.xml', 
		description => 'Acces a internet pour les images', 
		principal => 'HUGO',
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
	url varchar2(200) := 'http://image.noelshack.com/';
BEGIN
	url := concat (url ,'/sav0jxhqiH0bPr2vZFU0Kjt2nZL.jpg');
	image := httpuritype.createuri(url).getblob();
	insert into blobtest values (10,image);
COMMIT;
END;
