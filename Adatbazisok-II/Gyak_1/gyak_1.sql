--1.Kinek a tulajdon�ban van a DBA_TABLES nev? n�zet, illetve a DUAL nev? t�bla? [owner, object_name, object_type]
select owner from DBA_OBJECTS where object_name='DBA_TABLES' and object_type='VIEW';
select owner from DBA_OBJECTS where object_name='DUAL' and object_type='TABLE';


--2.Kinek a tulajdon�ban van a DBA_TABLES nev?, illetve a DUAL nev? szinonima? [owner, object_name, object_type]
--Az im�nti k�t lek�rdez�s megmagyar�zza, hogy mi�rt tudjuk el�rni a DUAL t�bl�t, illetve a DBA_TABLES n�zetet an�lk�l, hogy min?s�ten�nk ?ket a tulajdonos nev�vel �gy -> tulajdonos.objektum.
SELECT OWNER FROM DBA_SYNONYMS WHERE TABLE_NAME='DUAL' OR TABLE_NAME='DBA_TABLES'; 

--3.Milyen t�pus� objektumai vannak az orauser nev? felhaszn�l�nak az adatb�zisban? [object_type]
SELECT DISTINCT object_type FROM DBA_OBJECTS WHERE OWNER = 'ORAUSER';

--4.H�ny k�l�nb�z? t�pus� objektum van nyilv�ntartva az adatb�zisban? [darab]
SELECT COUNT(DISTINCT object_type) FROM DBA_OBJECTS;

--5.Melyek ezek a t�pusok? [object_type]
SELECT DISTINCT object_type FROM DBA_OBJECTS;


--6.Kik azok a felhaszn�l�k, akiknek t�bb mint 10 f�le objektumuk van? [owner]\
SELECT OWNER, COUNT(DISTINCT OBJECT_TYPE) FROM DBA_OBJECTS HAVING COUNT(DISTINCT OBJECT_TYPE)>10 GROUP BY OWNER;

--7.Kik azok a felhaszn�l�k, akiknek van triggere �s n�zete is? [owner]
SELECT OWNER FROM DBA_OBJECTS WHERE OBJECT_TYPE='TRIGGER'
INTERSECT 
SELECT OWNER FROM DBA_OBJECTS WHERE OBJECT_TYPE='VIEW';


--8.Kik azok a felhaszn�l�k, akiknek van n�zete, de nincs triggere? [owner]
SELECT OWNER FROM DBA_OBJECTS WHERE OBJECT_TYPE='VIEW'
MINUS
SELECT OWNER FROM DBA_OBJECTS WHERE OBJECT_TYPE='TRIGGER';


--9.Kik azok a felhaszn�l�k, akiknek t�bb mint n t�bl�juk, de maximum m index�k van? [owner]
--(n �s m �rt�k�t adjuk meg �gy, hogy kb. 1-15 k�z�tt legyen a sorok sz�ma, pl. n=20, m=15)
SELECT distinct OWNER FROM DBA_OBJECTS WHERE OBJECT_TYPE='TABLE' GROUP BY OWNER having  COUNT(*)>20
minus
SELECT distinct OWNER FROM DBA_OBJECTS WHERE OBJECT_TYPE='INDEX' GROUP BY OWNER having  COUNT(*)<15;


/*

10.
Melyek azok az objektum t�pusok, amelyek t�nyleges t�rol�st ig�nyelnek, vagyis
tartoznak hozz�juk adatblokkok? [object_type]
 (Az olyan objektumoknak, amik nem ig�nyelnek t�nyleges t�rol�st, pl. n�zet, szinonima,
  csak a defin�ci�ja t�rol�dik az adatsz�t�rban. A megold�shoz a data_object_id oszlopot
  vizsg�ljuk meg.)*/
SELECT DISTINCT object_type FROM dba_objects WHERE data_object_id IS NOT NULL;
/*
11.
Melyek azok az objektum t�pusok, amelyek nem ig�nyelnek t�nyleges t�rol�st, vagyis nem
tartoznak hozz�juk adatblokkok? [object_type]
 Az ut�bbi k�t lek�rdez�s metszete nem �res. Vajon mi�rt? -> l�sd majd part�cion�l�s*/
  SELECT DISTINCT object_type FROM dba_objects WHERE data_object_id IS NULL;
  /*

12.
Keress�k meg az ut�bbi k�t lek�rdez�s metszet�t. [object_type]
 (Ezek olyan objektum t�pusok, amelyekb?l el?fordul adatblokkokal rendelkez?
 �s adatblokkokal nem rendelkez? is.)*/
SELECT distinct object_type FROM dba_objects WHERE NVL(data_object_id,0) = 0
  INTERSECT
SELECT distinct object_type FROM dba_objects WHERE NVL(data_object_id,0) != 0;
 /*
T�bl�k oszlopai (DBA_TAB_COLUMNS)
---------------------------------
Az al�bbi k�rd�sekkel egy t�bla oszlopait vizsg�lhatjuk meg r�szletesen, vagyis
az oszlop nev�t, sorsz�m�t (h�nyadik oszlop), t�pus�t, azt hogy elfogadja-e a NULL
�rt�ket, van-e alap�rtelmezett �rt�ke, stb.
--------------------------------------------------------------------------------
*/
--13.H�ny oszlopa van a nikovits.emp t�bl�nak? [darab]
SELECT COUNT(COLUMN_NAME) FROM DBA_TAB_COLUMNS WHERE TABLE_NAME='EMP' AND OWNER='NIKOVITS';

--14.Milyen t�pus� a nikovits.emp t�bla 6. oszlopa? [data_type]
SELECT DATA_TYPE FROM DBA_TAB_COLUMNS WHERE TABLE_NAME='EMP' AND OWNER='NIKOVITS' AND COLUMN_ID='6';

--15.Adjuk meg azoknak a t�bl�knak a tulajdonos�t �s nev�t, amelyeknek van 'Z' bet?vel kezd?d? oszlopa. [owner, table_name]

--16.Adjuk meg azoknak a t�bl�knak a tulajdonos�t �s nev�t, amelyeknek legal�bb 8 darab d�tum tipus� oszlopa van. [owner, table_name]
SELECT OWNER, TABLE_NAME FROM DBA_TAB_COLUMNS WHERE DATA_TYPE='DATE' GROUP BY OWNER, TABLE_NAME HAVING COUNT(*)>7;
 
--17.Adjuk meg azoknak a t�bl�knak a tulajdonos�t �s nev�t, amelyeknek 1. es 4. oszlopa is VARCHAR2 tipus�, az oszlop hossza mindegy. [owner, table_name]
SELECT owner, table_name FROM dba_tab_columns WHERE column_id=1 AND data_type='CHAR'
  INTERSECT
SELECT owner, table_name FROM dba_tab_columns WHERE column_id=4 AND data_type='CHAR';

/*
-----------------------------------------------------------------------
18.
�rjunk meg egy PLSQL proced�r�t, amelyik a param�ter�l kapott karakterl�nc alapj�n 
ki�rja azoknak a t�bl�knak a nev�t �s tulajdonos�t, amelyek az adott karakterl�nccal 
kezd?dnek. (Ha a param�ter kisbet?s, akkor is m?k�dj�n a proced�ra!)
A fenti proced�ra seg�ts�g�vel �rjuk ki a Z bet?vel kezd?d? t�bl�k nev�t �s tulajdonos�t.
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
*/