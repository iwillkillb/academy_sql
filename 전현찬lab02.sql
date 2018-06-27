-- (6) 연산자
-- 실습 23)
SELECT *
    FROM emp e
    WHERE e.SAL BETWEEN 2500 AND 3000
;

-- 실습 24)
SELECT *
    FROM emp e
    WHERE e.COMM IS NULL
;

-- 실습 25)
SELECT *
    FROM emp e
    WHERE e.COMM IS NOT NULL
;

-- 실습 26)
SELECT 
    e.EMPNO as "사번"
    , e.ENAME || '의 월급은 $' || e.SAL || ' 입니다.' as "월급여"
    FROM emp e
;


-- 6. 함수

-- 실습 1)
SELECT INITCAP(e.ENAME) as "Result"
    FROM emp e
;
/*
Smith
Allen
Ward
Jones
Martin
Blake
Clark
King
Turner
James
Ford
Miller
J_June
J
J%Jones
*/

-- 실습 2)
SELECT LOWER(e.ENAME) as "Result"
    FROM emp e
;
/*
smith
allen
ward
jones
martin
blake
clark
king
turner
james
ford
miller
j_june
j
j%jones
*/

-- 실습 3)
SELECT UPPER(e.ENAME) as "Result"
    FROM emp e
;
/*
SMITH
ALLEN
WARD
JONES
MARTIN
BLAKE
CLARK
KING
TURNER
JAMES
FORD
MILLER
J_JUNE
J
J%JONES
*/

-- 실습 4)
SELECT 
    LENGTH('korea') as "Length"
    ,LENGTHB('korea') as "Length Byte"
    FROM dual
;   -- 결과 : 5, 5

-- 실습 5)
SELECT 
    LENGTH('전현찬') as "Length"
    ,LENGTHB('전현찬') as "Length Byte"
    FROM dual
;   -- 결과 : 3, 9

-- 실습 6)
SELECT 
    CONCAT('SQL','배우기') as "Result"
    FROM dual
;   -- 결과 : SQL배우기

-- 실습 7)
SELECT 
    SUBSTR('SQL 배우기',5,2) as "Result"
    FROM dual
;   -- 결과 : 배우

-- 실습 8)
SELECT 
    LPAD('SQL',7,'$') as "Result"
    FROM dual
;   -- 결과 : $$$$SQL

-- 실습 9)
SELECT 
    RPAD('SQL',7,'$') as "Result"
    FROM dual
;   -- 결과 : SQL$$$$

-- 실습 10)
SELECT 
    LTRIM('     SQL 배우기   ') as "Result"
    FROM dual
;   -- 결과 : 'SQL 배우기   '

-- 실습 11)
SELECT 
    RTRIM('     SQL 배우기   ') as "Result"
    FROM dual
;   -- 결과 : '     SQL 배우기'

-- 실습 12)
SELECT 
    TRIM('     SQL 배우기   ') as "Result"
    FROM dual
;   -- 결과 : 'SQL 배우기'

-- 실습 13)
SELECT
    e.EMPNO
    ,e.ENAME
    ,NVL(e.COMM, 0) as "COMM"
    FROM emp e
;
/*
7369	SMITH	0
7499	ALLEN	300
7521	WARD	500
7566	JONES	0
7654	MARTIN	1400
7698	BLAKE	0
7782	CLARK	0
7839	KING	0
7844	TURNER	0
7900	JAMES	0
7902	FORD	0
7934	MILLER	0
9999	J_JUNE	0
8888	J	    0
7777	J%JONES	0
*/

-- 실습 14)
SELECT
    e.EMPNO
    ,e.ENAME
    ,NVL2(e.COMM, e.SAL + e.COMM, 0) as "COMM"
    FROM emp e
;
/*
7369	SMITH	0
7499	ALLEN	1900
7521	WARD	1750
7566	JONES	0
7654	MARTIN	2650
7698	BLAKE	0
7782	CLARK	0
7839	KING	0
7844	TURNER	1500
7900	JAMES	0
7902	FORD	0
7934	MILLER	0
9999	J_JUNE	0
8888	J	    0
7777	J%JONES	0
*/

-- 실습 15)
SELECT
    e.EMPNO as "사원번호"
    ,e.ENAME as "이름"
    ,e.SAL as "급여"
    ,TO_CHAR(DECODE(e.JOB
        ,'CLERK', 300
        ,'SALESMAN', 450
        ,'MANAGER', 600
        ,'ANALYST', 800
        ,'PRESIDENT', 1000
    ), '$9,999') as "자기 계발비"
    FROM emp e
;
/*
7369	SMITH	800	       $300
7499	ALLEN	1600	   $450
7521	WARD	1250	   $450
7566	JONES	2975	   $600
7654	MARTIN	1250	   $450
7698	BLAKE	2850	   $600
7782	CLARK	2450	   $600
7839	KING	5000	 $1,000
7844	TURNER	1500	   $450
7900	JAMES	950	       $300
7902	FORD	3000	   $800
7934	MILLER	1300	   $300
9999	J_JUNE	500	       $300
8888	J	    400	       $300
7777	J%JONES	300	       $300
*/