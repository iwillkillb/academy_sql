-- sql day01
---------------------------------------------------------------------
-- 기본 실행 환경 설정
---------------------------------------------------------------------
-- 1. SCOTT 계정 활성화 : sys 계정으로 접속하여 스크립트 실행
@C:\oraclexe\app\oracle\product\11.2.0\server\rdbms\admin\scott.sql
-- 2. 접속 유저 확인 명령
SHOW USER
-- 3. HR 계정 활성화 : sys 계정으로 접속
-- 다른 사용자 확장 후 HR 계정의 계정잠김, 비밀번호 만료상태
-- 계정에 존재하는 테이블 목록 조회
SELECT *
    FROM tab
;
---------------------------------------------------------------------
-- SCOTT 계정의 데이터 구조

-- (1) EMP 테이블 내용 조회 : 사원 테이블
SELECT *
	FROM emp
;
/*
7369	SMITH	CLERK	    7902	80/12/17	800		20
7499	ALLEN	SALESMAN	7698	81/02/20	1600	300	    30
7521	WARD	SALESMAN	7698	81/02/22	1250	500	    30
7566	JONES	MANAGER	    7839	81/04/02	2975		    20
7654	MARTIN	SALESMAN	7698	81/09/28	1250	1400	30
7698	BLAKE	MANAGER	    7839	81/05/01	2850		    30
7782	CLARK	MANAGER	    7839	81/06/09	2450		    10
7839	KING	PRESIDENT   		81/11/17	5000		    10
7844	TURNER	SALESMAN	7698	81/09/08	1500	0	    30
7900	JAMES	CLERK	    7698	81/12/03	950		30
7902	FORD	ANALYST	    7566	81/12/03	3000		    20
7934	MILLER	CLERK	    7782	82/01/23	1300		    10
*/

-- (2) DEPT 테이블 내용 조회 : 부서 테이블
SELECT *
	FROM dept
;
/*
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	    CHICAGO
40	OPERATIONS	BOSTON
*/

-- (3) SALGRADE 테이블 내용 조회 : 급여등급 테이블
SELECT *
	FROM salgrade
;
/*
1	700	    1200
2	1201	1400
3	1401	2000
4	2001	3000
5	3001	9999
*/

---------------------------------------------------------------------

-- 01. DQL

-- (1) SELECT 구문
-- 1) emp 테이블에서 사번/이름/직무를 조회
SELECT e.EMPNO
    ,  e.ENAME
    ,  e.JOB
    FROM emp e -- e는 alias(별칭)
;
/*
7369	SMITH	CLERK
7499	ALLEN	SALESMAN
7521	WARD	SALESMAN
7566	JONES	MANAGER
7654	MARTIN	SALESMAN
7698	BLAKE	MANAGER
7782	CLARK	MANAGER
7839	KING	PRESIDENT
7844	TURNER	SALESMAN
7900	JAMES	CLERK
7902	FORD	ANALYST
7934	MILLER	CLERK
*/

-- 2) emp 테이블에서 직무만 조회
SELECT e.JOB
    FROM emp e -- e는 alias(별칭)
;
/*
CLERK
SALESMAN
SALESMAN
MANAGER
SALESMAN
MANAGER
MANAGER
PRESIDENT
SALESMAN
CLERK
ANALYST
CLERK
*/

-- (2) DISTINCT 구문 : SELECT문 사용시 중복 배제하여 조회
-- 3) emp 테이블에서 job 컬럼의 중복을 배제하여 조회
SELECT DISTINCT e.JOB
    FROM emp e -- e는 alias(별칭)
;
/*
CLERK
SALESMAN
PRESIDENT
MANAGER
ANALYST
*/

-- * SQL SELECT 구문의 작동 원리 : 테이블의 한 행을 기본 단위로 실행한다. 테이블의 행의 개수만큼 반복실행.
SELECT 'Hello, SQL~'
    FROM emp e
;

-- 4) emp 테이블에서 job, deptno에 대해 중복 제거 조회
SELECT DISTINCT 
    e.job
    ,e.DEPTNO
    FROM emp e
;
/*
MANAGER	    20
PRESIDENT	10
CLERK	    10
SALESMAN	30
ANALYST	    20
MANAGER	    30
MANAGER	    10
CLERK	    30
CLERK	    20
*/

-- (3) ORDER BY 절 : 정렬
-- 5) emp 테이블에서 job을 중복배제, 오름차순으로 정렬하여 조회, 정렬기준 안 쓰면 오름차순이 기본.
SELECT DISTINCT
    e.JOB
    FROM emp e
    ORDER BY e.JOB  -- ASC 써도 되고 안써도 된다. = 오름차순
;
-- 6) emp 테이블에서 job을 중복배제, 내림차순으로 정렬하여 조회
SELECT DISTINCT
    e.JOB
    FROM emp e
    ORDER BY e.JOB DESC
;
/*
정렬 X...
CLERK
SALESMAN
PRESIDENT
MANAGER
ANALYST

오름차순...
ANALYST
CLERK
MANAGER
PRESIDENT
SALESMAN

내림차순...
SALESMAN
PRESIDENT
MANAGER
CLERK
ANALYST
*/

-- 7) emp 테이블에서 comm을 가장 많이 받는 순서대로 출력
-- 사번, 이름, 직무, 입사일, 커미션 순으로 조회
SELECT e.EMPNO
    , e.ENAME
    , e.JOB
    , e.HIREDATE
    , e.COMM
    FROM emp e
    ORDER BY e.COMM DESC
;
/* COMM 기준으로, null이 큰 수보다도 먼저 나온다.
7369	SMITH	CLERK	    80/12/17	
7698	BLAKE	MANAGER	    81/05/01	
7902	FORD	ANALYST	    81/12/03	
7900	JAMES	CLERK	    81/12/03	
7839	KING	PRESIDENT	81/11/17	
7566	JONES	MANAGER	    81/04/02	
7934	MILLER	CLERK	    82/01/23	
7782	CLARK	MANAGER	    81/06/09	
7654	MARTIN	SALESMAN	81/09/28	1400
7521	WARD	SALESMAN	81/02/22	500
7499	ALLEN	SALESMAN	81/02/20	300
7844	TURNER	SALESMAN	81/09/08	0
*/

-- 8) emp 테이블에서 comm이 적은 순서대로, 직무별 오름차순으로, 이름별 오름차순으로 조회
-- 사번, 이름, 직무, 입사일, 커미션을 조회
SELECT e.EMPNO
    , e.ENAME
    , e.JOB
    , e.HIREDATE
    , e.COMM
    FROM emp e
    ORDER BY e.COMM, e.JOB, e.ENAME
;
/* 커미션 -> 직무 -> 이름 우선순위로 정렬됨. 제대로 나왔는지 꼭 검증하자.
7844	TURNER	SALESMAN	81/09/08	0
7499	ALLEN	SALESMAN	81/02/20	300
7521	WARD	SALESMAN	81/02/22	500
7654	MARTIN	SALESMAN	81/09/28	1400
7902	FORD	ANALYST 	81/12/03	
7900	JAMES	CLERK	    81/12/03	
7934	MILLER	CLERK	    82/01/23	
7369	SMITH	CLERK	    80/12/17	
7698	BLAKE	MANAGER	    81/05/01	
7782	CLARK	MANAGER	    81/06/09	
7566	JONES	MANAGER	    81/04/02	
7839	KING	PRESIDENT	81/11/17	
*/

-- 9) emp 테이블에서 comm이 적은 순서대로, 직무별 오름차순, 이름별 내림차순으로 정렬
-- 사번, 이름, 직무, 입사일, 커미션 조회
SELECT e.EMPNO
    , e.ENAME
    , e.JOB
    , e.HIREDATE
    , e.COMM
    FROM emp e
    ORDER BY e.COMM, e.JOB, e.ENAME DESC
;
/* 커미션 -> 직무 -> 이름 우선순위로 정렬됨.
7844	TURNER	SALESMAN	81/09/08	0
7499	ALLEN	SALESMAN	81/02/20	300
7521	WARD	SALESMAN	81/02/22	500
7654	MARTIN	SALESMAN	81/09/28	1400
7902	FORD	ANALYST	    81/12/03	
7369	SMITH	CLERK	    80/12/17	
7934	MILLER	CLERK	    82/01/23	
7900	JAMES	CLERK	    81/12/03	
7566	JONES	MANAGER 	81/04/02	
7782	CLARK	MANAGER 	81/06/09	
7698	BLAKE	MANAGER 	81/05/01	
7839	KING	PRESIDENT	81/11/17	
*/











---------------------------------------------------------------------


---------------------------------------------------------------------