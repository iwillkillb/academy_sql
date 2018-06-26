-- 실습1) emp 테이블에서 사번, 이름, 업무, 급여 컬럼을 조회하고 급여가 많은 순서대로 정렬
SELECT 
    e.EMPNO
    ,e.ENAME
    ,e.JOB
    ,e.SAL
    FROM emp e
    ORDER BY e.SAL DESC
;

-- 실습2) emp 테이블에서 사번, 이름, 입사일 컬럼을 조회하고 입사일이 빠른 순서대로 정렬
SELECT
    e.EMPNO
    ,e.ENAME
    ,e.HIREDATE
    FROM emp e
    ORDER BY e.HIREDATE
;

-- 실습3) emp 테이블에서 수당이 적은 순서대로 사번, 이름, 수당 컬럼을 조회
SELECT
    e.EMPNO
    ,e.ENAME
    ,e.COMM
    FROM emp e
    ORDER BY e.COMM
;

-- 실습4) emp 테이블에서 수당이 큰 순서대로 사번, 이름, 수당 컬럼을 조회
SELECT
    e.EMPNO
    ,e.ENAME
    ,e.COMM
    FROM emp e
    ORDER BY e.COMM DESC
;

-- 실습5) emp 테이블에서 empno->사번, ename->이름, sal->급여, hiredate->입사일로 변경하여 출력
SELECT
    e.EMPNO 사번
    , e.ENAME 이름
    , e.SAL 급여
    , e.HIREDATE 입사일
    FROM emp e
;

