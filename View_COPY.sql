--CREATE VIEW view_name AS query;


CREATE VIEW S_R AS
SELECT * FROM ("Sailors" NATURAL JOIN "Reserves");

SELECT * FROM S_R;


SELECT S_R.*, B.color FROM S_R, "Boats" as B;

SELECT * FROM S_R WHERE age > 45;
--------
CREATE VIEW S AS
SELECT sid,sname,age FROM "Sailors" where age >30



INSERT INTO S VALUES(23,'علی',35);
delete from S where sid=23
update S set sname='ahmad' where sid=23

SELECT * FROM S;
--
CREATE VIEW S2 AS
SELECT max(age),rating FROM "Sailors" where age >30 GROUP BY rating

INSERT INTO S2
VALUES(2,11);

-- ERROR:  cannot insert into view "s_r"
-- HINT:  You need an unconditional ON INSERT DO INSTEAD rule or an INSTEAD OF INSERT trigger.
--GROUP BY, HAVING, DISTINCT, UNION, INTERSECT, EXCEPT, any aggregate function such as SUM, COUNT, AVG, MIN, and MAX and ....
INSERT INTO S_R 
VALUES(23,'علی',46,8,4,'2011-02-24');


-- ERROR:  cannot delete from view "s_r"
-- HINT:  You need an unconditional ON DELETE DO INSTEAD rule or an INSTEAD OF DELETE trigger.
DELETE FROM S_R WHERE sid = 15;



-- ERROR:  column "sid" specified more than once
CREATE VIEW S_R2 AS 
SELECT * FROM "Sailors" S,"Reserves" R 
WHERE S.sid=R.sid;

CREATE VIEW S_R2 AS 
SELECT S.*,R.bid,R.date FROM "Sailors" S,"Reserves" R 
WHERE S.sid=R.sid;


-- MATERIALIZED VIEW implemented in PostgreSQL 9.3 OR newer version

CREATE MATERIALIZED VIEW mymatview AS 
SELECT * FROM ("Sailors" NATURAL JOIN "Reserves") W ;

SELECT * FROM mymatview;

-- materialized view cannot subsequently be directly updated

REFRESH MATERIALIZED VIEW mymatview;



--- COPY EXAPLE


COPY "Sailors" TO 'D:\test2.csv' WITH HEADER CSV;

CREATE TABLE "Sailors_test"
(
  sid integer NOT NULL,
  sname character varying(30),
  age integer,
  rating integer,
  PRIMARY KEY (sid )
)


COPY "Sailors_test" FROM 'D:\test2.csv' WITH HEADER CSV DELIMITER ',';

SELECT * FROM "Sailors_test"

INSERT INTO "Sailors_test" SELECT * FROM  "Sailors"

CREATE TABLE "Sailors_test2" AS TABLE "Sailors" WITH NO DATA;

CREATE TABLE "Sailors_test3" AS TABLE "Sailors";

