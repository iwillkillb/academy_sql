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