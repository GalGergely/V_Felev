CREATE OR REPLACE PROCEDURE newest_table(p_user VARCHAR2) IS 
table_name dba_objects.object_name%TYPE;
created_date dba_objects.created%TYPE;
table_size dba_segments.bytes%TYPE;
BEGIN
select object_name,created into table_name,created_date from dba_objects where owner= upper(p_user) and object_type='TABLE'order by created desc fetch first 1 rows only;
select distinct bytes into table_size from dba_segments where segment_name=table_name;
dbms_output.put_line('table_name: '||table_name||' Size: '||table_size||' bytes Created: '||to_char(created_date,'yyyy.mm.dd.hh24:mi'));
END;
\

SET SERVEROUTPUT ON
EXECUTE newest_table('NIKOVITS');

EXECUTE check_plsql('newest_table(''nikovits'')');


select * from DBA_TABLES where owner = 'NIKOVITS';
select * from dba_objects where owner ='NIKOVITS' order by created;



--5.Írjunk meg egy PLSQL procedúrát, amelyik kiírja, hogy a NIKOVITS.TABLA_123 táblának melyik 
--adatblokkjában hány sor van. Az output formátuma soronként: FILE_ID; BLOKK_ID -> darab
--Példa az output egy sorára: 2;563->306
--Vigyázat!!! Azokat az adatblokkokat is ki kell írni, amelyekben a sorok száma 0, de a tábla
--szegmenséhez tartoznak. Az output FILE_ID majd azon belül BLOKK_ID szerint legyen rendezett.
select * from DBA_SEGMENTS,DBA_TABLES where DBA_SEGMENTS.SEGMENT_NAME=DBA_TABLES.TABLE_NAME;
select DBA_EXTENTS.FILE_ID,DBA_EXTENTS.BLOCK_ID,DBA_TABLES.NUM_ROWS from DBA_EXTENTS 
join DBA_TABLES on DBA_EXTENTS.SEGMENT_NAME=DBA_TABLES.TABLE_NAME where DBA_EXTENTS.SEGMENT_NAME='TABLA_123' and DBA_TABLES.owner='NIKOVITS';
select * from NIKOVITS.TABLA_123;
select * from DBA_TABLES where TABLE_NAME='TABLA_123' and owner='NIKOVITS';
select * from DBA_DATA_FILES;

CREATE OR REPLACE PROCEDURE num_of_rows IS 
file_id DBA_EXTENTS.FILE_ID%TYPE;
num_rows DBA_TABLES.NUM_ROWS%TYPE;
block_id DBA_EXTENTS.block_id%TYPE;
BEGIN
select DBA_EXTENTS.FILE_ID,DBA_EXTENTS.BLOCK_ID,DBA_TABLES.NUM_ROWS into file_id,block_id,num_rows from DBA_EXTENTS 
join DBA_TABLES on DBA_EXTENTS.SEGMENT_NAME=DBA_TABLES.TABLE_NAME where DBA_EXTENTS.SEGMENT_NAME='TABLA_123' and DBA_TABLES.owner='NIKOVITS';
dbms_output.put_line(file_id||';'||block_id||' -> '||num_rows);
END;
/

CREATE OR REPLACE PROCEDURE num_of_rows IS 
begin
 DECLARE
        CURSOR CURS1 (OA NUMBER) IS select DBA_EXTENTS.FILE_ID,DBA_EXTENTS.BLOCK_ID,DBA_TABLES.NUM_ROWS from DBA_EXTENTS join DBA_TABLES on DBA_EXTENTS.SEGMENT_NAME=DBA_TABLES.TABLE_NAME where DBA_EXTENTS.SEGMENT_NAME='TABLA_123' and DBA_TABLES.owner='NIKOVITS' order by DBA_EXTENTS.FILE_ID,DBA_EXTENTS.BLOCK_ID;
        REC CURS1%ROWTYPE;
BEGIN
 OPEN CURS1(1);
        LOOP
            FETCH CURS1 INTO REC;
            EXIT WHEN CURS1%NOTFOUND;
            dbms_output.put_line(rec.FILE_ID||';'||rec.BLOCK_ID||' -> '||rec.NUM_ROWS);
        END LOOP;
CLOSE CURS1;
END;
end;
/

SET SERVEROUTPUT ON
EXECUTE num_of_rows();

EXECUTE check_plsql('num_of_rows()');




create or replace PROCEDURE newest_table(p_user VARCHAR2) IS
    table_name  dba_objects.object_name%TYPE;
    createdDate  dba_objects.created%TYPE;
    tableSize dba_segments.bytes%TYPE;
BEGIN
    select object_name,created into table_name,createdDate from dba_objects 
    where owner = upper(p_user) and object_type='TABLE' order by created desc
        fetch FIRST 1 rows only;
    select bytes into tableSize from dba_segments where segment_name = table_name;
    dbms_output.put_line('Table_name: '|| table_name || '    Size: ' || tableSize || ' bytes    Created: '|| to_char(createdDate,'yyyy.mm.dd.hh24:mi'));
END;