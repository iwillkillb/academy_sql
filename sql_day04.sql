-- JOIN 계속
-- EQUI 조인 구문 구조

--------------------------------------------------------------------------------------------------------
-- 1. 오라클 전용 조인 구조
/*
SELECT [별칭1.]컬럼명1, [별칭2.]컬럼명2 [, ...]
    FROM 테이블1 별칭1, 테이블2 별칭2 [, ...]
    WHERE 별칭1.공통컬럼1 = 별칭2.공통컬럼1 -- 조인 조건
        [AND 별칭1.공통컬럼1 = 별칭n.공통컬럼2] -- FROM에 나열된 테이블이 2개가 넘을 때 조인 조건 추가
        [AND ... 추가 가능한 일반 조건들 등장];
*/

-- 2. NATURAL JOIN을 사용하는 구조
/*
SELECT [별칭1.]컬럼명1, [별칭2.]컬럼명2 [, ...]
    FROM 테이블1 별칭1
        NATURAL JOIN 테이블2 별칭2
        [NATURAL JOIN 테이블n 별칭n];
*/

-- 3. JOIN ~ USING을 사용하는 구조 : 여러 테이블에서 공통컬럼 이름이 동일해야 함
/*
SELECT [별칭1.]컬럼명1, [별칭2.]컬럼명2 [, ...]
    FROM 테이블1 별칭1
        JOIN 테이블2 별칭2 USING (공통컬럼) -- 공통컬럼에 별칭 사용 금지;
*/

-- 4. JOIN ~ ON을 사용하는 구조 : 표준 SQL 구문
/*
SELECT [별칭1.]컬럼명1, [별칭2.]컬럼명2 [, ...]
    FROM 테이블1 별칭1
        JOIN 테이블2 별칭2 ON (별칭1.공통컬럼2 = 별칭n.공통컬럼2)
        JOIN 테이블n 별칭n ON (별칭1.공통컬럼n = 별칭n.공통컬럼2);
*/
--------------------------------------------------------------------------------------------------------

-- 4) NON-EQUI JOIN : WHERE 조건절에 join attribute를 쓰는 대신 다른 비교연산자(BETWEEN 등)를 사용하여 여러 테이블을 엮는 기법
-- 문제) emp, salgrade 테이블을 사용하여 직원의 급여에 따른 등급을 함께 조회
--  emp 테이블에는 salgrade 테이블과 연결할 동일한 값이 없다.
SELECT
    e.EMPNO
    ,e.ENAME
    ,e.SAL
    ,s.GRADE
    FROM emp e, salgrade s
    WHERE e.SAL BETWEEN s.LOSAL AND s.HISAL -- 누락된 데이터들을 볼 수 없다는 단점이 있다.
;
/* GRADE 1 -> LOSAL 700 미만은 표시 안되서(누락되서) 13명.
7369	SMITH	800	1
7900	JAMES	950	1
7521	WARD	1250	2
7654	MARTIN	1250	2
7934	MILLER	1300	2
7844	TURNER	1500	3
7499	ALLEN	1600	3
7782	CLARK	2450	4
6666	JJ	2800	4
7698	BLAKE	2850	4
7566	JONES	2975	4
7902	FORD	3000	4
7839	KING	5000	5
*/

-- 5). OUTER JOIN : 조인 대상 테이블 중 공통 컬럼에 NULL값인 데이터의 경우도 출력을 원할 때
-- 연산자 : (+), LEFT/RIGHT OUTER JOIN
-- 1. (+) : 오라클이 사용하는 전통적인 OUTER JOIN 연산자. 왼쪽/오른쪽 어느쪽에나 NULL값을 출력하기 원하는 쪽에 붙여서 사용
/*
-- 2. (+) 연산자 사용시 JOIN구문 구조 :
SELECT ...
    FROM 테이블1 별칭1, 테이블2 별칭2
    WHERE 별칭1.공통컬럼(+) = 별칭2.공통컬럼 -- 왼쪽에 (+)가 붙어서 RIGHT OUTER JOIN -> 왼쪽 테이블의 NULL 데이터 출력
    [WHERE 별칭1.공통컬럼 = 별칭2.공통컬럼(+)]; -- 오른쪽에 (+)가 붙어서 LEFT OUTER JOIN -> 오른쪽 테이블의 NULL 데이터 출력
    
-- 3. RIGHT OUTER JOIN ~ ON 구문 구조 :
SELECT ...
    FROM 테이블1 별칭1 RIGHT OUTER JOIN 테이블2 별칭2
    ON 별칭1.공통컬럼 = 별칭2.공통컬럼;
        
-- 4. LEFT OUTER JOIN ~ ON 구문 구조 :
SELECT ...
    FROM 테이블1 별칭1 LEFT OUTER JOIN 테이블2 별칭2
    ON 별칭1.공통컬럼 = 별칭2.공통컬럼;
*/

-- 문제) 직원 중 부서가 배치되지 않은 사람이 있을 때
-- 1. 일반 EQUI JOIN으로는 조회가 안된다.
-- 2. OUTER JOIN -> (+)로 해결
SELECT
    e.EMPNO
    ,e.ENAME
    ,e.SAL
    ,d.DNAME
    FROM emp e, dept d
    WHERE e.DEPTNO = d.DEPTNO(+)    -- (+)는 오른쪽에 -> NULL 나올 테이블은 오른쪽 -> 전체를 기준삼는 테이블은 왼쪽 -> LEFT OUTER JOIN
;
-- 3. LEFT OUTER JOIN ~ ON으로 해결
SELECT
    e.EMPNO
    ,e.ENAME
    ,e.SAL
    ,d.DNAME
    FROM emp e LEFT OUTER JOIN dept d
    ON e.DEPTNO = d.DEPTNO    -- (+)는 오른쪽에 -> NULL 나올 테이블은 오른쪽 -> 전체를 기준삼는 테이블은 왼쪽 -> LEFT OUTER JOIN
;

-- 문제) 아직 아무도 배치되지 않은 부서가 있어도 부서를 다 조회하고 싶다면?
-- 1. (+)로 해결
SELECT
    e.EMPNO
    ,e.ENAME
    ,e.DEPTNO
    ,'|'
    ,d.DNAME
    FROM emp e, dept d
    WHERE e.DEPTNO(+) = d.DEPTNO
;
-- 2. RIGHT OUTER JOIN ~ ON으로 해결
SELECT
    e.EMPNO
    ,e.ENAME
    ,e.DEPTNO
    ,'|'
    ,d.DNAME
    FROM emp e RIGHT OUTER JOIN dept d
        ON e.DEPTNO = d.DEPTNO
;
/*
7839	KING	10	|	ACCOUNTING
7782	CLARK	10	|	ACCOUNTING
7934	MILLER	10	|	ACCOUNTING
7902	FORD	20	|	RESEARCH
7369	SMITH	20	|	RESEARCH
7566	JONES	20	|	RESEARCH
7900	JAMES	30	|	SALES
7844	TURNER	30	|	SALES
7654	MARTIN	30	|	SALES
7521	WARD	30	|	SALES
7499	ALLEN	30	|	SALES
7698	BLAKE	30	|	SALES
			|	OPERATIONS
*/

-- 문제) 부서배치가 안된 직원도 보고싶고, 직원이 아무도 없는 부서도 모두 보고 싶을 때 -> 양쪽 모두 있는 NULL데이터 모두 한 번에 조회하기
/* ORA-01468: a predicate may reference only one outer-joined table
SELECT
    e.EMPNO
    ,d.DNAME
    FROM emp e, dept d
    WHERE e.DEPTNO(+) = d.DEPTNO(+) -- (+)로는 양쪽 아우터 조인이 불가능하다...
;   */
-- FULL OUTER JOIN으로 해결!
SELECT
    e.EMPNO
    ,e.ENAME
    ,d.DNAME
    FROM emp e FULL OUTER JOIN dept d
        ON e.DEPTNO = d.DEPTNO
;
/*
7369	SMITH	RESEARCH
7499	ALLEN	SALES
7521	WARD	SALES
7566	JONES	RESEARCH
7654	MARTIN	SALES
7698	BLAKE	SALES
7782	CLARK	ACCOUNTING
7839	KING	ACCOUNTING
7844	TURNER	SALES
7900	JAMES	SALES
7902	FORD	RESEARCH
7934	MILLER	ACCOUNTING
9999	J_JUNE	
8888	J	
7777	J%JONES	
6666	JJ	
		OPERATIONS
*/

-- 6). SELF JOIN : 한 테이블 내에서 자기 자신의 컬럼 끼리 연결하여 새 행을 만드는 기법
-- 문제) emp 테이블에서 mgr에 해당하는 상사 이름을 같이 조회하고 싶다.
SELECT
    e1.EMPNO    "직원 사번"
    ,e1.ENAME   "직원 이름"
    ,e1.MGR     "상사 사번"
    ,e2.ENAME   "상사 이름"
    FROM emp e1, emp e2
    WHERE e1.MGR = e2.EMPNO
;
/*
7902	FORD	7566	JONES
7900	JAMES	7698	BLAKE
7844	TURNER	7698	BLAKE
7521	WARD	7698	BLAKE
7654	MARTIN	7698	BLAKE
7499	ALLEN	7698	BLAKE
7934	MILLER	7782	CLARK
7782	CLARK	7839	KING
7566	JONES	7839	KING
7698	BLAKE	7839	KING
7369	SMITH	7902	FORD
*/

-- 상사가 없는 직원도 조회하려면
-- a) e1테이블이 기준 -> LEFT OUTER JOIN
SELECT
    e1.EMPNO    "직원 사번"
    ,e1.ENAME   "직원 이름"
    ,e1.MGR     "상사 사번"
    ,e2.ENAME   "상사 이름"
    FROM emp e1 LEFT OUTER JOIN emp e2
        ON e1.MGR = e2.EMPNO
    ORDER BY "직원 사번"
;
-- b) (+)를 오른쪽에
SELECT
    e1.EMPNO    "직원 사번"
    ,e1.ENAME   "직원 이름"
    ,e1.MGR     "상사 사번"
    ,e2.ENAME   "상사 이름"
    FROM emp e1, emp e2
    WHERE e1.MGR = e2.EMPNO(+)
    ORDER BY "직원 사번"
;
/*
6666	JJ		
7369	SMITH	7902	FORD
7499	ALLEN	7698	BLAKE
7521	WARD	7698	BLAKE
7566	JONES	7839	KING
7654	MARTIN	7698	BLAKE
7698	BLAKE	7839	KING
7777	J%JONES		
7782	CLARK	7839	KING
7839	KING		
7844	TURNER	7698	BLAKE
7900	JAMES	7698	BLAKE
7902	FORD	7566	JONES
7934	MILLER	7782	CLARK
8888	J		
9999	J_JUNE		
*/

-- 부하가 없는 직원을 조회하려면
-- a) e2테이블이 기준 -> RIGHT OUTER JOIN
SELECT
    e1.EMPNO    "직원 사번"
    ,e1.ENAME   "직원 이름"
    ,e1.MGR     "상사 사번"
    ,e2.ENAME   "상사 이름"
    FROM emp e1 RIGHT OUTER JOIN emp e2
        ON e1.MGR = e2.EMPNO
    ORDER BY "직원 사번"
;
-- b) (+)를 왼쪽에
SELECT
    e1.EMPNO    "직원 사번"
    ,e1.ENAME   "직원 이름"
    ,e1.MGR     "상사 사번"
    ,e2.ENAME   "상사 이름"
    FROM emp e1, emp e2
    WHERE e1.MGR(+) = e2.EMPNO
    ORDER BY "직원 사번"
;
/*
7369	SMITH	7902	FORD
7499	ALLEN	7698	BLAKE
7521	WARD	7698	BLAKE
7566	JONES	7839	KING
7654	MARTIN	7698	BLAKE
7698	BLAKE	7839	KING
7782	CLARK	7839	KING
7844	TURNER	7698	BLAKE
7900	JAMES	7698	BLAKE
7902	FORD	7566	JONES
7934	MILLER	7782	CLARK
			J
			MILLER
			JAMES
			TURNER
			J%JONES
			MARTIN
			WARD
			ALLEN
			J_JUNE
			JJ
			SMITH
*/

-- 7. 조인과 서브쿼리
-- (2). 서브쿼리 : SUB-QUERY. SELECT/FROM/WHERE절에 사용 가능
-- 문제) BLAKE와 직무가 동일한 직원의 정보를 조회
-- 1. BLAKE의 직무를 조회
SELECT e.JOB
    FROM emp e
    WHERE e.ENAME = 'BLAKE'
;
-- 2. 1의 결과를 WHERE조건 절에 사용하는 메인 쿼리 작성
SELECT
    e.EMPNO
    ,e.ENAME
    ,e.JOB
    FROM emp e
    WHERE e.JOB = (
        SELECT e.JOB
            FROM emp e
            WHERE e.ENAME = 'BLAKE'
        )
;
/* 
7566	JONES	MANAGER
7698	BLAKE	MANAGER
7782	CLARK	MANAGER
*/

-----------------------------------------------------------------
-- 1. 이 회사의 평균 급여보다 급여가 큰 직원 조회
SELECT
    e.EMPNO
    ,e.ENAME
    ,e.SAL
    FROM emp e
    WHERE e.SAL > (
        SELECT
            AVG(e.SAL)
            FROM emp e
        )
;
-- 2. 급여가 평균보다 크면서 사번이 7700번보다 높은 직원 조회
SELECT
    e.EMPNO
    ,e.ENAME
    ,e.SAL
    FROM emp e
    WHERE e.SAL > (
        SELECT
            AVG(e.SAL)
            FROM emp e
        ) AND e.EMPNO > 7700
;
-- 3. 각 직무별로 최대 급여를 받는 직원 목록 조회
SELECT
    e.JOB
    ,MAX(e.SAL) maxSal
    FROM emp e
    GROUP BY e.JOB
;
-- 이하 메인쿼리는 최대급여가 자기 급여와 같은지, 그때 직무가 자기 직무와 같은지 비교
-- 위의 서브쿼리를 통째로 e.SAL과 비교할 수는 없다. 1행 vs 6행이라서.
SELECT
    e.EMPNO
    ,e.ENAME
    ,e.JOB
    ,e.SAL
    FROM emp e
    WHERE (e.JOB, e.SAL) IN (
        SELECT
            e.JOB
            ,MAX(e.SAL) maxSal
            FROM emp e
            GROUP BY e.JOB
    )
;
-- 4. 각 월별 입사인원 세로 출력
SELECT
    TO_CHAR(e.HIREDATE, 'FMMM')
    FROM emp e
;
-- 입사월별 인원 -> 그룹화기준 월 -> 인원 구하는 함수는 COUNT(*)
SELECT
    TO_CHAR(e.HIREDATE, 'MM') || '월' 입사월
    ,COUNT(*) || '명' 인원수
    FROM emp e
    GROUP BY TO_CHAR(e.HIREDATE, 'MM')
    ORDER BY TO_CHAR(e.HIREDATE, 'MM')
;







---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
---------------------------------------DDL---------------------------------------
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

-- DDL : DBMS가 OBJECT(객체)로 관리/인식하는 대상을 생성/수정/삭제하는 언어
-- 생성 : CREATE
-- 수정 : ALTER
-- 삭제 : DROP
-- 사실 DML에서도 비슷한 기능이 있다.
-- 생성 : INSERT
-- 수정 : UPDATE
-- 삭제 : DELETE
/*
CREATE | ALTER | DROP {관리할 객체의 타입명}

DBMS의 객체들 타입
SCHEMA, DOMAIN, TABLE, VIEW, INDEX, SEQUENCE, USER, DATABASE
*/

/*
CREATE TABLE 테이블이름
( 컬럼1이름 데이터타입 [(길이)] [DEFAULT 기본값] [컬럼의 제약사항]
[,컬럼2이름 데이터타입 [(길이)] [DEFAULT 기본값] [컬럼의 제약사항]]
......
[,컬럼n이름 데이터타입 [(길이)] [DEFAULT 기본값] [컬럼의 제약사항]]
);
*/

/* 컬럼의 제약사항 : 이 컬럼에 무슨 규칙을 적용할까?
---------------------------------------------------------------------------------
1. PRIMARY KEY : 이 컬럼에 입력되는 값은 중복되지 않고, 한 행을 유일하게 식별가능한 값으로 설정. NULL 데이터입력이 불가능한 값이어야 한다.
2. FOREIGN KEY : 주로 JOIN에 사용되는 조건. 다른 테이블의 PRIMARY KEY로 사용되었던 값이 등장하도록 설정하는게 보통.
3. UNIQUE : 이 컬럼에 입력되는 값은 중복되지 않음을 보장. 그러나 NULL일 수 있다.
4. NOT NULL : 이 컬럼에 입력되는 값의 중복은 상관없으나, NULL상태가 되지 않도록 보장한다.
---------------------------------------------------------------------------------
결론 : PRIMARY KEY = UNIQUE + NOT NULL의 형태.
*/



-- 예) 아카데미 구성인원 정보를 저장할 테이블을 정의
/*
테이블 이름 : member
1. 멤버 아이디 : member_id : 문자 : VARCHAR2 : PK
2. 멤버 이름 : member_name : 문자 : VARCHAR2 : NOT NULL
3. 전화번호 뒷자리 : phone : 문자 : VARCHAR2
4. 시스템 등록날짜 : reg_date : 날짜 : DATE
5. 사는 곳(동 이름만) : address : 문자 : VARCHAR2
6. 좋아하는 숫자 : like_number : 숫자 : NUMBER
*/



-- 1. 테이블 생성 구문
CREATE TABLE member
(
    member_id   VARCHAR2(3) PRIMARY KEY,
    member_name VARCHAR2(15) NOT NULL,
    phone       VARCHAR2(4), -- NULL 허용시, 제약조건 비우면 된다.
    reg_date    DATE        DEFAULT sysdate,
    address     VARCHAR2(30),
    like_number NUMBER
); -- 결과 : Table MEMBER이(가) 생성되었습니다.



-- 2. 테이블 삭제 구문
DROP TABLE member;  -- 결과 : Table MEMBER이(가) 삭제되었습니다.



-- 3. 테이블 수정 구문
/* 수정의 종류 -------------------------------------------------
1. 컬럼 추가 : ADD
2. 컬럼 삭제 : DROP COLUMN
3. 컬럼 수정 : MODIFY
*/
-- ALTER TABLE 테이블이름{ADD | DROP COLUMN | MODIFY} .... ;

-- 예) 생성한 member 테이블에 컬럼 2개 추가
-- 1) ADD
-- 출생 월 : birth_month : NUMBER / 성별 : gender : VARCHAR2(1)
ALTER TABLE member ADD
(
    birth_month NUMBER,
    gender VARCHAR2(1)
); -- 결과 : Table MEMBER이(가) 변경되었습니다.

-- 예) 수정한 member 테이블에서 like_number 컬럼을 삭제
-- 2) DROP COLUMN
ALTER TABLE member DROP COLUMN like_number;
-- 결과 : Table MEMBER이(가) 변경되었습니다.

-- 예) 출생월 컬럼을 숫자 2자리까지만으로 제한하도록 수정
-- 3) MODIFY
ALTER TABLE member MODIFY birth_month NUMBER(2);
-- 결과 : Table MEMBER이(가) 변경되었습니다.

-- 예로 사용할 member 테이블의 최종형태
CREATE TABLE member
(
    member_id   VARCHAR2(3) PRIMARY KEY,
    member_name VARCHAR2(15) NOT NULL,
    phone       VARCHAR2(4), -- NULL 허용시, 제약조건 비우면 된다.
    reg_date    DATE        DEFAULT sysdate,
    address     VARCHAR2(30),
    birth_month NUMBER(2),
    gender      VARCHAR2(1) CHECK (gender IN ('M', 'F'))
);  -- 가장 단순화된 테이블 정의 구문
-- 제약조건을 각 컬럼 뒤에 바로 이름 없이 생성하는 기법.



-- 테이블 생성시 정의한 제약조건이 저장되는 형태
-- DDL로 정의된 제약조건은 시스템 카탈로그에 저장됨
-- user_constraint 테이블에 저장됨.
SELECT
    u.CONSTRAINT_NAME,
    u.CONSTRAINT_TYPE,
    u.TABLE_NAME
    FROM user_constraints u
    WHERE u.TABLE_NAME = 'MEMBER'
;



-- 제약조건에 이름 부여하기 : 컬럼정의 후 제약조건 정의를 몰아서 작성.
DROP TABLE member;
CREATE TABLE member
(
    member_id   VARCHAR2(3),
    member_name VARCHAR2(15) NOT NULL,
    phone       VARCHAR2(4), -- NULL 허용시, 제약조건 비우면 된다.
    reg_date    DATE        DEFAULT sysdate,
    address     VARCHAR2(30),
    birth_month NUMBER(2),
    gender      VARCHAR2(1),
    CONSTRAINT pk_member PRIMARY KEY (member_id),
    CONSTRAINT ck_member_gender CHECK (gender IN ('M', 'F'))
);

-- 테이블 생성 기법 중 이미 존재하는 테이블로부터 복사 생성
-- 예) 앞서 생성한 member 테이블을 복사 생성 : new_member
DROP TABLE new_member;
CREATE TABLE new_member
AS
SELECT *
    FROM member
    WHERE 1 = 2 -- 항상 거짓
; -- 테이블 구조만 복사하는 방식이라, PK설정은 복사되지 않는다.

-- 오정동에 사는 인원의 정보만 복사해서 새 테이블 생성
-- ojung_member
DROP TABLE ojung_member;
CREATE TABLE ojung_member
AS
SELECT *
    FROM member
    WHERE address = '오정동'
; -- Table OJUNG_MEMBER이(가) 생성되었습니다.

-- 복사할 조건에 항상 참이되는 조건을 주면 모든 데이터를 복사하여 새 테이블 생성
DROP TABLE full_member;
CREATE TABLE full_member;
AS
SELECT *
    FROM member
    WHERE 1 = 1 -- 항상 거짓
;

-- 테이블 수정 시 주의사항
-- 1). 컬럼에 데이터가 없을 때는 타입/크기 변경이 자유롭다.
-- 2). 컬럼에 데이터가 있을 때는 데이터 크기가 동일 혹은 커지는 방향으로만 가능
-- 3). 숫자는 정밀도 증가로만 허용
-- 4). 기본값(default) 설정은 수정 이후 입력값부터 적용

-- 오정동에 사는 멤버만 복사한 ojung_member 테이블에서,
-- 1). 기본값 설정 전 멤버정보 하나 추가 : address가 NULL인 데이터
INSERT INTO "SCOTT"."OJUNG_MEMBER" (MEMBER_ID, MEMBER_NAME, PHONE, BIRTH_MONTH, GENDER) VALUES ('M99', '홍길동', '0000', '9', 'M');
-- 2). 홍길동 정보 입력 후 기본값으로 설정
ALTER TABLE ojung_member MODIFY (address DEFAULT '오정동');
-- 3). 기본값 설정 후 새 멤버 추가
INSERT INTO "SCOTT"."OJUNG_MEMBER" (MEMBER_ID, MEMBER_NAME, PHONE, BIRTH_MONTH, GENDER) VALUES ('M98', '허균', '9999', '7', 'M');

-- 이미 데이터가 들어있는 컬럼 크기 변경
-- 예) ojung_member 테이블의 출생월 birth_month 컬럼을 1칸으로 줄이면
ALTER TABLE ojung_member MODIFY birth_month NUMBER(1); -- ORA-01440: column to be modified must be empty to decrease precision or scale
ALTER TABLE ojung_member MODIFY birth_month NUMBER(10, 2); -- ALTER TABLE ojung_member MODIFY birth_month NUMBER(10, 2);
-- 숫자데이터를 확장하는 방식으로 변경 성공

-- 예) 출생월 birth_month를 문자 2자리로 변경?
ALTER TABLE ojung_member MODIFY birth_month VARCHAR2(2); -- ORA-01439: column to be modified must be empty to change datatype
-- 데이터 타입변경을 위해서는 값을 비워야 한다.



-- (3) 데이터 무결성 제약 조건 처리 방법 4가지
-- 1. 컬럼 정의할 때 제약 조건 이름 없이 바로 선언
DROP TABLE main_table;
CREATE TABLE main_table
(
    id          VARCHAR2(10)    PRIMARY KEY
    ,nickname   VARCHAR2(30)    UNIQUE
    ,reg_date   DATE            DEFAULT sysdate
    ,gender     VARCHAR2(1)     CHECK (gender IN ('F', 'M'))
    ,message    VARCHAR2(300)
);
DROP TABLE sub_table;
CREATE TABLE sub_table
(
    id          VARCHAR2(10)    REFERENCES main_table(id)
    ,sub_code   NUMBER(4)       NOT NULL
    ,sub_name   VARCHAR2(30)
);

-- 생성된 제약조건 확인 쿼리
SELECT u.CONSTRAINT_NAME, u.CONSTRAINT_TYPE, u.TABLE_NAME
    FROM user_constraints u
    WHERE u.TABLE_NAME IN ('MAIN_TABLE', 'SUB_TABLE')
;

-- 2. 컬럼 정의할 때 제약 조건 이름 주며 선언
DROP TABLE main_table;
CREATE TABLE main_table
(
    id          VARCHAR2(10)    CONSTRAINT pk_main_table        PRIMARY KEY
    ,nickname   VARCHAR2(30)    CONSTRAINT pk_main_table_nick   UNIQUE
    ,reg_date   DATE            DEFAULT sysdate
    ,gender     VARCHAR2(1)     CONSTRAINT pk_main_table_gender CHECK (gender IN ('F', 'M'))
    ,message    VARCHAR2(300)
);
DROP TABLE sub_table;
CREATE TABLE sub_table
(
    id          VARCHAR2(10)    CONSTRAINT fk_sub_table         REFERENCES main_table(id)
    ,sub_code   NUMBER(4)       NOT NULL
    ,sub_name   VARCHAR2(30)
);

-- 3. 컬럼 정의 후 제약 조건 따로 선언
DROP TABLE main_table;
CREATE TABLE main_table
(
    id          VARCHAR2(10)    
    ,nickname   VARCHAR2(30)    
    ,reg_date   DATE            DEFAULT sysdate
    ,gender     VARCHAR2(1)     
    ,message    VARCHAR2(300)
    ,CONSTRAINT pk_main_table        PRIMARY KEY(id)
    ,CONSTRAINT pk_main_table_nick   UNIQUE(nickname)
    ,CONSTRAINT pk_main_table_gender CHECK (gender IN ('F', 'M'))
);
DROP TABLE sub_table;
CREATE TABLE sub_table
(
    id          VARCHAR2(10)    
    ,sub_code   NUMBER(4)       NOT NULL
    ,sub_name   VARCHAR2(30)
    ,CONSTRAINT fk_sub_table    FOREIGN KEY(id) REFERENCES main_table(id)
    ,CONSTRAINT pk_sub_table    FOREIGN KEY(id) REFERENCES main_table(id)
);

-- 4. 테이블 정의 후 테이블 수정(ALTER TABLE)으로 제약조건 추가
DROP TABLE sub_table;
DROP TABLE main_table;

-- 제약조건 없는 테이블 생성
CREATE TABLE main_table
(
    id          VARCHAR2(10)    
    ,nickname   VARCHAR2(30)    
    ,reg_date   DATE            DEFAULT sysdate
    ,gender     VARCHAR2(1)     
    ,message    VARCHAR2(300)
);

-- 제약조건 사후추가
ALTER TABLE main_table ADD
(
    CONSTRAINT pk_main_table4         PRIMARY KEY(id)
    ,CONSTRAINT pk_main_table_nick4   UNIQUE(nickname)
    ,CONSTRAINT pk_main_table_gender4 CHECK (gender IN ('F', 'M'))
);

CREATE TABLE sub_table
(
    id          VARCHAR2(10)    
    ,sub_code   NUMBER(4)       NOT NULL
    ,sub_name   VARCHAR2(30)
);

-- 제약조건 사후추가
ALTER TABLE main_table ADD
(
    CONSTRAINT fk_sub_table4    FOREIGN KEY(id) REFERENCES main_table(id)
    ,CONSTRAINT pk_sub_table4   FOREIGN KEY(id) REFERENCES main_table(id)
);



-- 테이블 이름의 변경 : RENAME
-- ojung_member -> member_of_ojung
RENAME ojung_member TO member_of_ojung;

-- 테이블 삭제
DROP TABLE main_table;  -- sub_table의 id컬럼이 main_table의 것을 참조하기 때문에 안된다.
DROP TABLE main_table CASCADE CONSTRAINT;   -- sub_table과의 참조 관계가 끊어지며 바로 삭제됨.