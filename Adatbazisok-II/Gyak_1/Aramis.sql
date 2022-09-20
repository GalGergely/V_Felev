--1.Kinek a tulajdon�ban van a DBA_TABLES nev? n�zet, illetve a DUAL nev? t�bla? [owner, object_name, object_type]

--3.Milyen t�pus� objektumai vannak az orauser nev? felhaszn�l�nak az adatb�zisban? [object_type]

--4.H�ny k�l�nb�z? t�pus� objektum van nyilv�ntartva az adatb�zisban? [darab]
select count(*) as "objektumok" from (SELECT COUNT(OBJECT_TYPE) FROM all_objects GROUP BY OBJECT_TYPE);

--5.Melyek ezek a t�pusok? [object_type]
SELECT distinct OBJECT_TYPE FROM all_objects;