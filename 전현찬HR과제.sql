SELECT *
    FROM employees e
;

--1. employees 테이블에서 job_id 를 중복 배제하여 조회 하고
--   job_title 같이 출력
--19건
SELECT DISTINCT e.JOB_ID, j.JOB_TITLE
    FROM employees e, JOBS j
    WHERE e.JOB_ID = j.JOB_ID
;
/*
AD_ASST	Administration Assistant
SA_REP	Sales Representative
IT_PROG	Programmer
MK_MAN	Marketing Manager
AC_MGR	Accounting Manager
FI_MGR	Finance Manager
AC_ACCOUNT	Public Accountant
PU_MAN	Purchasing Manager
SH_CLERK	Shipping Clerk
FI_ACCOUNT	Accountant
AD_PRES	President
SA_MAN	Sales Manager
MK_REP	Marketing Representative
AD_VP	Administration Vice President
PU_CLERK	Purchasing Clerk
ST_MAN	Stock Manager
ST_CLERK	Stock Clerk
HR_REP	Human Resources Representative
PR_REP	Public Relations Representative
*/



--2. employees 테이블에서 사번, 라스트네임, 급여, 커미션 팩터,
--   급여x커미션팩터(null 처리) 조회
--   커미션 컬럼에 대해 null 값이면 0으로 처리하도록 함
--107건
SELECT 
    e.EMPLOYEE_ID
    ,e.LAST_NAME
    ,e.SALARY
    ,NVL(e.COMMISSION_PCT, 0) COMMISSION_PCT
    ,e.SALARY * NVL(e.COMMISSION_PCT, 0) "SAL*COMM"
    FROM employees e
;
/*
100	King	24000	0	0
101	Kochhar	17000	0	0
102	De Haan	17000	0	0
103	Hunold	9000	0	0
104	Ernst	6000	0	0
105	Austin	4800	0	0
106	Pataballa	4800	0	0
107	Lorentz	4200	0	0
108	Greenberg	12008	0	0
109	Faviet	9000	0	0
110	Chen	8200	0	0
111	Sciarra	7700	0	0
112	Urman	7800	0	0
113	Popp	6900	0	0
114	Raphaely	11000	0	0
115	Khoo	3100	0	0
116	Baida	2900	0	0
117	Tobias	2800	0	0
118	Himuro	2600	0	0
119	Colmenares	2500	0	0
120	Weiss	8000	0	0
121	Fripp	8200	0	0
122	Kaufling	7900	0	0
123	Vollman	6500	0	0
124	Mourgos	5800	0	0
125	Nayer	3200	0	0
126	Mikkilineni	2700	0	0
127	Landry	2400	0	0
128	Markle	2200	0	0
129	Bissot	3300	0	0
130	Atkinson	2800	0	0
131	Marlow	2500	0	0
132	Olson	2100	0	0
133	Mallin	3300	0	0
134	Rogers	2900	0	0
135	Gee	2400	0	0
136	Philtanker	2200	0	0
137	Ladwig	3600	0	0
138	Stiles	3200	0	0
139	Seo	2700	0	0
140	Patel	2500	0	0
141	Rajs	3500	0	0
142	Davies	3100	0	0
143	Matos	2600	0	0
144	Vargas	2500	0	0
145	Russell	14000	0.4	5600
146	Partners	13500	0.3	4050
147	Errazuriz	12000	0.3	3600
148	Cambrault	11000	0.3	3300
149	Zlotkey	10500	0.2	2100
150	Tucker	10000	0.3	3000
151	Bernstein	9500	0.25	2375
152	Hall	9000	0.25	2250
153	Olsen	8000	0.2	1600
154	Cambrault	7500	0.2	1500
155	Tuvault	7000	0.15	1050
156	King	10000	0.35	3500
157	Sully	9500	0.35	3325
158	McEwen	9000	0.35	3150
159	Smith	8000	0.3	2400
160	Doran	7500	0.3	2250
161	Sewall	7000	0.25	1750
162	Vishney	10500	0.25	2625
163	Greene	9500	0.15	1425
164	Marvins	7200	0.1	720
165	Lee	6800	0.1	680
166	Ande	6400	0.1	640
167	Banda	6200	0.1	620
168	Ozer	11500	0.25	2875
169	Bloom	10000	0.2	2000
170	Fox	9600	0.2	1920
171	Smith	7400	0.15	1110
172	Bates	7300	0.15	1095
173	Kumar	6100	0.1	610
174	Abel	11000	0.3	3300
175	Hutton	8800	0.25	2200
176	Taylor	8600	0.2	1720
177	Livingston	8400	0.2	1680
178	Grant	7000	0.15	1050
179	Johnson	6200	0.1	620
180	Taylor	3200	0	0
181	Fleaur	3100	0	0
182	Sullivan	2500	0	0
183	Geoni	2800	0	0
184	Sarchand	4200	0	0
185	Bull	4100	0	0
186	Dellinger	3400	0	0
187	Cabrio	3000	0	0
188	Chung	3800	0	0
189	Dilly	3600	0	0
190	Gates	2900	0	0
191	Perkins	2500	0	0
192	Bell	4000	0	0
193	Everett	3900	0	0
194	McCain	3200	0	0
195	Jones	2800	0	0
196	Walsh	3100	0	0
197	Feeney	3000	0	0
198	OConnell	2600	0	0
199	Grant	2600	0	0
200	Whalen	4400	0	0
201	Hartstein	13000	0	0
202	Fay	6000	0	0
203	Mavris	6500	0	0
204	Baer	10000	0	0
205	Higgins	12008	0	0
206	Gietz	8300	0	0
*/
 
 
 
--3. employees 테이블에서 사번, 라스트네임, 급여, 커미션 팩터(null 값 처리) 조회
--   단, 2007년 이 후 입사자에 대하여 조회, 고용년도 순 오름차순 정렬
--30건
SELECT 
    e.EMPLOYEE_ID
    ,e.LAST_NAME
    ,e.SALARY
    ,NVL(e.COMMISSION_PCT, 0) COMMISSION_PCT
    FROM employees e
    WHERE TO_CHAR(e.HIRE_DATE, 'YYYY') >= 2007
    ORDER BY e.HIRE_DATE
;
/*
127	Landry	2400	0
107	Lorentz	4200	0
187	Cabrio	3000	0
171	Smith	7400	0.15
195	Jones	2800	0
163	Greene	9500	0.15
172	Bates	7300	0.15
132	Olson	2100	0
104	Ernst	6000	0
178	Grant	7000	0.15
198	OConnell	2600	0
182	Sullivan	2500	0
119	Colmenares	2500	0
148	Cambrault	11000	0.3
124	Mourgos	5800	0
155	Tuvault	7000	0.15
113	Popp	6900	0
135	Gee	2400	0
191	Perkins	2500	0
179	Johnson	6200	0.1
199	Grant	2600	0
164	Marvins	7200	0.1
149	Zlotkey	10500	0.2
183	Geoni	2800	0
136	Philtanker	2200	0
165	Lee	6800	0.1
128	Markle	2200	0
166	Ande	6400	0.1
167	Banda	6200	0.1
173	Kumar	6100	0.1
*/



--4. Finance 부서에 소속된 직원의 목록 조회
SELECT
    e.EMPLOYEE_ID
    ,e.FIRST_NAME
    ,e.LAST_NAME
    ,e.JOB_ID
    FROM employees e
    WHERE e.JOB_ID LIKE 'FI%'
;
--조인으로 해결
SELECT
    e.EMPLOYEE_ID
    ,e.FIRST_NAME
    ,e.LAST_NAME
    ,e.JOB_ID
    FROM employees e JOIN jobs j ON (e.JOB_ID = j.JOB_ID AND j.JOB_ID LIKE 'FI%')
;
--서브쿼리로 해결 -- 아직 못함...
SELECT j.JOB_ID
    FROM jobs j
    WHERE j.JOB_ID LIKE 'FI%'
;
SELECT
    e.EMPLOYEE_ID
    ,e.FIRST_NAME
    ,e.LAST_NAME
    FROM employees e
;
--6건
/*
109	Daniel	Faviet	FI_ACCOUNT
110	John	Chen	FI_ACCOUNT
111	Ismael	Sciarra	FI_ACCOUNT
112	Jose Manuel	Urman	FI_ACCOUNT
113	Luis	Popp	FI_ACCOUNT
108	Nancy	Greenberg	FI_MGR
*/


 
--5. Steven King 의 직속 부하직원의 모든 정보를 조회
--14건
-- 조인 이용


-- 서브쿼리 이용



 
--6. Steven King의 직속 부하직원 중에서 Commission_pct 값이 null이 아닌 직원 목록
--5건

--7. 각 job 별 최대급여를 구하여 출력 job_id, job_title, job별 최대급여 조회
--19건


 
--8. 각 Job 별 최대급여를 받는 사람의 정보를 출력,
--  급여가 높은 순서로 출력
----서브쿼리 이용
 
----join 이용


--20건

--9. 7번 출력시 job_id 대신 Job_name, manager_id 대신 Manager의 last_name, department_id 대신 department_name 으로 출력
--20건


--10. 전체 직원의 급여 평균을 구하여 출력


--11. 전체 직원의 급여 평균보다 높은 급여를 받는 사람의 목록 출력. 급여 오름차순 정렬
--51건

--12. 각 부서별 평균 급여를 구하여 출력
--12건

--13. 12번의 결과에 department_name 같이 출력
--12건


--14. employees 테이블이 각 job_id 별 인원수와 job_title을 같이 출력하고 job_id 오름차순 정렬


--15. employees 테이블의 job_id별 최저급여,
--   최대급여를 job_title과 함께 출력 job_id 알파벳순 오름차순 정렬


 
--16. Employees 테이블에서 인원수가 가장 많은 job_id를 구하고
--   해당 job_id 의 job_title 과 그 때 직원의 인원수를 같이 출력




--17.사번,last_name, 급여, 직책이름(job_title), 부서명(department_name), 부서매니저이름
--  부서 위치 도시(city), 나라(country_name), 지역(region_name) 을 출력
----------- 부서가 배정되지 않은 인원 고려 ------


--18.부서 아이디, 부서명, 부서에 속한 인원숫자를 출력



--19.인원이 가장 많은 상위 다섯 부서아이디, 부서명, 인원수 목록 출력


 
--20. 부서별, 직책별 평균 급여를 구하여라.
--   부서이름, 직책이름, 평균급여 소수점 둘째자리에서 반올림으로 구하여라.



--21.각 부서의 정보를 부서매니저 이름과 함께 출력(부서는 모두 출력되어야 함)


 
--22. 부서가 가장 많은 도시이름을 출력



--23. 부서가 없는 도시 목록 출력
--조인사용

--집합연산 사용

--서브쿼리 사용

  
--24.평균 급여가 가장 높은 부서명을 출력



--25. Finance 부서의 평균 급여보다 높은 급여를 받는 직원의 목록 출력


-- 26. 각 부서별 인원수를 출력하되, 인원이 없는 부서는 0으로 나와야 하며
--     부서는 정식 명칭으로 출력하고 인원이 많은 순서로 정렬.



--27. 지역별 등록된 나라의 갯수 출력(지역이름, 등록된 나라의 갯수)



 
--28. 가장 많은 나라가 등록된 지역명 출력