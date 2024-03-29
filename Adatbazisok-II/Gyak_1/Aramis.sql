--1.Kinek a tulajdon�ban van a DBA_TABLES nev? n�zet, illetve a DUAL nev? t�bla? [owner, object_name, object_type]
select * from dba_objects where upper(object_name) = 'DUAL';

--2.Kinek a tulajdon�ban van a DBA_TABLES nev�, illetve a DUAL nev� szinonima? [owner, object_name, object_type]
select * from dba_synonyms where synonym_name = 'DUAL';

--3.Milyen t�pus� objektumai vannak az orauser nev� felhaszn�l�nak az adatb�zisban? [object_type]
SELECT distinct object_type FROM dba_objects WHERE owner='ORAUSER';

--4.H�ny k�l�nb�z� t�pus� objektum van nyilv�ntartva az adatb�zisban? [darab]
 SELECT count(distinct object_type) FROM dba_objects;

--5.Melyek ezek a t�pusok? [object_type]
 SELECT distinct object_type FROM dba_objects;

--6.Kik azok a felhaszn�l�k, akiknek t�bb mint 10 f�le objektumuk van? [owner]
 select owner, count(owner) from dba_objects having count(owner)>10 group by owner;

--7.Kik azok a felhaszn�l�k, akiknek van triggere �s n�zete is? [owner]

--8.Kik azok a felhaszn�l�k, akiknek van n�zete, de nincs triggere? [owner]
 SELECT distinct owner FROM dba_objects WHERE object_type='VIEW'
  MINUS
 SELECT distinct owner FROM dba_objects WHERE object_type='TRIGGER';

--9.Kik azok a felhaszn�l�k, akiknek t�bb mint n t�bl�juk, de maximum m index�k van? [owner] (n �s m �rt�k�t adjuk meg �gy, hogy kb. 1-15 k�z�tt legyen a sorok sz�ma, pl. n=20, m=15)
 SELECT distinct owner FROM dba_objects WHERE object_type='TABLE'
 GROUP BY owner
 HAVING count(*) > 20
  MINUS
 SELECT distinct owner FROM dba_objects WHERE object_type='INDEX'
 GROUP BY owner
 HAVING count(*) > 15;

--10.Melyek azok az objektum t�pusok, amelyek t�nyleges t�rol�st ig�nyelnek, vagyis tartoznak hozz�juk adatblokkok? [object_type]
--(Az olyan objektumoknak, amik nem ig�nyelnek t�nyleges t�rol�st, pl. n�zet, csak a defin�ci�ja t�rol�dik az adatsz�t�rban. A megold�shoz a data_object_id oszlopot vizsg�ljuk meg.)
 SELECT DISTINCT object_type FROM dba_objects WHERE data_object_id IS NOT NULL;

--11.Melyek azok az objektum t�pusok, amelyek nem ig�nyelnek t�nyleges t�rol�st, vagyis nem tartoznak hozz�juk adatblokkok? [object_type]
--Az ut�bbi k�t lek�rdez�s metszete nem �res. Vajon mi�rt? -> l�sd majd part�cion�l�s
 SELECT DISTINCT object_type FROM dba_objects WHERE data_object_id IS NULL;

--12.Keress�k meg az ut�bbi k�t lek�rdez�s metszet�t. [object_type]
--(Ezek olyan objektum t�pusok, amelyekb�l el�fordul adatblokkokal rendelkez� �s adatblokkokal nem rendelkez� is.)
 SELECT distinct object_type FROM dba_objects WHERE NVL(data_object_id,0) = 0
  INTERSECT
 SELECT distinct object_type FROM dba_objects WHERE NVL(data_object_id,0) != 0;
 
--13.H�ny oszlopa van a nikovits.emp t�bl�nak? [darab]

--14.Milyen t�pus� a nikovits.emp t�bla 6. oszlopa? [data_type]

--15.Adjuk meg azoknak a t�bl�knak a tulajdonos�t �s nev�t, amelyeknek van 'Z' bet�vel kezd�d� oszlopa. [owner, table_name]

--16.Adjuk meg azoknak a t�bl�knak a tulajdonos�t �s nev�t, amelyeknek legal�bb 8 darab d�tum tipus� oszlopa van. [owner, table_name]
 SELECT owner, table_name FROM dba_tab_columns
 WHERE data_type='DATE'
 GROUP BY owner, table_name
 HAVING count(*) >= 8;

--17.Adjuk meg azoknak a t�bl�knak a tulajdonos�t �s nev�t, amelyeknek 1. es 4. oszlopa is
VARCHAR2 tipus�, az oszlop hossza mindegy. [owner, table_name]
 SELECT owner, table_name FROM dba_tab_columns
 WHERE column_id=1 AND data_type='CHAR'
  INTERSECT
 SELECT owner, table_name FROM dba_tab_columns
 WHERE column_id=4 AND data_type='CHAR';

-----------------------------------------------------------------------
--18.�rjunk meg egy plsql proced�r�t, amelyik a param�ter�l kapott karakterl�nc alapj�n ki�rja azoknak a t�bl�knak a nev�t �s tulajdonos�t, amelyek az adott karakterl�nccal kezd�dnek. 
--(Ha a param�ter kisbet�s, akkor is m�k�dj�n a proced�ra!)
     PROCEDURE table_print(p_kar VARCHAR2) 
A fenti proced�ra seg�ts�g�vel �rjuk ki a Z bet�vel kezd�d� t�bl�k nev�t �s tulajdonos�t.

CREATE OR REPLACE PROCEDURE table_print(p_kar VARCHAR2) is
  CURSOR curs1 IS 
  select owner,table_name from dba_tables
  where upper(table_name) like upper(p_kar)||'%';
  rec curs1%ROWTYPE;
BEGIN
  OPEN curs1;
  LOOP
    FETCH curs1 INTO rec;
    EXIT WHEN curs1%NOTFOUND;
    dbms_output.put_line(rec.owner||' - '||rec.table_name);
  END LOOP;
  CLOSE curs1;
END;
/
Teszt:
set serveroutput on
execute table_print('z');






