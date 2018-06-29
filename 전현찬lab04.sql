-- (2) 조인 종류 : OUTER JOIN
-- 실습3)
SELECT
    e.EMPNO
    ,e.ENAME
    ,e.MGR
    FROM emp e
    WHERE e.MGR IS NULL
;
/*
7839	KING	
9999	J_JUNE	
8888	J	
7777	J%JONES	
6666	JJ	
*/

-- 실습4)
SELECT
    e.EMPNO
    ,e.ENAME
    ,e.MGR
    ,e1.EMPNO
    ,e1.ENAME
    FROM emp e, emp e1
    WHERE e.MGR(+) = e1.EMPNO
;

-- 실습5)
SELECT
    e.JOB
    FROM emp e
    WHERE e.ENAME = 'JAMES'
;
SELECT
    e.EMPNO
    ,e.ENAME
    ,e.JOB
    FROM emp e
    WHERE e.JOB = (
        SELECT
            e.JOB
            FROM emp e
            WHERE e.ENAME = 'JAMES'
    )
;
/*
7369	SMITH	CLERK
7900	JAMES	CLERK
7934	MILLER	CLERK
9999	J_JUNE	CLERK
8888	J	CLERK
7777	J%JONES	CLERK
*/





-- 8. DDL
-- (1) 테이블 생성
-- 실습 1), 2)
CREATE TABLE CUSTOMER
(
    userid      VARCHAR2(10)
    ,name       VARCHAR2(10)
    ,birthyear  NUMBER(4)
    ,regdate    DATE
    ,address    VARCHAR2(20)
);
/*
USERID	VARCHAR2(10 BYTE)	Yes		1	
NAME	VARCHAR2(10 BYTE)	Yes		2	
BIRTHYEAR	NUMBER(4,0)	Yes		3	
REGDATE	DATE	Yes		4	
ADDRESS	VARCHAR2(20 BYTE)	Yes		5	
*/