----------DECLARE variables------------
/*
DECLARE 
variable_name data_type [:= expression];
constant_name CONSTANT data_type := expression;
 
*/
--------------block --------------
/*
[ DECLARE
    declarations ]
BEGIN
    statements;
	...
END ;
*/
------------CREATE FUNCTION--------------
/*
CREATE [OR REPLACE] FUNCTION function_name (arg1  datatype, ...)
RETURN return_datatype AS
$$
[DECLARE
    declarations ]
BEGIN
BODY of function 
END
$$
LANGUAGE language_of_function   
*/
--LANGUAGE: PL/pgSQL, PL/Perl,PL/PHP, PL/Python,PL/Ruby, PL/Java , PL/R 
---------FUNCTION SQL------------------ 
CREATE TABLE Rectangle (RectId int, a real, b real);
INSERT INTO Rectangle VALUES(1, 5.5, 6.6);
INSERT INTO Rectangle VALUES(2, 3.3, 4.4);
---
CREATE OR REPLACE FUNCTION area( real, real) RETURNS real
AS 'SELECT $1*$2;'
LANGUAGE SQL;


SELECT area(12,34);
SELECT RectId, area(a, b) FROM Rectangle;

 ---------FUNCTION PL/Pgsql---------
CREATE OR REPLACE FUNCTION get_sum(a NUMERIC, b NUMERIC) 
RETURNS NUMERIC AS 
$$
BEGIN
	RETURN a + b;
END; 
$$
LANGUAGE plpgsql;
SELECT get_sum(10,20);

-------OUT parameters -------------
CREATE OR REPLACE FUNCTION test(a NUMERIC, b NUMERIC,c NUMERIC,  OUT sum1 NUMERIC,OUT mul NUMERIC)
AS $$
BEGIN
	sum1 := a+b+c;
	mul := a*b*c;
END; $$
LANGUAGE plpgsql;
SELECT test(10,20,30);
--make the output separated as columns, you use the following syntax:
SELECT * FROM test(10,20,30);
-----------------list variables----
CREATE OR REPLACE FUNCTION sum_avg(VARIADIC list NUMERIC[], OUT total NUMERIC, OUT average NUMERIC)
AS $$
BEGIN
   SELECT INTO total SUM(list[i])
   FROM generate_subscripts(list, 1) g(i);

   SELECT INTO average AVG(list[i])
   FROM generate_subscripts(list, 1) g(i);
END; $$
LANGUAGE plpgsql;
SELECT * FROM sum_avg(10,20,30,12);


------PL/pgSQL Errors and Messages------
--If you don’t specify the level, by default, the RAISE statement will use EXCEPTION level that raises an error and stops the current transaction
--Notice that not all messages are reported back to the client, only INFO, WARNING, and NOTICE level messages are reported to the client
--Notice that not all messages are reported back to the client, only INFO, WARNING, and NOTICE level messages are reported to the client. 

-- EXCEPTION,NOTICE,WARNING, DEBUG, LOG, INFO
 
DO $$ 
BEGIN 
   RAISE LOG 'log message %', now();
   RAISE DEBUG 'debug message %', now();
   RAISE INFO 'information message %', now() ;
   RAISE WARNING 'warning message %', now();
   RAISE NOTICE 'notice message %', now();
END $$;

DO $$ 
DECLARE
  email varchar(255) := 'info@postgresqltutorial.com';
BEGIN 
 
  RAISE EXCEPTION 'Duplicate email: %', email
		 USING HINT = 'Check the email again';

END $$;

--MESSAGE: set error message text
 --HINT: provide the hint message so that the root cause of the error is easier to be discovered.
 --DETAIL:  give detailed information about the error.
-- ERRCODE: identify the error code, which can be either by condition name or directly five-character SQLSTATE code
-------------------------IF AND CASE------------------
CREATE OR REPLACE FUNCTION AB(OUT aa integer) AS $$
 DECLARE
   a integer := 10;
   b integer := 10;
BEGIN  
  IF a > b THEN 
    aa=a*b;
   ELSIF a < b THEN
     aa=a+b;
   ELSE
     RAISE NOTICE 'a is equal to b';
	 aa=a;
   END IF;
END; $$
LANGUAGE plpgsql;
SELECT AB();

CREATE OR REPLACE FUNCTION AB1() RETURNS VARCHAR(50) AS $$
 DECLARE
   rate integer := 10;
   msg VARCHAR(50);
  BEGIN 
  CASE rate
     WHEN 100 THEN
            msg = 'rate is 100';
	WHEN 10 THEN
            msg = 'rate is 10';
	WHEN 1 THEN
            msg = 'rate is 1';
	End CASE;
	 RETURN msg;
END;
$$ LANGUAGE plpgsql;

SELECT AB1();
----------------------for and WHILE-------------------
CREATE OR REPLACE FUNCTION AB2() RETURNS void  
AS $$
 BEGIN 
  FOR counter IN 1..5 BY 2 LOOP
	RAISE NOTICE 'Counter: %', counter;
   END LOOP;
END;
$$ LANGUAGE plpgsql;
SELECT AB2();

CREATE OR REPLACE FUNCTION AB3(n INTEGER) RETURNS INTEGER 
AS $$
DECLARE
counter INTEGER := 0;
i INTEGER := 1;
 BEGIN 
 
     WHILE counter <= n LOOP
		counter := counter + 1 ;
		i=i*n;
     END LOOP ; 
	 RETURN i ;
	
END;
$$ LANGUAGE plpgsql;

SELECT AB3(5);
--*********************-----------------------------
CREATE FUNCTION ft() RETURNS record AS 
$$
DECLARE
	t record;
BEGIN
		SELECT * INTO t FROM "Sailors"	 
		WHERE "Sailors".sid = 2 AND  "Sailors".rating = 10;
		IF NOT FOUND THEN	
			SELECT * INTO t FROM "Sailors"	  
			WHERE "Sailors".rating = 10;
			
			
		END IF;
		RETURN t;
END;
$$ LANGUAGE plpgsql;

SELECT  ft();

---***-
CREATE FUNCTION ft2() RETURNS TABLE (sname character VARying,rating  integer ) 
AS 
$$
BEGIN
		RETURN QUERY SELECT "Sailors".sname, "Sailors".rating FROM "Sailors"	 
		WHERE "Sailors".sid = 2 AND  "Sailors".rating = 10;
		IF NOT FOUND THEN	
		RETURN QUERY SELECT "Sailors".sname, "Sailors".rating  FROM "Sailors"	  
			WHERE "Sailors".rating = 10;
		END IF;		
END;
$$ LANGUAGE plpgsql;
SELECT * from ft2();

--------------------update insert -----------------------------
CREATE table book2 
(
id integer,
title text,	
author text	
);
insert into book2(id,title , author) values(1,'حمید عالمی','سیستم عامل'); 
insert into book2(id,title , author) values(2,'فاطمه صالح احمدی','حساب کامپیوتری'); 
insert into book2(id,title , author) values(3,'دکتر منهاج','شبکه عصبی'); 

-----------insert FUNCTION--------
CREATE OR REPLACE FUNCTION ins_book(id_p integer,p_title varchar , p_author text) RETURNS void 
AS $$
BEGIN
insert into book2(id,title , author) values(id_p,p_title,p_author); 
END; $$ 
LANGUAGE 'plpgsql';
select ins_book('4','پایگاه داده','روحانی رانکوهی')  
select * from book2
-------------update FUNCTION------------------
 CREATE OR REPLACE FUNCTION upd_book(id_p integer,p_title text , p_author text) RETURNS void 
AS $$
BEGIN
update book2 set   title=p_title , author=p_author   where id=id_p;
END; $$ 
LANGUAGE 'plpgsql';

select upd_book( '1','پایگاه ',' رانکوهی')   
select * from book2
-------------DELETE FUNCTION------------------
CREATE OR REPLACE FUNCTION del_book(id_p integer) RETURNS void 
AS $$
BEGIN
DELETE from book2 where id=id_p;
END; $$ 
LANGUAGE 'plpgsql';

select del_book( '1')   
select * from book2
------------------- Returns A Table----------
CREATE OR REPLACE FUNCTION get_Sailors (age_Sailors integer) 
	RETURNS TABLE (sname character VARying,rating  integer ) 
AS $$
BEGIN
RETURN QUERY SELECT  "Sailors".sname, "Sailors".rating FROM  "Sailors"  WHERE  age > age_Sailors;
END;
$$ 
LANGUAGE 'plpgsql';

select * from get_Sailors(41);  
------------------DROP------
DROP FUNCTION ft2();



----------------------Stored Procedures---------------------------------------------------------------
/*
CREATE [OR REPLACE] PROCEDURE procedure_name(parameter_list)
LANGUAGE language_name
AS $$
    stored_procedure_body;
$$;

CALL stored_procedure_name(parameter_list);

*/

CREATE TABLE accounts (
    id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    balance INT NOT NULL,
    PRIMARY KEY(id)
);

INSERT INTO accounts(id,name,balance)
VALUES(1,'ali',10000);
INSERT INTO accounts(id,name,balance)
VALUES(2,'Alice',10000);


CREATE OR REPLACE PROCEDURE transfer(a INT,b INT,c INT)
LANGUAGE plpgsql    
AS 
$$
BEGIN
     UPDATE accounts  SET balance = balance - c WHERE id = a;

     UPDATE accounts SET balance = balance + c WHERE id = b;

    COMMIT;
END;
$$;

CALL transfer(1,2,1000);
SELECT * FROM accounts;