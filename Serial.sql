--smallserial / 2 bytes / 1 to 32767
--serial / 4 bytes / 1 to 2147483647
--bigserial/ 8 bytes/ 1 to 9223372036854775807

CREATE TABLE Test (
	id	SERIAL PRIMARY KEY,
	name character varying (20))



Incorrect:
INSERT INTO Test values ('Ali');
correct:
INSERT INTO Test ( name ) values ('Ali');
INSERT INTO Test ( name ) values ('sara');
INSERT INTO Test ( name ) values ('hasan');
INSERT INTO Test(id,name) VALUES(DEFAULT,'ahmad');

INSERT INTO Test(name) VALUES('sara') RETURNING id;

SELECT * FROM test
-----------  SEQUENCE  ------------
--The sequence name must be distinct from any other sequences, tables, indexes, views, or foreign tables in the same schema. 
--The default data type is BIGINT if you skip it.
/*
CREATE SEQUENCE [ IF NOT EXISTS ] sequence_name
    [ AS { SMALLINT | INT | BIGINT(Default) } ]
    [ INCREMENT [ BY ] increment ]
    [ MINVALUE minvalue | NO MINVALUE ] 
    [ MAXVALUE maxvalue | NO MAXVALUE ]
    [ START [ WITH ] start ] 
    [ CACHE cache ] 
    [ [ NO ] CYCLE ]
    [ OWNED BY { table_name.column_name | NONE } ]
*/

CREATE SEQUENCE  IF NOT EXISTS mysequence
INCREMENT 5
START 100
;
SELECT nextval('mysequence'); /*Run Multi Time*/

CREATE SEQUENCE mysequence2
INCREMENT 3
MINVALUE 1 
MAXVALUE 10
START 3
CYCLE; /*حرکت به صورت چرخشی*/
SELECT nextval('mysequence2');

CREATE SEQUENCE mysequence3
INCREMENT 3
MINVALUE 1 
MAXVALUE 10
START 1
SELECT nextval('mysequence3'); /*بعد از رسیدن به مقدار ماکس ارور میدهد*/

----------------------------
CREATE SEQUENCE Test_id_seq; 


CREATE TABLE test2 ( 
id integer NOT NULL DEFAULT nextval(' Test_id_seq '),
name character varying (20) );



INSERT INTO test2 ("name") values ('Ali') RETURNING id;

SELECT nextval('Test_id_seq');

select * from test2

------------------DROP SEQUENCE-----------------------
--Otherwise, you need to remove the sequence manually using the DROP SEQUENCE statement:
DROP SEQUENCE [ IF EXISTS ] sequence_name [, ...] 
[ CASCADE | RESTRICT ];

DROP SEQUENCE IF EXISTS Test_id_seq  CASCADE;
