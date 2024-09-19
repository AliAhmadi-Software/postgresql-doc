/*
SELECT
  column_1,column_2,...
FROM
   table_name1,..;
*/ 
   
SELECT * FROM "Sailors";
SELECT sid,sname FROM "Sailors";
SELECT  sid AS id,sname AS name FROM "Sailors";
SELECT bid,color || ' - ' || bname AS color_name FROM "Boats";
SELECT bid,concat(color,' - ' , bname) AS color_name FROM "Boats";
SELECT sname,rating+10 AS new_rating FROM "Sailors";
 
/*
SELECT
    column_1,
    column_2
 FROM
   table_name
 ORDER BY
   column_1 [ASC | DESC],
   column_2 [ASC | DESC],
*/   
SELECT sname,rating FROM "Sailors" ORDER BY rating DESC,sname ASC;
SELECT sname,rating FROM "Sailors" ORDER BY rating ;
SELECT sid,sname,rating*10 FROM "Sailors" ORDER BY 3 DESC;

--------------------------------
SELECT * FROM "Sailors", "Boats";
SELECT sid,bid FROM "Sailors", "Boats";
SELECT S.sid  ,R.sid , date FROM "Sailors" S,"Reserves" R;


-------------------------------
/*
SELECT
  DISTINCT column_1
FROM
 table_name; 
*/
SELECT DISTINCT color FROM  "Boats";
SELECT  color FROM  "Boats";

-------------------------------
/*
SELECT
 column_1,column_2,...
FROM
 table_name;
WHERE  condition (=,>,<,>=,<=,<> !=,AND,OR)
ORDER BY
  column_1 [ASC | DESC]
*/

SELECT sname,age FROM "Sailors" WHERE age > 45;
SELECT * FROM "Sailors" WHERE age > 45 AND rating>=9;
SELECT * FROM "Sailors" WHERE age = 50 OR rating>=9;
SELECT * FROM "Sailors" WHERE rating >= 8 and rating<=10;
SELECT * FROM "Sailors" WHERE  rating between 8 and 10;
SELECT * FROM "Sailors" WHERE  rating NOT between 8 and 10;

SELECT S.*,date,bid FROM "Sailors" S,"Reserves" R WHERE S.sid=R.sid; 
SELECT S.*,date,bid FROM "Sailors" S,"Reserves" R WHERE S.sid=R.sid and S.sid=1 ;
SELECT S.* FROM "Sailors" S,"Reserves" R WHERE S.sid=R.sid AND bid = 3;


SELECT * FROM "Sailors" S,"Reserves" R WHERE S.sid=R.sid AND bid != 3;
SELECT * FROM "Sailors" S,"Reserves" R WHERE S.sid=R.sid AND bid <> 3;

SELECT * FROM "Sailors" WHERE  rating in (5,9,10);
SELECT * FROM "Sailors" WHERE  rating not in (5,9,10);
 ----------------------------------
SELECT * FROM "Sailors" WHERE sname LIKE '%ز' ;
SELECT * FROM "Sailors" WHERE sname LIKE 'ز%' ;
SELECT * FROM "Sailors" WHERE sname LIKE '%ل%ا%' ;
SELECT * FROM "Sailors" WHERE sname LIKE '%ل%ا%' OR sname LIKE 'ا%%د';
SELECT * FROM "Sailors" WHERE sname LIKE '__ا%';
SELECT * FROM "Sailors" WHERE sname LIKE '__ا';
SELECT * FROM "Sailors" WHERE sname LIKE '_ل%' OR sname LIKE '_ه%';
SELECT * FROM "Sailors" WHERE sname NOT LIKE '_ه%' AND sname NOT LIKE '_ل%' ;
 ----------------------------------
SELECT sname,S.sid FROM "Sailors" S,"Reserves" R WHERE S.sid=R.sid;
SELECT DISTINCT sname,S.sid FROM "Sailors" S,"Reserves" R WHERE S.sid=R.sid;


------------ subquery     ----------
SELECT DISTINCT S.sid, sname FROM "Sailors" S,"Reserves" R, "Boats" B  
WHERE S.sid=R.sid AND R.bid=B.bid AND (color='قرمز' OR color='سبز');

SELECT sname FROM "Sailors" 
WHERE sid IN (SELECT sid FROM "Reserves"
			        WHERE bid IN (SELECT bid FROM "Boats" 
							     WHERE color='قرمز' OR color='سبز'))
			  
SELECT sid,sname FROM "Sailors" 
WHERE sid NOT IN (SELECT sid FROM "Reserves"
			        WHERE bid  IN (SELECT bid FROM "Boats" 
							     WHERE color='قرمز' OR color='سبز'))
SELECT sname FROM (SELECT * FROM "Sailors" WHERE rating>5) AS S		

---------------------- UNION INTERSECT EXCEPT   -------------------------	
/*
SELECT 
   column_list
FROM 
    tbl_name_1 
WHERE condition
 UNION
SELECT 
    column_list
FROM 
   tbl_name_2 WHERE condition; 
*/    
SELECT  sname,S.sid FROM "Sailors" S,"Reserves" R, "Boats" B 
WHERE S.sid=R.sid AND R.bid=B.bid AND color='قرمز'
UNION 
SELECT  sname,S.sid FROM "Sailors" S,"Reserves" R, "Boats" B 
WHERE S.sid=R.sid AND R.bid=B.bid AND color='سبز';

/* 
SELECT 
   column_list
FROM 
  tbl_name_1 WHERE condition
INTERSECT
SELECT 
    column_list
FROM 
    tbl_name_2 WHERE condition;
*/
 
	  
SELECT DISTINCT sname,S.sid FROM "Sailors" S,"Reserves" R, "Boats" B 
WHERE S.sid=R.sid AND R.bid=B.bid AND color='قرمز'
INTERSECT
SELECT DISTINCT sname,S.sid FROM "Sailors" S,"Reserves" R, "Boats" B 
WHERE S.sid=R.sid AND R.bid=B.bid AND color='سبز';

/*
SELECT  
     column_list
FROM 
    tbl_name_1 WHERE condition
	
EXCEPT

SELECT 
      column_list
-- FROM 	
	   tbl_name_2 WHERE condition; 
*/

SELECT sname,sid FROM "Sailors" 
EXCEPT
SELECT sname,S.sid FROM "Sailors" S,"Reserves" R WHERE S.sid=R.sid;

--=================  EXISTS  =======================

-- نام قایقران هایی که قایق 3 را رزرو نموده اند
SELECT sname FROM "Sailors" S,"Reserves" R 
WHERE S.sid=R.sid AND bid = 3;

SELECT sname FROM "Sailors" WHERE sid 
	IN	(SELECT sid FROM "Reserves" WHERE bid = 3) 

--EXISTS (subquery)
--incorrect
SELECT sname FROM "Sailors" WHERE  
	EXISTS	(SELECT sid FROM "Reserves" WHERE bid = 3);
	
--correct
SELECT sname FROM "Sailors" S WHERE
	EXISTS	(SELECT  sid FROM  "Reserves" R WHERE  R.bid=3 AND S.sid=R.sid);
	
--SELECT 
--    column_1 
--FROM 
--    table_1
--    WHERE 
--    EXISTS( SELECT 
                1 
--            FROM 
--                table_2 
--            WHERE 
--                column_2 = table_1.column_1);
--------------------------------------------------------	
-- نام قایقران هایی که قایق 3 را رزرو نکرده اند
SELECT sid,sname FROM "Sailors" 
EXCEPT
SELECT S.sid,sname FROM "Sailors" S,"Reserves" R 
WHERE S.sid=R.sid AND bid = 3;

SELECT  sname FROM "Sailors" WHERE sid 
	NOT IN	(SELECT sid FROM "Reserves" WHERE bid = 3);

SELECT sid,S.sname FROM "Sailors" S WHERE
	NOT EXISTS	(SELECT  * FROM  "Reserves" R WHERE  R.bid=3 AND S.sid=R.sid);

--------------------------------------------------------
--expresion operator ANY(subquery)

--The subquery must return exactly one column.
--The ANY operator must be preceded by one of the following comparison operator =, <=, >, <, > and <>
--The ANY operator returns true if any value of the subquery meets the condition, otherwise, it returns false.

-- مشخصات قایقران هایی را بیابید که امتیاز آنها حداقل از یکی از افراد بالای 45 سال بیشتر باشد
SELECT  * FROM  "Sailors" S WHERE  
	S.rating > ANY  (SELECT  S2.rating  
		FROM  "Sailors" S2 WHERE S2.age > 45);
		
SELECT  * FROM  "Sailors" S WHERE  
	S.rating > SOME  (SELECT  S2.rating  
		FROM  "Sailors" S2 WHERE S2.age > 45);
		
--comparison_operator ALL (subquery)
--comparison operator such as equal (=),(!=),(>),(>=),(<),(<=).
 
-- مشخصات قایقران هایی را بیابید که سن آنها از همه قایقران هایی که امتیاز بین 8 تا 9 دارند بیشتر است	
SELECT  * FROM  "Sailors" S WHERE  
	S.age >  ALL  (SELECT  S2.age 
			FROM  "Sailors" S2 WHERE S2.rating <=9 
			AND S2.rating >= 8);
 
 
 
 
 
 
 
 
 
 
-------xxxxxxxxxxx
 
-- شماره قایقران هایی که همه قایق ها را رزرو کرده اند

SELECT Sid FROM "Reserves"
EXCEPT
(SELECT Sid FROM ( 
	     			  (SELECT * FROM ( SELECT Sid FROM "Reserves") AS T1 ,( SELECT Bid FROM "Boats") AS T2  )
 	 						EXCEPT
    				  (SELECT Sid,Bid FROM "Reserves")
                 ) AS T3
)
	
 
--- With EXIST
SELECT DISTINCT  R1.sid
FROM  "Reserves" R1
WHERE  NOT EXISTS 
              ((SELECT  B.bid
                 FROM  "Boats" B)
                EXCEPT
                 (SELECT  R2.bid
                  FROM  "Reserves" R2
                  WHERE  R1.sid=R2.sid));
