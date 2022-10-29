--1.A NIKOVITS felhasználó CIKK táblája hány blokkot foglal le az adatbázisban? (blokkszám)
--(Vagyis hány olyan blokk van, ami ennek a táblának a szegmenséhez tartozik és így már más táblához nem rendelhetõ hozzá?)
SELECT * FROM dba_segments WHERE owner='NIKOVITS' AND segment_name='CIKK' AND segment_type='TABLE';

select dbms_rowid from nikovits.cikk;

--2.A NIKOVITS felhasználó CIKK táblájának adatai hány blokkban helyezkednek el? (blokkszám)
--(Vagyis a tábla sorai ténylegesen hány blokkban vannak tárolva?)
--!!! -> Ez a kérdés nem ugyanaz mint az elõzõ, mert a tábla blokkjai lehetnek üresek is.
SELECT DISTINCT dbms_rowid.rowid_relative_fno(ROWID) fajl,
                dbms_rowid.rowid_block_number(ROWID) blokk
FROM nikovits.cikk;

--3.Az egyes blokkokban hány sor van? (file_id, blokk_id, darab)
SELECT dbms_rowid.rowid_relative_fno(ROWID) fajl,
       dbms_rowid.rowid_block_number(ROWID) blokk, count(*)
FROM nikovits.cikk
GROUP BY dbms_rowid.rowid_relative_fno(ROWID), dbms_rowid.rowid_block_number(ROWID);

--4.Állapítsuk meg, hogy a NIKOVITS.ELADASOK táblának a következõ adatokkal azonosított sora
--(szla_szam=100) melyik adatfájlban van, azon belül melyik blokkban, és a blokkon belül hányadik a sor?
--(file_név, blokk_id, sorszám)
SELECT  dbms_rowid.rowid_object(ROWID) adatobj, 
        dbms_rowid.rowid_relative_fno(ROWID) fajl,
        dbms_rowid.rowid_block_number(ROWID) blokk,
        dbms_rowid.rowid_row_number(ROWID) sor
FROM nikovits.eladasok 
WHERE szla_szam=100;

--5.Írjunk meg egy PLSQL procedúrát, amelyik kiírja, hogy a NIKOVITS.TABLA_123 táblának melyik 
--adatblokkjában hány sor van. Az output formátuma soronként: FILE_ID; BLOKK_ID -> darab
--Példa az output egy sorára: 2;563->306
--Vigyázat!!! Azokat az adatblokkokat is ki kell írni, amelyekben a sorok száma 0, de a tábla
--szegmenséhez tartoznak. Az output FILE_ID majd azon belül BLOKK_ID szerint legyen rendezett.
create or replace PROCEDURE num_of_rows IS 
    CURSOR curs1 IS select dbms_rowid.rowid_RELATIVE_FNO(ROWID) as falj, dbms_rowid.rowid_block_number(ROWID) blokk, count(dbms_rowid.rowid_row_number(ROWID)) sor
                 from nikovits.tabla_123
                 group by dbms_rowid.rowid_RELATIVE_FNO(ROWID),dbms_rowid.rowid_block_number(ROWID) order by dbms_rowid.rowid_RELATIVE_FNO(ROWID), dbms_rowid.rowid_block_number(ROWID);
    CURSOR curs2 IS select file_id falj,block_id blokk,blocks blokkszam from dba_extents where SEGMENT_NAME = 'TABLA_123' and owner = 'NIKOVITS' and segment_type = 'TABLE';
    rec1 curs1%ROWTYPE;
    rec2 curs2%ROWTYPE;
    helper integer := 0;
begin
     open curs1;
     FETCH curs1 INTO rec1;
     open curs2;
        loop
            FETCH curs2 INTO rec2;
            exit WHEN curs2%NOTFOUND;
            if rec2.blokk = rec1.blokk
            then
                dbms_output.put_line(rec1.falj||';'||rec1.blokk||'->'||rec1.sor);
            else
                for i in 0..rec2.blokkszam-1 
                loop
                   helper := rec2.blokk + i;
                   if rec1.blokk = helper
                   then
                       dbms_output.put_line(rec1.falj||';'||rec1.blokk||'->'||rec1.sor);
                       FETCH curs1 INTO rec1;
                   else
                       dbms_output.put_line(rec2.falj||';'||helper||'->'||0);
                   end if;
                end loop;
            end if;
        end loop;
end;
/