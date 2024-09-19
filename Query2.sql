--COUNT , SUM , AVG, MAX , MIN 
--------- COUNT -----------
SELECT COUNT(*) FROM "Boats";
-- چند رنگ متفاوت برای قایق ها داریم
SELECT COUNT(DISTINCT color) FROM "Boats";
SELECT COUNT(color) FROM "Boats";
SELECT color FROM "Boats";
 
--incorrect
SELECT COUNT(color, bid) FROM "Boats";

-- COUNT & NULL
INSERT INTO "Boats" (bid,color,bname) values (7,NULL,'AA');
DELETE FROM "Boats" WHERE bid = 7;
--  چند قایقران داریم که سن آنها از 45 بیشتر است
SELECT COUNT(*) FROM "Sailors" WHERE age > 45;
----------------   AVG   ----------
SELECT AVG(age) FROM "Sailors";

--------       SUM /MAX/ MIN      -----------
-- حداکثر سن قایقران ها
SELECT MAX(age) FROM "Sailors";
SELECT MIN(age) FROM "Sailors";
SELECT SUM(age) FROM "Sailors";

-- اطلاعات مسن ترین قایقران
SELECT * FROM "Sailors"   WHERE age = (SELECT MAX(age) FROM "Sailors") ;
-----------   INCORRECT USE -----------
SELECT * FROM "Sailors" WHERE age =MAX(age)
-----------   INCORRECT USE -----------
 SELECT   sname, MAX (age) FROM  "Sailors" 
--------     GROUP BY       ---------------
 
-- تاریخی که هر قایقران اولین قایق خود را رزرو نموده است
SELECT sid, MIN(date) FROM "Reserves"  GROUP BY sid;

SELECT sid, COUNT(*) AS CNT FROM "Reserves" R 
GROUP BY sid 
ORDER BY CNT DESC;
 
 
SELECT * FROM 
(
	SELECT sid, COUNT(*) AS CNT FROM "Reserves" R 
	GROUP BY sid 
  UNION
	SELECT sid,0 FROM
	(SELECT sid FROM "Sailors" 
  EXCEPT
	SELECT sid FROM "Reserves") AS T1
	
) AS T2
ORDER BY CNT DESC;


--تعداد دفعاتی که هر قایق بعد از تاریخ 28-01-2011 رزرو شده است
SELECT bid, count(*) FROM "Reserves" R
WHERE date >= '2011-01-28'
GROUP BY bid

------      HAVING       -------------------
-- شماره قایقران هایی که بیش از 4 بار قایق رزرو کرده اند
SELECT sid, COUNT(*) FROM "Reserves" R 
GROUP BY sid 
HAVING count(*) > 4;

-- شماره قایقران هایی که بعد از تاریخ 24-02-2011 بیش از 2 بار قایق رزرو کرده اند
SELECT sid, COUNT(*) FROM "Reserves" R 
WHERE date > '2011-02-24' 
GROUP BY sid 
HAVING count(*) > 2;
--قایق هایی که بیش از یک بار توسط یک قایقران رزرو شده یاشد
SELECT sid, bid , COUNT(*) FROM "Reserves" 
GROUP BY sid,bid 
HAVING count(*) > 1;

-- چند قایقران داریم که یک قایق را بیش از یک بار رزرو کرده اند
SELECT COUNT(DISTINCT sid) FROM
(SELECT sid, bid , COUNT(*) FROM "Reserves" 
GROUP BY sid,bid HAVING count(*) > 1) AS T1
 --کدام قایق بیشتر از یکبار توسط یک قایقران رزرو شد
SELECT DISTINCT R.bid, bname 
FROM "Reserves" R, "Boats" B 
WHERE R.bid=B.bid 
GROUP BY sid,R.bid,bname 
HAVING count(*) > 1;

--------      HAVING     EVERY        -------------
SELECT sid,bid,date,(date > '2011-02-13') as "new-name"
FROM "Reserves" where sid=4

SELECT COUNT(*),EVERY (date > '2007-02-13') 
FROM "Reserves"   

SELECT sid, COUNT(*),EVERY (date > '2011-02-13') 
FROM "Reserves" R 
GROUP BY sid 

SELECT sid, COUNT(*) FROM "Reserves" R 
GROUP BY sid 
HAVING count(*) > 1 AND EVERY (date > '2011-02-13');
------------x-
SELECT sid, COUNT(*) FROM "Reserves" R 
WHERE date > '2011-02-13'
GROUP BY sid HAVING count(*) > 1 

SELECT sid, COUNT(*) FROM "Reserves" R 
WHERE date > '2011-02-25'
GROUP BY sid 
HAVING count(*) > 1 AND sid = 1
 
SELECT  S.rating,  MIN (S.age), COUNT(*)
FROM  "Sailors" S
WHERE  S.age > 20
GROUP BY  S.rating
HAVING  1  <  COUNT (*);
                    
SELECT  S.rating,  MIN (S.age), COUNT(*)
FROM  "Sailors" S
WHERE  S.age > 18
GROUP BY  S.rating
HAVING  1  <  (SELECT  COUNT (*)
                         FROM  "Sailors" S2
                         WHERE  S.rating=S2.rating);


---------    NATURAL JOIN      --------

SELECT * FROM ("Sailors" NATURAL JOIN "Reserves") AS W ;
SELECT * FROM "Sailors" S,"Reserves" R WHERE R.sid=S.sid ;

SELECT COUNT(*),sname 
FROM "Sailors"  NATURAL JOIN "Reserves"  
GROUP BY sid;

---------        JOIN      --------
SELECT * FROM ("Sailors" JOIN "Reserves" ON "Sailors".sid = "Reserves".sid ) H ;
 
SELECT COUNT(*),sname FROM "Sailors" JOIN "Reserves" ON "Sailors".sid = "Reserves".sid 
GROUP BY "Sailors".sid;

---------        LEFT OUTER JOIN      --------

SELECT * FROM "Sailors" LEFT OUTER JOIN "Reserves" 
		ON "Sailors".sid = "Reserves".sid ;
--تعداد قایق های رزرو شده توسط هر قایقران
--غلط
SELECT COUNT(*),sname 
FROM "Sailors" LEFT OUTER JOIN "Reserves" 
ON "Sailors".sid = "Reserves".sid 
GROUP BY "Sailors".sid;
--درست
SELECT COUNT(bid) AS CNT,sname 
FROM "Sailors" LEFT OUTER JOIN "Reserves" 
ON "Sailors".sid = "Reserves".sid 
GROUP BY "Sailors".sid
ORDER BY CNT
--هر قایقران چند قایق مجزا رزرو کرده است
SELECT COUNT(DISTINCT "Reserves".bid ),sname 
FROM "Sailors" 
LEFT OUTER JOIN "Reserves" ON "Sailors".sid = "Reserves".sid 
GROUP BY "Sailors".sid;


SELECT AVG(CNT) FROM
(SELECT COUNT(DISTINCT "Reserves".bid ) AS CNT,sname FROM "Sailors" 
LEFT OUTER JOIN "Reserves" ON "Sailors".sid = "Reserves".sid 
GROUP BY "Sailors".sid) AS T1

SELECT MIN(date), COUNT(*),sname FROM "Sailors" LEFT OUTER JOIN "Reserves" ON "Sailors".sid = "Reserves".sid GROUP BY "Sailors".sid;

SELECT MIN(date), COUNT(*),sname FROM "Sailors" LEFT OUTER JOIN "Reserves" ON "Sailors".sid = "Reserves".sid GROUP BY "Sailors".sid HAVING MIN(date) > '2011-01-01';


---------        RIGHT OUTER JOIN      --------
SELECT * FROM "Reserves" RIGHT OUTER JOIN "Sailors" ON "Sailors".sid = "Reserves".sid ;
 

---------        FULL OUTER JOIN      --------
SELECT * FROM "Sailors" FULL OUTER JOIN "Reserves" ON "Sailors".sid = "Reserves".sid ;

SELECT COUNT(*),sname FROM "Sailors" RIGHT OUTER JOIN "Reserves" ON "Sailors".sid = "Reserves".sid GROUP BY "Sailors".sid;




---------   DIFFERENCE OF JOIN and LEFT OUTER JOIN    -----------------

SELECT * FROM "Sailors" LEFT OUTER JOIN "Reserves" ON "Sailors".sid = "Reserves".sid
EXCEPT
SELECT * FROM "Sailors" JOIN "Reserves" ON "Sailors".sid = "Reserves".sid ;

SELECT COUNT(*),sname FROM "Sailors" LEFT OUTER JOIN "Reserves" ON "Sailors".sid = "Reserves".sid GROUP BY "Sailors".sid
EXCEPT
SELECT COUNT(*),sname FROM "Sailors" JOIN "Reserves" ON "Sailors".sid = "Reserves".sid GROUP BY "Sailors".sid;



----------------UPDATE && DELET------------
INSERT INTO "Sailors" VALUES(11,'ali',35,9)
INSERT INTO "Sailors" VALUES(12,'zz',35,9)
     

/*
DELETE FROM table WHERE condition;
*/
DELETE FROM "Sailors";
DELETE  FROM "Sailors" WHERE sid=11

SELECT * FROM "Sailors"
/*
UPDATE table
SET column1 = value1,
  column2 = value2 ,...
WHERE
  condition;
*/  
update "Sailors" 
set age=60
where sid=11


update "Sailors" 
set age=60*10


update "Sailors" 
set age=60/10
