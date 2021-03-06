-------------------------------------------------------
-- VIEW : 논리적으로만 존재하는 가상 테이블
-------------------------------------------------------

-- 1. SCOTT 계정에 VIEW 생성 권한 설정
CONN sys as sysdba
GRANT CREATE VIEW TO SCOTT;
CONN SCOTT/TIGER;

-- 2. emp, dept 복사
DROP TABLE new_emp;
DROP TABLE new_dept;

CREATE TABLE new_emp
AS
SELECT *
    FROM emp
    WHERE 1=1
;
CREATE TABLE new_dept
AS
SELECT *
    FROM emp
    WHERE 1=1
;

-- 3. 복사 테이블에 누락된 PK 설정 ALTER
-- new_dept에 pk 설정
ALTER TABLE new_dept ADD
(
    CONSTRAINT pk_new_dept PRIMARY KEY (deptno)
);
-- new_emp PK 설정
ALTER TABLE new_emp ADD
(
    CONSTRAINT pk_new_emp PRIMARY KEY (empno),
    CONSTRAINT fk_new_deptno FOREIGN KEY (deptno) REFERENCES new_dept(deptno),
    CONSTRAINT fk_new_emp_mgr FOREIGN KEY (mgr) REFERENCES new_emp(empno)
);

-- 4. 복사 테이블에서 view 생성
-- 상사이름, 부서명, 부서위치까지 조회할 수 있는 뷰
CREATE OR REPLACE VIEW v_emp_dept
AS
SELECT e1.EMPNO
     , e1.ENAME
     , e2.ENAME mgr_name
     , e1.DEPTNO
     , d.DNAME
     , d.LOC
    FROM new_emp e1
       , new_emp e2
       , new_dept d
    WHERE e1.deptno = d.deptno(+)
      AND e1.mgr = e2.empno(+)
      WITH READ ONLY
;

-- 5. 생성된 뷰의 구조 확인
DESC v_emp_dept;

-- 6. 뷰 정보는 딕셔너리에 저장됨. 딕셔너리 확인하기.
-- user_views
DESC user_views;

SELECT u.VIEW_NAME
     , u.TEXT
     , u.READ_ONLY
    FROM user_views u
;

-- 7. 생성된 뷰에서 데이터 확인
-- 1) 전체 데이터 조회
SELECT v.*
    FROM v_emp_dept v
;

-- 2) SALES 이름 부서의 소속 직원 조회
SELECT v.empno
     , v.ENAME
     , v.DNAME
    FROM v_emp_dept v
    WHERE v.DNAME = 'SALES'
;