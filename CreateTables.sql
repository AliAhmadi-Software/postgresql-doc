--drop table "Reserves";
--drop table "Sailors";
--drop table "Boats";
-- /* */
CREATE TABLE "Sailors"
(
  sid INTEGER NOT NULL,
  sname CHARACTER VARYING(30),
  age INTEGER,
  rating INTEGER,
  PRIMARY KEY (sid )
);

CREATE TABLE "Boats"
(
  bid INTEGER NOT NULL,
  color CHARACTER VARYING(10),
  bname CHARACTER VARYING(10),
  PRIMARY KEY (bid )
);

CREATE TABLE "Reserves"
(
  sid INTEGER NOT NULL,
  bid INTEGER NOT NULL,
  date DATE NOT NULL,
  PRIMARY KEY (sid , bid , date ),
  FOREIGN KEY (bid) REFERENCES "Boats" (bid),
  FOREIGN KEY (sid) REFERENCES "Sailors" (sid)
);
