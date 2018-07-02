-- Day 05 : SQL
-------------------------------------------------------------------------------------------------------------------------------
-- Oracle의 특별한 컬럼

-- 1. ROWID : 물리적으로 디스크에 저장된 위치를 가리키는 값. 유일. ORDER BY절에 의해 변경되지 않는다.
-- 예) emp 테이블에서 'SMITH'인 사람의 정보
SELECT
    e.EMPNO
    ,e.ENAME
    FROM emp e
    WHERE e.ENAME = 'SMITH'
;
-- rowid를 같이 조회하면
SELECT
    e.rowid
    ,e.EMPNO
    ,e.ENAME
    FROM emp e
    WHERE e.ENAME = 'SMITH'
; -- AAAE6sAAEAAAAFbAAA 7369 SMITH
-- rowid는 ORDER BY에 의해 변경되지 않는다.
SELECT
    e.rowid
    ,e.EMPNO
    ,e.ENAME
    FROM emp e
    ORDER BY e.EMPNO
;

-- 2. ROWNUM : 조회된 결과의 첫번째 행부터 1로 증가하는 값
SELECT
    ROWNUM
    ,e.EMPNO
    ,e.ENAME
    FROM emp e
    WHERE e.ENAME LIKE 'J%'
;
/*
1	7566	JONES
2	7900	JAMES
3	9999	J_JUNE
4	8888	J
5	7777	J%JONES
6	6666	JJ
*/
SELECT  -- 정렬 있는 버전
    ROWNUM
    ,e.EMPNO
    ,e.ENAME
    FROM emp e
    WHERE e.ENAME LIKE 'J%'
    ORDER BY e.ENAME
;
/*
4	8888	J
5	7777	J%JONES
2	7900	JAMES
6	6666	JJ
1	7566	JONES
3	9999	J_JUNE
*/
-- 위의 두 결과를 비교하면 rownum도 ORDER BY에 영향을 받지 않는 것처럼 보이나,
-- Sub-Query로 사용할 때 영향을 받음.
SELECT
    rownum
    ,a.EMPNO
    ,a.ENAME
    ,a.deli
    ,a.numrow
    FROM (
        SELECT
            e.EMPNO
            ,e.ENAME
            ,'|' as deli
            ,rownum as numrow
            FROM emp e
            WHERE e.ENAME LIKE 'J%'
            ORDER BY e.ENAME) a
;





-------------------------------------------------------------------------------------------------------------------------------
-- DML : 데이터 조작 언어
-------------------------------------------------------------------------------------------------------------------------------
-- 1) INSERT : 테이블에 데이터 행(row) 추가하는 명령
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
    CONSTRAINT ck_member_gender CHECK (gender IN ('M', 'F')),
    CONSTRAINT ck_member_birth CHECK (birth_month > 0 AND birth_month <= 12)
);
DESC member;    -- 테이블 구조 확인



-- 1. INTO구문에 컬럼 이름 생략시 데이터 추가
INSERT INTO member
VALUES ('M01', '전현찬', '5250', sysdate, '덕명동', 11, 'M');
INSERT INTO member
VALUES ('M02', '조성철', '9034', sysdate, '오정동', 8, 'M');
INSERT INTO member
VALUES ('M03', '김승유', '5219', sysdate, '오정동', 1, 'M');

-- 몇몇 컬럼에 null 추가
INSERT INTO member
VALUES ('M04', '박길수', '4003', sysdate, NULL, NULL, 'M');
INSERT INTO member
VALUES ('M05', '강현', NULL, NULL, '홍도동', 6, 'M');
INSERT INTO member
VALUES ('M06', '김소민', NULL, sysdate, '월평동', NULL, NULL);

-- 입력데이터 조회
SELECT m.*
    FROM member m
;

-- Check 옵션에 위배되는 데이터 추가
INSERT INTO member
VALUES ('M07', '강병우', '2260', sysdate, '사정동', 2, 'N');  -- 성별(gender)의 M을 N으로 썼다.
-- ORA-02290: check constraint (SCOTT.CK_MEMBER_GENDER) violated
INSERT INTO member
VALUES ('M08', '정준호', NULL, sysdate, '나성동', 0, NULL);   -- 생월(birth_month)을 0으로 넣었다.
-- ORA-02290: check constraint (SCOTT.CK_MEMBER_BIRTH) violated

-- 위의 것을 수정
INSERT INTO member
VALUES ('M07', '강병우', '2260', sysdate, '사정동', 2, 'M');
INSERT INTO member
VALUES ('M08', '정준호', NULL, sysdate, '나성동', 1, NULL);



-- 2. INTO구문에 컬럼 이름 명시하여 데이터 추가
-- VALUE절에 INTO 순서대로 값의 타입과 개수를 맞춰서 작성.
INSERT INTO member (member_id, member_name, gender)
VALUES ('M09', '윤홍식', 'M');
-- reg_date 컬럼은 DEFAULT 설정이 작동하여 시스템 날짜가 자동 입력.
-- phone, address 컬럼은 null값으로 설정됨.

-- INTO절에 컬럼 나열 시 테이블 정의 순서와 별개로 나열 가능
INSERT INTO member (member_name, address, member_id)
VALUES ('이주영', '용전동', 'M10');

-- PK값이 중복된 입력
INSERT INTO member (member_name, member_id)
VALUES ('남정규', 'M10');
-- ORA-00001: unique constraint (SCOTT.PK_MEMBER) violated

-- 수정 : 이름 컬럼에 주소가 들어간 논리오류 (둘 다 문자데이터)
INSERT INTO member (member_name, member_id)
VALUES ('목동', 'M11');

-- 필수 입력 컬럼 member_name 누락
INSERT INTO member (member_id)
VALUES ('M12');
-- ORA-01400: cannot insert NULL into ("SCOTT"."MEMBER"."MEMBER_NAME")

INSERT INTO member (member_id, member_name)
VALUES ('M12', '이동희');

-- INTO절에 나열된 컬럼과 VALUES절의 값의 개수가 불일치
INSERT INTO member (member_id, member_name, gender)
VALUES ('M13', '유재성');
-- ORA-00947: not enough values

-- INTO절에 나열된 컬럼과 VALUES절의 데이터 타입이 불일치
INSERT INTO member (member_id, member_name, birth_month)
VALUES ('M13', '유재성', 'M');   -- gender(M or F)를 생월에
-- ORA-01722: invalid number
INSERT INTO member (member_id, member_name, birth_month)
VALUES ('M13', '유재성', 3);



-----------------------------------------------------------------
-- 다중 행 입력 : sub-query를 쓰면 가능

-- 구문구조 :
INSERT INTO 테이블이름
SELECT 문장;  -- 서브쿼리

-- CREATE AS SELECT : 데이터 복사하여 테이블 생성
-- INSERT INTO ~ SELECT : 이미 만들어진 테이블에 데이터만 복사추가

-- member 테이블 내용을 조회 -> new_member로 삽입
INSERT INTO new_member
SELECT m.*
    FROM member m
    WHERE m.PHONE IS NOT NULL
;   -- 5개 행 이(가) 삽입되었습니다.

INSERT INTO new_member
SELECT m.*
    FROM member m
    WHERE m.MEMBER_ID > 'M09'
;   -- 4개 행 이(가) 삽입되었습니다.

-- NEW_MEMBER 테이블 데이터 삭제 후 데이터 반영
-- 성이 '김'인 멤버데이터를 복사입력
INSERT INTO new_member
SELECT m.*
    FROM member m
    WHERE m.MEMBER_NAME LIKE '김%'
;

-- 짝수달에 태어난 멤버데이터를 복사입력
INSERT INTO new_member
SELECT m.*
    FROM member m
    WHERE mod(m.BIRTH_MONTH, 2) = 0
;





---------------------------------------------------------------------------------------------
-- 2) UPDATE : 테이블의 행을 수정. WHERE 조건에 따라 1행 또는 다행 수정이 가능.

-- member테이블에서 이름이 잘못들어간 m11멤버정보 수정하기
-- 데이터 수정 전 영구반영을 실행.
commit;

UPDATE member m
    SET m.MEMBER_NAME = '남정규'
    WHERE m.MEMBER_ID = 'M11'
; -- 1 행 이(가) 업데이트되었습니다.

-- 'M05' 회원의 전화번호 필드 업데이트
commit;
UPDATE member m
    SET m.PHONE = '1743'
    --WHERE m.MEMBER_ID = 'M05'
;   -- 13 행 이(가) 업데이트되었습니다.
-- WHERE 조건절의 실수 -> DML 작업 실수
-- 데이터 상태 되돌리기
rollback;   -- 롤백 완료. / 마지막 커밋 상태까지 되돌린다.

-- 2개 이상의 컬럼을 한 번에 업데이트
UPDATE member m
    SET m.PHONE = '1743'
        ,m.REG_DATE = sysdate
    WHERE m.MEMBER_ID = 'M05'
;
commit;

-- 월평동에 사는 김소민의 NULL 업데이트
UPDATE member m
    SET m.PHONE = '4724'
        ,m.BIRTH_MONTH = 1
        ,m.GENDER = 'F'
    WHERE m.MEMBER_ID = 'M06'
;
-- WHERE가 주소나 이름 등으로 하면, 같은 정보의 사람들 모두가 정보가 수정된다. 그래서 WHERE는 주의해서.

/*
DML : UPDATE / DELETE 작업 시 주의
딱 하나의 데이터를 수정/삭제하려면
WHERE절의 비교조건에 반드시 PK로 설정한
컬럼의 값을 비교하도록 권장한다.
PK는 전체 행 중 유일하고, NOT NULL이 보장되기 때문.
UPDATE / DELETE는 구문에 물리적 오류가 없으면
WHERE조건에 맞는 전체 행 대상으로 작업하는게 기본.
*/

-- UPDATE 구문에 SELECT 서브쿼리 사용
-- 'M08' 아이디의 phone, gender 수정
-- 가장 권장되는 PK조건 구문
UPDATE member m
    SET m.PHONE = '3318'
        ,m.GENDER = 'M'
    WHERE m.MEMBER_ID = 'M08'
;

-- 서브쿼리 사용하기
UPDATE member m
    SET m.PHONE = '3318'
        ,m.GENDER = 'M'
    WHERE m.ADDRESS = (
        SELECT m.ADDRESS
            FROM member m
            WHERE m.MEMBER_ID = 'M08'
    )
;

-- M13 유재성 멤버의 성별 업데이트
UPDATE member m
    SET m.GENDER = (
        SELECT substr('Male',1,1)
            FROM dual
    )
    WHERE m.MEMBER_ID = 'M13'
;

-- M12 데이터 gender컬럼 수정 시 제약조건 위반
UPDATE member m
    SET m.GENDER = 'N'
    WHERE m.MEMBER_ID = 'M12'
; -- ORA-02290: check constraint (SCOTT.CK_MEMBER_GENDER) violated

-- address가 null인 사람들의 주소를 일괄 '대전'으로 변경하자.
UPDATE member m
    SET m.ADDRESS = '대전'
    WHERE m.ADDRESS IS NULL
; -- 5개 행 이(가) 업데이트되었습니다.
commit;





-------------------------------------------------------------------------------------------
-- 3) DELETE : 테이블에서 행단위로 데이터 삭제

-- 1. WHERE 조건이 있는 DELETE 구문
-- gender가 F인 데이터를 삭제
-- 삭제 전 커밋해라.
commit;
DELETE member m
    WHERE m.GENDER = 'F'    -- M, F 외의 다른 알파벳을 쓰면 0개 행 삭제. 구문 오류 아님. 논리 오류.
;
-- WHERE 조건 절 만족하는 모든 행을 삭제. 그래서 이걸 잘 줘야 한다. PK 걸어서 삭제하는 방법 추천.
-- 데이터 되돌림.
rollback;

-- M99 1행을 삭제하고 싶다면 PK로 삭제하자.
DELETE member m
    WHERE m.MEMBER_ID = 'M99'
;
commit;



-- 2. WHERE 조건을 누락하면 전체삭제.
DELETE member;



-- 3. DELETE의 WHERE에 서브쿼리.
-- 주소가 대전인 사람 모두 삭제
-- (1) 주소가 대전인 사람들 조회
SELECT m.*
    FROM member m
    WHERE m.ADDRESS = '대전'
;

-- (2) 삭제하는 메인쿼리 작성
DELETE member m
    WHERE m.MEMBER_ID IN (
        SELECT m.*
            FROM member m
            WHERE m.ADDRESS = '대전'
    )
;
rollback;

-- 일반 where조건버전
DELETE member m
    WHERE m.ADDRESS = '대전'
;
rollback;



-----------------------------------------------------------------------
-- DELETE vs TRUNCATE
/*
1. TRUNCATE는 DDL에 속하는 명령어다. Rollback지점을 생성하지 않는다. 그래서 되돌릴 수 없음.
2. TRUNCATE는 WHERE절 조합이 안되므로 특정 데이터 선별하여 삭제하는 게 불가능.
*/
-- new_member 테이블 TRUNCATE로 날려보기

-- 실행 전 커밋지점 생성.
commit;

-- new_member 내용확인
SELECT *
    FROM new_member m
;
/*
M03	김승유	5219	18/07/02	오정동	1	M
M06	김소민		18/07/02	월평동		
M02	조성철	9034	18/07/02	오정동	8	M
M05	강현			홍도동	6	M
M07	강병우	2260	18/07/02	사정동	2	M
*/

-- TRUNCATE로 new_member 테이블 잘라내기
TRUNCATE TABLE new_member;

-- new_member 내용확인
SELECT *
    FROM new_member m
;-- 1행도 나오지 않는다.

-- 되돌릴 수 있나? 안된다.
rollback;

-- DDL 종류 구문은 생성 즉시 자동으로 커밋을 하기 때문이다. 롤백의 시점은 이미 DDL 실행 이후로 잡혔다.





------------------------------------------------------------------------------------------------------------------------------
-- TCL : Transaction Control Language
-- 1). COMMIT
-- 2). ROLLBACK
-- 3). SAVEPOINT
commit;
-- 1. new_member에 1행 추가
INSERT INTO new_member(MEMBER_ID, MEMBER_NAME) -- 1 행 이(가) 삽입되었습니다.
    VALUES ('M01', '홍길동')
;
-- 1행 추가 상태까지 중간저장
SAVEPOINT do_insert; -- Savepoint이(가) 생성되었습니다.

-- 2. 홍길동 데이터의 주소 수정
UPDATE new_member m
    SET m.ADDRESS = '율도국'
    WHERE m.MEMBER_ID = 'M01'
;

-- 주소 수정 상태까지 중간저장
SAVEPOINT do_update_addr; -- Savepoint이(가) 생성되었습니다.

-- 3. 전화번호 수정
UPDATE new_member m
    SET m.PHONE = '0001'
    WHERE m.MEMBER_ID = 'M01'
;

-- 전화번호 수정 상태까지 중간저장
SAVEPOINT do_update_phone; -- Savepoint이(가) 생성되었습니다.

-- 4. gender 수정
UPDATE new_member m
    SET m.GENDER = 'M'
    WHERE m.MEMBER_ID = 'M01'
;
-- gender 수정 상태까지 중간저장
SAVEPOINT do_update_gender; -- Savepoint이(가) 생성되었습니다.

-- 홍길동 데이터 롤백 시나리오
-- 1. 주소 수정까지는 맞는데, 전화번호와 성별 수정이 잘못되었을 때
ROLLBACK TO do_update_addr;

-- 2. 주소, 전화번호까지는 맞는데, 성별 수정이 잘못되었을 때
ROLLBACK TO do_update_phone;
-- savepoint 'DO_UPDATE_PHONE' never established in this session or is invalid
-- SAVEPOINT의 순서가 앞서기 때문에, 한 번 롤백이 일어나면 그 후에 만든 SAVEPOINT는 다 삭제된다.

-- 3. 2번 수행 후 어디까지 롤백 가능?
ROLLBACK TO do_update_addr;
ROLLBACK TO do_insert;
ROLLBACK;
-- SAVEPOINT로 한번 되돌아가면 되돌아간 시점 이후 생성된 SAVEPOINT는 무효화됨.




----------------------------------------------------------------------------------------------------------------------------
-- 시퀀스 SEQUENCE : 기본 키 등으로 사용되는 일련번호 생성 객체.
-- 1. 시작번호 : 1, 최대 : 30, 사이클 없는 시퀀스 생성
CREATE SEQUENCE seq_member_id
START WITH 1
MAXVALUE 30
NOCYCLE
; -- Sequence SEQ_MEMBER_ID이(가) 생성되었습니다.

-- 시퀀스가 생성되면 유저 딕셔너리에 정보가 저장됨 : user_sequences
SELECT
     s.SEQUENCE_NAME
    ,s.MIN_VALUE
    ,s.MAX_VALUE
    ,s.CYCLE_FLAG
    ,s.INCREMENT_BY
    ,s.CACHE_SIZE
    FROM user_sequences s
    WHERE s.SEQUENCE_NAME = 'SEQ_MEMBER_ID'
;
-- 이름이 다른 객체와 같을 수는 없다.
CREATE SEQUENCE new_member
START WITH 1
MAXVALUE 30
NOCYCLE
; -- ORA-00955: name is already used by an existing object

-- 사용자의 객체가 저장되는 딕셔너리 테이블
SELECT
      o.OBJECT_NAME
    , o.OBJECT_TYPE
    , o.OBJECT_ID
    FROM user_objects o
;

/*
메타 데이터를 저장하는 유저 딕셔너리
-------------------------------
무결성 제약조건 : user_constraints
시퀀스 생성정보 : user_sequences
테이블 생성정보 : user_tables
인덱스 생성정보 : user_indexes
객체들 생성정보 : user_objects
-------------------------------
*/



-- 2. 생성된 시퀀스 사용하기
-- (1) NEXTVAL : 시퀀스의 다음 번호를 생성, CREATE되고나서 반드시 최초에 한번은 NEXTVAL 호출되어야 생성 시작됨.
-- 사용법 : 시퀀스이름.NEXTVAL
SELECT SEQ_MEMBER_ID.NEXTVAL
    FROM dual
; -- MAXVALUE 이상 생성하면 오류.

-- (2) CURRVAL : 시퀀스에서 현재 생성된 번호 확인. 시퀀스 생성 후 NEXTVAL 한 번도 호출된 적 없으면 비활성화 상태.
-- 사용법 : 시퀀스이름.CURRVAL
SELECT SEQ_MEMBER_ID.CURRVAL
    FROM dual
;

CREATE SEQUENCE seq_test;
DROP SEQUENCE seq_test;



-- 3. 시퀀스 수정 : ALTER SEQUENCE
-- 생성된 시퀀스의 MAXVALUE 옵션을 NOMAXVALUE로 바꾸기
ALTER SEQUENCE seq_member_id
    NOMAXVALUE
; -- Sequence SEQ_MEMBER_ID이(가) 변경되었습니다.
-- SEQ_MEMBER_ID	1	9999999999999999999999999999



-- 4. 시퀀스 삭제 : DROP SEQUENCE
-- 생성한 시퀀스 seq_member_id 삭제
DROP SEQUENCE seq_member_id; -- Sequence SEQ_MEMBER_ID이(가) 삭제되었습니다.

-- 존재하지 않는 시퀀스에서 CURRVAL 시도하면?
SELECT SEQ_MEMBER_ID.CURRVAL
    FROM dual
; -- ORA-02289: sequence does not exist

-- 멤버 아이디에 조합한 시퀀스 신규 생성
CREATE SEQUENCE seq_member_id
START WITH 1
NOMAXVALUE
NOCYCLE
;

-- 일괄적으로 증가하는 값을 멤버아이디로 자동생성
-- 'M01', 'M02', ...'M0x' 이런 형태의 값을 조합
SELECT 'M' || LPAD(seq_member_id.NEXTVAL, 2, 0) as member_id
    FROM dual
;

INSERT INTO new_member(member_id, member_name)
VALUES (
    SELECT 'M' || LPAD(seq_member_id.CURRVAL, 2, 0) as member_id
    FROM dual,
);



----------------------------------------------------------------------------------------------
-- INDEX : 데이터의 검색(조회)시 일정한 검색 속도를 보장하기 위하여 DBMS가 관리하는 객체
-- 1. user_indexes 딕셔너리에서 검색
SELECT
      i.INDEX_NAME
    , i.INDEX_TYPE
    , i.TABLE_NAME
    , i.TABLE_OWNER
    , i.INCLUDE_COLUMN
    FROM user_indexes i
;
/* PK로 준 컬럼들과, 직접 만든 인덱스들이 나온다.
PK_MEMBER	NORMAL	MEMBER	SCOTT	
PK_EMP	NORMAL	EMP	SCOTT	
PK_DEPT	NORMAL	DEPT	SCOTT	
idx_cust_userid	NORMAL	CUSTOMER	SCOTT	
*/

-- 2. 테이블의 주기(PK) 컬럼에 대해서는 이미 DBMS가 자동으로 인덱스를 생성한다.
-- 따라서 또 생성 시도시 불가능.
-- 예) member 테이블의 member_id 컬럼에 인덱스 생성 시도
CREATE INDEX idx_member_id
ON member (member_id); -- ORA-01408: such column list already indexed   아이디가 달라도 소용없다.
-- 테이블의 주기 컬럼에 이미 있으므로, 인덱스 이름이 달라도 생성 불가.

-- 3. 복사한 테이블인 new_member에는 PK가 없으므로 인덱스도 없는 상태.
-- new_member 테이블에 index 생성 시도.
CREATE INDEX idx_new_member_id
ON new_member(member_id); -- Index IDX_NEW_MEMBER_ID이(가) 생성되었습니다.

-- user_indexes 딕셔너리에서 검색.
SELECT
      i.INDEX_NAME
    , i.INDEX_TYPE
    , i.TABLE_NAME
    , i.TABLE_OWNER
    , i.INCLUDE_COLUMN
    FROM user_indexes i
;
/*
IDX_NEW_MEMBER_ID	NORMAL	NEW_MEMBER	SCOTT	여기 한 줄 생성됨.
PK_MEMBER	NORMAL	MEMBER	SCOTT	
PK_EMP	NORMAL	EMP	SCOTT	
PK_DEPT	NORMAL	DEPT	SCOTT	
idx_cust_userid	NORMAL	CUSTOMER	SCOTT	
*/

-- (2) 대상 컬럼이 중복 값이 없는 컬럼임이 확실하다면 UNIQUE 인덱스 생성이 가능.
DROP INDEX IDX_NEW_MEMBER_ID;

CREATE UNIQUE INDEX IDX_NEW_MEMBER_ID
    ON new_member(member_id)
;

-- INDEX가 명시적으로 사용되는 경우
-- 오라클에 빠른 검색을 위해 HINT절을 SELECT에 사용하는 경우가 존재.