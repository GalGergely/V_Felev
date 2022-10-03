--1.Kinek a tulajdonában van a DBA_TABLES nev? nézet, illetve a DUAL nev? tábla? [owner, object_name, object_type]
select owner from DBA_OBJECTS where object_name='DBA_TABLES' and object_type='VIEW';
select owner from DBA_OBJECTS where object_name='DUAL' and object_type='TABLE';


--2.Kinek a tulajdonában van a DBA_TABLES nev?, illetve a DUAL nev? szinonima? [owner, object_name, object_type]
--Az iménti két lekérdezés megmagyarázza, hogy miért tudjuk elérni a DUAL táblát, illetve a DBA_TABLES nézetet anélkül, hogy min?sítenénk ?ket a tulajdonos nevével így -> tulajdonos.objektum.
SELECT OWNER FROM DBA_SYNONYMS WHERE TABLE_NAME='DUAL' OR TABLE_NAME='DBA_TABLES'; 

--3.Milyen típusú objektumai vannak az orauser nev? felhasználónak az adatbázisban? [object_type]
SELECT DISTINCT object_type FROM DBA_OBJECTS WHERE OWNER = 'ORAUSER';

--4.Hány különböz? típusú objektum van nyilvántartva az adatbázisban? [darab]
SELECT COUNT(DISTINCT object_type) FROM DBA_OBJECTS;

--5.Melyek ezek a típusok? [object_type]
SELECT DISTINCT object_type FROM DBA_OBJECTS;


--6.Kik azok a felhasználók, akiknek több mint 10 féle objektumuk van? [owner]\
SELECT OWNER, COUNT(DISTINCT OBJECT_TYPE) FROM DBA_OBJECTS HAVING COUNT(DISTINCT OBJECT_TYPE)>10 GROUP BY OWNER;

--7.Kik azok a felhasználók, akiknek van triggere és nézete is? [owner]
SELECT OWNER FROM DBA_OBJECTS WHERE OBJECT_TYPE='TRIGGER'
INTERSECT 
SELECT OWNER FROM DBA_OBJECTS WHERE OBJECT_TYPE='VIEW';


--8.Kik azok a felhasználók, akiknek van nézete, de nincs triggere? [owner]
SELECT OWNER FROM DBA_OBJECTS WHERE OBJECT_TYPE='VIEW'
MINUS
SELECT OWNER FROM DBA_OBJECTS WHERE OBJECT_TYPE='TRIGGER';


--9.Kik azok a felhasználók, akiknek több mint n táblájuk, de maximum m indexük van? [owner]
--(n és m értékét adjuk meg úgy, hogy kb. 1-15 között legyen a sorok száma, pl. n=20, m=15)
SELECT distinct OWNER FROM DBA_OBJECTS WHERE OBJECT_TYPE='TABLE' GROUP BY OWNER having  COUNT(*)>20
minus
SELECT distinct OWNER FROM DBA_OBJECTS WHERE OBJECT_TYPE='INDEX' GROUP BY OWNER having  COUNT(*)<15;


/*

10.
Melyek azok az objektum típusok, amelyek tényleges tárolást igényelnek, vagyis
tartoznak hozzájuk adatblokkok? [object_type]
 (Az olyan objektumoknak, amik nem igényelnek tényleges tárolást, pl. nézet, szinonima,
  csak a definíciója tárolódik az adatszótárban. A megoldáshoz a data_object_id oszlopot
  vizsgáljuk meg.)*/
SELECT DISTINCT object_type FROM dba_objects WHERE data_object_id IS NOT NULL;
/*
11.
Melyek azok az objektum típusok, amelyek nem igényelnek tényleges tárolást, vagyis nem
tartoznak hozzájuk adatblokkok? [object_type]
 Az utóbbi két lekérdezés metszete nem üres. Vajon miért? -> lásd majd partícionálás*/
  SELECT DISTINCT object_type FROM dba_objects WHERE data_object_id IS NULL;
  /*

12.
Keressük meg az utóbbi két lekérdezés metszetét. [object_type]
 (Ezek olyan objektum típusok, amelyekb?l el?fordul adatblokkokal rendelkez?
 és adatblokkokal nem rendelkez? is.)*/
SELECT distinct object_type FROM dba_objects WHERE NVL(data_object_id,0) = 0
  INTERSECT
SELECT distinct object_type FROM dba_objects WHERE NVL(data_object_id,0) != 0;
 /*
Táblák oszlopai (DBA_TAB_COLUMNS)
---------------------------------
Az alábbi kérdésekkel egy tábla oszlopait vizsgálhatjuk meg részletesen, vagyis
az oszlop nevét, sorszámát (hányadik oszlop), típusát, azt hogy elfogadja-e a NULL
értéket, van-e alapértelmezett értéke, stb.
--------------------------------------------------------------------------------
*/
--13.Hány oszlopa van a nikovits.emp táblának? [darab]
SELECT COUNT(COLUMN_NAME) FROM DBA_TAB_COLUMNS WHERE TABLE_NAME='EMP' AND OWNER='NIKOVITS';

--14.Milyen típusú a nikovits.emp tábla 6. oszlopa? [data_type]
SELECT DATA_TYPE FROM DBA_TAB_COLUMNS WHERE TABLE_NAME='EMP' AND OWNER='NIKOVITS' AND COLUMN_ID='6';

--15.Adjuk meg azoknak a tábláknak a tulajdonosát és nevét, amelyeknek van 'Z' bet?vel kezd?d? oszlopa. [owner, table_name]

--16.Adjuk meg azoknak a tábláknak a tulajdonosát és nevét, amelyeknek legalább 8 darab dátum tipusú oszlopa van. [owner, table_name]
SELECT OWNER, TABLE_NAME FROM DBA_TAB_COLUMNS WHERE DATA_TYPE='DATE' GROUP BY OWNER, TABLE_NAME HAVING COUNT(*)>7;
 
--17.Adjuk meg azoknak a tábláknak a tulajdonosát és nevét, amelyeknek 1. es 4. oszlopa is VARCHAR2 tipusú, az oszlop hossza mindegy. [owner, table_name]
SELECT owner, table_name FROM dba_tab_columns WHERE column_id=1 AND data_type='CHAR'
  INTERSECT
SELECT owner, table_name FROM dba_tab_columns WHERE column_id=4 AND data_type='CHAR';

/*
-----------------------------------------------------------------------
18.
Írjunk meg egy PLSQL procedúrát, amelyik a paraméterül kapott karakterlánc alapján 
kiírja azoknak a tábláknak a nevét és tulajdonosát, amelyek az adott karakterlánccal 
kezd?dnek. (Ha a paraméter kisbet?s, akkor is m?ködjön a procedúra!)
A fenti procedúra segítségével írjuk ki a Z bet?vel kezd?d? táblák nevét és tulajdonosát.
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