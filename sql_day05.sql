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