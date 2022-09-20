

--trigger generálás példa
CREATE TABLE test1(col1 INTEGER PRIMARY KEY, col2 VARCHAR2(20));

CREATE SEQUENCE seq1 
MINVALUE 1 MAXVALUE 100 INCREMENT BY 5 START WITH 50 CYCLE;

CREATE OR REPLACE TRIGGER test1_bir -- before insert row
BEFORE INSERT ON test1 
FOR EACH ROW 
WHEN (new.col1 is null) 
BEGIN
  :new.col1 := seq1.nextval;
END;
/
BEGIN
 FOR i IN 1..14 LOOP 
  INSERT INTO test1 VALUES(null, 'trigger'||to_char(i,'FM09'));
 END LOOP;
 INSERT INTO test1 VALUES(seq1.currval + 1, 'sequence + 1'); 
 COMMIT;
END;
/
SELECT * FROM test1 ORDER BY col2