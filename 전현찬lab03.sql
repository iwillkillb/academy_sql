-- 실습15)의 답
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

-- 실습16)
SELECT
    e.EMPNO
    ,e.ENAME
    ,e.SAL
    ,TO_CHAR(CASE e.JOB
        WHEN 'CLERK' THEN 300
        WHEN 'SALESMAN' THEN 450
        WHEN 'MANAGER' THEN 600
        WHEN 'ANALYST' THEN 800
        WHEN 'PRESIDENT' THEN 1000
    END, '$9,999') as "자기 계발비"
    FROM emp e
;
/*
7369	SMITH	800	   $300
7499	ALLEN	1600	   $450
7521	WARD	1250	   $450
7566	JONES	2975	   $600
7654	MARTIN	1250	   $450
7698	BLAKE	2850	   $600
7782	CLARK	2450	   $600
7839	KING	5000	 $1,000
7844	TURNER	1500	   $450
7900	JAMES	950	   $300
7902	FORD	3000	   $800
7934	MILLER	1300	   $300
9999	J_JUNE	500	   $300
8888	J	400	   $300
7777	J%JONES	300	   $300
6666	JJ	2800	
*/

-- 실습17)
SELECT
    e.EMPNO
    ,e.ENAME
    ,e.SAL
    ,TO_CHAR(CASE
        WHEN e.JOB = 'CLERK' THEN 300
        WHEN e.JOB = 'SALESMAN' THEN 450
        WHEN e.JOB = 'MANAGER' THEN 600
        WHEN e.JOB = 'ANALYST' THEN 800
        WHEN e.JOB = 'PRESIDENT' THEN 1000
    END, '$9,999') as "자기 계발비"
    FROM emp e
;
/*
7369	SMITH	800	   $300
7499	ALLEN	1600	   $450
7521	WARD	1250	   $450
7566	JONES	2975	   $600
7654	MARTIN	1250	   $450
7698	BLAKE	2850	   $600
7782	CLARK	2450	   $600
7839	KING	5000	 $1,000
7844	TURNER	1500	   $450
7900	JAMES	950	   $300
7902	FORD	3000	   $800
7934	MILLER	1300	   $300
9999	J_JUNE	500	   $300
8888	J	400	   $300
7777	J%JONES	300	   $300
6666	JJ	2800	
*/

-- 실습18)
SELECT COUNT(*)
    FROM emp e
;   -- 결과 : 16

-- 실습19)
SELECT COUNT(DISTINCT e.JOB)
    FROM emp e
;   -- 결과 : 5

-- 실습20)
SELECT COUNT(e.COMM) as "커미션 받는 직원"
    FROM emp e
    WHERE e.COMM > 0
;   -- 결과 : 3

-- 실습21)
SELECT SUM(e.SAL) as "급여 총합"
    FROM emp e
;   -- 결과 : 28925

-- 실습22)
SELECT AVG(e.SAL) as "급여 평균"
    FROM emp e
;   -- 결과 : 1807.8125

-- 실습23)
SELECT
    SUM(e.SAL) as "급여 총합"   -- 28925
    ,AVG(e.SAL) as "급여 평균"  -- 1807.8125
    ,MAX(e.SAL) as "급여 최대"  -- 5000
    ,MIN(e.SAL) as "급여 최소"  -- 300
    FROM emp e
;   -- 결과 : 28925

-- 실습24)
SELECT
    STDDEV(e.SAL) as "급여 표준편차"  -- 1269.964525423184146877743892556640279933
    ,VARIANCE(e.SAL) as "급여 분산" -- 1612809.89583333333333333333333333333333
    FROM emp e
;

-- 실습25)
SELECT
    STDDEV(e.SAL) as "급여 표준편차"  -- 177.951304200521853513525399426595177105
    ,VARIANCE(e.SAL) as "급여 분산" -- 31666.6666666666666666666666666666666667
    FROM emp e
    WHERE e.JOB = 'SALESMAN'
;

-- 실습26)
SELECT
    e.DEPTNO as "부서 번호"
    ,SUM(DECODE(e.JOB,
        'CLERK', 300,
        'SALESMAN', 450,
        'MANAGER', 600,
        'ANALYST', 800,
        'PRESIDENT', 1000,
        0)
    ) as "자기계발비 총합"
    FROM emp e
    GROUP BY e.DEPTNO
    ORDER BY e.DEPTNO
;
/*
10	1900
20	1700
30	2700
	900
*/

-- 실습27)
SELECT
    e.DEPTNO as "부서 번호"
    , e.JOB as "직책"
    ,SUM(DECODE(e.JOB,
        'CLERK', 300,
        'SALESMAN', 450,
        'MANAGER', 600,
        'ANALYST', 800,
        'PRESIDENT', 1000,
        0)
    ) as "자기계발비 총합"
    FROM emp e
    GROUP BY e.DEPTNO, e.JOB
    ORDER BY e.DEPTNO, e.JOB DESC
;
/*
10	PRESIDENT	1000
10	MANAGER	600
10	CLERK	300
20	MANAGER	600
20	CLERK	300
20	ANALYST	800
30	SALESMAN	1800
30	MANAGER	600
30	CLERK	300
		0
	CLERK	900
*/




-- 7. 조인과 서브쿼리
-- (2) 조인종류

-- 실습1)
SELECT e.ENAME, d.DNAME
    FROM emp e NATURAL JOIN dept d
;

-- 실습2)
SELECT e.ENAME, d.DNAME
    FROM emp e JOIN dept d USING (DEPTNO)
;

/*
KING	ACCOUNTING
CLARK	ACCOUNTING
MILLER	ACCOUNTING
FORD	RESEARCH
SMITH	RESEARCH
JONES	RESEARCH
JAMES	SALES
TURNER	SALES
MARTIN	SALES
WARD	SALES
ALLEN	SALES
BLAKE	SALES
*/