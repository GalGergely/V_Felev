SET SERVEROUTPUT ON
--I. Feladat sor:

--A rendszerkatalógus maga is egy adatbázisnak tekinthető, amit lekérdezve egyre többet
--tudhatunk meg az ORACLE adatbázisban tárolt dolgokról és azok tulajdonságairól.
--A rendszerkatalógus tábláinak (nézeteinek) elnevezése: DBA_..., ALL_..., USER_...
--A rendszerkatalógus másik szokásos elnevezése: adatszótár (Data Dictionary)

--Vigyázat !!!
--Az alábbiakban ha egy objektumnak vagy egy felhasználónak a neve kisbetűvel
--szerepel a feladat szövegében, az nem jelenti, hogy ez az adatszótárban is kisbetűvel
--van tárolva. Pl. orauser - ORAUSER felhasználó, emp - EMP tábla.

CREATE table proba (o integer);  --> A tábla neve az adatszótárakban 'PROBA' lesz.
CREATE table "pRoBa" (o integer);  --> A tábla neve az adatszótárakban 'pRoBa' lesz.

--Adatbázis objektumok (DBA_OBJECTS)
------------------------------------
--Az alábbi lekérdezések segítenek feltérképezni, hogy milyen objektumok
--vannak egy Oracle adatbázisban, ki a tulajdonosuk, mikor hozták létre azokat, stb.
--A kérdések után zárójelben az elvárt végeredmény oszlopai szerepelnek.

------------------------------------------------------------------------------------------------------------------------
--Feladatok
------------------------------------------------------------------------------------------------------------------------
--1.
------------------------------------------------------------------------------------------------------------------------
--Kinek a tulajdonában van a DBA_TABLES nevű nézet, illetve a DUAL nevű tábla? [owner, object_name, object_type]
SELECT OWNER, OBJECT_NAME, OBJECT_TYPE
FROM DBA_OBJECTS
WHERE OBJECT_NAME='DBA_TABLES' AND OBJECT_TYPE != 'SYNONYM'
   OR OBJECT_NAME='DUAL' AND OBJECT_TYPE != 'SYNONYM';
------------------------------------------------------------------------------------------------------------------------
--2.
------------------------------------------------------------------------------------------------------------------------
--Kinek a tulajdonában van a DBA_TABLES nevű, illetve a DUAL nevű szinonima? [owner, object_name, object_type]
SELECT OWNER, OBJECT_NAME, OBJECT_TYPE
FROM DBA_OBJECTS
WHERE OBJECT_NAME='DBA_TABLES' AND OBJECT_TYPE='SYNONYM'
   OR OBJECT_NAME='DUAL' AND OBJECT_TYPE='SYNONYM';
------------------------------------------------------------------------------------------------------------------------
--3.
------------------------------------------------------------------------------------------------------------------------
--Milyen típusú objektumai vannak az orauser nevű felhasználónak az adatbázisban? [object_type]
 SELECT distinct object_type FROM dba_objects
 WHERE owner='ORAUSER';
------------------------------------------------------------------------------------------------------------------------
--4.
------------------------------------------------------------------------------------------------------------------------
--Hány különböző típusú objektum van nyilvántartva az adatbázisban? [darab]
 SELECT count(distinct object_type) FROM dba_objects;
------------------------------------------------------------------------------------------------------------------------
--5.
------------------------------------------------------------------------------------------------------------------------
--Melyek ezek a típusok? [object_type]
SELECT distinct object_type FROM dba_objects;
------------------------------------------------------------------------------------------------------------------------
--6.
------------------------------------------------------------------------------------------------------------------------
--Kik azok a felhasználók, akiknek több mint 10 féle objektumuk van? [owner]
SELECT * FROM (SELECT OWNER, COUNT(*) NumberOfObjects FROM DBA_OBJECTS GROUP BY OWNER)
WHERE NumberOfObjects > 10 order by NumberOfObjects;

SELECT OWNER, count(*) from DBA_OBJECTS having count(*) > 10 group by owner;
------------------------------------------------------------------------------------------------------------------------
--7.
------------------------------------------------------------------------------------------------------------------------
--Kik azok a felhasználók, akiknek van triggere és nézete is? [owner]
SELECT OWNER
FROM DBA_OBJECTS WHERE OBJECT_TYPE='TRIGGER' GROUP BY OWNER
INTERSECT
SELECT OWNER
FROM DBA_OBJECTS WHERE OBJECT_TYPE='VIEW' GROUP BY OWNER;
------------------------------------------------------------------------------------------------------------------------
--8.
------------------------------------------------------------------------------------------------------------------------
--Kik azok a felhasználók, akiknek van nézete, de nincs triggere? [owner]
SELECT distinct owner FROM dba_objects WHERE object_type='VIEW'
MINUS
SELECT distinct owner FROM dba_objects WHERE object_type='TRIGGER';
------------------------------------------------------------------------------------------------------------------------
--9.
------------------------------------------------------------------------------------------------------------------------
--Kik azok a felhasználók, akiknek több mint n táblájuk, de maximum m indexük van? [owner]
--(n és m értékét adjuk meg úgy, hogy kb. 1-15 között legyen a sorok száma, pl. n=20, m=15)
SELECT distinct owner FROM dba_objects WHERE object_type='TABLE'
GROUP BY owner
HAVING count(*) > 20
MINUS
SELECT distinct owner FROM dba_objects WHERE object_type='INDEX'
GROUP BY owner
HAVING count(*) > 15;
------------------------------------------------------------------------------------------------------------------------
--10.
------------------------------------------------------------------------------------------------------------------------
--Melyek azok az objektum típusok, amelyek tényleges tárolást igényelnek, vagyis
--tartoznak hozzájuk adatblokkok? [object_type]
-- (Az olyan objektumoknak, amik nem igényelnek tényleges tárolást, pl. nézet,
--  csak a definíciója tárolódik az adatszótárban. A megoldáshoz a data_object_id oszlopot
--  vizsgáljuk meg.)
 SELECT DISTINCT object_type FROM dba_objects WHERE data_object_id IS NOT NULL;
------------------------------------------------------------------------------------------------------------------------
--11.
------------------------------------------------------------------------------------------------------------------------
--Melyek azok az objektum típusok, amelyek nem igényelnek tényleges tárolást, vagyis nem
--tartoznak hozzájuk adatblokkok? [object_type]
--Az utóbbi két lekérdezés metszete nem üres. Vajon miért? -> lásd majd partícionálás
 SELECT DISTINCT object_type FROM dba_objects WHERE data_object_id IS NULL;
------------------------------------------------------------------------------------------------------------------------
--12.
------------------------------------------------------------------------------------------------------------------------
--Keressük meg az utóbbi két lekérdezés metszetét. [object_type]
--(Ezek olyan objektum típusok, amelyekből előfordul adatblokkokal rendelkező
--és adatblokkokal nem rendelkező is.)
 SELECT distinct object_type FROM dba_objects WHERE NVL(data_object_id,0) = 0
  INTERSECT
 SELECT distinct object_type FROM dba_objects WHERE NVL(data_object_id,0) != 0;
------------------------------------------------------------------------------------------------------------------------
--Táblák oszlopai (DBA_TAB_COLUMNS)
-----------------------------------
--Az alábbi kérdésekkel egy tábla oszlopait vizsgálhatjuk meg részletesen, vagyis
--az oszlop nevét, sorszámát (hányadik oszlop), típusát, azt hogy elfogadja-e a NULL
--értéket, van-e alapértelmezett értéke, stb.
------------------------------------------------------------------------------------------------------------------------
--13.
------------------------------------------------------------------------------------------------------------------------
--Hány oszlopa van a nikovits.emp táblának? [darab]
SELECT COUNT(*) FROM DBA_TAB_COLUMNS
WHERE OWNER = 'NIKOVITS' AND TABLE_NAME='EMP';
------------------------------------------------------------------------------------------------------------------------
--14.
------------------------------------------------------------------------------------------------------------------------
--Milyen típusú a nikovits.emp tábla 6. oszlopa? [data_type]
SELECT DATA_TYPE FROM DBA_TAB_COLUMNS
WHERE OWNER='NIKOVITS' AND TABLE_NAME='EMP' AND COLUMN_ID=6;
------------------------------------------------------------------------------------------------------------------------
--15.
------------------------------------------------------------------------------------------------------------------------
--Adjuk meg azoknak a tábláknak a tulajdonosát és nevét, amelyeknek van 'Z' betűvel
--kezdődő oszlopa. [owner, table_name]
SELECT DISTINCT OWNER, TABLE_NAME FROM DBA_TAB_COLUMNS
WHERE COLUMN_NAME LIKE 'Z%';
------------------------------------------------------------------------------------------------------------------------
--16.
------------------------------------------------------------------------------------------------------------------------
--Adjuk meg azoknak a tábláknak a tulajdonosát és nevét, amelyeknek legalább 8
--darab dátum tipusú oszlopa van. [owner, table_name]
 SELECT owner, table_name FROM dba_tab_columns
 WHERE data_type='DATE'
 GROUP BY owner, table_name
 HAVING count(*) >= 8;
------------------------------------------------------------------------------------------------------------------------
--17.
------------------------------------------------------------------------------------------------------------------------
--Adjuk meg azoknak a tábláknak a tulajdonosát és nevét, amelyeknek 1. es 4. oszlopa is
--VARCHAR2 tipusú, az oszlop hossza mindegy. [owner, table_name]
 SELECT owner, table_name FROM dba_tab_columns
 WHERE column_id=1 AND data_type='VARCHAR2'
  INTERSECT
 SELECT owner, table_name FROM dba_tab_columns
 WHERE column_id=4 AND data_type='VARCHAR2';
------------------------------------------------------------------------------------------------------------------------
--18.
------------------------------------------------------------------------------------------------------------------------
--Írjunk meg egy plsql procedúrát, amelyik a paraméterül kapott karakterlánc alapján
--kiírja azoknak a tábláknak a nevét és tulajdonosát, amelyek az adott karakterlánccal
--kezdődnek. (Ha a paraméter kisbetűs, akkor is működjön a procedúra!)
--  PROCEDURE table_print(p_kar VARCHAR2)
--A fenti procedúra segítségével írjuk ki a Z betűvel kezdődő táblák nevét és tulajdonosát.

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
--Teszt:
call table_print('z');
------------------------------------------------------------------------------------------------------------------------
--1. Kötelező feladat:
CREATE TABLE GYAK01 AS SELECT TABLE_NAME FROM DBA_TABLES WHERE OWNER='NIKOVITS' AND TABLE_NAME LIKE '%B';
SELECT * FROM GYAK01;
------------------------------------------------------------------------------------------------------------------------
--II. Feladat sor:
--Kötelező feladat ellenőrzése
------------------------------
select q'[execute check_plsql('newest_table(''nikovits'')',']' || azonosito || q'[');]'
from nikovits.nt_hallgatok where upper(idopont)='K10'
order by nev;

--Előkészítések
--=============
--CREATE TABLE tabla_123 as SELECT * FROM CIKK WHERE 1=2;
--ALTER TABLE tabla_123 ALLOCATE EXTENT
--(SIZE 200K DATAFILE '/u01/app/oracle/oradata/aramis/users02.dbf');  -- itt egy létező adatfájlt kell megadni
--insert into tabla_123 select * from cikk;
--commit;
--grant select on tabla_123 to public;
--
--create view v1 as
--select first_name, last_name, salary, department_name
--from nikovits.employees e natural join nikovits.departments
--where employee_id between 110 and 120;
--create public synonym sz1 for nikovits.v1; -- system felhasználó adhatja ki

--Egyéb objektumok (szinonima, nézet, szekvencia, adatbázis-kapcsoló)
------------------
--(DBA_SYNONYMS, DBA_VIEWS, DBA_SEQUENCES, DBA_DB_LINKS)
--------------------------------------------------------
--Adjuk ki az alábbi utasítást (ARAMIS adatbázisban)
--  SELECT * FROM sz1;
--majd derítsük ki, hogy kinek melyik tábláját kérdeztük le.
--(Ha esetleg nézettel találkozunk, azt is fejtsük ki, hogy az mit kérdez le.)


SELECT * FROM sz1;
SELECT * from dba_objects where lower(object_name) like 'sz1%';
SELECT * FROM DBA_SYNONYMS WHERE owner='PUBLIC' AND synonym_name like'SZ1%';
SELECT * from dba_objects where lower(object_name) like 'v1%' and owner='NIKOVITS';
SELECT view_name, text FROM DBA_VIEWS WHERE owner='NIKOVITS' AND view_name='V1';

SELECT * from dba_objects where lower(object_name) like 'employ%' and owner='NIKOVITS';
SELECT * from dba_objects where lower(object_name) like 'departm%' and owner='NIKOVITS';
------------------------------------------------------------------------------------------------------------------------
--Hozzunk létre egy szekvenciát, amelyik az osztály azonosítókat fogja generálni
--a számunkra. Minden osztály azonosító a 10-nek többszöröse legyen.
--Vigyünk fel 3 új osztályt és osztályonként minimum 3 dolgozót a táblákba.
--Az osztály azonosítókat a szekvencia segítségével állítsuk elő, és ezt tegyük
--be a táblába. (Vagyis ne kézzel írjuk be a 10, 20, 30 ... stb. azonosítót.)
--A felvitel után módosítsuk a 10-es osztály azonosítóját a következő érvényes (generált)
--osztály azonosítóra. (Itt is a szekvencia segítségével adjuk meg, hogy mi lesz a
--következő azonosító.) A 10-es osztály dolgozóinak az osztályazonosító ertékét is
--módosítsuk az új értékre.
------------------------------------------------------------------------------------------------------------------------
--Hozzunk létre adatbázis-kapcsolót (database link) az ULLMAN adatbázisban,
--amelyik a másik adatbázisra mutat.
--CREATE DATABASE LINK aramisdb CONNECT TO felhasznalo IDENTIFIED BY jelszo
--USING 'aramis.inf.elte.hu:1521/aramis';
--Ennek segítségével adjuk meg a következő lekérdezéseket.
--A lekérdezések alapjául szolgáló táblák:

--NIKOVITS.VILAG_ORSZAGAI   ULLMAN adatbázis
--NIKOVITS.FOLYOK           ARAMIS adatbázis
--
--Az országok egyedi azonosítója a TLD (Top Level Domain) oszlop.
--Az ország hivatalos nyelveit vesszőkkel elválasztva a NYELV oszlop tartalmazza.
--A GDP (Gross Domestic Product -> hazai bruttó össztermék) dollárban van megadva.
--A folyók egyedi azonosítója a NEV oszlop.
--A folyók vízhozama m3/s-ban van megadva, a vízgyűjtő területük km2-ben.
--A folyó által érintett országok azonosítóit (TLD) a forrástól a torkolatig
--(megfelelő sorrendben vesszőkkel elválasztva) az ORSZAGOK oszlop tartalmazza.
--A FORRAS_ORSZAG és TORKOLAT_ORSZAG hasonló módon a megfelelő országok azonosítóit
--tartalmazza. (Vigyázat!!! egy folyó torkolata országhatárra is eshet, pl. Duna)


--Adjuk meg azoknak az országoknak a nevét, amelyeket a Mekong nevű folyó érint.
--Aramison:
CREATE DATABASE LINK ULLMAN_LINK CONNECT TO STM3ML IDENTIFIED BY stm3ml USING 'ullman.inf.elte.hu:1521/ullman';
DROP DATABASE LINK ULLMAN_LINK;
SELECT F.NEV, O.NEV, O.TLD, F.ORSZAGOK FROM NIKOVITS.VILAG_ORSZAGAI@ULLMAN_LINK O, NIKOVITS.FOLYOK F
WHERE F.NEV = 'Mekong' AND F.ORSZAGOK LIKE '%'||O.TLD||'%';

--Ullmanon:
CREATE DATABASE LINK ARAMIS_LINK CONNECT TO STM3ML IDENTIFIED BY stm3ml USING 'aramis.inf.elte.hu:1521/aramis';
DROP DATABASE LINK ARAMIS_LINK;
SELECT F.NEV, O.NEV, O.TLD, F.ORSZAGOK FROM NIKOVITS.VILAG_ORSZAGAI O, NIKOVITS.FOLYOK@ARAMIS_LINK F WHERE F.NEV = 'Mekong' AND F.ORSZAGOK LIKE '%'||O.TLD||'%';
------------------------------------------------------------------------------------------------------------------------
---* Adjuk meg azoknak az országoknak a nevét, amelyeket a Mekong nevű folyó érint.
--   Most az országok nevét a megfelelő sorrendben (folyásirányban) adjuk meg.
--   -> ötlet: ORDER BY INSTR(...)
-----------------------------------------------------------------------------------
--
--Adattárolással kapcsolatos fogalmak
-------------------------------------
--(DBA_TABLES, DBA_DATA_FILES, DBA_TEMP_FILES, DBA_TABLESPACES, DBA_SEGMENTS, DBA_EXTENTS, DBA_FREE_SPACE)
----------------------------------------------------------------------------------------------------------
--1.
------------------------------------------------------------------------------------------------------------------------
--Adjuk meg az adatbázishoz tartozó adatfile-ok (és temporális fájlok) nevét és méretét
--méret szerint csökkenő sorrendben. (név, méret)
SELECT file_name, bytes FROM dba_data_files
 union
SELECT file_name, bytes FROM dba_temp_files
ORDER BY bytes DESC;
------------------------------------------------------------------------------------------------------------------------
--2.
------------------------------------------------------------------------------------------------------------------------
--Adjuk meg, hogy milyen táblaterek vannak létrehozva az adatbazisban,
--az egyes táblaterek hány adatfájlbol állnak, és mekkora az összméretük.
--(tablater_nev, fajlok_szama, osszmeret)
--!!! Vigyázat, van temporális táblatér is.
SELECT DISTINCT TABLESPACE_NAME, NUMBER_OF_FILES, BYTES FROM (
    SELECT TABLESPACE_NAME, COUNT(FILE_ID) AS NUMBER_OF_FILES, SUM(BYTES) AS BYTES
    FROM DBA_DATA_FILES GROUP BY TABLESPACE_NAME
    UNION
    SELECT TABLESPACE_NAME, COUNT(FILE_ID) AS NUMBER_OF_FILES, SUM(BYTES) AS BYTES
    FROM DBA_TEMP_FILES GROUP BY TABLESPACE_NAME
);
------------------------------------------------------------------------------------------------------------------------
--3.
------------------------------------------------------------------------------------------------------------------------
--Mekkora az adatblokkok merete a USERS táblatéren?
SELECT SUM(BLOCKS) AS SIZE_OF_DATABLOCKS_IN_USERS FROM (
    SELECT BLOCKS FROM DBA_DATA_FILES WHERE TABLESPACE_NAME='USERS' UNION
    SELECT BLOCKS FROM DBA_TEMP_FILES WHERE TABLESPACE_NAME='USERS'
);
------------------------------------------------------------------------------------------------------------------------
--4.
------------------------------------------------------------------------------------------------------------------------
--Van-e olyan táblatér, amelynek nincs DBA_DATA_FILES-beli adatfájlja?
--Ennek adatai hol tárolódnak? -> DBA_TEMP_FILES
SELECT tablespace_name FROM dba_tablespaces WHERE tablespace_name NOT IN
 (SELECT tablespace_name FROM dba_data_files);
SELECT file_name, tablespace_name FROM dba_temp_files;
------------------------------------------------------------------------------------------------------------------------
--5.
------------------------------------------------------------------------------------------------------------------------
--Melyik a legnagyobb méretű tábla szegmens az adatbázisban és hány extensből áll?
--(tulajdonos, szegmens_név, darab)
--(A particionált táblákat most ne vegyük figyelembe.)
--------------------------------------------------------------------
SELECT owner, segment_name, extents FROM dba_segments
WHERE segment_type='TABLE'
ORDER BY bytes DESC
FETCH FIRST 1 rows ONLY;
------------------------------------------------------------------------------------------------------------------------
--6.
------------------------------------------------------------------------------------------------------------------------
--Melyik a legnagyobb meretű index szegmens az adatbázisban és hány blokkból áll?
--(tulajdonos, szegmens_név, darab)
--(A particionált indexeket most ne vegyuk figyelembe.)
SELECT OWNER, SEGMENT_NAME, BLOCKS FROM DBA_SEGMENTS
WHERE SEGMENT_TYPE = 'INDEX' ORDER BY BYTES DESC FETCH FIRST 1 ROWS ONLY;
------------------------------------------------------------------------------------------------------------------------
--7.
------------------------------------------------------------------------------------------------------------------------
--Adjuk meg adatfájlonkent, hogy az egyes adatfájlokban mennyi a foglalt
--hely osszesen. (fájlnév, fájl_méret, foglalt_hely)
SELECT FILE_NAME, MAXBYTES AS FILE_SIZE_BYTES, BYTES AS ACTUAL_SIZE_BYTES FROM DBA_DATA_FILES;
------------------------------------------------------------------------------------------------------------------------
--8.
------------------------------------------------------------------------------------------------------------------------
--Melyik ket felhasznalo objektumai foglalnak osszesen a legtobb helyet az adatbazisban?
--Vagyis ki foglal a legtöbb helyet, és ki a második legtöbbet?
SELECT owner, SUM(bytes) FROM dba_segments GROUP BY owner ORDER BY 2 DESC
FETCH FIRST 2 ROWS ONLY;
------------------------------------------------------------------------------------------------------------------------
--9.
------------------------------------------------------------------------------------------------------------------------
--Hány extens van a 'users02.dbf' adatfájlban? Mekkora ezek összmérete? (darab, össz)
--Hány összefüggő szabad terület van a 'users02.dbf' adatfájlban? Mekkora ezek összmérete? (darab, össz)
--Hány százalékban foglalt a 'users02.dbf' adatfájl?
SELECT count(*), sum(e.bytes) FROM dba_data_files f, dba_extents e
WHERE file_name like '%/users02%' AND f.file_id=e.file_id;
SELECT COUNT(*), SUM(BYTES) FROM DBA_EXTENTS WHERE FILE_ID = (SELECT FILE_ID FROM DBA_DATA_FILES WHERE FILE_NAME LIKE '%users02.dbf%');

SELECT count(*), sum(fr.bytes) FROM dba_data_files f, dba_free_space fr
WHERE file_name LIKE '%/users02%' AND f.file_id=fr.file_id;
SELECT COUNT(*), SUM(BYTES) FROM DBA_FREE_SPACE WHERE FILE_ID = (SELECT FILE_ID FROM DBA_DATA_FILES WHERE FILE_NAME LIKE '%users02.dbf%');

SELECT sum(e.bytes)/f.bytes * 100 FROM dba_data_files f, dba_extents e
WHERE file_name LIKE '%/users02%' AND f.file_id=e.file_id
GROUP BY f.bytes;
------------------------------------------------------------------------------------------------------------------------
--10.
------------------------------------------------------------------------------------------------------------------------
--Van-e a NIKOVITS felhasználónak olyan táblája, amelyik több adatfájlban is foglal helyet? (Aramis)
SELECT segment_name, count(distinct file_id)
FROM dba_extents WHERE owner='NIKOVITS' AND segment_type='TABLE'
GROUP BY segment_name HAVING count(distinct file_id) > 1;
------------------------------------------------------------------------------------------------------------------------
--11.
------------------------------------------------------------------------------------------------------------------------
--Válasszunk ki a fenti táblákból egyet (pl. tabla_123) és adjuk meg, hogy ez a
--tábla mely adatfájlokban foglal helyet.
select FILE_NAME from DBA_DATA_FILES where FILE_ID in
                                   (select distinct FILE_ID from dba_extents
                                   where SEGMENT_NAME = 'TABLA_123' and owner = 'NIKOVITS');

------------------------------------------------------------------------------------------------------------------------
--12.
------------------------------------------------------------------------------------------------------------------------
--Melyik táblatéren van az ORAUSER felhasználó DOLGOZO táblája?
SELECT tablespace_name FROM dba_tables WHERE owner='ORAUSER' AND table_name='DOLGOZO';
------------------------------------------------------------------------------------------------------------------------
--13.
------------------------------------------------------------------------------------------------------------------------
--Melyik táblatéren van a NIKOVITS felhasználó ELADASOK táblája? (Miért lesz null?)
---> Mert ez egy úgynevezett partícionált tábla, aminek minden partíciója külön szegmenst alkot,
--   és ezek a szegmensek más-más táblatéren lehetnek.
select TABLESPACE_NAME from dba_tables where TABLE_NAME='ELADASOK' AND OWNER='NIKOVITS';
select * from dba_tables where TABLE_NAME like 'ELADASOK%' AND OWNER='NIKOVITS';
------------------------------------------------------------------------------------------------------------------------
--14.
--2. Kötelező feladat
------------------------------------------------------------------------------------------------------------------------
--Írjunk meg egy PLSQL procedúrát, amelyik a paraméterül kapott felhasználónévre kiírja
--a felhasználó legutoljára létrehozott tábláját, annak méretét byte-okban, valamint a létrehozás
--dátumát.
------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE newest_table(P_USER VARCHAR2) IS
    TABLE_NAME  DBA_OBJECTS.OBJECT_NAME%TYPE;
    CREATE_DATE  DBA_OBJECTS.CREATED%TYPE;
    TABLE_SIZE DBA_SEGMENTS.BYTES%TYPE;
BEGIN
    SELECT OBJECT_NAME, CREATED INTO TABLE_NAME, CREATE_DATE FROM DBA_OBJECTS
    WHERE OWNER = UPPER(P_USER)  AND OBJECT_TYPE='TABLE' ORDER BY CREATED DESC FETCH FIRST 1 ROWS ONLY;
    SELECT BYTES INTO TABLE_SIZE FROM DBA_SEGMENTS WHERE SEGMENT_NAME = TABLE_NAME;
    DBMS_OUTPUT.PUT_LINE('Table_name: '|| TABLE_NAME || '    Size: ' || TABLE_SIZE || ' bytes    Created: '|| to_char(CREATE_DATE,'yyyy.mm.dd.hh24:mi'));
END;

CALL newest_table('NIKOVITS');
CALL check_plsql('newest_table(''NIKOVITS'')');

--Megjegyzés!
--Próbáljuk ki a procedúrát a saját felhasználónevünket megadva paraméterként, az alábbi tábla létrehozása után:
--  CREATE TABLE t_without_segment(o INT) SEGMENT CREATION DEFERRED;
--Majd szúrjunk be 1 sort és próbáljuk ki újra.
--  INSERT INTO t_without_segment VALUES(100);
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--III. feladat sor:
------------------------------------------------------------------------------------------------------------------------
--ROWID adattípus formátuma és jelentése (lásd még DBMS_ROWID package)
----------------------------------------------------------------------
--18 karakteren irodik ki, a kovetkezo formaban: OOOOOOFFFBBBBBBRRR
--OOOOOO -  az objektum azonositoja (egészen pontosan az úgynevezett adatobjektum azonosítója)
--FFF    -  fajl azonositoja (tablateren beluli relativ sorszam)
--BBBBBB -  blokk azonosito (a fajlon beluli sorszam)
--RRR    -  sor azonosito (a blokkon beluli sorszam)
--
--A ROWID megjeleniteskor 64-es alapu kodolasban jelenik meg (Base64).
--Az egyes szamoknak (0-63) a következo karakterek felelnek meg:
--A-Z -> (0-25), a-z -> (26-51), 0-9 -> (52-61), '+' -> (62), '/' -> (63)
--
--Pl. 'AAAAAB' -> 000001
--
--1.
--A NIKOVITS felhasználó CIKK táblája hány blokkot foglal le az adatbázisban? (blokkszám)
--(Vagyis hány olyan blokk van, ami ennek a táblának a szegmenséhez tartozik és így már
--más táblához nem rendelhető hozzá?)
SELECT bytes, blocks FROM dba_segments
WHERE owner='NIKOVITS' AND segment_name='CIKK' AND segment_type='TABLE';
------------------------------------------------------------------------------------------------------------------------
--2.
------------------------------------------------------------------------------------------------------------------------
--A NIKOVITS felhasználó CIKK táblájának adatai hány blokkban helyezkednek el? (blokkszám)
--(Vagyis a tábla sorai ténylegesen hány blokkban vannak tárolva?)
--!!! -> Ez a kérdés nem ugyanaz mint az előző, mert a tábla blokkjai lehetnek üresek is.
SELECT DISTINCT dbms_rowid.rowid_relative_fno(ROWID) fajl,
       dbms_rowid.rowid_block_number(ROWID) blokk
FROM nikovits.cikk;
------------------------------------------------------------------------------------------------------------------------
--Vagy rögtön megszámolva az elő lekérdezés által felsorolt adatblokkokat:
------------------------------------------------------------------------
SELECT count(*) FROM
(SELECT DISTINCT dbms_rowid.rowid_relative_fno(ROWID) fajl,
        dbms_rowid.rowid_block_number(ROWID) blokk
 FROM nikovits.cikk);
------------------------------------------------------------------------------------------------------------------------
--3.
------------------------------------------------------------------------------------------------------------------------
--Az egyes blokkokban hány sor van? (file_id, blokk_id, darab)
SELECT dbms_rowid.rowid_relative_fno(ROWID) fajl,
       dbms_rowid.rowid_block_number(ROWID) blokk, count(*)
FROM nikovits.cikk
GROUP BY dbms_rowid.rowid_relative_fno(ROWID), dbms_rowid.rowid_block_number(ROWID);
------------------------------------------------------------------------------------------------------------------------
--Hozzunk létre egy táblát az EXAMPLE táblatéren, amelynek szerkezete azonos a nikovits.cikk
--tábláéval és pontosan 128 KB helyet foglal az adatbázisban. Foglaljunk le manuálisan további
--128 KB helyet a táblához. Vigyünk fel sorokat addig, amig az első blokk tele nem
--lesz, és 1 további sora lesz még a táblának a második blokkban.
--(A felvitelt plsql programmal végezzük és ne kézzel, mert úgy kicsit sokáig tartana.)
--További segítség és példák találhatók az ab2_oracle.docx állományban.
-------------------------------------------------------------------------------------
ALTER SESSION SET deferred_segment_creation = FALSE;

--A fenti utasítás egy inicializációs paraméter értékét változtatja meg. Ha a paraméter
--értéke TRUE lenne, akkor csak késleltetve, az első beszúráskor jönne létre a szegmens.
--Az inicializációs paraméter(ek) aktuális értékét megnézhetjük session szinten:
SELECT * FROM v$parameter WHERE name like '%deferred%segment%';
--illetve instance szinten:
SELECT * FROM v$system_parameter WHERE name like '%deferred%segment%';
------------------------------------------------------------------------------------------------------------------------
-- Létrehozzuk a táblát a megfelelő helyfoglalási paraméterekkel:
CREATE TABLE proba
TABLESPACE example
STORAGE (INITIAL 128K  MINEXTENTS 1  MAXEXTENTS 200  PCTINCREASE 0)
AS
SELECT * FROM nikovits.cikk WHERE 1=2;
------------------------------------------------------------------------------------------------------------------------
-- Újabb extenst foglalunk le a tábla számára (a táblatér egy létező fájlja legyen !!!)
ALTER TABLE proba ALLOCATE EXTENT
(SIZE 128K DATAFILE '/u01/app/oracle/oradata/aramis/example01.dbf');
------------------------------------------------------------------------------------------------------------------------
-- Majd egyesével sorokat szúrunk be, és mindig megnézzük, hogy van-e már 2 blokk
DECLARE
 v_blokkszam NUMBER := 0; -- nemüres blokkok száma
 v_sorsz NUMBER := 1;
BEGIN
  WHILE v_blokkszam < 2 AND v_sorsz < 1000 LOOP
    INSERT INTO proba SELECT * FROM nikovits.cikk WHERE ckod=v_sorsz;
    v_sorsz := v_sorsz + 1;
    SELECT COUNT(DISTINCT dbms_rowid.rowid_relative_fno(ROWID)||
                dbms_rowid.rowid_block_number(ROWID)) INTO v_blokkszam
    FROM nikovits.proba;
  END LOOP;
  COMMIT;
END;
------------------------------------------------------------------------------------------------------------------------
-- A végén ellenőrizhetjük, hogy tényleg 2 blokkban vannak a sorok:
SELECT dbms_rowid.rowid_relative_fno(ROWID) fajl,
       dbms_rowid.rowid_block_number(ROWID) blokk, count(*)
FROM nikovits.proba
GROUP BY dbms_rowid.rowid_relative_fno(ROWID), dbms_rowid.rowid_block_number(ROWID);
------------------------------------------------------------------------------------------------------------------------
--Próbáljuk ki az előzőt ismét, de most a PCTFREE értéket állítsuk 40-re.
--Mindkét esetben ellenőrizzük is, hogy a sorok tényleg két blokkban vannak,
--és a másodikban csak egyetlen sor van.
------------------------------------------------------------------------------------------------------------------------
DROP TABLE proba;
CREATE TABLE proba
TABLESPACE example PCTFREE 40
STORAGE (INITIAL 128K  MINEXTENTS 1  MAXEXTENTS 200  PCTINCREASE 0)
AS
SELECT * FROM nikovits.cikk WHERE 1=2;

--A PL/SQL programot ismét lefuttatva, látható, hogy most kevesebb sor fér el a 2 blokkban.
------------------------------------------------------------------------------------------------------------------------
--4.
------------------------------------------------------------------------------------------------------------------------
--�?llapítsuk meg, hogy a NIKOVITS.ELADASOK táblának a következő adatokkal azonosított sora
--(szla_szam=100) melyik adatfájlban van, azon belül melyik blokkban, és a blokkon belül hányadik a sor?
--(file_név, blokk_id, sorszám)
--------------------------------------------------------------
SELECT  dbms_rowid.rowid_object(ROWID) adatobj,
        dbms_rowid.rowid_relative_fno(ROWID) fajl,
        dbms_rowid.rowid_block_number(ROWID) blokk,
        dbms_rowid.rowid_row_number(ROWID) sor
FROM nikovits.eladasok
WHERE szla_szam=100;

--Az előző feladatban megadott sor melyik partícióban van?
--Mennyi az objektum azonosítója, és ez milyen objektum?
------------------------------------------------------------------------------------------------------------------------
SELECT  o.object_name, o.subobject_name, o.object_type,o.data_object_id
FROM nikovits.eladasok e, dba_objects o
WHERE dbms_rowid.rowid_object(e.ROWID) = o.data_object_id
AND szla_szam=100;
------------------------------------------------------------------------------------------------------------------------
--5.
------------------------------------------------------------------------------------------------------------------------
--Írjunk meg egy PLSQL procedúrát, amelyik kiírja, hogy a NIKOVITS.TABLA_123 táblának melyik
--adatblokkjában hány sor van. (Output formátuma soronként: file_id; blokk_id -> darab)
--Vigyázat!!! Azokat az adatblokkokat is ki kell írni, amelyekben a sorok száma 0, de a tábla
--szegmenséhez tartoznak.
-- előtte GRANT SELECT ON tabla_123 to PUBLIC;
CREATE OR REPLACE PROCEDURE num_of_rows IS
    COUNTER NUMBER;
BEGIN
    FOR RECORD IN (SELECT FILE_ID, BLOCK_ID, BLOCKS FROM DBA_EXTENTS WHERE OWNER='NIKOVITS' AND SEGMENT_NAME='TABLA_123' ORDER BY 1, 2, 3)
    LOOP
        FOR i in 1..RECORD.BLOCKS LOOP
            SELECT COUNT(*) INTO COUNTER FROM NIKOVITS.tabla_123
            WHERE DBMS_ROWID.ROWID_RELATIVE_FNO(ROWID) = RECORD.FILE_ID
            AND DBMS_ROWID.ROWID_BLOCK_NUMBER(ROWID) = RECORD.BLOCK_ID + i - 1;
            DBMS_OUTPUT.PUT_LINE(RECORD.FILE_ID || ';' || TO_CHAR(RECORD.BLOCK_ID + i - 1) || '->' || COUNTER);
        END LOOP;
    END LOOP;
END;

CALL num_of_rows();
CALL check_plsql('num_of_rows()');
------------------------------------------------------------------------------------------------------------------------
--6.
------------------------------------------------------------------------------------------------------------------------
--További példák a ROWID használatára
-------------------------------------
--Hozzunk letre egy EXCEPTIONS nevu tablat az utlexcpt.sql nevu script
--alapjan, majd egy olyan constraintet, amelyet a tablaban levo sorok
--kozul nehany megsert. (Emiatt a constraint letrehozasa hibauzenetet
--kell, hogy eredmenyezzen.) Allapitsuk meg az EXCEPTIONS nevu tabla
--segitsegevel, hogy mely sorok sertik meg az imenti constraintet.
--
--Az utlexcpt.sql nevű script a következő utasítást tartalmazza:
CREATE TABLE exceptions(row_id rowid, owner varchar2(30),
    table_name varchar2(30), constraint varchar2(30));
------------------------------------------------------------------------
--A fenti megoldását lásd az ab2_oracle.docx állományban, kb. a 10. oldalon
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--IV. feladat sor
------------------------------------------------------------------------------------------------------------------------
--B+ fa index
------------------------------------------------------------------------------------------------------------------------
--Az alábbi feladatban a tankönyben leírt és az előadáson is bemutatott algoritmussal
--építsünk fel egy B+ fát!
--
--Tegyük fel, hogy egy B+ fa blokkjaiba 3 kulcs fér el plusz 4 mutató. A kulcsok
--különbözőek. Szúrjuk be a B+ fába az alábbi kulcsértékeket a megadott sorrendben:
--39,15,50,70,79,83,72,43,75,45,60,80
--Adjuk meg a B+ fa minden olyan állapotát, amikor egy csomópont kettéosztására volt szükség.
--
--
--                       15|39|50                <- 70
--
--                          50
--                    15|39    50|70             <- 79
--
--                          50
--                    15|39    50|70|79          <- 83
--
--                         50|79
--                15|39    50|70   79|83         <- 72,43
--
--                         50|79
--           15|39|43    50|70|72   79|83        <- 75
--
--                        50|72|79
--          15|39|43   50|70    72|75   79|83    <- 45
--
--45 beszúrása két lépésre osztva:
--1.
--                        43|50|72|79
--      15|39   43|45   50|70    72|75   79|83
--
--2.
--                           72
--                43|50               79
--      15|39   43|45   50|70    72|75   79|83    <- 60,80
--
--                           72
--               43|50                   79
--      15|39   43|45   50|60|70    72|75   79|80|83
--
--Egy kis segítség:
------------------------------------------------------------------------------------------------------------------------
--
--Levél csúcs kettéosztásakor minden kulcsot megőrzünk a régi és az új (szomszédos) csúcsban.
--1 új kulcs-mutató párt küldünk felfelé a szülő csúcsba, amit ott kell elhelyezni.
--
--Belső csúcs kettéosztásakor (N,M-re) a mutatók első fele az N-be kerül, a második az M-be.
--A kulcsok első fele az N-be kerül a második fele az M-be, de középen kimarad egy kulcs,
--ami az M-en keresztül (első gyermekén keresztül) elérhető legkisebb kulcsot tartalmazza.
--Ez nem kerül sem N-be, sem M-be, hanem ez megy fölfelé N és M közös szülőjébe az M-re mutató
--mutatóval együtt.

--Bitmap index
--------------
--
--DKOD DNEV   FIZETES  FOGLALKOZAS  BELEPES  OAZON
-----------------------------------------------------
--1    SMITH     800   CLERK        1980     20
--2    ALLEN    1600   SALESMAN     1981     30
--3    WARD     1250   SALESMAN     1981     30
--4    JONES    2975   MANAGER      1981     20
--5    MARTIN   1250   SALESMAN     1981     30
--6    BLAKE    2850   MANAGER      1981     30
--7    CLARK    2450   MANAGER      1981     10
--8    SCOTT    3000   ANALYST      1982     20
--9    KING     5000   PRESIDENT    1981     10
--10   TURNER   1500   SALESMAN     1981     30
--11   ADAMS    1100   CLERK        1983     20
--12   JAMES     950   CLERK        1981     30
--13   FORD     3000   ANALYST      1981     20
--14   MILLER   1300   CLERK        1982     10
--
--
--Készítsen bitmap indexet a dolgozó tábla OAZON oszlopára és adja meg a bitvektorokat.
--
--Tegyük fel, hogy a FOGLALKOZAS, a BELEPES és az OAZON oszlopokra létezik bitmap index (3 index).
--Készítsük el az alábbi lekérdezésekhez szükséges bitvektorokat, majd végezzük el rajtuk a szükséges
--műveleteket, és adjuk meg azt az előállt bitvektort, ami alapján a végeredmény sorok megkaphatók.
--Ellenőrzésképpen adjuk meg a lekérdezést SQL-ben is.
--
--- Adjuk meg azoknak a dolgozóknak a nevét, akik 1981-ben léptek be és a foglalkozásuk hivatalnok (CLERK),
--  vagy a 20-as osztályon dolgoznak és a foglalkozásuk MANAGER.
--
--- Adjuk meg azoknak a dolgozóknak a nevét, akik nem 1981-ben léptek be és a 10-es vagy a 30-as
--  osztályon dolgoznak.
--
--Tömörítse a következő bitvektort a szakaszhossz kódolással. (lásd UW_szakaszhossz_kodolas.doc)
--0000000000000000000000010000000101
--
--szakaszhosszok: 23, 7, 1 -> bináris formában: 10111, 111, 1
--tömörített -> 1111010111 110111 01
--                   -----    ---  -
--                     23      7   1
--
--Fejtsük vissza a következő, szakaszhossz kódolással tömörített bitvektort:
--1111010101001011
--     ----- -  --
--       21  0   3
--visszafejtve -> 00000000000000000000110001
--
--
--Oracle indexek
----------------
--(DBA_INDEXES, DBA_IND_COLUMNS, DBA_IND_EXPRESSIONS)
--
--Hozzunk létre egy vagy több táblához több különböző indexet, legyen köztük több oszlopos,
--csökkenő sorrendű, bitmap, függvény alapú stb. (Ehhez használhatók az ab2_oracle.doc
--állományban szereplő példák, vagy a cr_index.txt-ben szereplők.)
--Az alábbi lekérdezésekkel megállapítjuk az iménti indexeknek mindenféle tulajdonságait a
--katalógusokból.
------------------------------------------------------------------------------------------------------------------------
--1.
------------------------------------------------------------------------------------------------------------------------
--Adjuk meg azoknak a tábláknak a nevét, amelyeknek van csökkenő sorrendben indexelt oszlopa. (tulajdonos: NIKOVITS)
------------------------------------------------------------------------------------------------------------------------
SELECT * FROM dba_ind_columns WHERE descend='DESC' AND index_owner='NIKOVITS';
SELECT * FROM dba_ind_columns WHERE index_owner='NIKOVITS';
select * from DBA_IND_EXPRESSIONS where TABLE_OWNER ='NIKOVITS';
--Miért ilyen furcsa az oszlopnév?
---> lásd DBA_IND_EXPRESSIONS
------------------------------------------------------------------------------------------------------------------------
--2.
------------------------------------------------------------------------------------------------------------------------
--Adjuk meg azoknak az indexeknek a nevét, amelyek legalább 9 oszloposak.
--(Vagyis a táblának legalább 9 oszlopát vagy egyéb kifejezését indexelik.)
------------------------------------------------------------------------------------------------------------------------
SELECT index_owner, index_name FROM dba_ind_columns
GROUP BY index_owner, index_name HAVING count(*) >=9;
------------------------------------------------------------------------------------------------------------------------
--3.
------------------------------------------------------------------------------------------------------------------------
--Adjuk meg a NIKOVITS.CUSTOMERS táblára létrehozott bitmap indexek nevét.
--Előtte:
create bitmap index CUSTOMERS_MARITAL_BIX on customers(cust_marital_status);
create bitmap index CUSTOMERS_YOB_BIX on customers(cust_year_of_birth);
--------------------------------------------------------------------------------
SELECT index_name FROM dba_indexes
WHERE table_owner='NIKOVITS' AND table_name='CUSTOMERS' AND index_type='BITMAP';
------------------------------------------------------------------------------------------------------------------------
--4.
------------------------------------------------------------------------------------------------------------------------
--Adjuk meg azon kétoszlopos indexek nevét és tulajdonosát, amelyeknek legalább
--az egyik kifejezése függvény alapú. (tulajdonos, név)
------------------------------------------------------------------------------------------------------------------------
SELECT index_owner, index_name FROM dba_ind_columns
GROUP BY index_owner, index_name HAVING count(*) =2
 INTERSECT
SELECT index_owner, index_name FROM dba_ind_expressions;
------------------------------------------------------------------------------------------------------------------------
--5.
------------------------------------------------------------------------------------------------------------------------
--Adjuk meg az egyikükre, pl. a NIKOVITS tulajdonában lévőre, hogy milyen kifejezések szerint
--vannak indexelve a soraik. (Vagyis mi a függveny, ami alapján a bejegyzések készülnek.)
----------------------------------------------------------------------------------
SELECT * FROM dba_ind_expressions WHERE index_owner='NIKOVITS';
------------------------------------------------------------------------------------------------------------------------
--6.
------------------------------------------------------------------------------------------------------------------------
--Írjunk meg egy plsql procedúrát, amelyik a paraméterül kapott táblára vonatkozóan
--kiírja a tábla indexeit és azok méretét.
create or replace PROCEDURE list_indexes(p_owner VARCHAR2, p_table VARCHAR2) IS
    CURSOR curs1 IS select INDEX_NAME indName,COLUMN_length colLength from DBA_IND_COLUMNS where table_owner = upper(p_owner) and table_name=upper(p_table) order by INDEX_NAME ASC;
    rec1 curs1%ROWTYPE;
    indSize integer;
begin
    open curs1;
        loop
            FETCH curs1 INTO rec1;
            exit WHEN curs1%NOTFOUND;
                select distinct bytes into indSize from dba_segments
                    where segment_name = rec1.indName and segment_type='INDEX' and owner = upper(p_owner);
                dbms_output.put_line(rec1.indName||': '||indSize);
        end loop;
end;

CALL list_indexes('nikovits', 'customers');
CALL list_indexes('nikovits', 'cikk_iot');
------------------------------------------------------------------------------------------------------------------------
--V. feladat sor
------------------------------------------------------------------------------------------------------------------------
--Kötelező feladat ellenőrzése
------------------------------------------------------------------------------------------------------------------------
--Index-szervezett tábla
------------------------------------------------------------------------------------------------------------------------
--1.
------------------------------------------------------------------------------------------------------------------------
--Adjuk meg a NIKOVITS felhasználó tulajdonában levő index-szervezett táblák nevét.
--(Melyik táblatéren vannak ezek a táblák? -> miért nem látható?)
----------------------------------------------------------------------------------
SELECT owner, table_name, iot_name, iot_type, tablespace_name FROM dba_tables
WHERE owner='NIKOVITS' AND iot_type = 'IOT';
------------------------------------------------------------------------------------------------------------------------
--2.
------------------------------------------------------------------------------------------------------------------------
--Adjuk meg a fenti táblák index részét, és azt, hogy ezek az index részek (szegmensek)
--melyik táblatéren vannak?
----------------------------------------------------------------------------------
SELECT table_name, index_name, index_type, tablespace_name FROM dba_indexes
WHERE table_owner='NIKOVITS' AND index_type LIKE '%IOT%TOP%';
------------------------------------------------------------------------------------------------------------------------
--3.
------------------------------------------------------------------------------------------------------------------------
--Keressük meg a szegmensek között az előző táblákat illetve indexeket, és adjuk
--meg a méretüket.
------------------------------------------------------------------------------------------------------------------------
SELECT table_name, index_name, index_type, s.bytes
FROM dba_indexes i, dba_segments s
WHERE i.table_owner='NIKOVITS' AND i.index_type LIKE '%IOT%TOP%'
AND i.index_name=s.segment_name AND s.owner='NIKOVITS';
------------------------------------------------------------------------------------------------------------------------
--4.
------------------------------------------------------------------------------------------------------------------------
--Keressük meg az adatbázis objektumok között a fenti táblákat és indexeket, és adjuk
--meg az objektum azonosítójukat és adatobjektum azonosítójukat (DATA_OBJECT_ID).
------------------------------------------------------------------------------------------------------------------------
--5.
------------------------------------------------------------------------------------------------------------------------
--Adjuk meg a fenti táblák túlcsordulási részeit (ha van).
----------------------------------------------------------------------------------
SELECT owner, table_name, iot_name, iot_type FROM dba_tables
WHERE owner='NIKOVITS' AND iot_type = 'IOT_OVERFLOW';
------------------------------------------------------------------------------------------------------------------------
--6.
------------------------------------------------------------------------------------------------------------------------
--Keressük meg a túlcsordulási részeket a szegmensek között és adjuk meg a méretüket.
----------------------------------------------------------------------------------
SELECT t.owner, t.table_name, t.iot_name, t.iot_type, s.bytes
FROM dba_tables t, dba_segments s
WHERE t.owner='NIKOVITS' AND t.iot_type = 'IOT_OVERFLOW'
AND s.owner='NIKOVITS' AND s.segment_name=t.table_name;
------------------------------------------------------------------------------------------------------------------------
--7.
------------------------------------------------------------------------------------------------------------------------
--Keressük meg a NIKOVITS.CIK_IOT index szervezett tábla részeit
--(tábla szegmens, túlcsordulási szegmens, a tábla indexei), adjuk meg az
--objektum azonosítóikat és az adatobjektum azonosítóikat.
--(object_name, object_type, object_id, data_object_id)
----------------------------------------------------------------------------------
SELECT object_name, object_type, object_id, data_object_id
FROM dba_objects WHERE owner='NIKOVITS'
AND (object_name LIKE 'SYS_IOT%' OR object_name LIKE 'CIKK_IOT%');
------------------------------------------------------------------------------------------------------------------------
--8.
------------------------------------------------------------------------------------------------------------------------
--Adjuk meg azokat az index szervezett táblákat, amelyeknek pontosan
--1 dátum típusú oszlopa van. (owner, table_name)
----------------------------------------------------------------------------------
SELECT owner, table_name FROM dba_tables WHERE iot_type = 'IOT'
 INTERSECT
SELECT owner, table_name FROM dba_tab_columns
WHERE data_type='DATE' GROUP BY owner, table_name
HAVING count(*) = 1;

------------------------------------------------------------------------------------------------------------------------
--9.
------------------------------------------------------------------------------------------------------------------------
--Írjunk meg egy plsql procedúrát, amelyik a paraméterül kapott index szervezett
--tábláról kiírja a tábla méretét.
--Vigyázzunk, mert a táblának lehet index és túlcsordulási szegmense is!
CREATE OR REPLACE PROCEDURE iot_size(p_owner VARCHAR2, p_table VARCHAR2) IS
BEGIN

END;
CALL iot_size('nikovits', 'cikk_iot');

--Segítség:
SELECT i.table_name, i.index_name, t.table_name overfl
FROM dba_indexes i LEFT OUTER JOIN dba_tables t
 ON (t.owner='NIKOVITS' AND t.iot_type = 'IOT_OVERFLOW' AND i.table_name=t.iot_name)
WHERE i.table_owner='NIKOVITS' AND i.index_type LIKE '%IOT%TOP%';

--Partícionálás
------------------------------------------------------------------------------------------------------------------------
--(DBA_PART_TABLES, DBA_PART_INDEXES, DBA_TAB_PARTITIONS, DBA_IND_PARTITIONS,
--DBA_TAB_SUBPARTITIONS, DBA_IND_SUBPARTITIONS, DBA_PART_KEY_COLUMNS)
------------------------------------------------------------------------------------------------------------------------
--1.
------------------------------------------------------------------------------------------------------------------------
--Adjuk meg a NIKOVITS felhasználó tulajdonában levő partícionált táblák nevét és a
--particionálás típusát. (táblanév, típus)
-----------------------------------------------------------------------------
SELECT table_name, partitioning_type FROM dba_part_tables WHERE owner = 'NIKOVITS';
------------------------------------------------------------------------------------------------------------------------
--2.
------------------------------------------------------------------------------------------------------------------------
--Soroljuk fel a NIKOVITS.ELADASOK tábla partícióit valamint, hogy hány blokkot foglalnak
--az egyes partíciók. (név, blokkok)
--(Vigyázat! Egyes adatszótárak csak becsült méretet tartalmaznak.
--A pontos méreteket az extenseknél és szegmenseknél keressük.)
-----------------------------------------------------------------------------
--Az alábbi csak becsült adat az adatszótárból:
SELECT partition_name, blocks FROM dba_tab_partitions WHERE table_owner='NIKOVITS' AND table_name='ELADASOK';

--Az alábbi megadja a szegmens tényleges méretét:
SELECT segment_name, partition_name, blocks
FROM dba_segments WHERE owner='NIKOVITS' AND segment_type='TABLE PARTITION' and segment_name='ELADASOK';
------------------------------------------------------------------------------------------------------------------------
--3.
------------------------------------------------------------------------------------------------------------------------
--Adjuk meg, hogy a NIKOVITS.ELADASOK tábla mely oszlop(ok) szerint van particionálva, valamint
--adjuk meg az oszlopok sorrendjét a partícionáló oszlopokon belül. (oszlop, sorrend)
-----------------------------------------------------------------------------
SELECT column_name, column_position FROM dba_part_key_columns
WHERE owner='NIKOVITS' AND name='ELADASOK' AND object_type='TABLE';
------------------------------------------------------------------------------------------------------------------------
--4.
------------------------------------------------------------------------------------------------------------------------
--Adjuk meg, hogy a NIKOVITS.ELADASOK3 tábla második partíciójában milyen értékek szerepelhetnek. (érték)
-----------------------------------------------------------------------------
SELECT partition_name, high_value, partition_position FROM dba_tab_partitions
WHERE table_owner='NIKOVITS' AND table_name='ELADASOK3' AND partition_position=2;
------------------------------------------------------------------------------------------------------------------------
--5.
------------------------------------------------------------------------------------------------------------------------
--Adjuk meg egy partícionált tábla (pl. NIKOVITS.ELADASOK) logikai és fizikai részeit.
--(object_name, object_type, subobject_name, object_id, data_object_id)
--Maga a tábla most is logikai objektum, a partíciói vannak fizikailag tárolva.
--Nézzük meg az objektumok és a szegmensek között is.
-----------------------------------------------------------------------------
SELECT object_name, object_type, subobject_name, object_id, data_object_id
FROM dba_objects WHERE owner='NIKOVITS' AND object_name='ELADASOK';

SELECT * FROM dba_segments WHERE owner='NIKOVITS' AND segment_name='ELADASOK';
------------------------------------------------------------------------------------------------------------------------
--6.
------------------------------------------------------------------------------------------------------------------------
--Illetve ha alpartíciói is vannak (pl. nikovits.eladasok4), akkor csak az alpartíciók
--vannak tárolva. (object_name, object_type, subobject_name, object_id, data_object_id)
--Nézzük meg az objektumok és a szegmensek között is.
--(segment_name, segment_type, bytes)
-----------------------------------------------------------------------------
SELECT object_name, object_type, subobject_name, object_id, data_object_id
FROM dba_objects WHERE owner='NIKOVITS' AND object_name='ELADASOK4';

SELECT * FROM dba_segments WHERE owner='NIKOVITS' AND segment_name='ELADASOK4';
------------------------------------------------------------------------------------------------------------------------
--7.
------------------------------------------------------------------------------------------------------------------------
--Melyik a legnagyobb méretű partícionált tábla az adatbázisban a partíciók
--összméretét tekintve? Az alpartícióval rendelkező táblákat is vegyük figyelembe.
--(tulajdonos, táblanév, méret)
-----------------------------------------------------------------------------
SELECT owner, segment_name, SUM(bytes) FROM dba_segments
WHERE segment_type LIKE 'TABLE%PARTITION'
GROUP BY owner, segment_name
ORDER BY SUM(bytes) DESC
FETCH FIRST 1 ROWS ONLY;

--Dinamikus SQL utasítások PL/SQL programban
------------------------------------------------------------------------------------------------------------------------
--8.
------------------------------------------------------------------------------------------------------------------------
--Írjunk meg egy PLSQL procedúrát, amelyik kiírja a paraméterül kapott táblára,
--hogy annak hány üres blokkja van. A procedúrát úgy írjuk meg, hogy az partícionált táblára
--is működjön. (Output formátum -> Empty Blocks: nnn)
---- grant select on eladasok to public;
create or replace PROCEDURE empty_blocks(p_owner VARCHAR2, p_table VARCHAR2) IS
    v_sql VARCHAR(1000);
    num1 integer;
    num2 integer;
    intersection integer;
begin
    select sum(blocks) into num1 from dba_segments where segment_name=upper(p_table) and owner = upper(p_owner);
    v_sql := 'select count(DISTINCT dbms_rowid.rowid_block_number(ROWID)) blokk from '||p_owner||'.'||p_table;
    EXECUTE IMMEDIATE v_sql INTO num2;
    intersection := num1-num2;
    dbms_output.put_line('Empty Blocks: '||intersection);
end;
/
CALL empty_blocks('nikovits','customers');
CALL empty_blocks('nikovits','eladasok');
CALL empty_blocks('nikovits','hivas');
-- ez utóbbi csak az ullmanon, és akár 1 percig is futhat

--Tipp:
--Nézzük meg, hogy összesen hány blokkot tartalmaz(nak) a tábla szegmense(i). (partícionált is lehet !)
--Számoljuk meg az olyan blokkok számát, amelyek nem üresek. A fenti kettő különbsége adja a végeredményt.
--Mivel a tábla nevét csak futásidőben fogjuk megtudni, ezért úgynevezett dinamikus SQL utasítást
--kell használnunk. Ehhez lásd: pl_dinamikusSQL.txt
------------------------------------------------------------------------------------------------------------------------
--Klaszter (CLUSTER)
------------------------------------------------------------------------------------------------------------------------
--(DBA_CLUSTERS, DBA_CLU_COLUMNS, DBA_TABLES, DBA_CLUSTER_HASH_EXPRESSIONS)
--
--Hozzunk létre egy DOLGOZO(dazon, nev, beosztas, fonoke, fizetes, oazon ... stb.)
--és egy OSZTALY(oazon, nev, telephely ... stb.) nevű táblát.
--(lásd NIKOVITS.DOLGOZO és NIKOVITS.OSZTALY)
--A két táblának az osztály azonosítója (oazon) lesz a közös oszlopa. A két táblát
--egy index alapú CLUSTEREN hozzuk létre. (Előbb persze létre kell hozni a clustert is.)
--Majd tegyünk bele 3 osztályt, és osztályonként két dolgozót.
------------------------------------------------------------------------------------------------------------------------
--1.
------------------------------------------------------------------------------------------------------------------------
--Adjunk meg egy olyan clustert az adatbázisban (ha van ilyen), amelyen még nincs
--egy tábla sem. (tulajdonos, klaszternév)
-----------------------------------------------------------------------------
SELECT owner, cluster_name FROM dba_clusters
 MINUS
SELECT owner, cluster_name FROM dba_tables;
------------------------------------------------------------------------------------------------------------------------
--2.
------------------------------------------------------------------------------------------------------------------------
--Adjunk meg egy olyant, amelyiken pontosan 2 tábla van. (tulajdonos, klaszternév)
-----------------------------------------------------------------------------
SELECT owner, cluster_name FROM dba_tables WHERE cluster_name IS NOT NULL
GROUP BY owner, cluster_name HAVING COUNT(*) = 2;
------------------------------------------------------------------------------------------------------------------------
--3.
------------------------------------------------------------------------------------------------------------------------
--Adjunk meg egy olyan clustert, amelynek a cluster kulcsa 3 oszlopból áll.
--Vigyázat, több tábla is lehet rajta!!! (tulajdonos, klaszternév)
-----------------------------------------------------------------------------
SELECT owner, cluster_name FROM dba_clu_columns
GROUP BY owner, cluster_name HAVING COUNT(DISTINCT clu_column_name) = 3;
------------------------------------------------------------------------------------------------------------------------
--4.
------------------------------------------------------------------------------------------------------------------------
--HASH CLUSTER
--Hány olyan hash cluster van az adatbázisban, amely nem az oracle alapértelmezés
--szerinti hash függvényén alapul? (darab)
-----------------------------------------------------------------------------
SELECT COUNT(*) FROM
(SELECT owner, cluster_name, hash_expression FROM dba_cluster_hash_expressions);
------------------------------------------------------------------------------------------------------------------------
--5.
------------------------------------------------------------------------------------------------------------------------
--Hozzunk létre egy hash clustert és rajta két táblát, majd szúrjunk be a
--táblákba sorokat úgy, hogy a két táblának 2-2 sora ugyanabba a blokkba
--kerüljön. Ellenőrizzük is egy lekérdezéssel, hogy a 4 sor valóban ugyanabban
--a blokkban van-e. (A ROWID lekérdezésével)
--TIPP: A sorok elhelyezését befolyásolni tudjuk a HASH IS megadásával.
------------------------------------------------------------------------------------------------------------------------
--6.
------------------------------------------------------------------------------------------------------------------------
--Írjunk meg egy PL/SQL procedúrát, amely kiírja egy tábla tárolási módját (HEAP, PARTITION, IOT, CLUSTER)
--Segítség:
SELECT owner, table_name, cluster_name, partitioned, iot_type
FROM dba_tables WHERE owner='NIKOVITS'
AND table_name IN ('EMP', 'ELADASOK5', 'CIKK_IOT', 'EMP_CLT');

CREATE OR REPLACE PROCEDURE print_type(p_owner VARCHAR2, p_table VARCHAR2) IS
BEGIN END;

--Teszt:
CALL print_type('nikovits', 'emp');
CALL print_type('nikovits', 'eladasok5');
CALL print_type('nikovits', 'cikk_iot');
CALL print_type('nikovits', 'emp_clt');
------------------------------------------------------------------------------------------------------------------------
--VI. Feladat sor
------------------------------------------------------------------------------------------------------------------------
--Az alábbi feladatokban kiszámoljuk, illetve sok helyen csak megbecsüljük egy tábla sorainak
--vagy adatblokkjainak a számát, egy index méretét, vagy egy lekérdezés végrehajtása során
--előálló köztes részeredmény méretét (sorainak vagy blokkjainak számát).
--Vannak olyan feladatok is, ahol azt számoljuk ki (becsüljük meg), hogy milyen költséggel
--lehet egy lekérdezést, vagy annak egy lépését végrehajtani.
--Mindezeknek az a jelentősége, hogy megértjük, milyen nagy különbséget jelenhet futásidőben,
--ha egy lekérdezéshez például van megfelelő index létrehozva, vagy ha egy bonyolult lekérdezés
--egyik lépését egy jobb algoritmussal, és így kisebb költséggel lehet végrehajtani.
--A költségek tekintetében többnyire a szükséges adatblokk olvasások/írások száma a legjelentősebb.
------------------------------------------------------------------------------------------------------------------------
--1. Feladat
------------------------------------------------------------------------------------------------------------------------
--Van egy R táblánk, egy I1 sűrű és egy I2 ritka (egy szintű) indexünk az alábbi paraméterekkel:
--T(R) = 10000, bf(R) = 20, bf(I1) = 100, bf(I2) = 100
--Számoljuk ki a következőket:
--B(R)  = ?   ->  B(R) = T(R)/bf(R) = 500
--                A tábla sorainak száma osztva a blokkolási faktorral
--B(I1) = ?   ->  B(I1) = T(I1)/bf(I1) = 100
--                I1 sűrű index, így T(I1)=T(R), mert a tábla minden sorához tartozik egy (kulcs, mutató)
--                pár az indexben.
--B(I2) = ?   ->  B(I2) = T(I2)/bf(I2) = 5
--                I2 ritka, így T(I2)=B(R), mert csak a tábla blokkjaihoz tartozik egy (kulcs, mutató) pár.
--Megjegyzés: Látható, hogy a ritka index sokkal kevesebb helyet foglal, mint a sűrű. Persze a ritka indexhez
--            szükséges, hogy az indexelt adatok rendezetten legyenek tárolva.
------------------------------------------------------------------------------------------------------------------------
--2. feladat
------------------------------------------------------------------------------------------------------------------------
--Számoljuk ki az előző feladatbeli értékeket, ha a blokkok csak 80%-ban lehetnek tele.
---> bf(R) = 0.8 * 20; bf(I1) = 0.8 * 100, a számolás egyebekben hasonló az előzőhöz.
--T(R) = 10000, bf(R) = 16, bf(I1) = 80, bf(I2) = 80
--B(R)  = ?   ->  B(R) = T(R)/bf(R) = 625
--                A tábla sorainak száma osztva a blokkolási faktorral
--B(I1) = ?   ->  B(I1) = T(I1)/bf(I1) = 125
--                I1 sűrű index, így T(I1)=T(R), mert a tábla minden sorához tartozik egy (kulcs, mutató)
--                pár az indexben.
--B(I2) = ?   ->  B(I2) = T(I2)/bf(I2) = 625/80 = 7,8125
--                I2 ritka, így T(I2)=B(R), mert csak a tábla blokkjaihoz tartozik egy (kulcs, mutató) pár.
------------------------------------------------------------------------------------------------------------------------
--3. Feladat
------------------------------------------------------------------------------------------------------------------------
--T(R) = 1.000.000, bf(R) = 20, egy kulcs oszlopra készítünk B+ fa indexet, amelyre bf(I) = 50.
--Számoljuk ki a következőket:
--B(I) = ?    (segítség: számítsuk ki szintenként az indexblokkok számát, a levél szinttel kezdve)

--Megoldás:
--A legalsó (levél) szint egy sűrű index, annyi (kulcs, mutató) párt tartalmaz, ahány sora van a táblának.
---> itt a blokkok száma tehát: T(R)/bf(I) = 20000.
--A második (és további szintek) ritka indexek az alattuk levő szintekre, vagyis annyi (kulcs, mutató)
--párt tartalmaznak, ahány blokk az alattuk levő szinten van.
---> 2. szint: 20000/bf(I) = 400
---> 3. szint: 400/bf(I) = 8
---> 4. szint: 8/bf(I) = 1 blokk (ez a gyökér blokk, ami nincs tele)
---> összesen 20409 blokkja lesz az indexnek, vagyis B(I) = 20409

--Mennyi a műveletigénye blokkolvasásokban egy A = c típusú keresésnek (legrosszabb esetben) ha
--a) a tábla sorai rendezetlenül vannak tárolva és nem használunk indexet
---> B(R) = T(R)/bf(R)-rel = 50000
--   vagyis a táblának mind az 50000 blokkját be kell olvasni legrosszabb esetben.

--b) a tábla sorai rendezetten vannak tárolva és nem használunk indexet
---> log2(B(R)) =~ 16
--   rendezett esetben bináris keresést alkalmazhatunk, ami jelen esetben ~16 blokk olvasást jelent.

--c) a fenti B+ fa indexet használjuk.
---> ht(I) + 1 = 5
--   (ht(I) a fa magassága, jelen esetben 4, plusz még be kell olvasnunk a megtalált blokkot.

--Megjegyzés: A fenti eredmények megmutatják, hogy miért nem érdemes egyszintű indexet létrehozni, hanem helyette
--            B+ fát. A B+ fa nem foglal sokkal több helyet, mint egy egyszintű sűrű index, de sokkal gyorsabban
--            lehet a segítségével keresni.
------------------------------------------------------------------------------------------------------------------------
--4. Feladat (optimization.pptx, 11. old.)
------------------------------------------------------------------------------------------------------------------------
--Tekintsük a következő paraméterekkel rendelkező R relációt:
--T(R)=1.000.000, blokkméret = 4096 byte, L(R)=128 byte, képméret = l(A) = V(R,A) = 500, és legyen W a következő
--lekérdezés eredménye:
--W <-- SELECT c1,c2,c3 FROM R WHERE A=x;
--Számoljuk ki B(R)-t és B(W)-t ha L(W)=64 byte.

--1. rész B(R) = ?
--B(R) = T(R) / bf(R) = 1.000.000 / 32 = 31.250
--bf(R) = b / L(R) = 4096 / 128 = 32

--2. rész B(W) = ?
--B(W) = T(W) / bf(W) = 2000 / 64 = 31.25 =~ 32
--T(W) = T(R) / V(R,A) = 1.000.000 / 500 = 2000
--bf(W) = b / L(W) = 4096 / 64 = 64

--Megoldás:
---> B = T/bf, de most előzőleg ki kell számolnunk T-t és bf-et.
--bf(R) = blokkméret/L(R) = 4096/128 = 32, bf(W) = blokkméret/L(W) = 64, T(W) = T(R)/V(R,A) = 2000
--B(R) = T(R)/bf(R) = 1000000/32 =~ 31250
--B(W) = T(W)/bf(W) = 2000/64 =~ 32
--
--Megjegyzés: Egy lekérdezés során a köztes eredményeket sokszor lemezen kell tárolnia az ABKR-nek,
--            ezért fontos kiszámolni (megbecsülni) a méretüket.
--
------------------------------------------------------------------------------------------------------------------------
--5. Feladat  (optimization.pptx, 21. old.)
------------------------------------------------------------------------------------------------------------------------
--Tegyük fel, hogy a memória mérete 101 blokk (M=101), és van egy R relációnk, amelyre B(R)=1000000.
--Mennyi a költsége (I/O műveletekben kifejezve) a fenti reláció külső összefuttatásos rendezésének?

--Megoldás:
---> 2 * B(R) + 2 * B(R) * log[B(R)/M] - B(R)  (a logaritmus alapja M-1)
---> Költség =~ 2000000 + 4000000 - 1000000 = 5000000
------------------------------------------------------------------------------------------------------------------------
--6. Feladat  (output_estimate.pptx 17. old.)
------------------------------------------------------------------------------------------------------------------------
--T(R) = 1000000, V(R,A) = 500, V(R,B) = 1000
--Számoljuk ki T(W)-t az egyenletességi feltételezéssel élve, ha W a következő lekérdezés eredménye:
--a) W <-- SELECT * FROM R WHERE A=x;           -> T(W) = T(R)/V(R,A) = 2000
--b) W <-- SELECT * FROM R WHERE A=x AND B=y;   -> T(W) = T(R)*(1/V(R,A))*(1/V(R,B)) = 2
--c) W <-- SELECT * FROM R WHERE A=x OR B=y;    -> T(W) = T(R)*(1-[1-1/V(R,A)]*[1-1/V(R,B)]) = ... lásd lejjebb
--
--c) részhez egy kis átalakítás:  V(R,A) -> v1, V(R,B) -> v2
--T*[1-(1-1/v1)*(1-1/v2)] = T*[(v1*v2)/(v1*v2) - (v1-1)*(v2-1)/(v1*v2)] =
--= T*[(v1 + v2 -1)/(v1*v2)] = T/v2 + T/v1 - T/(v1*v2)
--
--A fenti átalakítást felhasználva c) feladat eredménye könnyen kiszámolható:
--T(W) = T(R)/V(R,A) + T(R)/V(R,B) - T(R)/[V(R,A)*V(R,B)] = 2000+1000-2 = 2998
--
------------------------------------------------------------------------------------------------------------------------
--7. Feladat  (output_estimate.pptx 13-16. old.)
------------------------------------------------------------------------------------------------------------------------
--T(R) = 10000, T(S) = 4000, a két tábla közös oszlopa: A, ahol ugyanazok az értékek fordulnak elő.
--V(R,A) = 500, V(S,A) = 500.
--Számoljuk ki T(W)-t ha W a következő lekérdezés eredménye:
--a) W <-- SELECT * FROM R CROSS JOIN S;    -> T(W) = T(R)*T(S) = 40000000
--b) W <-- SELECT * FROM R NATURAL JOIN S;  -> T(W) = T(R)*T(S)/V(R,A) = 80000
--
--Megjegyzés: A fenti feladat azt illusztrálja, hogy mennyire költséges lehet egy lekérdezés végrehajtása,
--            ha köztes eredményként direkt szorzatot kell létrehozni, és esetleg temporálisan tárolni.
--
------------------------------------------------------------------------------------------------------------------------
--8. Feladat  (optimization.pptx a) 28-29., b) 32., c) 21. és 31. old.)
------------------------------------------------------------------------------------------------------------------------
--Tegyük fel, hogy a memóriánk 101 blokknyi (M=101), és van egy 1000000 soros R táblánk
--T(R) = 1000000, amelynek 10 sora fér el egy blokkban bf(R) = 10, valamint egy 60000 soros S táblánk,
--T(S) = 60000, amelynek 12 sora fér el egy blokkban bf(S) = 12.
--Mennyi a blokkolvasási és írási költsége (I/O költsége) egy egyenlőséges összekapcsolás műveletnek
--(WHERE R.A = S.A) az alábbi algoritmusok esetén:
--a) beágyazott ciklusú algoritmus (block-nested loop)
---> B(S)/(M-1)*B(R) + B(S)   =~ (5000/100)*100000 + 5000 = 5005000
---> B(R)/(M-1)*B(S) + B(R)   =~ 5100000 (ha felcseréljük a táblák sorrendjét a join műveletben)
--b) HASH alapú algoritmus (hash-join)
---> 3*[B(S)+B(R)]    =~ 315000
--c) RENDEZÉS alapú algoritmus (sort-merge join)
---> (Menetek száma)*[2*B(S)+2*B(R)] + B(S)+B(R) =~ 5*105000 = 525000
--   ahol a Menetek száma különböző lehet a két relációra, és a következő képlettel becsülhető:
--   log[B(R)/M] felső egészrésze (a logaritmus alapja M-1)
--
--Megjegyzés: hatalmas futásidő különbség lehet egy HASH-JOIN és egy NESTED-LOOP join között, és
--            sok esetben a lekérdezés szintaxisa dönti, el, hogy melyik használható.
------------------------------------------------------------------------------------------------------------------------
--9. Feladat  (optimization.pptx 30. old.)
------------------------------------------------------------------------------------------------------------------------
--Mennyi az I/O költsége az előző feladatbeli két tábla index alapú összekapcsolásának (index-join),
--ha R-re van indexünk (amit végig a memóriában tartunk, tehát az index olvasás költségét most nem vesszük figyelembe),
--R nem nyaláboltan (nem klaszterezetten) van tárolva és
--a) V(R,A) = 1000000    -> B(S) + T(S) * T(R)/V(R,A)   ~ 65000
--b) V,R,A) = 10000      -> B(S) + T(S) * T(R)/V(R,A)   ~ 6000500

--Megjegyzés: A fenti eredmények azt illusztrálják, hogy az indexek használata akkor hatékony,
--            ha kevés sor felel meg a feltételeknek, vagyis a tábla méretéhez képest kevés sort
--            kell beolvasnunk az index segítségével.
------------------------------------------------------------------------------------------------------------------------

SELECT distinct SEGMENT_NAME, BYTES FROM DBA_EXTENTS where SEGMENT_NAME =
    (SELECT CLUSTER_NAME FROM DBA_CLUSTERS WHERE OWNER='LKPETER' and CLUSTER_TYPE = 'INDEX');
------------------------------------------------------------------------------------------------------------------------
CREATE or replace function nt_tables return varchar2 is
    CURSOR curs1 IS select SEGMENT_NAME table_name from dba_extents where SEGMENT_NAME in (select distinct table_name from DBA_TAB_COLUMNS where DATA_TYPE = 'NUMBER' AND TABLE_NAME in
    (select distinct TABLE_NAME from dba_tables where owner = 'LKPETER' and CLUSTER_NAME is null)) group by SEGMENT_NAME having 2 > count(distinct FILE_ID) order by SEGMENT_NAME;
    rec curs1%ROWTYPE;
    ret VARCHAR2(20000);
BEGIN
  OPEN curs1;
  LOOP
    FETCH curs1 INTO rec;
    EXIT WHEN curs1%NOTFOUND;
    ret := ret || rec.table_name || ', ';
  END LOOP;
  CLOSE curs1;
  DBMS_OUTPUT.PUT_LINE(ret);
  return ret;
END;

select nt_tables() from dual;

select SEGMENT_NAME from dba_extents where SEGMENT_NAME in
    (select distinct table_name from DBA_TAB_COLUMNS where DATA_TYPE = 'NUMBER' AND TABLE_NAME in
        (select distinct TABLE_NAME from dba_tables where owner = 'LKPETER' and CLUSTER_NAME is null))
    group by SEGMENT_NAME having 2 > count(distinct FILE_ID)
order by SEGMENT_NAME;

------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE lt10 IS
COUNTER NUMBER;
BEGIN
    FOR RECORD IN (SELECT FILE_ID, BLOCK_ID, BLOCKS FROM DBA_EXTENTS WHERE OWNER='NIKOVITS' AND SEGMENT_NAME='CIKK' ORDER BY 1, 2, 3)
    LOOP
        FOR i in 1..RECORD.BLOCKS LOOP
            SELECT COUNT(*) INTO COUNTER FROM NIKOVITS.CIKK
            WHERE DBMS_ROWID.ROWID_RELATIVE_FNO(ROWID) = RECORD.FILE_ID
            AND DBMS_ROWID.ROWID_BLOCK_NUMBER(ROWID) = RECORD.BLOCK_ID + i - 1;
            IF 10 > COUNTER then
                DBMS_OUTPUT.PUT_LINE(RECORD.FILE_ID || ';' || TO_CHAR(RECORD.BLOCK_ID + i - 1) || ';' || COUNTER);
            end if;
        END LOOP;
    END LOOP;
END;

call lt10();
SELECT FILE_ID, BLOCK_ID, BLOCKS from dba_extents where SEGMENT_NAME = 'CIKK' and owner='NIKOVITS';