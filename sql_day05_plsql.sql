----------------------------------
-- PL / SQL
----------------------------------
-- 1. ANONYMOUS PROCEDURE : 이름 없이 1회 실행 저장 프로시저

-- 출력 설정 SQL*PLUS 명령
SHOW SERVEROUTPUT
;   -- 기본 접속 설정
SET SERVEROUTPUT ON
;   -- 새로 접속을 할 때마다 OFF가 되어 있으므로, 항상 ON으로 해놓고 시작하자.
-- serveroutput ON SIZE UNLIMITED FORMAT WORD_WRAPPED

-- 1) 변수선언이 있는 ANONYMOUS PROCEDURE 작성.
/*
DECLARE
    -- 변수 선언부
    name VARCHAR2(20) := 'Hannam Univ'; -- 선언과 동시에 값 저장
    year NUMBER; -- 선언만 하고 값 저장 안함.
BEGIN
    -- 프로시저에서 실행할 로직을 작성
    -- 일반적으로 SQL 구문처리가 들어감.
    -- 변수 처리, 비교, 반복 등의 로직이 들어감.
    year := 1956; -- year 변수에 값 저장
    DBMS_OUTPUT.put_line(name || ' since ' || year);
END;
-- 위의 프로시저를 아래처럼 수정해보자.
-- DECLARE에서는 변수만 선언
-- BEGIN에서는 값을 저장
-- 출력
*/
DECLARE
    -- 변수 선언부
    name VARCHAR2(20);
    year NUMBER;
BEGIN
    name := '한밭대학교';
    year := 1927;
    DBMS_OUTPUT.put_line(name || ' since ' || year);
END;

-- 2) 변수 선언이 없는 1회용 프로시저는 DECLARE블록 생략 가능
BEGIN
    DBMS_OUTPUT.put_line('한남대 개교는 1965년');
END;
/

-----------------------------------------
-- 2. STORED PROCEDURE : (SP) 저장 프로시저
-----------------------------------------
-- 반복적으로 호출하여 사용하기 위한 목적으로
-- PROCEDURE를 DBMS에 선 컴파일하여 저장하고 사용하는 객체.

-- TABLE, SEQUENCE, INDEX, VIEW 등과 같은 객체이므로, 동일한 이름의 다른 테이블명 등으로 생성 불가능.

-- 1) 저장 프로시저(SP)의 생성
CREATE OR REPLACE PROCEDURE sp_maxim
(   name       IN VARCHAR2
,   message    IN VARCHAR2)
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE(name || ' : ' || message);
END sp_maxim;
/

-- 2) Oracle SQL Developer에서는 Ctrl + Enter -> 컴파일.
--      SQL*PLUS 명령창(Run SQL Command Line) 코드 붙여놓기로 컴파일 가능
-- Procedure SP_MAXIM이(가) 컴파일되었습니다.
-- 저장 프로시저는 컴파일과 동시 실행이 아니라 컴파일만 실행. 실행은 따로 해야 함.
-- 구문에 오류가 있으면 오류와 함께 컴파일이 진행되서, 오류상태로 컴파일된 프로시저는 실행이 안된다.

-- 3) 오류 상태로 컴파일되면 오류 수정 후 재컴파일 진행
-- 재컴파일 진행을 쉽게 하기 위해서,
-- CREATE OR REPLACE 옵션 사용을 권장.
-- 오류가 있다면 SHOW ERRORS 명령으로 오류 확인 가능. (SQL*PLUS 명령)

-- 4) 실행
-- a. BIND 변수를 선언 (OUT 변수가 선언된 경우에만)
-- b. EXECUTE 명령을 실행
-- c. PRINT 명령으로 BIND 변수 값 출력 (OUT 변수가 선언된 경우에만)

-- EXECUTE 프로시저이름(전달할값1, 전달할값2) : SQL*PLUS 명령
EXECUTE SP_MAXIM('소크라테스', '너 자신을 알라');
EXECUTE SP_MAXIM('홍길동', '호부호형을 못하니...');
EXECUTE SP_MAXIM('데카르트', '나는 생각한다. 고로 존재한다.');
EXECUTE SP_MAXIM('장 폴 사르트르', '인생은 B와 D사이의 C이다.');
/*
소크라테스 : 너 자신을 알라


PL/SQL 프로시저가 성공적으로 완료되었습니다.

홍길동 : 호부호형을 못하니...


PL/SQL 프로시저가 성공적으로 완료되었습니다.

데카르트 : 나는 생각한다. 고로 존재한다.


PL/SQL 프로시저가 성공적으로 완료되었습니다.

장 폴 사르트르 : 인생은 B와 D사이의 C이다.


PL/SQL 프로시저가 성공적으로 완료되었습니다.
*/



-- 입력 인자가 없는 sp 작성
CREATE OR REPLACE PROCEDURE sp_maxim_noargs
IS 
    -- 지역변수 선언 블록, BEGIN ~ END 사이에서 사용되는 변수 선언부
    -- 변수타입 선언시 크기까지 지정
    name       VARCHAR2(30)  := '소크라테스';
    message    VARCHAR2(100) := '너 자신을 알라';
BEGIN
    DBMS_OUTPUT.PUT_LINE(name || ' : ' || message);
END sp_maxim_noargs;
/
-- Procedure SP_MAXIM_NOARGS이(가) 컴파일되었습니다.

EXECUTE sp_maxim_noargs;
/*
소크라테스 : 너 자신을 알라


PL/SQL 프로시저가 성공적으로 완료되었습니다.
*/



---------------------------------------------------
-- OUT모드 변수가 있는 SP
-- 1) OUT 모드 변수를 만들어준다.
CREATE OR REPLACE PROCEDURE sp_maxim
(   name       IN VARCHAR2
,   message    IN VARCHAR2
,   result     OUT VARCHAR2)
IS
BEGIN
    -- 블록 안에서 바로 출력
    DBMS_OUTPUT.PUT_LINE(name || ' : ' || message);
    -- result OUT 변수에 저장
    result := name || ' : ' || message;
END sp_maxim;
/
-- Procedure SP_MAXIM이(가) 컴파일되었습니다.

-- 2) 실행을 위해
-- a. BIND 변수를 선언 : SQL*PLUS 의 변수
-- VAR[IABLE] 바인드변수이름 타입
VAR v_maxim_result VARCHAR2(200);   -- Procedure SP_MAXIM이(가) 컴파일되었습니다.
PRINT v_maxim_result;
-- b. EXECUTE로 SP 실행
EXECUTE sp_maxim('소크라테스', '너 자신을 알라', :v_maxim_result);
/*
소크라테스 : 너 자신을 알라


PL/SQL 프로시저가 성공적으로 완료되었습니다.
*/
PRINT v_maxim_result;
/*
V_MAXIM_RESULT
--------------------------------------------------------------------------------
소크라테스 : 너 자신을 알라
*/