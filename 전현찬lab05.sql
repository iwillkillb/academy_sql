-- 실습1)

INSERT INTO customer
VALUES ('C001', '김수현', 1988, sysdate, '경기');
INSERT INTO customer
VALUES ('C002', '이효리', 1979, sysdate, '제주');
INSERT INTO customer
VALUES ('C003', '원빈', 1977, sysdate, '강원');
/*
C001	김수현	1988	18/07/02	경기
C002	이효리	1979	18/07/02	제주
C003	원빈	1977	18/07/02	강원
*/

-- 실습2)
UPDATE customer c
    SET c.NAME = '차태현'
        ,c.BIRTHYEAR = 1976
    WHERE c.USERID = 'C001'
;
/*
C001	차태현	1976	18/07/02	경기
C002	이효리	1979	18/07/02	제주
C003	원빈	1977	18/07/02	강원
*/

-- 실습3)
UPDATE customer c
    SET c.ADDRESS = '서울'
;
/*
C001	차태현	1976	18/07/02	서울
C002	이효리	1979	18/07/02	서울
C003	원빈	1977	18/07/02	서울
*/

-- 실습4)
DELETE customer c
    WHERE c.USERID = 'C003'
; -- 1개 행 이(가) 삭제되었습니다.
/*
C001	차태현	1976	18/07/02	서울
C002	이효리	1979	18/07/02	서울
*/

-- 실습5)
DELETE customer c; -- 2개 행 이(가) 삭제되었습니다.

-- 실습6)
TRUNCATE TABLE customer; -- Table CUSTOMER이(가) 잘렸습니다.




-- 11. 시퀀스와 인덱스, 기타 객체
-- (1) SEQUENCE
-- 실습1)
CREATE SEQUENCE "seq_cust_userid"
    START WITH 1
    MAXVALUE 99
    NOCYCLE
; -- Sequence "seq_cust_userid"이(가) 생성되었습니다.

-- 실습2)
SELECT
     s.SEQUENCE_NAME
    ,s.MIN_VALUE
    ,s.MAX_VALUE
    ,s.CYCLE_FLAG
    FROM user_sequences s
; -- seq_cust_userid	1	99	N

-- 실습3)
CREATE INDEX "idx_cust_userid"
ON customer (userid)
; -- Index "idx_cust_userid"이(가) 생성되었습니다.




-- (4) Anonymous Procedure
-- 실습1)
BEGIN
    DBMS_OUTPUT.put_line('Hello, PL/SQL World!');
END;

-- 실습2)
DECLARE
    hello VARCHAR2(10);
    world VARCHAR2(10);
BEGIN
    hello := 'Hello, ';
    world := ' World!';
    DBMS_OUTPUT.put_line(hello || 'PL/SQL' || world);
END;
/

/*
Hello, PL/SQL World!
Hello, PL/SQL World!


PL/SQL 프로시저가 성공적으로 완료되었습니다.

*/

-- 실습3)
CREATE TABLE "log_table" (
    userid      VARCHAR2(20),
    log_date    DATE
);

CREATE OR REPLACE PROCEDURE log_execution
IS
    v_userid VARCHAR2(20) := 'myid';
BEGIN
    INSERT INTO "log_table" VALUES(v_userid, sysdate);
END;
/

EXECUTE log_execution;

-- 실습4)
CREATE OR REPLACE PROCEDURE log_execution
(   v_log_user      IN VARCHAR2
,   v_log_date      OUT DATE)
IS
BEGIN
    INSERT INTO "log_table" VALUES(v_log_user, sysdate);
    v_log_date := sysdate;
END log_execution;
/
-- Procedure LOG_EXECUTION이(가) 컴파일되었습니다.

-- 실습5)
CREATE OR REPLACE PROCEDURE chk_sal_per_month
(   v_sal       IN VARCHAR2
,   v_sal_month OUT VARCHAR2)
IS
BEGIN
    v_sal_month := v_sal / 12;
    DBMS_OUTPUT.PUT_LINE(v_sal || '에서 12를 나누면 ' || v_sal_month);
END chk_sal_per_month;
/
-- Procedure CHK_SAL_PER_MONTH이(가) 컴파일되었습니다.

VAR v_month NUMBER;
EXECUTE chk_sal_per_month(5000, :v_month);
PRINT v_month;