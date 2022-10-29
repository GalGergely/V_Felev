--1.A NIKOVITS felhaszn�l� CIKK t�bl�ja h�ny blokkot foglal le az adatb�zisban? (blokksz�m)
--(Vagyis h�ny olyan blokk van, ami ennek a t�bl�nak a szegmens�hez tartozik �s �gy m�r m�s t�bl�hoz nem rendelhet� hozz�?)
SELECT * FROM dba_segments WHERE owner='NIKOVITS' AND segment_name='CIKK' AND segment_type='TABLE';

select dbms_rowid from nikovits.cikk;

--2.A NIKOVITS felhaszn�l� CIKK t�bl�j�nak adatai h�ny blokkban helyezkednek el? (blokksz�m)
--(Vagyis a t�bla sorai t�nylegesen h�ny blokkban vannak t�rolva?)
--!!! -> Ez a k�rd�s nem ugyanaz mint az el�z�, mert a t�bla blokkjai lehetnek �resek is.
SELECT DISTINCT dbms_rowid.rowid_relative_fno(ROWID) fajl,
                dbms_rowid.rowid_block_number(ROWID) blokk
FROM nikovits.cikk;

--3.Az egyes blokkokban h�ny sor van? (file_id, blokk_id, darab)
SELECT dbms_rowid.rowid_relative_fno(ROWID) fajl,
       dbms_rowid.rowid_block_number(ROWID) blokk, count(*)
FROM nikovits.cikk
GROUP BY dbms_rowid.rowid_relative_fno(ROWID), dbms_rowid.rowid_block_number(ROWID);

--4.�llap�tsuk meg, hogy a NIKOVITS.ELADASOK t�bl�nak a k�vetkez� adatokkal azonos�tott sora
--(szla_szam=100) melyik adatf�jlban van, azon bel�l melyik blokkban, �s a blokkon bel�l h�nyadik a sor?
--(file_n�v, blokk_id, sorsz�m)
SELECT  dbms_rowid.rowid_object(ROWID) adatobj, 
        dbms_rowid.rowid_relative_fno(ROWID) fajl,
        dbms_rowid.rowid_block_number(ROWID) blokk,
        dbms_rowid.rowid_row_number(ROWID) sor
FROM nikovits.eladasok 
WHERE szla_szam=100;

--5.�rjunk meg egy PLSQL proced�r�t, amelyik ki�rja, hogy a NIKOVITS.TABLA_123 t�bl�nak melyik 
--adatblokkj�ban h�ny sor van. Az output form�tuma soronk�nt: FILE_ID; BLOKK_ID -> darab
--P�lda az output egy sor�ra: 2;563->306
--Vigy�zat!!! Azokat az adatblokkokat is ki kell �rni, amelyekben a sorok sz�ma 0, de a t�bla
--szegmens�hez tartoznak. Az output FILE_ID majd azon bel�l BLOKK_ID szerint legyen rendezett.
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