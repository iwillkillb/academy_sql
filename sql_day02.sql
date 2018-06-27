-- sql day02
---------------------------------------------------------------------

-- IS NULL, IS NOT NULL 연산자
/*
IS NULL : 비교하려는 컬럼의 값이 null이면 true, 아니면 false
IS NOT NULL : 비교하려는 컬럼의 값이 null이면 false, 아니면 true
null값은 비교연산자(=, !=, <> 등)와 연산이 불가능, null값 비교 연산자가 따로 존재함.
*/

-- 27) 어떤 직원의 MANAGER가 지정되지 않은 직원 정보 조회
SELECT
    e.EMPNO
    ,e.ENAME
    ,e.MGR
    FROM emp e
    WHERE e.MGR IS NULL -- e.MGR = NULL 은 불가능.
;
/*
7839	KING	
9999	J_JUNE	
8888	J	
7777	J%JONES	
*/
-- MANAGER가 지정된 직원 정보 조회
SELECT
    e.EMPNO
    ,e.ENAME
    ,e.MGR
    FROM emp e
    WHERE e.MGR IS NOT NULL
;
/* 11행이 조회됨.
7369	SMITH	7902
7499	ALLEN	7698
7521	WARD	7698
7566	JONES	7839
7654	MARTIN	7698
7698	BLAKE	7839
7782	CLARK	7839
7844	TURNER	7698
7900	JAMES	7698
7902	FORD	7566
7934	MILLER	7782
비교연산자를 쓰면 0행이 인출된다. (오류 없이)
*/

-- BETWEEN ~ AND ~ : 범위 비교 연산자 범위 포함
-- a <= e.SAL <= b과 동일. 양쪽의 a, b를 포함한다.

-- 28) 급여가 500 ~ 1200 사이인 직원 정보 조회
SELECT
    e.EMPNO
    ,e.ENAME
    ,e.SAL
    FROM emp e
    WHERE e.SAL BETWEEN 500 AND 1200
;
/*
7369	SMITH	800
7900	JAMES	950
9999	J_JUNE	500
*/
-- BETWEEN 500 AND 1200과 같은 결과의 비교연산자
SELECT
    e.EMPNO
    ,e.ENAME
    ,e.SAL
    FROM emp e
    WHERE e.SAL >= 500
        AND e.SAL <= 1200   -- 등호 필요
;

-- EXISTS 연산자 : 조회한 결과가 1행 이상 있는 경우 true. 만약 결과가 0행이면 false. 서브쿼리(또다른 SELECT문)와 병용.

-- 29) 급여가 10000이 넘는 사람이 있는가?
-- (1) 급여가 10000이 넘는 사람을 찾는 구문을 작성.
SELECT
    e.ENAME
    FROM emp e
    WHERE e.SAL > 10000
;
-- 위의 쿼리 결과가 1행이라도 있으면 화면에 "급여가 3000이 넘는 직원이 존재함."이라고 출력하기.
SELECT
    '급여가 3000이 넘는 직원이 존재함.' as "시스템 메시지"
    FROM dual
    WHERE EXISTS (
        SELECT
            e.ENAME
            FROM emp e
            WHERE e.SAL > 3000
    )
;
-- 결과 : 급여가 3000이 넘는 직원이 존재함.

-- 위의 쿼리 결과가 1행이라도 없으면 화면에 "급여가 10000이 넘는 직원이 존재하지 않음."이라고 출력하기.
SELECT
    '급여가 10000이 넘는 직원이 존재하지 않음.' as "시스템 메시지"
    FROM dual
    WHERE NOT EXISTS (
        SELECT
            e.ENAME
            FROM emp e
            WHERE e.SAL > 10000
    )
;
-- 결과 : 급여가 10000이 넘는 직원이 존재하지 않음.



-- (6) 연산자 : 결합연산자 (||). 오라클에서만 존재. 문자열 결합/접합. 다른 프로그래밍 언어에서는 OR 연산자.

-- 오늘 날짜를 화면에 조회하려면
SELECT sysdate
    FROM dual
;
-- 오늘 날짜를 알려주는 문장을 만드려면
SELECT '오늘의 날짜는' || sysdate || '입니다.' as "오늘의 날짜"
    FROM dual
;
-- 직원 사번을 알려주는 구문
SELECT '안녕하세요. ' || e.ENAME || '씨, 당신의 사번은 ' || e.EMPNO || ' 입니다.' as "사번 알리미"
    FROM emp e
;




-- (6) 연산자 : 6. 집합연산자
/* dept 테이블
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	    CHICAGO
40	OPERATIONS	BOSTON
*/
-- 첫번째 쿼리
SELECT *
    FROM dept d
;
-- 두번째 쿼리 : 부서번호가 10번인 부서정보만 조회
SELECT *
    FROM dept d
    WHERE d.DEPTNO = 10
;

-- 1) UNION ALL : 두 집합의 중복데이터를 허용한 합집합
SELECT *
    FROM dept d
UNION ALL
SELECT *
    FROM dept d
    WHERE d.DEPTNO = 10
;
/*
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	    CHICAGO
40	OPERATIONS	BOSTON
10	ACCOUNTING	NEW YORK    중복된 내용, 두번째 쿼리
*/

-- 2) UNION : 두 집합의 중복데이터를 제거한 합집합
SELECT *
    FROM dept d
UNION
SELECT *
    FROM dept d
    WHERE d.DEPTNO = 10
;
/*
10	ACCOUNTING	NEW YORK    1)에서 나온 중복데이터는 제거되었다.
20	RESEARCH	DALLAS
30	SALES	    CHICAGO
40	OPERATIONS	BOSTON
*/

-- 3) INTERSECT : 두 집합의 중복데이터만 남는 교집합
SELECT *
    FROM dept d
INTERSECT
SELECT *
    FROM dept d
    WHERE d.DEPTNO = 10
;
/*
10	ACCOUNTING	NEW YORK    공통된 내용
*/

-- 4) MINUS : 첫번째 - 두번째 차집합
SELECT *
    FROM dept d
MINUS
SELECT *
    FROM dept d
    WHERE d.DEPTNO = 10
;
/* 중복된 부분 제외
20	RESEARCH	DALLAS
30	SALES	CHICAGO
40	OPERATIONS	BOSTON
*/

-- 주의! : 각 쿼리 조회 결과의 컬럼 개수, 데이터 타입이 서로 일치해야 한다.
/*
SELECT *                    -- 컬럼 개수 3개
    FROM dept d
UNION ALL
SELECT d.DEPTNO, d.DNAME    -- 컬럼 개수 2개
    FROM dept d
    WHERE d.DEPTNO = 10
;*/
-- 결과 : ORA-01789: query block has incorrect number of result columns
/*
SELECT d.DNAME, d.DEPTNO    -- 문자/숫자
    FROM dept d
UNION ALL
SELECT d.DEPTNO, d.DNAME    -- 숫자/문자
    FROM dept d
    WHERE d.DEPTNO = 10
;*/
-- 결과 : ORA-01790: expression must have same datatype as corresponding expression

-- 서로 다른 테이블에서 조회한 결과를 집합연산
-- 첫번째 쿼리 : emp 테이블에서 조회
SELECT e.EMPNO, e.ENAME, e.JOB      -- 숫자/문자/문자
    FROM emp e
;
-- 두번째 쿼리 : emp 테이블에서 조회
SELECT d.DEPTNO, d.DNAME, d.LOC     -- 숫자/문자/문자
    FROM dept d
;

-- 서로 다른 테이블 조회한 결과를 UNION
SELECT e.EMPNO, e.ENAME, e.JOB
    FROM emp e
UNION
SELECT d.DEPTNO, d.DNAME, d.LOC
    FROM dept d
;
/*
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	CHICAGO
40	OPERATIONS	BOSTON
7369	SMITH	CLERK
7499	ALLEN	SALESMAN
7521	WARD	SALESMAN
7566	JONES	MANAGER
7654	MARTIN	SALESMAN
7698	BLAKE	MANAGER
7777	J%JONES	CLERK
7782	CLARK	MANAGER
7839	KING	PRESIDENT
7844	TURNER	SALESMAN
7900	JAMES	CLERK
7902	FORD	ANALYST
7934	MILLER	CLERK
8888	J	    CLERK
9999	J_JUNE	CLERK
*/

-- 서로 다른 테이블 조회한 결과를 MINUS
SELECT e.EMPNO, e.ENAME, e.JOB
    FROM emp e
MINUS
SELECT d.DEPTNO, d.DNAME, d.LOC
    FROM dept d
;
/* 첫번째 쿼리만 다 나옴. 중복된 게 없어서.
7369	SMITH	CLERK
7499	ALLEN	SALESMAN
7521	WARD	SALESMAN
7566	JONES	MANAGER
7654	MARTIN	SALESMAN
7698	BLAKE	MANAGER
7777	J%JONES	CLERK
7782	CLARK	MANAGER
7839	KING	PRESIDENT
7844	TURNER	SALESMAN
7900	JAMES	CLERK
7902	FORD	ANALYST
7934	MILLER	CLERK
8888	J	    CLERK
9999	J_JUNE	CLERK
*/

-- 서로 다른 테이블 조회한 결과를 INTERSECT
SELECT e.EMPNO, e.ENAME, e.JOB
    FROM emp e
INTERSECT
SELECT d.DEPTNO, d.DNAME, d.LOC
    FROM dept d
;
-- No rows selected. 0행.





-- (6) 연산자 : 7. 연산자 우선순위
/*
주어진 조건 3가지
1. mgr = 7698
2. job = 'CLERK'
3. sal > 1300
*/

-- 1) 매니저가 7698번이며, 직무가 CLERK(일반사원)이거나, 급여가 1300이 넘는 조건을 만족하는 직원의 정보를 조회
SELECT
    e.EMPNO
    ,e.ENAME
    ,e.JOB
    ,e.SAL
    ,e.MGR
    FROM emp e
    WHERE e.MGR = 7698
        AND e.JOB = 'CLERK'
        OR e.SAL > 1300
;
/*
7499	ALLEN	SALESMAN	1600	7698
7566	JONES	MANAGER	    2975	7839
7698	BLAKE	MANAGER	    2850	7839
7782	CLARK	MANAGER	    2450	7839
7839	KING	PRESIDENT	5000	
7844	TURNER	SALESMAN	1500	7698
7900	JAMES	CLERK	    950	    7698
7902	FORD	ANALYST	    3000	7566
*/
-- 2) 매니저가 7698번인 직원 중, 직무가 CLERK(일반사원)이거나, 급여가 1300이 넘는 조건을 만족하는 직원의 정보를 조회
SELECT
    e.EMPNO
    ,e.ENAME
    ,e.JOB
    ,e.SAL
    ,e.MGR
    FROM emp e
    WHERE e.MGR = 7698  -- 이 조건은 무조건 갖춰야 나온다.
        AND (e.JOB = 'CLERK' OR e.SAL > 1300)
;
/*
7499	ALLEN	SALESMAN	1600	7698
7844	TURNER	SALESMAN	1500	7698
7900	JAMES	CLERK	    950	    7698
*/
-- 3) 직무가 CLERK(일반사원)이거나, 급여가 1300이 넘으면서, 매니저가 7698번인 직원의 정보를 조회
SELECT
    e.EMPNO
    ,e.ENAME
    ,e.JOB
    ,e.SAL
    ,e.MGR
    FROM emp e
    WHERE e.JOB = 'CLERK'
        OR (e.SAL > 1300 AND e.MGR = 7698)
;
/*
7369	SMITH	CLERK	    800	    7902
7499	ALLEN	SALESMAN	1600	7698
7844	TURNER	SALESMAN	1500	7698
7900	JAMES	CLERK	    950	    7698
7934	MILLER	CLERK	    1300	7782
9999	J_JUNE	CLERK	    500	
8888	J	    CLERK	    400	
7777	J%JONES	CLERK	    300	
*/
-- AND 연산자의 우선순위는 자동으로 OR 연산자보다 높기 때문에 ()없어도 결과는 같음.




-- 6. 함수
-- (2) dual 테이블 : 1행1열로 구성된 시스템 테이블
DESC dual;  -- 문자데이터 1칸으로 구성된 dummy 컬럼을 가진 테이블
DESC emp;
SELECT *
    FROM dual
;
/*
이름    널? 유형          
----- -- ----------- 
DUMMY    VARCHAR2(1) 

이름       널?       유형           
-------- -------- ------------ 
EMPNO    NOT NULL NUMBER(4)    
ENAME             VARCHAR2(10) 
JOB               VARCHAR2(9)  
MGR               NUMBER(4)    
HIREDATE          DATE         
SAL               NUMBER(7,2)  
COMM              NUMBER(7,2)  
DEPTNO            NUMBER(2)    

X
*/





-- (3) 단일행 함수
-- 1) 숫자함수 : 
-- 1. MOD(m,n) : m을 n으로 나눈 나머지
SELECT mod(10,3) as "Result"
    FROM dual   -- 1번 수행
;
SELECT mod(10,3) as "Result"
    FROM dept   -- 4번 수행
;

-- 각 사원의 급여를 3으로 나눈 나머지를 조회
SELECT
    e.EMPNO
    ,e.ENAME
    ,e.SAL
    ,mod(e.SAL, 3) as "SAL/3"
    FROM emp e
;
/*
7369	SMITH	800	    2
7499	ALLEN	1600	1
7521	WARD	1250	2
7566	JONES	2975	2
7654	MARTIN	1250	2
7698	BLAKE	2850	0
7782	CLARK	2450	2
7839	KING	5000	2
7844	TURNER	1500	0
7900	JAMES	950	    2
7902	FORD	3000	0
7934	MILLER	1300	1
9999	J_JUNE	500	    2
8888	J	    400	    1
7777	J%JONES	300	    0
*/
-- 단일행 함수는 1행당 1번씩 적용

-- 2. ROUND(m,n) : 실수 m을 소수점 n+1자리에서 반올림 한 결과를 계산
SELECT ROUND(1234.56, 1) FROM dual; -- =1234.6
SELECT ROUND(1234.56, 0) FROM dual; -- =1235
SELECT ROUND(1234.46, 0) FROM dual; -- =1234
SELECT ROUND(1234.46) FROM dual; -- =1234
SELECT ROUND(1234.56) FROM dual; -- =1235

-- 3. TRUNC(m,n) : 실수 m을 n에서 지정한 자리 이하 소수점을 버림.
SELECT TRUNC(1234.56, 1) FROM dual; -- =1234.5
SELECT TRUNC(1234.56, 0) FROM dual; -- =1234
SELECT TRUNC(1234.56) FROM dual; -- =1234

-- 4. CEIL(n) : 입력된 실수 n에 대해서 가장 같거나 큰 가까운 정수. 정수를 쓰면 그대로, 실수를 쓰면 큰 것 중 가장 가까운 정수.
SELECT CEIL(1234.56) FROM dual; -- =1235
SELECT CEIL(1234) FROM dual; -- =1234
SELECT CEIL(1234.01) FROM dual; -- =1235

-- 5. FLOOR(n) : 입력된 실수 n에 대해서 가장 같거나 작은 가까운 정수. 정수를 쓰면 그대로, 실수를 쓰면 작은 것 중 가장 가까운 정수.
SELECT FLOOR(1234.56) FROM dual; -- =1234
SELECT FLOOR(1234) FROM dual; -- =1234
SELECT FLOOR(1234.01) FROM dual; -- =1234

-- 6. WIDTH_BUCKET(expr,min,max,buckets) : min/max 값 사이를 buckets 개수만큼 구간으로 나누고, expr이 출력하는 값이 어느 구간인지 위치를 숫자로 구해줌.
-- 급여 범위를 0 ~ 5000으로 잡고, 5개 구간으로 나누어서 각 직원의 급여가 어느 구간에 해당하는지 출력하자.
SELECT
    e.EMPNO
    ,e.ENAME
    ,e.SAL
    ,WIDTH_BUCKET(e.SAL, 0, 5000, 5) as "급여 구간"
    FROM emp e
    ORDER BY "급여 구간" DESC
;
/*
7839	KING	5000	6
7902	FORD	3000	4
7782	CLARK	2450	3
7698	BLAKE	2850	3
7566	JONES	2975	3
7654	MARTIN	1250	2
7521	WARD	1250	2
7499	ALLEN	1600	2
7934	MILLER	1300	2
7844	TURNER	1500	2
7369	SMITH	800 	1
8888	J	    400	    1
7900	JAMES	950	    1
9999	J_JUNE	500	    1
7777	J%JONES	300 	1
*/

-- 2). 문자함수