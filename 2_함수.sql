--함수 : 컬럼의 값을 읽어서 연산한 결과를 반환한다.

--단일행(SINGLE ROW) 함수  :  N의 값을 읽어서 N개의 결과를 반환

--그룹(GROUP) 함수 : N개의 값을 읽어 1개의 결과를 반환.

--함수는 SELECT / WHERE/ORDER BY/GROUP BY/HAVING에서 사용 가능.


--단일행 함수-------------------------------------

--LENGTH(문자열 | 컬럼) : 문자열 길이 반환

SELECT LENGTH('HELLO WORLD') FROM DUAL;

--이메일이 12글자인 이메일에만 조회
SELECT EMAIL, LENGTH(EMAIL)AS 길이
FROM EMPLOYEE
WHERE LENGTH(EMAIL)=12;

----------------------------------------------
-- INSTR('문자열' | 컬럼명, '찾을문자', [찾을 위치 시작위치, [순번]])
-- 지정한 위치부터 지정한 순번째로 검색되는 문자의 시작 위치를 반환

SELECT INSTR('AABAACAABBAA','B',5)
FROM DUAL;


--EMPLOYEE 테이블에서 사원명,이메일,이메일중 @ 위치 조회
SELECT EMP_NAME,EMAIL,INSTR(EMAIL,'@')
FROM EMPLOYEE;

-- SUBSTR('문자열' | 컬럼명, 잘라내기 시작할 위치 [, 잘라낼 길이]  )
-- 컬럼이나 문자열에서 지정한 위치부터 지정된 길이만큼 문자열을 잘라내서 반환
--> 잘라낼 길이 생략 시 끝까지 잘라냄


-- 사원명 / 이메일중에 아이디만 조회
SELECT EMP_NAME,SUBSTR(EMAIL,1,INSTR(EMAIL,'@')-1)아이디
FROM EMPLOYEE
ORDER BY 아이디;

------------------------------------------
-- TRIM([옵션] '문자열' | 컬럼명 [FROM '문자열'|컬럼명]  )
-- 주어진 컬럼이나 문자열의 앞, 뒤, 양쪽에 있는 지정된 문자를 제거
--> (보통 양쪽 공백 제거에 많이 사용)

-- 옵션 :  LEADING(앞쪽), TRAILING(뒤쪽), BOTH(양쪽, 기본값)

SELECT '            KH          ',TRIM('    K H     ') FROM DUAL;

SELECT '---KH---', TRIM('-' FROM'---KH---') FROM DUAL;
--BOTH 또는 생략시 : 양쪽 '-' 기호 제거
-- LEADING : 앞쪽만 제거
--TRAILING : 뒤쪽만 제거



/*숫자 관련 함수*/

--ABS ( 숫자 | 칼럼명) : 절대 값
SELECT ABS(10) , ABS(-10) FROM DUAL;

--MOD(숫자 | 컬럼명 , 숫자|컬럼명) : 나머지 값 반환
SELECT MOD(10,3) FROM DUAL;
--EMPLOYEE 테이블에서 사원의 월급을 100만으로 나눴을 때 나머지 조회
SELECT EMP_NAME,SALARY,MOD(SALARY,1000000)
FROM EMPLOYEE;


--ROUND (숫자 | 컬럼명 [,소수점 위치])  :반올림
SELECT 123.456, ROUND(123.456) FROM DUAL;
SELECT 123.456, ROUND(123.456,2) FROM DUAL;

SELECT ROUND(123.456,0) FROM DUAL;  --소수점 첫째 자리에서 반올림
SELECT ROUND(123.456,-1) FROM DUAL; --소수점 0번째 자리에서 반올림
SELECT ROUND(123.456,-2) FROM DUAL; -- 소수점 1번 자리에서 반올림


----------------------------------------------------------------------

--CEIL(숫자 | 컬럼명) : 천장/올림
--FLOOR(숫자| 컬럼명) : 바닥 /내림

SELECT 123.4 , CEIL(123.4),FLOOR(123.4) FROM DUAL;


-- TRUNC(숫자 | 컬럼명[,위치]) : 버림 특정 위치 아래를 버림 

SELECT TRUNC(123.456,-2), TRUNC(123.456,1) FROM DUAL;

SELECT TRUNC(-123.4),FLOOR(-123.5)
FROM DUAL;


-------------------------------------------------------------------

--날짜(DATE)관련 함수

--SYSDATE : 시스템에 현재 시간(년,월,일,시,분,초)을 반환
SELECT SYSDATE FROM DUAL;

--SYSTIMESTAMP : SYSDATE + MS 단위 추가

SELECT SYSTIMESTAMP FROM DUAL;


--MONTHS _BETWEEN(날짜, 날짜) : 두 날짜의 개월 수 차이 반환.

SELECT ROUND( MONTHS_BETWEEN(SYSDATE,'2022/02/21') )|| '개월'AS 수강기간 FROM DUAL;

SELECT ROUND(MONTHS_BETWEEN(SYSDATE,'2022/01/01'))FROM DUAL;

--EMPLOYEE 테이블에서 
--사원의 이름,입사일,현재 근무 개월수 ,근무 년도 조회
SELECT EMP_NAME,HIRE_DATE,
CEIL( MONTHS_BETWEEN(SYSDATE,HIRE_DATE) ) ||'개월 차' "근무 개월 수",
CEIL( MONTHS_BETWEEN(SYSDATE,HIRE_DATE)/12) ||'년 차' AS "근무 해 수" 
FROM EMPLOYEE
ORDER BY 4;


------------------------------------------------------------------
--ADD_MONTH(날짜, 숫자) : 날짜에 숫자만큼의 개월 수를 더함.
SELECT ADD_MONTHS(SYSDATE,4) +7 FROM DUAL;

--LAST_DAY(날짜) : 해당 달의 마지막 날짜를 구함.
SELECT LAST_DAY(SYSDATE) FROM DUAL;

SELECT LAST_DAY('2022/04/01') FROM DUAL;

---------------------------------------------------------------------
-- EXTRACT : 년, 월, 일 정보를 추출하여 리턴
-- EXTRACT(YEAR FROM 날짜) : 년도만 추출
-- EXTRACT(MONTH FROM 날짜) : 월만 추출
-- EXTRACT(DAY FROM 날짜) : 일만 추출

--EMPLOYEE 테이블에서 각 사원의 이름 , 입사 년도,입사 월 ,입사 일 조회

SELECT EMP_NAME,
EXTRACT(YEAR FROM HIRE_DATE)"입사 년도",
EXTRACT(MONTH FROM HIRE_DATE)"입사 월",
EXTRACT(DAY FROM HIRE_DATE)"입사 일"
FROM EMPLOYEE
WHERE EXTRACT(MONTH FROM HIRE_DATE)=1;

---------------------------------------------
--형변환 함수.
--문자열(CHAR) , 숫자(NUNBER) , 날짜(DATE)끼리 형변환 가능

-- TO_CHAR(날짜, [포맷]) : 날짜형 데이터를 문자형 데이터로 변경
-- TO_CHAR(숫자, [포맷]) : 숫자형 데이터를 문자형 데이터로 변경

--<패턴>
-- 9 : 숫자 한칸을 의미한다. 여러개 작성 시 오른 쪽 정렬

SELECT TO_CHAR(1234,'99999') FROM DUAL; --숫자 5칸 오른쪽 정렬.
SELECT TO_CHAR(1234,'00000') FROM DUAL; --숫자 5칸 . 오른쪽 정렬 빈칸 0 추가

SELECT TO_CHAR(1000000,'9,999,999') FROM DUAL;
SELECT TO_CHAR(1000000,'$9,999,999') FROM DUAL; 


--직원들의 급여를 원화 형식으로 조회
SELECT EMP_NAME, TO_CHAR(SALARY , 'L999,999,999') 급여
FROM EMPLOYEE;

--날짜에 TO_CHAR 적용

--YYYY : 년도 / YY :년(짦게)
--RRRR : 년도 / RR : 년도 짦게

--MM : 월 
--DD : 일수

--AM/PM : 오전 /오후를 표기하겟다
--HH : 시간 (24 붙일경우 24시간 표기법)
--MI : 분 
--SS : 초
--DAY : 요일 전체 / DY : 요일명만 표기

SELECT SYSDATE, TO_CHAR(SYSDATE,'DY AM HH24:MI:SS') FROM DUAL;

--직원들의 입사일을 2017년 12월 06일 (수) 형식으로 출력

SELECT EMP_NAME , TO_CHAR(HIRE_DATE, 'RRRR"년" MM"월" DD"일" (DY)')
FROM EMPLOYEE;

--년 월 일은 오라클에 등록된 날짜 표기 패턴이 아니라 오류. 
--기존에 없던 패턴 추가 시 ""(쌍따옴표)로 감싸줘서 문자열 그대로 출력하게 함.


---------------------------------------------------------------------
--TO_DATE : 날짜로 변경

-- TO_DATE(문자형 데이터, [포맷]) : 문자형 데이터를 날짜로 변경
-- TO_DATE(숫자형 데이터, [포맷]) : 숫자형 데이터를 날짜로 변경
--> 지정된 포멧으로 날짜를 인식함.

SELECT '2022-03-22',TO_DATE('2022-03-22') FROM DUAL;

SELECT TO_DATE(20100110) FROM DUAL;

SELECT TO_CHAR(TO_DATE('041030 143000','YYMMDD HH24MISS'), 
                'YYYY/MM/DD HH24"시"MI"분"') FROM DUAL;
                
------------------------------------------------------                     
           

--EMPLOYEE테이블에서 각 직원이 태어난 생년 월일 조회
SELECT EMP_NAME , TO_DATE(SUBSTR(EMP_NO,1,6), 'RRMMDD')
FROM EMPLOYEE;

--Y : 현재 세기(21세기 ==2000년대 )
--R : 1세기 기준 절반(50년)이상이면 1900년대
             --  절반 이하이면 2000년대
             
SELECT TO_DATE('19490125','RRMMDD')FROM DUAL;


------------------------------------------------------     
/*숫자 형변환*/
---- TO_NUMBER(문자데이터, [포맷]) : 문자형데이터를 숫자 데이터로 변경
SELECT TO_NUMBER('1,000,000','9,999,999') + 10 FROM DUAL;

------------------------------------------------------   

--NULL 처리 함수
--NVL(컬럼명. 컬럼값이 NULL일 때 바꿀 값) : NULL 컬럼값을 다른 값으로 변경

--EMPLOYEE 테이블에서 이름 급여 보너스 . 금여 *보너스 조회
SELECT EMP_NAME,SALARY,NVL(BONUS,0),NVL(BONUS,0)*SALARY
FROM EMPLOYEE;


-- NVL2(컬럼명, 바꿀값1, 바꿀값2)
-- 해당 컬럼의 값이 있으면 바꿀값1로 변경,
-- 해당 컬럼이 NULL이면 바꿀값2로 변경


-- EMPLOYEE 테이블에서
-- 기존 보너스를 받던 사원의 보너스를 0.8로
-- 보너스를 받지 못했던 사원의 보너스를 0.3 으로 변경하여
-- 이름, 기존 보너스, 변경된 보너스 조회

SELECT EMP_NAME,BONUS,NVL2(BONUS, 0.8,0.3)
FROM EMPLOYEE;
------------------------------------------------------------------------------
-- EMPLOYEE 테이블에서 사원명, 입사일-오늘, 오늘-입사일 조회
-- 단, 입사일-오늘의 별칭은 "근무일수1", 
-- 오늘-입사일의 별칭은 "근무일수2"로 하고
-- 모두 정수(내림)처리, 양수가 되도록 처리
SELECT EMP_NAME 사원명,
    FLOOR( ABS( HIRE_DATE - SYSDATE ) ) "근무일수1",
    FLOOR( ABS( SYSDATE - HIRE_DATE ) ) "근무일수2"
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 사번이 홀수인 직원들의 정보 모두 조회
SELECT *
FROM EMPLOYEE
WHERE MOD(EMP_ID,2)!=0;


-- EMPLOYEE 테이블에서 근무 년수가 20년 이상인 직원 정보 조회
SELECT EMP_NAME,HIRE_DATE,ROUND((MONTHS_BETWEEN(SYSDATE,HIRE_DATE)/12))AS 근속연수
FROM EMPLOYEE
WHERE ROUND((MONTHS_BETWEEN(SYSDATE,HIRE_DATE)/12))>=20;



-- EMPLOYEE 테이블에서
-- 직원명과 주민번호를 조회
-- 단, 주민번호 9번째 자리부터 끝까지는 '*'문자로 채움
-- 예 : 홍길동 771120-1******
SELECT EMP_NAME,(SUBSTR(EMP_NO,1,8))||'******'
FROM EMPLOYEE;



-- EMPLOYEE 테이블에서
-- 직원명, 직급코드, 연봉(원) 조회
-- 단, 연봉은 보너스가 적용된 1년치 급여 + ￦57,000,000 으로 표시 )
SELECT EMP_NAME,JOB_CODE,(SALARY*12) ||' + '||NVL(BONUS,0)*(SALARY*12)AS "연봉 +보너스" 
FROM EMPLOYEE
ORDER BY 2;



-- EMPLOYEE 테이블에서
-- 부서코드가 D5, D9인 직원들 중에서 2004년도에 입사한 직원의 
-- 사번 사원명 부서코드 입사일 조회 
SELECT EMP_ID,EMP_NAME,DEPT_CODE,HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE IN('D5','D9')
AND EXTRACT(YEAR FROM HIRE_DATE) =2004;

 

-- EMPLOYEE 테이블에서
-- 직원명, 입사일, 입사한 달의 근무일수 조회
-- 단, 입사한 날도 근무일수에 포함해서 +1 할 것
SELECT EMP_NAME,HIRE_DATE,
EXTRACT(MONTH FROM HIRE_DATE)AS"입사 월",
EXTRACT(DAY FROM LAST_DAY(HIRE_DATE))-EXTRACT(DAY FROM HIRE_DATE)+1 AS"근무일 ",
LAST_DAY(HIRE_DATE)AS"해당 달 마지막 일"
FROM EMPLOYEE;


-- EMPLOYEE 테이블에서
-- 직원명, 부서코드, 생년월일, 나이 조회
-- 단, 생년월일은 주민번호에서 추출해서, 
-- ㅇㅇ년 ㅇㅇ월 ㅇㅇ일로 출력되게 함.
-- 나이는 주민번호에서 추출해서 날짜데이터로 변환한 다음, 계산.
-- (년도만을 이용한 나이 구하기,   만 나이 구하기 둘다 시도해보세요!)
SELECT EMP_NAME,DEPT_CODE,
    TO_CHAR(TO_DATE(SUBSTR(EMP_NO,1,6),'YYMMDD'), 'YY"년 "MM"월 "DD"일"') AS "생년 월일",
    EXTRACT(YEAR FROM SYSDATE) - TO_CHAR(TO_DATE(SUBSTR(EMP_NO,1,2),'RR'),'RRRR') AS "나이"
    
FROM EMPLOYEE
ORDER BY 나이;




------------------------------------------------------------------------------------
--0323--0323--0323--0323--0323--0323--0323--0323--0323--0323--0323--0323
--0323--0323--0323--0323--0323--0323--0323--0323--0323--0323--0323--0323

/*선택 함수*/
--여러 가지 경우에 따라 알맞은 결과를 선택 할 수 있음

-- DECODE(계산식 | 컬럼명, 조건값1, 선택값1, 조건값2, 선택값2.....)
-- 비교하고자 하는 값 또는 컬럼이 조건식과 같으면 결과 값 반환
-- 일치하는 값을 확인(자바의 SWITCH와 비슷함)


--직원들 성별 구문
SELECT EMP_NAME AS 이름,DECODE( SUBSTR(EMP_NO,8,1),1,'남자',2,'여자' )AS 성별
FROM EMPLOYEE;

-- 직원의 급여를 인상하고자 한다
-- 직급코드가 J7인 직원은 급여의 10%를 인상하고
-- 직급코드가 J6인 직원은 급여의 15%를 인상하고
-- 직급코드가 J5인 직원은 급여의 20%를 인상하며
-- 그 외 직급의 직원은 급여의 5%만 인상한다.
-- 직원 테이블에서 직원명, 직급코드, 급여, 인상급여(위 조건)을 조회하세요

SELECT EMP_NAME,JOB_CODE,SALARY,DECODE(JOB_CODE,'J7', SALARY*1.1,
                                        'J6',SALARY*1.15,
                                        'J5',SALARY*1.2,
                                          SALARY*1.05)AS 인상급여
FROM EMPLOYEE;


-- CASE WHEN 조건식 THEN 결과값
--      WHEN 조건식 THEN 결과값
--      ELSE 결과값
-- END
-- 비교하고자 하는 값 또는 컬럼이 조건식과 같으면 결과 값 반환
-- 조건은 범위 값 가능

SELECT EMP_NAME,
    CASE  
        WHEN SUBSTR(EMP_NO,8,1) = 1 THEN '남자'
        WHEN SUBSTR(EMP_NO,8,1) = 2 THEN '여자'
    END 성별
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 사번, 사원명, 급여를 조회
-- 급여가 500만원 이상이면 '고급'
-- 급여가 300~500만원이면 '중급'
-- 그 미만은 '초급'으로 출력처리하고 별칭은 '구분'으로 한다.
-- 부서코드가 'D6'인 직원만 조회
-- 직급코드 오름차순 정렬
SELECT EMP_ID,EMP_NAME,SALARY,
    CASE
        WHEN SALARY >= 50000000 THEN '고급'
--        WHEN SALARY >=3000000 AND SALARY <5000000 THEN '중급'
        WHEN SALARY >=3000000 THEN '중급' --넘어온 값이 500백이 아닌건 이미 검증 되었기 때문에 
        ELSE '초급'
    END
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6'
ORDER BY JOB_CODE ASC; --정렬 기준이 되는 컬럼은 반드시  SELECT절에 포함 될 필요가 없다



------------------------------------------------------------------------------------
/* 그룹 함수 */
--하나 이상의 행을 그룹으로 묶어 연산하여 총합,평균,하나의 결과 행으로 반환하는 함수.

--SUM (숫자가 기록된 컬럼명) : 합계
--모든 직원의 급여 합

SELECT SUM(SALARY)FROM EMPLOYEE;


--부서 코드가 'D9'인 직원들의 급여합
SELECT SUM(SALARY) FROM EMPLOYEE
WHERE DEPT_CODE ='D9';



--AVG (숫자가 기록된 컬럼명) :평균
--전 직원 급여 평균
SELECT ROUND(AVG(SALARY))||'원'FROM EMPLOYEE;


--MIN (컬럼명) : 최소
--MAX (컬럼명) : 최대
--MIN / MAX는 숫자가 아니여도 사용가능하다 (숫자 : 대소 , 날짜 :과거미래 , 문자:ㄱㄴㄷㄹ/ABCD

SELECT MIN(SALARY),MIN(HIRE_DATE),MIN(EMAIL)
FROM EMPLOYEE;
--그룹함수는 여러개를 동시 작성 가능한다
--이 때 결과는 실제 테이블 한행이 아니고
--각 그룹함수 별 독립된 결과이다

SELECT MAX(SALARY),MAX(HIRE_DATE),MAX(EMAIL)
FROM EMPLOYEE
WHERE EMP_ID != 200;


-- * COUNT(* | 컬럼명) : 행 개수를 헤아려서 리턴
-- COUNT([DISTINCT] 컬럼명) : 중복을 제거한 행 개수를 헤아려서 리턴
-- COUNT(*) : NULL을 포함한 전체 행 개수를 리턴
-- COUNT(컬럼명) : NULL을 제외한 실제 값이 기록된 행 개수를 리턴함

--EMPLOYEE 테이블의 전체 행의 개수 == 전체 직원수 
SELECT COUNT(*) FROM EMPLOYEE;

--DEPT_CODE가 NULL이 아닌 행의 개수.
SELECT COUNT(*)FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL;

SELECT COUNT(DEPT_CODE) FROM EMPLOYEE;
--EMPLOYEE 테이블에 있는 부서 개수

SELECT COUNT(DISTINCT DEPT_CODE)FROM EMPLOYEE;
--COUNT로 중복을 제거하고 카운트

--남자직원들만 조회
SELECT COUNT(*) FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1)=1;