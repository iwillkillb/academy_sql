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
-- 1. INITCAP(str) : str(영문)의 첫 글자를 대문자로
SELECT INITCAP('the soap') FROM dual;   -- The Soap
SELECT INITCAP('안녕') FROM dual;   -- 안녕
-- 2. LOWER(str) : str(영문)을 소문자로
SELECT LOWER('MR. SCOTT MCMILLAN') "소문자로 변경" FROM dual; -- mr. scott mcmillan
-- 3. UPPER(str) : str(영문)을 대문자로
SELECT UPPER('lee') "대문자로 변경" FROM dual; -- LEE
-- 4. LENGTH(str), LENGTHB(str) : str의 글자길이를 계산 / str의 글자 byte를 계산
SELECT 'Hello, SQL의 글자 길이는 ' || LENGTH('Hello, SQL') || '입니다.' "글자 길이" FROM dual;  -- 10
-- Oracle에서, 영문은 1 byte, 한글은 3 byte로 계산한다.
SELECT 'Hello, SQL의 글자 바이트는 ' || LENGTHB('Hello, SQL') || '입니다.' "글자 바이트" FROM dual;  -- 10
SELECT '오라클의 글자 바이트는 ' || LENGTHB('오라클') || '입니다.' "글자 바이트" FROM dual;  -- 9
-- 5. CONCAT(str1, str2) : str1, str2 문자열 접합. ||와 동일.
SELECT CONCAT('안녕하세요', ' SQL') FROM dual;   -- 안녕하세요 SQL
SELECT '안녕하세요' || ' SQL' FROM dual;   -- 안녕하세요 SQL
-- 6. SUBSTR(str, i, n) : str에서 i번째 위치에서 n개의 글자를 추출. SQL에서 문자열 인덱스를 나타내는 i는 1부터 시작.
SELECT SUBSTR('Hello, SQL', 3, 4) FROM dual;    -- llo,
SELECT SUBSTR('Hello, SQL', 3) FROM dual;    -- llo, SQL
-- 7. INSTR(str1, str2) : str2가 str1에서 어디에 위치하는가? str1에 없으면 0 리턴.
SELECT INSTR('Hello, SQL', 'lo') FROM dual; -- 4
-- 8. LPAD(str, n, c), RPAD(str, n, c) :
-- 입력된 str에 전체 글자의 자리수를 n으로 잡고, 남는 공간에 왼쪽(LPAD)/오른쪽(RPAD)으로 c의 문자를 채워넣는다.
SELECT LPAD('spl is cooool', 20, '!') FROM dual;    -- !!!!!!!spl is cooool
SELECT RPAD('spl is cooool', 20, '!') FROM dual;    -- spl is cooool!!!!!!!
SELECT LPAD('spl is cooool', 4, '!') FROM dual;    -- spl 
SELECT RPAD('spl is cooool', 4, '!') FROM dual;    -- spl 
-- 9. LTRIM, RTRIM, TRIM : 입력된 문자열의 왼쪽/오른쪽/양쪽 공백 제거
SELECT '>' || LTRIM('     sql is cool     ') || '<' FROM dual;  -- >sql is cool     <
SELECT '>' || RTRIM('     sql is cool     ') || '<' FROM dual;  -- >     sql is cool<
SELECT '>' || TRIM('     sql is cool     ') || '<' FROM dual;   -- >sql is cool<
-- 10. NVL(expr1, expr2), NVL2(expr1, expr2, expr3), NULLIF(expr1, expr2)
-- NVL(expr1, expr2) : 첫번째 식의 값이 NULL이면 두번째 식으로 대체 출력.
-- mgr가 배정안된 직원은 '매니저 없음'으로 변경하여 출력.
/*
SELECT 
    e.EMPNO
    ,e.ENAME
    , NVL(e.MGR, '매니저 없음.') -- e.MGR이 숫자라서 안됨.
    FROM emp e
;*/
SELECT 
    e.EMPNO
    ,e.ENAME
    , NVL(e.MGR || '', '매니저 없음') as MGR    -- ||로 형변환.
    FROM emp e
;
-- NVL2(expr1, expr2, expr3) : 첫번째 식의 값이 NOT NULL이면 두번째 식의 값으로 대체 출력, NULL이면 세번째 식의 값으로 대체 출력.
SELECT 
    e.EMPNO
    ,e.ENAME
    , NVL2(e.MGR, '매니저 있음', '매니저 없음') as MGR
    FROM emp e
;
-- NULLIF(expr1, expr2) : 첫번째 식, 두번째 식의 수행 결과 값이 동일하면 NULL 출력. 아니면 첫번째 식.
SELECT 
    e.EMPNO
    ,e.ENAME
    , NULLIF('매니저 있음', '매니저 있음') as MGR
    FROM emp e
;
SELECT NULLIF('매니저 있음', '매니저 있음') as MGR
    FROM dual
;   -- 1행짜리 NULL, 0행과는 다르다.




-- 3) 날짜함수 : 날짜 출력 패턴 이용
SELECT sysdate FROM dual;

-- TO_CHAR() : 숫자/날짜 -> 문자형으로
SELECT TO_CHAR(sysdate, 'YYYY') FROM dual;
SELECT TO_CHAR(sysdate, 'YY') FROM dual;
SELECT TO_CHAR(sysdate, 'MM') FROM dual;
SELECT TO_CHAR(sysdate, 'MONTH') FROM dual;
SELECT TO_CHAR(sysdate, 'MON') FROM dual;
SELECT TO_CHAR(sysdate, 'DD') FROM dual;
SELECT TO_CHAR(sysdate, 'D') FROM dual;
SELECT TO_CHAR(sysdate, 'DAY') FROM dual;
SELECT TO_CHAR(sysdate, 'DY') FROM dual;

-- 패턴조합
SELECT TO_CHAR(sysdate, 'YYYY-MM-DD') FROM dual;
SELECT TO_CHAR(sysdate, 'FMYYYY-MM-DD') FROM dual;
SELECT TO_CHAR(sysdate, 'YY-MONTH-DD') FROM dual;
SELECT TO_CHAR(sysdate, 'YY-MONTH-DD DAY') FROM dual;
SELECT TO_CHAR(sysdate, 'YY-MONTH-DD DY') FROM dual;

/*
시간 패턴
HH : 시간 두자리
MI : 분 두자리
SS : 초 두자리
HH24 : 24시 체계
AM : 오전오후 표기
*/
SELECT TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS') FROM dual;
SELECT TO_CHAR(sysdate, 'YYYY-MM-DD AM HH:MI:SS') FROM dual;

-- 날짜와 숫자의 연산 + -
SELECT TO_CHAR(sysdate + 10) FROM dual;     -- 10일 후
SELECT TO_CHAR(sysdate - 10) FROM dual;     -- 10일 전
SELECT TO_CHAR(sysdate + 10/24) FROM dual;  -- 10시간 후
SELECT TO_CHAR(sysdate + 10/24, 'YY-MM-DD HH24:MI:SS') FROM dual;  -- 10시간 후

-- 1. MONTHS_BETWEEN(날짜1, 날짜2) : 두 날짜 사이 달의 차이
SELECT e.ENAME, MONTHS_BETWEEN(sysdate, e.HIREDATE) FROM emp e;
-- 2. ADD_MONTHS(날짜1, 숫자) : 날짜1 + 숫자만큼 더한 후의 날짜
SELECT ADD_MONTHS(sysdate, 3) FROM dual;
-- 3. NEXT_DAY, LAST_DAY : 다음 요일의 날짜, 이 달 마지막 날짜
SELECT NEXT_DAY(sysdate, '일요일') FROM dual;
SELECT NEXT_DAY(sysdate, '일') FROM dual;
SELECT NEXT_DAY(sysdate, 1) FROM dual;
SELECT LAST_DAY(sysdate) FROM dual;
-- 4. ROUND, TRUNC : 날짜 반올림/버림
SELECT ROUND(sysdate) FROM dual;
SELECT TO_CHAR(ROUND(sysdate), 'YYYY-MM-DD HH24:MI:SS') FROM dual;
SELECT TO_CHAR(TRUNC(sysdate), 'YYYY-MM-DD HH24:MI:SS') FROM dual;
SELECT TRUNC(sysdate) FROM dual;





-- 4) 데이터타입 변환
/*
TO_CHAR() : 숫자, 날짜 -> 문자
TO_DATE() : 날짜형식의 문자 -> 날짜
TO_NUMBER() : 숫자로만 구성된 문자열 -> 숫자
*/

-- 1. TO_CHAR() : 숫자패턴
-- 숫자패턴에서 9는 한자리 숫자
SELECT TO_CHAR(12345, '9999') FROM dual;    -- 자리수 부족으로, #####이 나온다.
SELECT TO_CHAR(12345, '99999') FROM dual;   -- 왼쪽에 정렬. 숫자는 오른쪽 정렬.
SELECT TO_CHAR(12345, '999999999') data FROM dual;
SELECT TO_CHAR(12345, '099999999') data FROM dual;
SELECT TO_CHAR(12345, '9999999.99') data FROM dual;
SELECT TO_CHAR(12345, '999,999,999') data FROM dual;

-- 2. TO_DATE() : 날짜패턴에 맞는 문자값을 날짜데이터로 변경. YYYY-MM-DD
SELECT TO_DATE('2018-06-27', 'YYYY-MM-DD') + 10 today FROM dual;

-- 3. TO_NUMBER() : 오라클이 자동 형변환을 해줘서 자주 사용은 안됨.
SELECT '1000' + 10 result FROM dual;    -- 결과 : 1010
SELECT TO_NUMBER('1000') + 10 result FROM dual;




-- 5) DECODE(expr, search, result [, search, result]... [, default])
-- 만약 default가 설정이 안되어있고, expr과 일치하는 search가 없으면 NULL 리턴.
SELECT DECODE('WHAT'
    ,'YES', '입력값이 YES입니다.'
    ,'NO', '입력값이 NO입니다.'
    ) as "Result"
    FROM dual
;   -- expr과 일치하는 search가 없고, default 설정이 안되있으면 NULL. 0행이 아니라.

SELECT DECODE('WHAT'
    ,'YES', '입력값이 YES입니다.'
    ,'NO', '입력값이 NO입니다.'
    , '입력값이 둘 다 아닙니다.') as "Result"
    FROM dual
;   -- dafault 있는 버전.

-- emp 테이블의 hiredate의 입사년도를 추출하여 몇년 근무했는지를 계산하고, 장기근속 여부를 판단.
-- 1) 입사년도 추출 : 패턴 사용
SELECT
    e.EMPNO
    ,e.ENAME
    ,TO_CHAR(e.HIREDATE, 'YYYY') as hireyear
    FROM emp e
;
-- 2) 몇년근무? 오늘 시스템 날짜와 연산
SELECT
    e.EMPNO
    ,e.ENAME
    ,TO_CHAR(sysdate, 'YYYY') - TO_CHAR(e.HIREDATE, 'YYYY') as "근무햇수"
    FROM emp e
;
-- 3) 37년 이상 근무자 장기근속으로 판단.
SELECT
    a.EMPNO
    ,a.ENAME
    ,a.WORKINGYEAR
    ,DECODE(a.WORKINGYEAR
        ,37, '장기근속'
        ,38, '장기근속'
        ,'장기근속 아님'
    ) as "장기 근속 여부"
    FROM (
    SELECT
        e.EMPNO
        ,e.ENAME
        ,TO_CHAR(sysdate, 'YYYY') - TO_CHAR(e.HIREDATE, 'YYYY') as WORKINGYEAR
        FROM emp e
    ) a
;

-- Job별로 급여 대비 일정 비율로 경조사비를 지급한다.
-- 각 직원들의 경조사비 지원금은?
/*
CLERK : 5%
SALESMAN : 4%
MANAGER : 3.7%
ANALYST : 3%
PRESIDENT : 1.5%
*/
SELECT
    e.EMPNO
    ,e.ENAME
    ,e.SAL
    ,e.JOB
    ,DECODE(e.JOB
        ,'CLERK', e.SAL*0.05
        ,'SALESMAN', e.SAL*0.04
        ,'MANAGER', e.SAL*0.037
        ,'ANALYST', e.SAL*0.03
        ,'PRESIDENT', e.SAL*0.015
    ) as "경조사비 지원금"
    FROM emp e
;
/*
7369	SMITH	800	    CLERK	    40
7499	ALLEN	1600	SALESMAN	64
7521	WARD	1250	SALESMAN	50
7566	JONES	2975	MANAGER	    110.075
7654	MARTIN	1250	SALESMAN	50
7698	BLAKE	2850	MANAGER	    105.45
7782	CLARK	2450	MANAGER	    90.65
7839	KING	5000	PRESIDENT	75
7844	TURNER	1500	SALESMAN	60
7900	JAMES	950	    CLERK	    47.5
7902	FORD	3000	ANALYST	    90
7934	MILLER	1300	CLERK	    65
9999	J_JUNE	500	    CLERK	    25
8888	J	    400	    CLERK	    20
7777	J%JONES	300	    CLERK	    15
*/

-- 출력결과에 숫자패턴 씌우기
SELECT
    e.EMPNO
    ,e.ENAME
    ,e.SAL
    ,e.JOB
    ,TO_CHAR(DECODE(e.JOB
        ,'CLERK', e.SAL*0.05
        ,'SALESMAN', e.SAL*0.04
        ,'MANAGER', e.SAL*0.037
        ,'ANALYST', e.SAL*0.03
        ,'PRESIDENT', e.SAL*0.015
    ),'$999.99') as "경조사비 지원금"
    FROM emp e
;
/*
7369	SMITH	800	    CLERK	    $40.00
7499	ALLEN	1600	SALESMAN	$64.00
7521	WARD	1250	SALESMAN	$50.00
7566	JONES	2975	MANAGER	    $110.08
7654	MARTIN	1250	SALESMAN    $50.00
7698	BLAKE	2850	MANAGER	    $105.45
7782	CLARK	2450	MANAGER	    $90.65
7839	KING	5000	PRESIDENT	$75.00
7844	TURNER	1500	SALESMAN	$60.00
7900	JAMES	950	    CLERK	    $47.50
7902	FORD	3000	ANALYST	    $90.00
7934	MILLER	1300	CLERK	    $65.00
9999	J_JUNE	500	    CLERK	    $25.00
8888	J	    400	    CLERK	    $20.00
7777	J%JONES	300	    CLERK	    $15.00
*/