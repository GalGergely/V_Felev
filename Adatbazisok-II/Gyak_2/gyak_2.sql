--1.Adjuk meg az adatbázishoz tartozó adatfile-ok (és temporális fájlok) nevét és méretét méret szerint csökkenõ sorrendben. (név, méret)
SELECT file_name, bytes FROM dba_data_files
 union
SELECT file_name, bytes FROM dba_temp_files
ORDER BY bytes DESC;

--2.Adjuk meg, hogy milyen táblaterek vannak létrehozva az adatbazisban,
--az egyes táblaterek hány adatfájlbol állnak, és mekkora az összméretük.
--(tablater_nev, fajlok_szama, osszmeret)
--!!! Vigyázat, van temporális táblatér is.

--3.Mekkora az adatblokkok merete a USERS táblatéren?
select blocks from DBA_DATA_FILES where TABLESPACE_NAME = 'USERS';

--4.Van-e olyan táblatér, amelynek nincs DBA_DATA_FILES-beli adatfájlja?
--Ennek adatai hol tárolódnak? -> DBA_TEMP_FILES
SELECT tablespace_name FROM dba_tablespaces WHERE tablespace_name NOT IN
 (SELECT tablespace_name FROM dba_data_files);
SELECT file_name, tablespace_name FROM dba_temp_files;

--5.Melyik a legnagyobb méretû tábla szegmens az adatbázisban és hány extensbõl áll? 
--(tulajdonos, szegmens_név, darab)
--(A particionált táblákat most ne vegyük figyelembe.)
SELECT owner, segment_name, extents FROM dba_segments
WHERE segment_type='TABLE' 
ORDER BY bytes DESC 
FETCH FIRST 1 rows ONLY;

--6.Melyik a legnagyobb meretû index szegmens az adatbázisban és hány blokkból áll?
--(tulajdonos, szegmens_név, darab)
--(A particionált indexeket most ne vegyuk figyelembe.)
SELECT owner, segment_name, blocks FROM dba_segments
WHERE segment_type='INDEX' 
ORDER BY bytes DESC 
FETCH FIRST 1 rows ONLY;

--7.Adjuk meg adatfájlonkent, hogy az egyes adatfájlokban mennyi a foglalt hely osszesen. (fájlnév, fájl_méret, foglalt_hely)
select file_name, bytes, maxbytes from DBA_DATA_FILES;

--8.Melyik ket felhasznalo objektumai foglalnak osszesen a legtobb helyet az adatbazisban?
--Vagyis ki foglal a legtöbb helyet, és ki a második legtöbbet?
SELECT owner, SUM(bytes) FROM dba_segments GROUP BY owner ORDER BY 2 DESC
FETCH FIRST 2 ROWS ONLY;

--9.Hány extens van a 'users02.dbf' adatfájlban? Mekkora ezek összmérete? (darab, össz)
--Hány összefüggõ szabad terület van a 'users02.dbf' adatfájlban? Mekkora ezek összmérete? (darab, össz)
--Hány százalékban foglalt a 'users02.dbf' adatfájl?
SELECT count(*), sum(e.bytes) FROM dba_data_files f, dba_extents e WHERE file_name like '%/users02%' AND f.file_id=e.file_id;

SELECT count(*), sum(fr.bytes) FROM dba_data_files f, dba_free_space fr WHERE file_name LIKE '%/users02%' AND f.file_id=fr.file_id;

SELECT sum(e.bytes)/f.bytes FROM dba_data_files f, dba_extents e WHERE file_name LIKE '%/users02%' AND f.file_id=e.file_id GROUP BY f.bytes;

--10.Van-e a NIKOVITS felhasználónak olyan táblája, amelyik több adatfájlban is foglal helyet? (Aramis)
SELECT segment_name, count(distinct file_id) FROM dba_extents WHERE owner='NIKOVITS' AND segment_type='TABLE' GROUP BY segment_name HAVING count(distinct file_id) > 1;

--11.Válasszunk ki a fenti táblákból egyet (pl. tabla_123) és adjuk meg, hogy ez a tábla mely adatfájlokban foglal helyet.
select distinct FILE_ID from DBA_EXTENTS where SEGMENT_NAME='TABLA_123';   

--12.Melyik táblatéren van az ORAUSER felhasználó DOLGOZO táblája?
SELECT TABLESPACE_NAME FROM dba_tables WHERE owner='ORAUSER' AND table_name='DOLGOZO';

--13.Melyik táblatéren van a NIKOVITS felhasználó ELADASOK táblája? (Miért lesz null?) -> Mert ez egy úgynevezett partícionált tábla, aminek minden partíciója külön szegmenst alkot, 
--és ezek a szegmensek más-más táblatéren lehetnek.
select TABLESPACE_NAME  from DBA_TABLES where owner='NIKOVITS' and table_name='ELOADASOK';