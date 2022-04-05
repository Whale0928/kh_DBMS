/*
    VIEW  : 가상의 테이블 

    -SELECT 문의 실행 결과(RESULT SET)를 저장하는 객체
    -논리적 가상 테이블
        -> 테이블 모양을 하고는 있지만 ,  실제 값을 저장하고 있지는 않음.

     ** VIEW 사용 목적 **
     1) 복잡한 SELECT 문을 쉽게 재사용하기 위해서
     2) 테이블의 진짜 모습을 감출 수 있어 보안상 유리하다.
     
     *** VIEW 사용시 주의 사항***
     1) 가상의 테이블 (실체가 없다) 이기 때문에 ALTER 구문 사용 불가능.
     2) VIEW를 이용한 DML(INSERT,UPDATE,DELETE) 가 가능한 경우도 있지만.
        제약이 많이 따르기 때문에 보통은 조회용(SELECT)용으로 많이 사용함.

    [VIEW 생성 방법]
    CREATE [OR REPLACE] [FORCE | NOFORCE] VIEW 뷰이름 [(alias[,alias]...]    AS subquery
    [WITH CHECK OPTION]
    [WITH READ ONLY];
     
    
    -- 1) OR REPLACE 옵션 : 기존에 동일한 뷰 이름이 존재하는 경우 덮어쓰고, 
    --                      존재하지 않으면 새로 생성.
    -- 2) FORCE / NOFORCE 옵션
    --      FORCE : 서브쿼리에 사용된 테이블이 존재하지 않아도 뷰 생성
    --      NOFORCE : 서브쿼리에 사용된 테이블이 존재해야만 뷰 생성(기본값)
    -- 3) WITH CHECK OPTION 옵션 : 옵션을 설정한 컬럼의 값을 수정 불가능하게 함.
    -- 4) WITH READ ONLY 옵션 : 뷰에 대해 조회만 가능(DML 수행 불가)
\\\
*/


--EMPLOYEE 테이블에서 모든 사원의 사번 , 이름 , 부서명 직급명 , 조회
SELECT EMP_ID,EMP_NAME,DEPT_TITLE,JOB_NAME
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE);
--자주 사용하는데 매번 쓰지 힘드 -> VIEW 생성

--사원의 사번 , 이름 , 부서명 직급명 , 조회 VIEW
CREATE VIEW V_EMP AS 
SELECT EMP_ID,EMP_NAME,DEPT_TITLE,JOB_NAME
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE);

ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

GRANT CREATE VIEW TO khg;


--VIEW를 이용한 조회
SELECT * FROM V_EMP;



-- OR REPLACE + 별칭

CREATE OR REPLACE VIEW V_EMP AS 
SELECT EMP_ID 사번,EMP_NAME 이름 ,DEPT_TITLE 부서명 ,JOB_NAME 직급명
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE);
--OR REPLACE 같은 뷰가 있어도 생성 가능

SELECT * FROM V_EMP
WHERE 직급명 = '대리';


-----------------------------------------------------------

-- VIEW 를 이용한 DML 확인
CREATE TABLE DEPT_COPY2
AS SELECT * FROM DEPARTMENT;

--복사한 테이블을 이용해서 VIEW 생성

CREATE OR REPLACE VIEW V_DCOPY2
AS SELECT  DEPT_ID , LOCATION_ID FROM DEPT_COPY2;

SELECT * FROM V_DCOPY2;

--VIEW를 이용한 삽입
INSERT INTO V_DCOPY2 VALUES('D0','L3');
SELECT * FROM V_DCOPY2;

SELECT * FROM DEPT_COPY2;
-->VIEW 에 삽입한 내용이 원본 테이블에 존재한다
-->VIEW를 이용한 DML 구문이 원본에 영향을 미친다.

--> VIEW이용한 DML 시 발생하는 문제점 == 제약조건 위배 현상
ROLLBACK;
SELECT * FROM DEPT_COPY2;
SELECT * FROM V_DCOPY2;

--원본 테이블 DEPT_TITLE컬럼에 NOT NULL 추가
ALTER TABLE DEPT_COPY2
MODIFY DEPT_TITLE  NOT NULL;

--현 상태에서 다시VIEW를 이용하 INSERT 수행
INSERT INTO V_DCOPY2 VALUES('D0','L3');

--> VIEW를 이용한 INSERT 시 원본 테이블에 삽입이 된다
--> 원본데이터 삽입시 VIEW INSERT  구문이 미포함된 컬럼에는 NULL이 저장된다
--> VIEW 가지고 DML 쓰지마라 그냥

---------------------------
--*WITH READ ONLY 옵션 *
CREATE OR REPLACE VIEW V_DCOPY2 AS 
SELECT DEPT_ID,LOCATION_ID FROM DEPARTMENT
WITH READ ONLY ; --SELECT전용의 VIEW 생성

INSERT INTO V_DCOPY2 VALUES('D0','L3');
--SQL 오류: ORA-42399: 읽기 전용 뷰에서는 DML 작업을 수행할 수 없습니다.





--------------------------------------------------------------------------------------------------------        
/*SEQUENCE(순서, 연속)
-순차적 버호 자동 발생기 역할의 객체
EX) 1   2   3   4   5   6 ....이때 발생하는 숫자는 곂치지 않는다

**SEQUENCE를 사용하는 방법 : PRIMARY KEY 컬럼에 사용될 값을 생성하는 용도로 주로 사용
    
[작성법]
  CREATE SEQUENCE 시퀀스이름
  [STRAT WITH 숫자] -- 처음 발생시킬 시작값 지정, 생략하면 자동 1이 기본
  [INCREMENT BY 숫자] -- 다음 값에 대한 증가치, 생략하면 자동 1이 기본
  [MAXVALUE 숫자 | NOMAXVALUE] -- 발생시킬 최대값 지정 (10의 27승, -1)
  [MINVALUE 숫자 | NOMINVALUE] -- 최소값 지정 (-10의 26승)
  [CYCLE | NOCYCLE] -- 값 순환 여부 지정
  [CACHE 바이트크기 | NOCACHE] -- 캐쉬메모리 기본값은 20바이트, 최소값은 2바이트

-- 시퀀스의 캐시 메모리는 할당된 크기만큼 미리 다음 값들을 생성해 저장해둠
-- --> 시퀀스 호출 시 미리 저장되어진 값들을 가져와 반환하므로 
--     매번 시퀀스를 생성해서 반환하는 것보다 DB속도가 향상됨.

--  ** SEQUENCE 사용 방법**

1) 시퀀스명 . NEDXTVAL  :  다음 시퀀스 번호를 얻어옴(INCREMENT BY만큼 증가된 값)
                                    단 시퀀스 생성 후 첫 호출인 경우 START WHIT의 값을 얻어온다

2) 시퀀스명 . CURRVAL : 현재 시퀀스 번호를 얻어옴 
                                단 시퀀스 생성 후 NEXTVAL 호출 없이CURRVAL을 호출하면 오류 발생 .
                                
                                

*/



--테이블 복사
CREATE TABLE EMPLOYEE_COPY4
AS SELECT EMP_ID,EMP_NAME FROM EMPLOYEE;

--EMPLOYEE_COPY EMP_ID 에 PK제약조건 추가

ALTER TABLE EMPLOYEE_COPY4
ADD PRIMARY KEY(EMP_ID);

SELECT * FROM EMPLOYEE_COPY4;


--223부터 시작하여 5씩 증가하는 시퀀스 생성
CREATE SEQUENCE SEQ_EMP_ID
START WITH 223 
INCREMENT BY 5;

--NEXTVAL 호출 없이 CURRVAL 호출하면 발생하는 오류 확인
SELECT SEQ_EMP_ID.CURRVAL FROM DUAL;
--ORA-08002: 시퀀스 SEQ_EMP_ID.CURRVAL은 이 세션에서는 정의 되어 있지 않습니다


SELECT SEQ_EMP_ID.NEXTVAL FROM DUAL;  --최초 호출 START WITH값이 조회
--223

SELECT SEQ_EMP_ID.NEXTVAL FROM DUAL;
--228  INCREMENT 만큼 증가한 값 조회

SELECT SEQ_EMP_ID.NEXTVAL FROM DUAL;

--CURRVAL 호출
SELECT SEQ_EMP_ID.CURRVAL FROM DUAL;

SELECT * FROM EMPLOYEE_COPY4;

INSERT INTO EMPLOYEE_COPY4 VALUES( SEQ_EMP_ID.NEXTVAL,'홍길동');
INSERT INTO EMPLOYEE_COPY4 VALUES( SEQ_EMP_ID.NEXTVAL,'고길동');
INSERT INTO EMPLOYEE_COPY4 VALUES( SEQ_EMP_ID.NEXTVAL,'장길산');

SELECT * FROM EMPLOYEE_COPY4;

SELECT SEQ_EMP_ID.CURRVAL FROM DUAL;

--시퀀스는 롤백 수행시에도 초기값으로 돌아가지 않는다
--> 계속 증가된 상태를 유지한다.
ROLLBACK;
SELECT * FROM EMPLOYEE_COPY4;
SELECT SEQ_EMP_ID.CURRVAL FROM DUAL;

--------------------------------------------------------------    
-- SEQUENCE 변경 (ALTER)
--자기만의 역할이 있는 하나의 객체라 VIEW랑 느낌이 다르다

-- [ 작성법 ]  CREATE = > ALTER  /  CREATE 삭제
--   ALTER SEQUENCE 시퀀스이름
--  [INCREMENT BY 숫자] -- 다음 값에 대한 증가치, 생략하면 자동 1이 기본
--  [MAXVALUE 숫자 | NOMAXVALUE] -- 발생시킬 최대값 지정 (10의 27승, -1)
--  [MINVALUE 숫자 | NOMINVALUE] -- 최소값 지정 (-10의 26승)
--  [CYCLE | NOCYCLE] -- 값 순환 여부 지정
--  [CACHE 바이트크기 | NOCACHE] -- 캐쉬메모리 기본값은 20바이트, 최소값은 2바이트


-- 시퀀스를 잘못 다뤄 번호에 공백이 있어서 다시 처음 부터 시작하고 싶은 경우.
-- >> 시퀀스 삭제후 재생성이 필요하다


--SEQ_EMP_ID 의 증가값을 5->1로 변경
ALTER SEQUENCE SEQ_EMP_ID
INCREMENT BY 1;

SELECT SEQ_EMP_ID.NEXTVAL FROM DUAL;

--SEQUENCE 삭제 
DROP SEQUENCE SEQ_EMP_ID;
--VIEW 삭제
DROP VIEW V_DCOPY2;












/* INDEX (색인)
-   SQL 명령문중 SELECT의 처리속도를 향상시키기 위해 
    컬럼에 대하여 생성하는 객체
    
-   인덱스 내부구조는 B* 트리 형식으로 되어있음

장점
-    이진 트리 형식으로 구성되어 있어 자동 정렬 및 검색속도가 빠름

-    조화 시 전체 테이블내용을 조회하는 것이 아닌 
    인덱스가 지정된 컬럼만을 이용해 조회하기 때문에
    시스템 부하가 낮아져 전체적인 성능 향상된다
    
    
단점
-   데이터 변경 (DML) 작업이 빈번한 경우 오히려 성능이 저하되는 문제가 발생
-   인덱스도 하나의 객체이다 보니 이를 저장하기 위한 별도의공간 


--인덱스 생성 방법--

    [작성법]
    CREATE [UNIQUE] INDEX 인덱스명
    ON 테이블명 (컬럼명, 컬럼명, ... | 함수명, 함수계산식);
    
    -- 인덱스가 자동으로 생성되는 경우
    --> PK 또는 UNIQUE 제약조건이 설정되는 경우
*/

SELECT * FROM EMPLOYEE_COPY4;

--EMPLYOEE_COPY4 테이블 EMP_NAME 컬럼에 인덱스 생성

CREATE INDEX ECOPY4_NAME_INDEX
ON EMPLOYEE_COPY4(EMP_NAME);

SELECT * FROM EMPLOYEE_COPY4;


--** 인덱스를 이용한 조회(검색)방법
--> WHERE 절에 인덱스가 추가된 컬럼이 언급되면 자동으로 INDEX가 활용된다.

SELECT * FROM EMPLOYEE_COPY4
WHERE EMP_NAME != '0' ;



--인덱스 확인용 테이블
CREATE TABLE TB_INX_TEST(
    TEST_NO NUMBER PRIMARY KEY, 
    -- 자동으로 인덱스가 생성된 PK 제약조건이 포함되어있으면 인덱스 자동 생성
    TEST_ID VARCHAR2(20) NOT NULL
);

--(PL /SQL 사용) 인덱스 테스트 샘플 데이터 100만개 삽입
BEGIN
    FOR I IN 1..1000000 
    LOOP 
        INSERT INTO TB_INX_TEST VALUES ( I  , 'TEST'||I) ;
    END LOOP;
    
    COMMIT;
END;
/

ALTER TABLE TB_INX_TEST RENAME TO TB_IDX_TEST;


SELECT COUNT(*) FROM TB_IDX_TEST;

SELECT * FROM TB_IDX_TEST
WHERE TEST_ID = 'TEST500000'; --0.042 S  / 0.024S

--INDEX 사용
SELECT * FROM TB_IDX_TEST
WHERE TEST_NO =  5000000; --0.005S 0.004S

DROP TABLE TB_IDX_TEST;

DROP INDEX ECOPY4_NAME_INDEX;                