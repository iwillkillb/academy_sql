-- 실습1)
SELECT 
    e.EMPNO
    ,e.ENAME
    ,e.JOB
    ,e.SAL
    FROM emp e
    ORDER BY e.SAL DESC
;

-- 실습2)
SELECT
    e.EMPNO
    ,e.ENAME
    ,e.HIREDATE
    FROM emp e
    ORDER BY e.HIREDATE
;

-- 실습3)
SELECT
    e.EMPNO
    ,e.ENAME
    ,e.COMM
    FROM emp e
    ORDER BY e.COMM
;

-- 실습4)
SELECT
    e.EMPNO
    ,e.ENAME
    ,e.COMM
    FROM emp e
    ORDER BY e.COMM DESC
;

-- 실습5)
SELECT
    e.EMPNO 사번
    , e.ENAME 이름
    , e.SAL 급여
    , e.HIREDATE 입사일
    FROM emp e
;

