-- sql day01
---------------------------------------------------------------------
-- �⺻ ���� ȯ�� ����
---------------------------------------------------------------------
-- 1. SCOTT ���� Ȱ��ȭ : sys �������� �����Ͽ� ��ũ��Ʈ ����
@C:\oraclexe\app\oracle\product\11.2.0\server\rdbms\admin\scott.sql
-- 2. ���� ���� Ȯ�� ���
SHOW USER
-- 3. HR ���� Ȱ��ȭ : sys �������� ����
-- �ٸ� ����� Ȯ�� �� HR ������ �������, ��й�ȣ �������
-- ������ �����ϴ� ���̺� ��� ��ȸ
SELECT *
    FROM tab
;
---------------------------------------------------------------------
-- SCOTT ������ ������ ����

-- (1) EMP ���̺� ���� ��ȸ : ��� ���̺�
SELECT *
	FROM emp
;
/*
7369	SMITH	CLERK	    7902	80/12/17	800		20
7499	ALLEN	SALESMAN	7698	81/02/20	1600	300	    30
7521	WARD	SALESMAN	7698	81/02/22	1250	500	    30
7566	JONES	MANAGER	    7839	81/04/02	2975		    20
7654	MARTIN	SALESMAN	7698	81/09/28	1250	1400	30
7698	BLAKE	MANAGER	    7839	81/05/01	2850		    30
7782	CLARK	MANAGER	    7839	81/06/09	2450		    10
7839	KING	PRESIDENT   		81/11/17	5000		    10
7844	TURNER	SALESMAN	7698	81/09/08	1500	0	    30
7900	JAMES	CLERK	    7698	81/12/03	950		30
7902	FORD	ANALYST	    7566	81/12/03	3000		    20
7934	MILLER	CLERK	    7782	82/01/23	1300		    10
*/

-- (2) DEPT ���̺� ���� ��ȸ : �μ� ���̺�
SELECT *
	FROM dept
;
/*
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	    CHICAGO
40	OPERATIONS	BOSTON
*/

-- (3) SALGRADE ���̺� ���� ��ȸ : �޿���� ���̺�
SELECT *
	FROM salgrade
;
/*
1	700	    1200
2	1201	1400
3	1401	2000
4	2001	3000
5	3001	9999
*/

---------------------------------------------------------------------

-- 01. DQL

-- (1) SELECT ����
-- 1) emp ���̺��� ���/�̸�/������ ��ȸ
SELECT e.EMPNO
    ,  e.ENAME
    ,  e.JOB
    FROM emp e -- e�� alias(��Ī)
;
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
*/

-- 2) emp ���̺��� ������ ��ȸ
SELECT e.JOB
    FROM emp e -- e�� alias(��Ī)
;
/*
CLERK
SALESMAN
SALESMAN
MANAGER
SALESMAN
MANAGER
MANAGER
PRESIDENT
SALESMAN
CLERK
ANALYST
CLERK
*/

-- (2) DISTINCT ���� : SELECT�� ���� �ߺ� �����Ͽ� ��ȸ
-- 3) emp ���̺��� job �÷��� �ߺ��� �����Ͽ� ��ȸ
SELECT DISTINCT e.JOB
    FROM emp e -- e�� alias(��Ī)
;
/*
CLERK
SALESMAN
PRESIDENT
MANAGER
ANALYST
*/

-- * SQL SELECT ������ �۵� ���� : ���̺��� �� ���� �⺻ ������ �����Ѵ�. ���̺��� ���� ������ŭ �ݺ�����.
SELECT 'Hello, SQL~'
    FROM emp e
;

-- 4) emp ���̺��� job, deptno�� ���� �ߺ� ���� ��ȸ
SELECT DISTINCT 
    e.job
    ,e.DEPTNO
    FROM emp e
;
/*
MANAGER	    20
PRESIDENT	10
CLERK	    10
SALESMAN	30
ANALYST	    20
MANAGER	    30
MANAGER	    10
CLERK	    30
CLERK	    20
*/

-- (3) ORDER BY �� : ����
-- 5) emp ���̺��� job�� �ߺ�����, ������������ �����Ͽ� ��ȸ, ���ı��� �� ���� ���������� �⺻.
SELECT DISTINCT
    e.JOB
    FROM emp e
    ORDER BY e.JOB  -- ASC �ᵵ �ǰ� �Ƚᵵ �ȴ�. = ��������
;
-- 6) emp ���̺��� job�� �ߺ�����, ������������ �����Ͽ� ��ȸ
SELECT DISTINCT
    e.JOB
    FROM emp e
    ORDER BY e.JOB DESC
;
/*
���� X...
CLERK
SALESMAN
PRESIDENT
MANAGER
ANALYST

��������...
ANALYST
CLERK
MANAGER
PRESIDENT
SALESMAN

��������...
SALESMAN
PRESIDENT
MANAGER
CLERK
ANALYST
*/

-- 7) emp ���̺��� comm�� ���� ���� �޴� ������� ���
-- ���, �̸�, ����, �Ի���, Ŀ�̼� ������ ��ȸ
SELECT e.EMPNO
    , e.ENAME
    , e.JOB
    , e.HIREDATE
    , e.COMM
    FROM emp e
    ORDER BY e.COMM DESC
;
/* COMM ��������, null�� ū �����ٵ� ���� ���´�.
7369	SMITH	CLERK	    80/12/17	
7698	BLAKE	MANAGER	    81/05/01	
7902	FORD	ANALYST	    81/12/03	
7900	JAMES	CLERK	    81/12/03	
7839	KING	PRESIDENT	81/11/17	
7566	JONES	MANAGER	    81/04/02	
7934	MILLER	CLERK	    82/01/23	
7782	CLARK	MANAGER	    81/06/09	
7654	MARTIN	SALESMAN	81/09/28	1400
7521	WARD	SALESMAN	81/02/22	500
7499	ALLEN	SALESMAN	81/02/20	300
7844	TURNER	SALESMAN	81/09/08	0
*/

-- 8) emp ���̺��� comm�� ���� �������, ������ ������������, �̸��� ������������ ��ȸ
-- ���, �̸�, ����, �Ի���, Ŀ�̼��� ��ȸ
SELECT e.EMPNO
    , e.ENAME
    , e.JOB
    , e.HIREDATE
    , e.COMM
    FROM emp e
    ORDER BY e.COMM, e.JOB, e.ENAME
;
/* Ŀ�̼� -> ���� -> �̸� �켱������ ���ĵ�. ����� ���Դ��� �� ��������.
7844	TURNER	SALESMAN	81/09/08	0
7499	ALLEN	SALESMAN	81/02/20	300
7521	WARD	SALESMAN	81/02/22	500
7654	MARTIN	SALESMAN	81/09/28	1400
7902	FORD	ANALYST 	81/12/03	
7900	JAMES	CLERK	    81/12/03	
7934	MILLER	CLERK	    82/01/23	
7369	SMITH	CLERK	    80/12/17	
7698	BLAKE	MANAGER	    81/05/01	
7782	CLARK	MANAGER	    81/06/09	
7566	JONES	MANAGER	    81/04/02	
7839	KING	PRESIDENT	81/11/17	
*/

-- 9) emp ���̺��� comm�� ���� �������, ������ ��������, �̸��� ������������ ����
-- ���, �̸�, ����, �Ի���, Ŀ�̼� ��ȸ
SELECT e.EMPNO
    , e.ENAME
    , e.JOB
    , e.HIREDATE
    , e.COMM
    FROM emp e
    ORDER BY e.COMM, e.JOB, e.ENAME DESC
;
/* Ŀ�̼� -> ���� -> �̸� �켱������ ���ĵ�.
7844	TURNER	SALESMAN	81/09/08	0
7499	ALLEN	SALESMAN	81/02/20	300
7521	WARD	SALESMAN	81/02/22	500
7654	MARTIN	SALESMAN	81/09/28	1400
7902	FORD	ANALYST	    81/12/03	
7369	SMITH	CLERK	    80/12/17	
7934	MILLER	CLERK	    82/01/23	
7900	JAMES	CLERK	    81/12/03	
7566	JONES	MANAGER 	81/04/02	
7782	CLARK	MANAGER 	81/06/09	
7698	BLAKE	MANAGER 	81/05/01	
7839	KING	PRESIDENT	81/11/17	
*/
---------------------------------------------------------------------