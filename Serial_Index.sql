
-----------------------INDEX--------------------
/*
CREATE INDEX  index_name  ON table_name 
[USING method]
(column_name [ASC | DESC] [NULLS {FIRST | LAST }],...);
*/

--specify the index method such as btree, hash, gist, spgist, gin, and brin. 
--PostgreSQL uses btree by default.
--The ASC and DESC specify the sort order.
--ASC is the default.
--NULLS FIRST or NULLS LAST specifies nulls sort before or after non-nulls.
--The NULLS FIRST is the default when DESC is specified and NULLS LAST is the default when DESC is not specified.


CREATE TABLE testindex (
id integer PRIMARY KEY,
name varchar,
phone integer);

INSERT INTO testindex VALUES('1','sara','0210110001');
INSERT INTO testindex VALUES('2','ali','01102220000');
INSERT INTO testindex VALUES('3','hamid','01103232300');
INSERT INTO testindex VALUES('4','zahra','0210525231');



SELECT * FROM testindex WHERE phone = '01102220000';
CREATE INDEX test_index ON testindex (phone);

--CREATE INDEX name ON table USING hash (column);
CREATE INDEX test_index_2 ON testindex USING hash (phone);
----------- DROP --------------
--CASCADE:If the index has dependent objects, you use the CASCADE option to automatically drop these objects and all objects that depends on those objects.
--RESTRICT: The RESTRICT option instructs PostgreSQL to refuse to drop the index if any objects depend on it. The DROP INDEX uses RESTRICT by default.
--CONCURRENTLY:When you execute the DROP INDEX statement, PostgreSQL acquires an exclusive lock on the table and block other accesses until the index removal completes.
--The DROP INDEX CONCURRENTLY has some limitations:
--First, the CASCADE option is not supported
--Second, executing in a transaction block is also not supported


--DROP INDEX  [ CONCURRENTLY][ IF EXISTS ]  index_name [ CASCADE | RESTRICT ]
DROP INDEX test_index;


--Note that only B-tree indexes can be declared as unique indexes.
--When you define an UNIQUE index for a column, the column cannot store multiple rows with the same values.
CREATE UNIQUE INDEX index_name
ON table_name(column_name, [...]);

