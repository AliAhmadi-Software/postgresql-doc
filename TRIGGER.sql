CREATE TRIGGER name { BEFORE | AFTER | INSTEAD OF } { event [ OR ... ] }
    ON "table"
    [ FOR [ EACH ] { ROW | STATEMENT } ]
    [ WHEN ( condition ) ]
    EXECUTE PROCEDURE function_name (  )
	
CREATE OR REPLACE FUNCTION function_name() RETURNS TRIGGER AS $$
BEGIN
	.
	.
	.
END;
$$ LANGUAGE plpgsql;
	

--In an INSERT trigger, only NEW.col_name can be used.
--In a UPDATE trigger, you can use OLD.col_name and NEW.col_name .
--In a DELETE trigger, only OLD.col_name can be used; 

DROP TRIGGER [ IF EXISTS ] name ON table_name [ CASCADE | RESTRICT ]

--------------- CREATE TRIGGER -------------------
---------------   POSTGRESQL    ------------------


CREATE OR REPLACE FUNCTION upgradeRating() RETURNS TRIGGER AS $$
BEGIN
	IF NEW.age < 18 THEN 
	UPDATE "Sailors" S SET rating=rating+1 
	WHERE S.sid = NEW.sid;
	END IF;
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER  upgradeRatingTrigger
	AFTER INSERT ON "Sailors"
FOR EACH ROW
EXECUTE PROCEDURE upgradeRating(); 

-- test trigger
INSERT INTO "Sailors" VALUES(12,'رضا',12,9);
INSERT INTO "Sailors" VALUES(13,'احمد',20,3);


DROP TRIGGER upgradeRatingTrigger  ON  "Sailors";

--With  WHEN

CREATE OR REPLACE FUNCTION upgradeRating22() RETURNS TRIGGER AS $$
BEGIN
	UPDATE "Sailors" S SET rating=rating+1 
	WHERE S.sid = NEW.sid;
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER  upgradeRatingTrigger22
	AFTER INSERT ON "Sailors"
FOR EACH ROW
WHEN (new.age < 18) 
EXECUTE PROCEDURE upgradeRating22();

DROP TRIGGER upgradeRatingTrigger22 ON "Sailors";

INSERT INTO "Sailors" VALUES(16,'احمد',15,3);
INSERT INTO "Sailors" VALUES(21,'احمد',20,2);

------------------
CREATE OR REPLACE FUNCTION upgradeRating2() RETURNS TRIGGER AS $$
BEGIN
	IF NEW.age < 18 THEN 
	NEW.rating=NEW.rating+1;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

 
CREATE TRIGGER  upgradeRatingTrigger2
	BEFORE INSERT ON "Sailors"
FOR EACH ROW
EXECUTE PROCEDURE upgradeRating2();
-- test trigger
INSERT INTO "Sailors" VALUES(14,'رضا',12,10);
INSERT INTO "Sailors" VALUES(15,'رضا',13,10);

SELECT * FROM "Sailors" WHERE sid = 14;
DELETE FROM "Sailors" WHERE sid = 15;

DROP TRIGGER upgradeRatingTrigger2 ON Sailors;
----------
CREATE TRIGGER  upgradeBoatsTrigger2
	BEFORE INSERT ON "Boats"
FOR EACH ROW
EXECUTE PROCEDURE upgradeBoats();

CREATE OR REPLACE FUNCTION upgradeBoats() RETURNS TRIGGER AS $$
BEGIN
	NEW.color = TRIM(NEW.color); --TRIM: Remove leading spaces from a string
	NEW.bname = UPPER(NEW.bname);
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- test trigger
INSERT INTO "Boats" VALUES(11,'   red  ','star');
select * from "Boats" 
DROP TRIGGER upgradeBoats ON Boats  CASCADE;

--------------------------------------------------
CREATE TABLE warehouse(
   id INT PRIMARY KEY  NOT NULL,
   Product_ID INT NOT NULL,
   Inventory INT NOT NULL );
   
 CREATE TABLE AUDIT(
   Product_ID INT NOT NULL,
   ENTRY_DATE TEXT NOT NULL);

INSERT INTO warehouse(id, Product_ID,Inventory) VALUES (1,1,10);
INSERT INTO warehouse(id, Product_ID,Inventory) VALUES (2,2,50);


CREATE TRIGGER AUDIT_trigger 
AFTER UPDATE  ON warehouse
FOR EACH ROW 
EXECUTE PROCEDURE AUDIT_triggerfunc();


CREATE OR REPLACE FUNCTION AUDIT_triggerfunc() RETURNS TRIGGER AS 
$$
   BEGIN
      INSERT INTO AUDIT(Product_ID, ENTRY_DATE) VALUES (new.Product_ID, now());
      RETURN NEW;
   END;
$$
LANGUAGE plpgsql;
--test tridgger
update   warehouse set Inventory=Inventory+10 where Product_ID=1; 
select * from AUDIT
select * from warehouse
--------------------------------
CREATE TABLE statename (
	code character(5),
    name character(15),
	PRIMARY KEY (code)         
);


CREATE OR REPLACE FUNCTION trigger_insert_update_statename() 
RETURNS trigger AS $$ 
BEGIN 
    IF new.code !~ '[A-Za-z][A-Za-z]' 
    THEN RAISE EXCEPTION 'State code must be two alphabetic characters.'; RETURN NULL;
    END IF; 
 
    IF length(TRIM(new.name)) < 3 
    THEN RAISE EXCEPTION 'State name must longer than two characters.'; RETURN NULL;
    END IF; 
	
    new.name = initcap(new.name); -- capitalize statename.name 
	
    RETURN new; 
   END;
$$ LANGUAGE plpgsql; 


CREATE TRIGGER trigger_statename 
BEFORE INSERT OR UPDATE 
ON statename 
FOR EACH ROW 
EXECUTE PROCEDURE trigger_insert_update_statename(); 

-- test trigger
DELETE FROM statename;
INSERT INTO statename VALUES ('11','BBB');
INSERT INTO statename VALUES ('AA','BB');
INSERT INTO statename VALUES ('1A5A0','123');
INSERT INTO statename VALUES ('1AA0','123');
INSERT INTO statename VALUES ('AA','BBB');
INSERT INTO statename VALUES ('AA6','BBB');


SELECT * FROM statename;
-----------------------------------------------------

CREATE TRIGGER trigger_sailors_delete 
BEFORE DELETE ON "Reserves" 
FOR EACH ROW 
EXECUTE PROCEDURE trig_delete_sailors_fun(); 

CREATE OR REPLACE FUNCTION trig_delete_sailors_fun()
RETURNS trigger AS $$ 
BEGIN 
	IF OLD.date='2011-02-10'
 	   THEN RAISE EXCEPTION 'You are not allowed to delete the Reserved Boats in date = 2011-02-10.';
	end if;
    RETURN NULL;	
END;
$$ LANGUAGE plpgsql; 

delete  from "Reserves" where date='2011-02-10'
delete  from "Reserves" where date='2011-02-9'
