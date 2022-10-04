--1.Adjuk meg az adatb�zishoz tartoz� adatfile-ok (�s tempor�lis f�jlok) nev�t �s m�ret�t m�ret szerint cs�kken� sorrendben. (n�v, m�ret)
SELECT file_name, bytes FROM dba_data_files
 union
SELECT file_name, bytes FROM dba_temp_files
ORDER BY bytes DESC;

--2.Adjuk meg, hogy milyen t�blaterek vannak l�trehozva az adatbazisban,
--az egyes t�blaterek h�ny adatf�jlbol �llnak, �s mekkora az �sszm�ret�k.
--(tablater_nev, fajlok_szama, osszmeret)
--!!! Vigy�zat, van tempor�lis t�blat�r is.

--3.Mekkora az adatblokkok merete a USERS t�blat�ren?
select blocks from DBA_DATA_FILES where TABLESPACE_NAME = 'USERS';

--4.Van-e olyan t�blat�r, amelynek nincs DBA_DATA_FILES-beli adatf�jlja?
--Ennek adatai hol t�rol�dnak? -> DBA_TEMP_FILES
SELECT tablespace_name FROM dba_tablespaces WHERE tablespace_name NOT IN
 (SELECT tablespace_name FROM dba_data_files);
SELECT file_name, tablespace_name FROM dba_temp_files;

--5.Melyik a legnagyobb m�ret� t�bla szegmens az adatb�zisban �s h�ny extensb�l �ll? 
--(tulajdonos, szegmens_n�v, darab)
--(A particion�lt t�bl�kat most ne vegy�k figyelembe.)
SELECT owner, segment_name, extents FROM dba_segments
WHERE segment_type='TABLE' 
ORDER BY bytes DESC 
FETCH FIRST 1 rows ONLY;

--6.Melyik a legnagyobb meret� index szegmens az adatb�zisban �s h�ny blokkb�l �ll?
--(tulajdonos, szegmens_n�v, darab)
--(A particion�lt indexeket most ne vegyuk figyelembe.)
SELECT owner, segment_name, blocks FROM dba_segments
WHERE segment_type='INDEX' 
ORDER BY bytes DESC 
FETCH FIRST 1 rows ONLY;

--7.Adjuk meg adatf�jlonkent, hogy az egyes adatf�jlokban mennyi a foglalt hely osszesen. (f�jln�v, f�jl_m�ret, foglalt_hely)
select file_name, bytes, maxbytes from DBA_DATA_FILES;

--8.Melyik ket felhasznalo objektumai foglalnak osszesen a legtobb helyet az adatbazisban?
--Vagyis ki foglal a legt�bb helyet, �s ki a m�sodik legt�bbet?
SELECT owner, SUM(bytes) FROM dba_segments GROUP BY owner ORDER BY 2 DESC
FETCH FIRST 2 ROWS ONLY;

--9.H�ny extens van a 'users02.dbf' adatf�jlban? Mekkora ezek �sszm�rete? (darab, �ssz)
--H�ny �sszef�gg� szabad ter�let van a 'users02.dbf' adatf�jlban? Mekkora ezek �sszm�rete? (darab, �ssz)
--H�ny sz�zal�kban foglalt a 'users02.dbf' adatf�jl?
SELECT count(*), sum(e.bytes) FROM dba_data_files f, dba_extents e WHERE file_name like '%/users02%' AND f.file_id=e.file_id;

SELECT count(*), sum(fr.bytes) FROM dba_data_files f, dba_free_space fr WHERE file_name LIKE '%/users02%' AND f.file_id=fr.file_id;

SELECT sum(e.bytes)/f.bytes FROM dba_data_files f, dba_extents e WHERE file_name LIKE '%/users02%' AND f.file_id=e.file_id GROUP BY f.bytes;

--10.Van-e a NIKOVITS felhaszn�l�nak olyan t�bl�ja, amelyik t�bb adatf�jlban is foglal helyet? (Aramis)
SELECT segment_name, count(distinct file_id) FROM dba_extents WHERE owner='NIKOVITS' AND segment_type='TABLE' GROUP BY segment_name HAVING count(distinct file_id) > 1;

--11.V�lasszunk ki a fenti t�bl�kb�l egyet (pl. tabla_123) �s adjuk meg, hogy ez a t�bla mely adatf�jlokban foglal helyet.
select distinct FILE_ID from DBA_EXTENTS where SEGMENT_NAME='TABLA_123';   

--12.Melyik t�blat�ren van az ORAUSER felhaszn�l� DOLGOZO t�bl�ja?
SELECT TABLESPACE_NAME FROM dba_tables WHERE owner='ORAUSER' AND table_name='DOLGOZO';

--13.Melyik t�blat�ren van a NIKOVITS felhaszn�l� ELADASOK t�bl�ja? (Mi�rt lesz null?) -> Mert ez egy �gynevezett part�cion�lt t�bla, aminek minden part�ci�ja k�l�n szegmenst alkot, 
--�s ezek a szegmensek m�s-m�s t�blat�ren lehetnek.
select TABLESPACE_NAME  from DBA_TABLES where owner='NIKOVITS' and table_name='ELOADASOK';