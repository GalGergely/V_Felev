--1.Kinek a tulajdonában van a DBA_TABLES nev? nézet, illetve a DUAL nev? tábla? [owner, object_name, object_type]

--3.Milyen típusú objektumai vannak az orauser nev? felhasználónak az adatbázisban? [object_type]

--4.Hány különböz? típusú objektum van nyilvántartva az adatbázisban? [darab]
select count(*) as "objektumok" from (SELECT COUNT(OBJECT_TYPE) FROM all_objects GROUP BY OBJECT_TYPE);

--5.Melyek ezek a típusok? [object_type]
SELECT distinct OBJECT_TYPE FROM all_objects;