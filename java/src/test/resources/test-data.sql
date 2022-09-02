BEGIN TRANSACTION;

DROP TABLE IF EXISTS users;
DROP SEQUENCE IF EXISTS seq_user_id;

CREATE SEQUENCE seq_user_id
  INCREMENT BY 1
  NO MAXVALUE
  NO MINVALUE
  CACHE 1;


CREATE TABLE users (
	user_id int DEFAULT nextval('seq_user_id'::regclass) NOT NULL,
	username varchar(50) NOT NULL UNIQUE,
	password_hash varchar(200) NOT NULL,
	role varchar(50) NOT NULL,
	email varchar(64) NOT NULL,
	CONSTRAINT PK_user PRIMARY KEY (user_id)
);

INSERT INTO users (username,password_hash,role, email) VALUES ('user1','user1','ROLE_USER','email');
INSERT INTO users (username,password_hash,role, email) VALUES ('user2','user2','ROLE_USER','email');
INSERT INTO users (username,password_hash,role, email) VALUES ('user3','user3','ROLE_USER','email');


COMMIT TRANSACTION;
