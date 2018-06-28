-- (3) 단일행 함수
-- 6) CASE

-- Job별로 급여 대비 일정 비율로 경조사비를 지급한다.
-- 각 직원들의 경조사비 지원금은?
/*
CLERK : 5%
SALESMAN : 4%
MANAGER : 3.7%
ANALYST : 3%
PRESIDENT : 1.5%
*/

-- 1. Simple CASE로 구현 : DECODE와 거의 유사, 동일비교만 가능, 괄호 없음, 콤마 대신 WHEN/THEN/ELSE 등을 사용.
SELECT
    e.EMPNO
    ,e.ENAME
    ,e.JOB
    ,CASE e.JOB
        WHEN 'CLERK' THEN e.SAL * 0.05
        WHEN 'SALESMAN' THEN e.SAL * 0.04
        WHEN 'MANAGER' THEN e.SAL * 0.037
        WHEN 'ANALYST' THEN e.SAL * 0.03
        WHEN 'PRESIDENT' THEN e.SAL * 0.015
    END as "경조사 지원금"
    FROM emp e
;
/*
7369	SMITH	CLERK	    40
7499	ALLEN	SALESMAN	64
7521	WARD	SALESMAN	50
7566	JONES	MANAGER	    110.075
7654	MARTIN	SALESMAN	50
7698	BLAKE	MANAGER	    105.45
7782	CLARK	MANAGER	    90.65
7839	KING	PRESIDENT	75
7844	TURNER	SALESMAN	60
7900	JAMES	CLERK	    47.5
7902	FORD	ANALYST	    90
7934	MILLER	CLERK	    65
9999	J_JUNE	CLERK	    25
8888	J	    CLERK	    20
7777	J%JONES	CLERK	    15
*/

-- 2. Searched CASE로 구현
SELECT
    e.EMPNO
    ,e.ENAME
    ,e.JOB
    ,CASE
        WHEN e.JOB = 'CLERK' THEN e.SAL * 0.05
        WHEN e.JOB = 'SALESMAN' THEN e.SAL * 0.04
        WHEN e.JOB = 'MANAGER' THEN e.SAL * 0.037
        WHEN e.JOB = 'ANALYST' THEN e.SAL * 0.03
        WHEN e.JOB = 'PRESIDENT' THEN e.SAL * 0.015
        ELSE 10 --JOB이 결정 안된 사람에게
    END as "경조사 지원금"
    FROM emp e
;
/*
7369	SMITH	CLERK	40
7499	ALLEN	SALESMAN	64
7521	WARD	SALESMAN	50
7566	JONES	MANAGER	110.075
7654	MARTIN	SALESMAN	50
7698	BLAKE	MANAGER	105.45
7782	CLARK	MANAGER	90.65
7839	KING	PRESIDENT	75
7844	TURNER	SALESMAN	60
7900	JAMES	CLERK	47.5
7902	FORD	ANALYST	90
7934	MILLER	CLERK	65
9999	J_JUNE	CLERK	25
8888	J	CLERK	20
7777	J%JONES	CLERK	15
6666	JJ		10	e.JOB이 null이라서
*/

-- CASE 결과에 숫자 통화 패턴 씌우기 : $기호, 숫자 세자리 끊어읽기, 소수점 이하 2자리
SELECT
    e.EMPNO
    ,e.ENAME
    ,NVL(e.JOB, '미지정') as JOB
    ,TO_CHAR(CASE
        WHEN e.JOB = 'CLERK' THEN e.SAL * 0.05
        WHEN e.JOB = 'SALESMAN' THEN e.SAL * 0.04
        WHEN e.JOB = 'MANAGER' THEN e.SAL * 0.037
        WHEN e.JOB = 'ANALYST' THEN e.SAL * 0.03
        WHEN e.JOB = 'PRESIDENT' THEN e.SAL * 0.015
        ELSE 10 --JOB이 결정 안된 사람에게
    END, '$999,999.99') as "경조사 지원금"
    FROM emp e
;

/* SALGRADE 테이블 : 이 회사의 급여등급 기준값
GRADE   LOSAL   HISAL
1	    700	    1200
2	    1201	1400
3	    1401	2000
4	    2001	3000
5	    3001	9999
*/
-- 제공되는 급여등급을 바탕으로 각 사원들의 급여등급을 구하자. CASE를 사용하여.
SELECT
    e.EMPNO
    ,e.ENAME
    ,e.SAL
    ,CASE
        WHEN e.SAL>=700 AND e.SAL<=1200 THEN 1
        WHEN e.SAL>1200 AND e.SAL<=1400 THEN 2
        WHEN e.SAL>1400 AND e.SAL<=2000 THEN 3
        WHEN e.SAL>2000 AND e.SAL<=3000 THEN 4
        WHEN e.SAL>3000 AND e.SAL<=9999 THEN 5
        ELSE 0
    END as "급여 등급"
    FROM emp e
    ORDER BY "급여 등급" DESC
;
/*
7839	KING	5000	5
7902	FORD	3000	4
6666	JJ	2800	4
7566	JONES	2975	4
7782	CLARK	2450	4
7698	BLAKE	2850	4
7499	ALLEN	1600	3
7844	TURNER	1500	3
7934	MILLER	1300	2
7521	WARD	1250	2
7654	MARTIN	1250	2
7900	JAMES	950	1
7369	SMITH	800	1
7777	J%JONES	300	0
9999	J_JUNE	500	0
8888	J	400	0
*/

-- WHEN 안의 구문을 BETWEEN~AND로 변경하여 작성.
SELECT
    e.EMPNO
    ,e.ENAME
    ,e.SAL
    ,CASE
        WHEN e.SAL BETWEEN 700 AND 1200 THEN 1
        WHEN e.SAL BETWEEN 1201 AND 1400 THEN 2
        WHEN e.SAL BETWEEN 1401 AND 2000 THEN 3
        WHEN e.SAL BETWEEN 2001 AND 3000 THEN 4
        WHEN e.SAL BETWEEN 3001 AND 9999 THEN 5
        ELSE 0
    END as "급여 등급"
    FROM emp e
    ORDER BY "급여 등급" DESC
;
/*
7839	KING	5000	5
7902	FORD	3000	4
6666	JJ	2800	4
7566	JONES	2975	4
7782	CLARK	2450	4
7698	BLAKE	2850	4
7499	ALLEN	1600	3
7844	TURNER	1500	3
7934	MILLER	1300	2
7521	WARD	1250	2
7654	MARTIN	1250	2
7900	JAMES	950	1
7369	SMITH	800	1
7777	J%JONES	300	0
9999	J_JUNE	500	0
8888	J	400	0
*/





-- 2. 그룹함수 (복수행 함수)
-- 1). COUNT(*) : 특정 테이블의 행의 개수(데이터 개수)를 세어준다. NULL을 처리하는 유일한 그룹함수
-- COUNT(expr) : expr로 등장한 값을 NULL 제외하고 세어주는 함수
-- dept, salgrade 테이블의 전체 개수 조회
SELECT COUNT(*) as "부서 개수"
    FROM dept d
;   -- 결과 : 4
SELECT *
    FROM dept d
;
/*
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	CHICAGO
40	OPERATIONS	BOSTON
*/

SELECT COUNT(*) as "급여등급 개수"
    FROM salgrade s
;   -- 결과 : 5

-- emp테이블에서 job컬럼의 데이터 개수를 카운트하기
SELECT COUNT(e.JOB)
    FROM emp e
;   -- 결과 : 15. 16명 중 job이 NULL인 직원을 제외한 15명을 세서.
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
9999	J_JUNE	CLERK
8888	J	CLERK
7777	J%JONES	CLERK
6666	JJ	(null)
*/

-- 회사에 매니저가 배정된 직원이 몇명인가?
SELECT COUNT(e.MGR) as "매니저가 있는 직원 수"
    FROM emp e
;   -- 결과 : 11

-- 매니저를 맡고있는 직원이 몇명인가?
-- 1. mgr컬럼을 중복제거하여 조회
SELECT DISTINCT e.MGR
    FROM emp e
;
-- 2. 그 결과를 카운트
SELECT COUNT(DISTINCT e.MGR)
    FROM emp e
;   -- 결과 : 5

-- 부서가 배정된 직원이 몇명인가?
SELECT
    COUNT(*) as "전체 인원"
    ,COUNT(e.DEPTNO) as "부서 배정 인원"
    ,(COUNT(*) - COUNT(e.DEPTNO)) as "부서 미배정 인원"
    FROM emp e
;   -- 결과 : 12, 4

-- COUNT(*)가 아닌 COUNT(expr)을 쓴 경우에는
SELECT e.DEPTNO
    FROM emp e
    WHERE e.DEPTNO IS NOT NULL
;   --을 카운트한 것과 같다.

-- 2) SUM() : NULL항목 제외하고 합산 가능한(숫자) 모든 행들을 더한 결과를 출력.
-- SALESMAN들의 수당 총합
SELECT SUM(e.COMM)
    FROM emp e
    WHERE e.JOB = 'SALESMAN'
;   -- 결과 : 2200. NULL은 계산 안함.

-- 숫자 출력 패턴, 별칭
SELECT TO_CHAR(SUM(e.COMM), '$999,999') as "수당 총합"
    FROM emp e
    WHERE e.JOB = 'SALESMAN'
;

-- 3) AVG(expr) : NULL값 제외하고 연산 가능한 항목의 산술평균
-- 수당 평균
SELECT AVG(e.COMM) as "수당 평균"
    FROM emp e
;   -- 결과 : 550

-- 숫자 출력 패턴, 별칭
SELECT TO_CHAR(AVG(e.COMM), '$999,999') as "수당 평균"
    FROM emp e
;

-- 4) MAX(expr) : expr에 등장한 값 중 최대값을 구함.
-- expr이 문자인 경우 알파벳 순 뒤쪽에 위치한 글자를 최대값으로 계산.

-- 이름이 가장 나중인 직원
SELECT MAX(e.ENAME)
    FROM emp e
;




-- 3. GROUP BY 절의 사용
-- 1). emp 테이블에서 각 부서별로 급여의 총합을 조회
-- 총합을 구하기 위해 SUM()을 사용
-- 그룹화 기준을 부서번호(deptno)를 사용
-- 그룹화 기준으로 잡은 부서번호가 GROUP BY 절에 등장해야 함.

-- a). 먼저 emp 테이블에서 급여 총합을 구하는 구문을 작성.
SELECT SUM(e.SAL) as "급여 총합"
    FROM emp e
;

-- b). 부서번호(deptno)를 기준으로 그룹화를 진행.
-- SUM()은 그룹함수이므로 GROUP BY 절을 조합하면 그룹화 가능.
-- 그룹화를 하려면 기준 컬럼을 GROUP BY 절에 명시
SELECT e.DEPTNO, SUM(e.SAL) as "급여 총합"
    FROM emp e
    GROUP BY e.DEPTNO
;
-- 만약 GROUP BY로 잡지않은 컬럼이 SELECT에 등장하면 오류.

-- 부서별 급여의 총합, 평균, 최대, 최소
SELECT
    e.DEPTNO as "부서 번호"
    ,SUM(e.SAL) as "급여 총합"
    ,ROUND(AVG(e.SAL),2) as "급여 평균"
    ,MAX(e.SAL) as "급여 최대"
    ,MIN(e.SAL) as "급여 최소"
    FROM emp e
    GROUP BY e.DEPTNO
    ORDER BY e.DEPTNO
;
-- 숫자패턴
SELECT
    e.DEPTNO
    ,TO_CHAR(SUM(e.SAL), '$999,999.999') as "급여 총합"
    ,TO_CHAR(AVG(e.SAL), '$999,999.999') as "급여 평균"
    ,TO_CHAR(MAX(e.SAL), '$999,999.999') as "급여 최대"
    ,TO_CHAR(MIN(e.SAL), '$999,999.999') as "급여 최소"
    FROM emp e
    GROUP BY e.DEPTNO
;
/*
GROUP BY 절에 등장하는 그룹화 기준 컬럼은 반드시 SELECT절에 똑같이 등장해야 한다.
하지만 e.DEPTNO가 없어도 실행되는 이유는 SELECT절에 나열된 컬럼 중에서 그룹함수가
사용되지 않은 컬럼이 없기 때문이다.
*/

-- 부서별, 직무별 급여의 총합, 평균, 최대, 최소
SELECT
    e.DEPTNO as "부서 번호"
    ,e.JOB as "직무"
    ,SUM(e.SAL) as "급여 총합"
    ,ROUND(AVG(e.SAL),2) as "급여 평균"
    ,MAX(e.SAL) as "급여 최대"
    ,MIN(e.SAL) as "급여 최소"
    FROM emp e
    GROUP BY e.DEPTNO, e.JOB
    ORDER BY e.DEPTNO, e.JOB
;
-- 그룹함수가 적용되지 않은 컬럼들이 SELECT에 등장하면 그룹화 기준으로 가정되야 한다.

-- job별 급여 총합/평균/최대/최소
SELECT
    NVL(e.JOB, '미지정') as "직무"
    ,SUM(e.SAL) as "급여 총합"
    ,ROUND(AVG(e.SAL), 2) as "급여 평균"
    ,MAX(e.SAL) as "급여 최대"
    ,MIN(e.SAL) as "급여 최소"
    FROM emp e
    GROUP BY e.JOB
;

-- 부서번호가  NULL이면 미배정으로 표기하기
SELECT
    DECODE(NVL(e.DEPTNO, 0),0,'미배정',e.DEPTNO) as "부서 번호"    -- 다른 방법 : NVL(e.DEPTNO||'', '미배정'), NVL(TO_CHAR(e.DEPTNO), '미배정')
    ,TO_CHAR(SUM(e.SAL),'$9999.99') as "급여 총합"
    ,TO_CHAR(AVG(e.SAL),'$9999.99') as "급여 평균"
    ,TO_CHAR(MAX(e.SAL),'$9999.99') as "급여 최대"
    ,TO_CHAR(MIN(e.SAL),'$9999.99') as "급여 최소"
    FROM emp e
    GROUP BY e.DEPTNO
    ORDER BY e.DEPTNO
;

-- JOB이 NULL이면 직무 미배정으로 표기하기
SELECT
    NVL(e.JOB, '직무 미배정') as "직무"
    ,TO_CHAR(SUM(e.SAL),'$9999.99') as "급여 총합"
    ,TO_CHAR(AVG(e.SAL),'$9999.99') as "급여 평균"
    ,TO_CHAR(MAX(e.SAL),'$9999.99') as "급여 최대"
    ,TO_CHAR(MIN(e.SAL),'$9999.99') as "급여 최소"
    FROM emp e
    GROUP BY e.JOB
;

-- 4. HAVING 절의 사용
-- GROUP BY 결과에 조건을 걸어서 결과를 필터링

-- 부서별 급여 평균이 2000 이상인 부서
-- a) 우선 부서별 급여 평균을 구한다.
SELECT
    e.DEPTNO "부서 번호"
    ,AVG(e.SAL)  "급여 평균"
    FROM emp e
    GROUP BY e.DEPTNO
;
-- b) a의 결과에서 2000 이상인 부서만 남긴다.
SELECT
    e.DEPTNO "부서 번호"
    ,AVG(e.SAL)  "급여 평균"
    FROM emp e
    GROUP BY e.DEPTNO
    HAVING AVG(e.SAL) >= 2000
;
/*
HAVING절이 존재하는 경우 SELECT의 구문의 실행 순서 정리
1. FROM     절의 테이블 각 행을 대상으로
2. WHERE    절의 조건에 맞는 행만 선택하고
3. GROUP BY 절에 나온 컬럼, 식(함수식 등)으로 그룹화 진행
4. HAVING   절의 조건을 만족시키는 그룹행만 선택
5. 4까지 선택된 그룹 정보를 가진 행에 대해서
    SELECT  절에 명시된 컬럼, 식(함수식 등)만 출력.
6. ORDER BY 가 있다면 정렬조건에 맞추어 최종 정렬하여 보여준다.
*/




-- 1. 매니저별, 부하직원 수를 구하고, 많은 순으로 정렬.
SELECT
    e.MGR as "매니저"
    ,COUNT(e.EMPNO) as "부하직원 수"
    FROM emp e
    WHERE e.MGR IS NOT NULL
    GROUP BY e.MGR
    ORDER BY "부하직원 수" DESC
;
/*
7698	5
7839	3
7782	1
7566	1
7902	1
*/

-- 2. 부서별 인원을 구하고, 인원수 많은 순으로 정렬.
SELECT
    NVL(e.DEPTNO||'','미배정') as "부서" -- 아니면 WHERE e.DEPTNO IS NOT NULL로 NULL을 거를 수 있다.
    ,COUNT(e.EMPNO) as "인원수"
    FROM emp e
    GROUP BY e.DEPTNO
    ORDER BY "인원수" DESC
;
/*
30	6
미배정	4
20	3
10	3
*/

-- 3. 직무별 급여 평균 구하고, 급여평균 높은 순으로 정렬.
SELECT
    NVL(e.JOB,'미배정') as "직무"
    ,ROUND(AVG(e.SAL),2) as "급여평균"
    FROM emp e
    GROUP BY e.JOB
    ORDER BY "급여평균" DESC
;
/*
PRESIDENT	5000
ANALYST	3000
미배정	2800
MANAGER	2758.33
SALESMAN	1400
CLERK	708.33
*/

-- 4. 직무별 급여 총합 구하고, 총합 높은 순으로 정렬.
SELECT
    NVL(e.JOB,'미배정') as "직무"
    ,SUM(e.SAL) as "급여총합"
    FROM emp e
    GROUP BY e.JOB
    ORDER BY "급여총합" DESC
;
/*
MANAGER	8275
SALESMAN	5600
PRESIDENT	5000
CLERK	4250
ANALYST	3000
미배정	2800
*/

-- 5. 급여의 앞단위가 1000이하/1000/2000/3000/4000/5000 별로 인원을 구하시오. 급여단위는 오름차순으로 정렬.
SELECT
    (WIDTH_BUCKET(e.SAL,0,5000,5)-1)*1000||'~'||(WIDTH_BUCKET(e.SAL,0,5000,5)*1000-1) as "급여단위"
    ,COUNT(e.EMPNO) as "인원수"
    FROM emp e
    GROUP BY WIDTH_BUCKET(e.SAL,0,5000,5)
    ORDER BY "급여단위"
;
/*
0~999	5
1000~1999	5
2000~2999	4
3000~3999	1
5000~5999	1
*/
SELECT
    CASE
        WHEN TRUNC(e.SAL, -3) < 1000 THEN '1000 미만'
        ELSE TRUNC(e.SAL, -3) || ' 이상'
    END as "급여 단위"
    -- TRUNC(e.SAL, -3)    -- 이걸 카운트하기
    ,COUNT(TRUNC(e.SAL, -3)) as "인원수"
    FROM emp e
    GROUP BY TRUNC(e.SAL, -3)
    ORDER BY TRUNC(e.SAL, -3)
;
/*
1000 미만	5
1000 이상	5
2000 이상	4
3000 이상	1
5000 이상	1
*/
SELECT 
    CASE
        WHEN SUBSTR(LPAD(e.SAL, 4, '0'), 1, 1) = 0 THEN '1000 미만'
        ELSE TO_CHAR(SUBSTR(LPAD(e.SAL, 4, '0'), 1, 1) * 1000) || ' 이상'
    END as "급여 단위"
    ,COUNT(*) "인원(명)"
    FROM emp e
    GROUP BY SUBSTR(LPAD(e.SAL, 4, '0'), 1, 1)
    ORDER BY SUBSTR(LPAD(e.SAL, 4, '0'), 1, 1)
;

-- 6. 직무별 급여 합의 단위를 구하고, 급여 합의 단위가 큰 순으로 정렬.
SELECT
    e.JOB as "직무"
    ,WIDTH_BUCKET(SUM(e.SAL),0,10000,10)-1 as "급여 합 단위"
    FROM emp e
    WHERE e.JOB IS NOT NULL
    GROUP BY e.JOB
    ORDER BY "급여 합 단위" DESC
;
/*
MANAGER	9
SALESMAN	6
PRESIDENT	6
CLERK	5
ANALYST	4
*/
SELECT
    e.JOB as "직무"
    ,TRUNC(SUM(e.SAL), -3) as "급여 단위"
    FROM emp e
    WHERE e.JOB IS NOT NULL
    GROUP BY e.JOB
    ORDER BY "급여 단위" DESC
;
/*
MANAGER	8000
SALESMAN	5000
PRESIDENT	5000
CLERK	4000
ANALYST	3000
*/

-- 7. 직무별 급여평균이 2000이하인 경우를 구하고, 평균이 높은 순으로 정렬.
SELECT
    e.JOB as "직무"
    ,ROUND(AVG(e.SAL),2) as "급여 평균"
    FROM emp e
    WHERE e.JOB IS NOT NULL
    GROUP BY e.JOB
    HAVING AVG(e.SAL) <= 2000
;
/*
CLERK	708.33
SALESMAN	1400
*/

-- 8. 연도별 입사인원
SELECT
    TO_CHAR(e.HIREDATE,'YYYY') as "연도"
    ,COUNT(e.EMPNO) as "인원수"
    FROM emp e
    GROUP BY TO_CHAR(e.HIREDATE,'YYYY')
    ORDER BY "연도"
;
/*
PRESIDENT	5000
MANAGER	2758.33
ANALYST	3000
*/

-- 9. 연도별 월별 입사인원
SELECT
    TO_CHAR(e.HIREDATE,'YYYY') as "연도"
    ,TO_CHAR(e.HIREDATE,'MM') as "월"
    ,COUNT(e.EMPNO) as "인원수"
    FROM emp e
    GROUP BY TO_CHAR(e.HIREDATE,'YYYY'), TO_CHAR(e.HIREDATE,'MM')
    ORDER BY "연도", "월"
;
/*
1980	12	1
1981	02	2
1981	04	1
1981	05	1
1981	06	1
1981	09	2
1981	11	1
1981	12	2
1982	01	1
2018	06	4
*/

-- 연도별/월별 입사인원을 가로 표 형태로 출력하기
SELECT
    TO_CHAR(e.HIREDATE, 'YYYY') "입사년도" --그룹화 기준 컬럼
    ,COUNT(DECODE(TO_CHAR(e.HIREDATE, 'MM'), '01', 1)) "1월"
    ,COUNT(DECODE(TO_CHAR(e.HIREDATE, 'MM'), '02', 1)) "2월"
    ,COUNT(DECODE(TO_CHAR(e.HIREDATE, 'MM'), '03', 1)) "3월"
    ,COUNT(DECODE(TO_CHAR(e.HIREDATE, 'MM'), '04', 1)) "4월"
    ,COUNT(DECODE(TO_CHAR(e.HIREDATE, 'MM'), '05', 1)) "5월"
    ,COUNT(DECODE(TO_CHAR(e.HIREDATE, 'MM'), '06', 1)) "6월"
    ,COUNT(DECODE(TO_CHAR(e.HIREDATE, 'MM'), '07', 1)) "7월"
    ,COUNT(DECODE(TO_CHAR(e.HIREDATE, 'MM'), '08', 1)) "8월"
    ,COUNT(DECODE(TO_CHAR(e.HIREDATE, 'MM'), '09', 1)) "9월"
    ,COUNT(DECODE(TO_CHAR(e.HIREDATE, 'MM'), '10', 1)) "10월"
    ,COUNT(DECODE(TO_CHAR(e.HIREDATE, 'MM'), '11', 1)) "11월"
    ,COUNT(DECODE(TO_CHAR(e.HIREDATE, 'MM'), '12', 1)) "12월"
    FROM emp e
    GROUP BY TO_CHAR(e.HIREDATE, 'YYYY')
    ORDER BY "입사년도"
;
/*
1980	0	0	0	0	0	0	0	0	0	0	0	1
1981	0	2	0	1	1	1	0	0	2	0	1	2
1982	1	0	0	0	0	0	0	0	0	0	0	0
2018	0	0	0	0	0	4	0	0	0	0	0	0
*/

-- 월별 입사인원 가로 표 만들기
SELECT
    COUNT(DECODE(TO_CHAR(e.HIREDATE, 'MM'), '01', 1)) "1월"
    ,COUNT(DECODE(TO_CHAR(e.HIREDATE, 'MM'), '02', 1)) "2월"
    ,COUNT(DECODE(TO_CHAR(e.HIREDATE, 'MM'), '03', 1)) "3월"
    ,COUNT(DECODE(TO_CHAR(e.HIREDATE, 'MM'), '04', 1)) "4월"
    ,COUNT(DECODE(TO_CHAR(e.HIREDATE, 'MM'), '05', 1)) "5월"
    ,COUNT(DECODE(TO_CHAR(e.HIREDATE, 'MM'), '06', 1)) "6월"
    ,COUNT(DECODE(TO_CHAR(e.HIREDATE, 'MM'), '07', 1)) "7월"
    ,COUNT(DECODE(TO_CHAR(e.HIREDATE, 'MM'), '08', 1)) "8월"
    ,COUNT(DECODE(TO_CHAR(e.HIREDATE, 'MM'), '09', 1)) "9월"
    ,COUNT(DECODE(TO_CHAR(e.HIREDATE, 'MM'), '10', 1)) "10월"
    ,COUNT(DECODE(TO_CHAR(e.HIREDATE, 'MM'), '11', 1)) "11월"
    ,COUNT(DECODE(TO_CHAR(e.HIREDATE, 'MM'), '12', 1)) "12월"
    FROM emp e
;




-- 7. 조인과 서브쿼리
-- (1) 조인
-- 1) 조인 개요
-- 하나 이상의 테이블을 논리적으로 묶어서 하나의 테이블인 것처럼 다루는 기술
-- FROM절에 JOIN에 사용할 테이블 이름을 나열

-- 문제) 직원의 소속부서 명을 알려면? 부서 번호가 아닌.
-- a) FROM절에 emp, dept 두 테이블을 나열 -> 조인 발생 -> 카티션 곱 -> 두 테이블의 모든 조합
-- b) 조건이 추가되어야 직원의 소속부서만 정확히 연결 가능
-- WHERE가 없으면? emp테이블 16건 * dept테이블 4건 = 64건
SELECT
    e.eNAME
    ,e.DEPTNO
    ,'|'
    ,d.DEPTNO 
    ,d.dNAME
    FROM
        emp e
        ,dept d
    WHERE e.DEPTNO = d.DEPTNO
    ORDER BY d.DEPTNO
;
SELECT
    e.eNAME
    ,e.DEPTNO
    ,'|'
    ,d.DEPTNO 
    ,d.dNAME
    FROM emp e JOIN dept d ON (e.DEPTNO = d.DEPTNO) -- 최근 다른 DBMS들이 사용하는 기법을 오라클에서 지원함.
    ORDER BY d.DEPTNO
;
/*
KING	10	|	10	ACCOUNTING
CLARK	10	|	10	ACCOUNTING
MILLER	10	|	10	ACCOUNTING
FORD	20	|	20	RESEARCH
SMITH	20	|	20	RESEARCH
JONES	20	|	20	RESEARCH
JAMES	30	|	30	SALES
TURNER	30	|	30	SALES
MARTIN	30	|	30	SALES
WARD	30	|	30	SALES
ALLEN	30	|	30	SALES
BLAKE	30	|	30	SALES
*/

-- 문제) 위의 결과에서 ACCOUNTING 부서의 직원만 알고싶다.
SELECT
    e.ENAME
    ,e.DEPTNO
    ,'|'
    ,d.DEPTNO 
    ,d.DNAME
    FROM
        emp e
        ,dept d
    WHERE e.DEPTNO = d.DEPTNO
        AND d.DNAME = 'ACCOUNTING'
    ORDER BY d.DEPTNO
;
/*
KING	10	|	10	ACCOUNTING
CLARK	10	|	10	ACCOUNTING
MILLER	10	|	10	ACCOUNTING
*/

-- 2) 조인 : 카티션 곱, 조인 대상 테이블의 데이터를 가능한 모든 조합으로 엮는 것.
-- 조인조건 누락시 발생. 오라클 9i버전 이후 CROSS JOIN 키워드 지원.
SELECT
    e.ENAME
    ,d.DNAME
    ,s.GRADE
    FROM emp e
        CROSS JOIN dept d
        CROSS JOIN salgrade s
;
SELECT
    e.ENAME
    ,d.DNAME
    ,s.GRADE
    FROM emp e
        ,dept d
        ,salgrade s
;   -- emp 16 * dept 4 * salgrade 5 = 320행

-- 3) EQUI JOIN : 가장 기본적인 JOIN. 서로 다른 테이블의 공통 컬럼을 '='로 연결. 공통 컬럼(Join Attribute)이라고 부름.

-- 1. 오라클 전통 WHERE조건 걸기 : 오라클 개발자들이 애용
SELECT
    e.ENAME
    ,d.DNAME
    FROM
        emp e
        ,dept d
    WHERE e.DEPTNO = d.DEPTNO
    ORDER BY d.DEPTNO
;
-- 2. NATURAL JOIN 키워드
SELECT
    e.ENAME
    ,d.DNAME
    FROM emp e NATURAL JOIN dept d -- 조인 공통 컬럼 명시가 필요 없음
;
-- 3. JOIN ~ UNING 키워드로 조인
SELECT
    e.ENAME
    ,d.DNAME
    FROM emp e JOIN dept d USING (deptno)
;
-- 4. JOIN ~ ON 키워드로 조인 : 이것도 중요
SELECT
    e.ENAME
    ,d.DNAME
    FROM emp e JOIN dept d ON (e.DEPTNO = d.DEPTNO)
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




-- (2) 서브쿼리