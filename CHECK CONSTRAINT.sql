-------------CHECK CONSTRAINT / CREATE TABLE -------------- 
CREATE TABLE employees (
	id serial PRIMARY KEY,
	ename VARCHAR (50),
	birth_date DATE CHECK (birth_date > '1900-01-01'),
	joined_date DATE CHECK (joined_date > birth_date),
	salary numeric CHECK(salary > 0 and salary<=100000)
);
 

INSERT INTO employees (ename,birth_date,joined_date,salary)
VALUES('ali','1972-05-01','2015-07-01', 100000);

/*ّنادرست*/
INSERT INTO employees (ename,birth_date,joined_date,salary)
VALUES('ali','1972-01-01','2015-07-01',120000);

---------
CREATE TABLE "Sailors2"
(
  sid INTEGER  NOT NULL,
  sname CHARACTER VARYING(30),
  age INTEGER,
  rating INTEGER,
  CONSTRAINT "Sailors2_pkey" PRIMARY KEY (sid),
  CONSTRAINT chk_Sailors CHECK (age>18 AND rating between 1 and 10)  
);
INSERT INTO "Sailors2" VALUES(1,'ahmad',20,10);
INSERT INTO "Sailors2" VALUES(1,'ahmad',9,2);

-------------CHECK CONSTRAINT / ALTER TABLE -------------- 
ALTER TABLE "Sailors" ADD CHECK (sid > 0);
ALTER TABLE "Sailors" ADD CONSTRAINT T23 CHECK  (age > 10);

ALTER TABLE "Sailors" ADD CONSTRAINT Sailors_check2 CHECK 
(sid > 0 AND age >= 18 AND rating >= 1 );

ALTER TABLE "book2" ADD   CONSTRAINT "book2_pkey" PRIMARY KEY (id);

-------------DROP CHECK CONSTRAINT -------------- 

ALTER TABLE "Sailors" DROP  CONSTRAINT "Sailors_age_check" CASCADE 
ALTER TABLE "book2" DROP  CONSTRAINT "book2_pkey"     

 
