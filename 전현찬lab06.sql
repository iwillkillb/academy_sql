-- (9) PL/SQL 변수의 종류
-- 실습7)
CREATE OR REPLACE PROCEDURE log_execution
(   v_log_user      IN log_table.USERID%TYPE
,   v_log_date      OUT log_table.LOG_DATE%TYPE)
IS
BEGIN
    SELECT l.LOG_DATE
        INTO v_log_date
        FROM log_table l
        WHERE l.USERID = v_log_user
    ;
END log_execution;
/

-- 실습8)
CREATE OR REPLACE PROCEDURE sp_chng_date_format
(
    v_date    IN OUT DATE
)
IS
BEGIN
    -- 1. 입력된 초기상태 값 출력
    DBMS_OUTPUT.PUT_LINE('초기 입력 값 : ' || v_date);
    -- 2. 숫자 패턴화 변경
    v_date := TO_CHAR(v_date, 'YYYY Mon dd');
    -- 3. 화면 출력으로 변경된 패턴 확인
    DBMS_OUTPUT.PUT_LINE('패턴 적용 값 : ' || v_date);
END sp_chng_date_format;
/

VAR v_date_bind VARCHAR2(20);
EXEC :v_date_bind := TO_CHAR(sysdate);
-- EXEC sp_chng_date_format(:(TO_DATE(v_date_bind)));
PRINT v_date_bind;

-- 실습9)
/*
CREATE OR REPLACE PROCEDURE insert_dept
(
    v_dname     IN VARCHAR2(20),
    v_loc       IN VARCHAR2(20)
)
IS
    -- 1. RECORD 타입의 선언
    TYPE dept_record_type IS RECORD
    (
        r_dname     DEPT.DNAME % TYPE,
        r_loc       DEPT.LOC % TYPE,
    );
    -- 2. 1에서 선언한 타입의 변수를 선언
    v_dept_record    dept_record_type;
BEGIN
    SELECT e.EMPNO
        INTO v_dept_record
        FROM dept d
        WHERE d.DNAME = v_dname
    ;
END insert_dept;
*/
-- 실습10)
-- 1. 위치에 의한 전달법
EXEC insert_dept(1000, :v_out_number_bind);
-- 2. 변수명에 의한 전달
EXEC insert_dept(in_number=>2000, out_number => :v_out_number_bind);
EXEC insert_dept(out_number => :v_out_number_bind, in_number=>3000);
-- 이후에 확인해라.
PRINT v_out_number_bind;

-- 실습11)
CREATE OR REPLACE PROCEDURE sp_get_comm
(
    v_empno IN EMP.EMPNO%TYPE,
    v_comm OUT EMP.COMM%TYPE
)
IS  
     EMP.JOB%TYPE; -- 사번의 직원 직무를 저장할 지역변수
BEGIN
    -- 1. 입력된 사번 직원의 직무를 조회
    SELECT e.JOB
        INTO v_job
        FROM emp e
        WHERE e.EMPNO = v_empno
    ;
    -- 2. v_comm 계산
    IF v_job = 'SALESMAN' THEN v_comm :=1000;
    ELSIF v_job = 'MANAGER' THEN v_comm := 1500;
    ELSE v_comm := 500;
    END IF;
END sp_get_comm;
/
VAR v_comm_bind NUMBER;
EXEC sp_get_comm(v_comm => :v_comm_bind, v_empno => 7566);
PRINT v_comm_bind;

-- 실습12)
DECLARE
    -- 1. 초기값 변수 선언 및 초기화
    v_init NUMBER := 0;
BEGIN
    LOOP
        v_init := v_init + 1;
        DBMS_OUTPUT.PUT_LINE(v_init);
        
        -- 종료 조건
        EXIT WHEN v_init = 10;
    END LOOP;
END;
/

-- 실습13)
DECLARE
    cnt NUMBER := 0;    -- 카운터 변수.
BEGIN
    FOR cnt IN REVERSE 1 .. 20 LOOP
        IF (MOD(cnt, 2) = 0) THEN
            DBMS_OUTPUT.PUT_LINE('2의 배수 ' || cnt);
        END IF;
    END LOOP;
END;
/
/*
2의 배수 20
2의 배수 18
2의 배수 16
2의 배수 14
2의 배수 12
2의 배수 10
2의 배수 8
2의 배수 6
2의 배수 4
2의 배수 2


PL/SQL 프로시저가 성공적으로 완료되었습니다.
*/

-- 실습14)
DECLARE
    cnt NUMBER := 1;
BEGIN
    WHILE cnt <= 10 LOOP
        DBMS_OUTPUT.PUT_LINE(cnt);
        cnt := cnt + 1;
    END LOOP;
END;
/
/*
1
2
3
4
5
6
7
8
9
10


PL/SQL 프로시저가 성공적으로 완료되었습니다.
*/

-- 실습15)
CREATE OR REPLACE FUNCTION emp_sal_avg
(
    v_job IN EMP.JOB % TYPE   -- 입력받을 부서번호
)
RETURN NUMBER
IS
    v_avg_sal EMP.SAL % TYPE;   -- 부서별 급여평균을 저장
BEGIN
    SELECT avg(e.SAL)   -- 이것을 구해서
        INTO v_avg_sal  -- 이것에 저장
        FROM emp e
        WHERE e.JOB = v_job   -- 입력받은 부서번호와 같으면
    ;
    RETURN ROUND(v_avg_sal);
    
END emp_sal_avg;
/
-- 실습16)
SELECT emp_sal_avg('SALESMAN') as "부서 급여 평균"
    FROM dual
;
SELECT -- 검증
    AVG(e.SAL)
    FROM emp e
    GROUP BY e.JOB
    HAVING e.JOB = 'SALESMAN'
; -- 결과 : 함수사용, 검증결과 둘 다 1400

-- 실습17)
SELECT
    e.ENAME,
    e.SAL,
    e.COMM
    FROM emp e
    WHERE e.SAL > emp_sal_avg('SALESMAN')
;
/*
ALLEN	1600	300
JONES	2975	
BLAKE	2850	
CLARK	2450	
KING	5000	
TURNER	1500	0
FORD	3000	
JJ	2800	
*/

-- 실습18)
CREATE OR REPLACE PROCEDURE sp_insert_dept
(
    v_dept_id IN DEPT.DEPTNO % TYPE,
    v_dept_name IN DEPT.DNAME % TYPE,
    v_dept_loc IN DEPT.LOC % TYPE,
    result_msg OUT VARCHAR2
)
IS
BEGIN
    -- 입력된 IN 모드 변수 값을 INSERT 시도.
    INSERT INTO DEPT (DEPTNO, DNAME, LOC)
    VALUES (v_dept_id, v_dept_name, v_dept_loc)
    ;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('부서 레코드 추가');
    result_msg := '부서 레코드 추가';
    
    -- 입력시도에는 항상 DUP_VAL_ON_INDEX 예외의 위험이 존재한다.
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX
        THEN -- 이미 존재하는 값이면 생성이 아닌 수정으로 진행
            UPDATE DEPT d
                SET
                    d.DNAME = v_dept_name,
                    d.LOC = v_dept_loc
                WHERE d.DEPTNO = v_dept_id
            ;
            -- 처리 화면을 화면 출력
            DBMS_OUTPUT.PUT_LINE('부서 레코드 변경');
            result_msg := '부서 레코드 변경';
END sp_insert_dept;
/
VAR insert_dept_msg_bind VARCHAR2(20);
EXEC sp_insert_dept (50, 'UNKNOWN', 'DAEJEON', :insert_dept_msg_bind);
PRINT insert_dept_msg_bind;
/*
부서 레코드 변경


명령의 246 행에서 시작하는 중 오류 발생 -
BEGIN sp_insert_dept (50, 'UNKNOWN', 'DAEJEON', :insert_dept_msg_bind); END;
오류 보고 -
ORA-06502: PL/SQL: numeric or value error: character string buffer too small
ORA-06512: at "SCOTT.SP_INSERT_DEPT", line 30
ORA-00001: unique constraint (SCOTT.PK_DEPT) violated
ORA-06512: at line 1
06502. 00000 -  "PL/SQL: numeric or value error%s"
*Cause:    An arithmetic, numeric, string, conversion, or constraint error
           occurred. For example, this error occurs if an attempt is made to
           assign the value NULL to a variable declared NOT NULL, or if an
           attempt is made to assign an integer larger than 99 to a variable
           declared NUMBER(2).
*Action:   Change the data, how it is manipulated, or how it is declared so
           that values do not violate constraints.

INSERT_DEPT_MSG_BIND
--------------------------------------------------------------------------------

DEPT 테이블에 새로운 레코드 추가됨.
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	CHICAGO
40	OPERATIONS	BOSTON
50	UNKNOWN	DAEJEON
/