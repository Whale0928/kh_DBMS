--DDL (DATE DEFINITION LANGUAGE) : 데이터 정의 언어
--객체를 만들고 (CREATE) , 수정하고(ALTER) , 삭제(DROP)하는 구문을 DDL이라 한다.

--ALTER (바꾸다 , 변조하다)  
-- 수정 가능한 것 : 컬럼(추가 / 수정 /삭제) , 제약 조건 (추가/삭제)
--                      이름변경 (테이블 , 컬럼 , 제약조건)


--[작성법]
--테이블을 수정하는 경우
--ALTER TABLE 테이블명 ADD / MODIFIY / DROP 수정할 내용

--------------------------------------------------------------------------------------------------------------
--1. 제약 조건 추가 / 삭제

--** 작성법 중 대괄호 [] : 생략 할 수도 안할 수도 있다.

--제약조건 추가 : ALTER TABLE 테이블명 
--             ADD [CONSTRAINT 제약 조건명 ] 제약 조건 (컬럼명) [REFERENCES 테이블명[(컬럼명)]]
                                                        
--제약조건 삭제 : ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명 ; 

--서브쿼리를 이용해서 DEPARTMENT 테이블 복사
CREATE TABLE DEPT_COPY AS
SELECT * FROM DEPARTMENT;

--DEPT_COPY 테이블에 PK추가
ALTER TABLE DEPT_COPY 
ADD PRIMARY KEY (DEPT_ID);

--DEPT_COPY 테이블에 DEPT_TITLE 컬럼에 UNIQUE 제약 조건 추가
ALTER TABLE DEPT_COPY 
ADD CONSTRAINT DEPT_TITLE_U UNIQUE(DEPT_TITLE); 


--DEPT_COPY 테이블의 LOCATION_ID 컬럼에 CHECK 제약 조건 추가
--컬럼에 작성할 수있는 값은 L1,L2,L3,L4,L5...
ALTER TABLE DEPT_COPY
ADD CONSTRAINT LOCATION_ID_CHK CHECK (LOCATION_ID IN('L1','L2','L3','L4','L5'));


--DEPT_COPY 테이블에 DEPT_TITLE 컬럼에 NOT NULL 제약 조건 추가
-- NOT NULL 제약 조건은 다루는 방법이 다름
-- NOT NULL을 제외한 제약 조건을 추가적인(ADD) 내용으로 인식함
-- NOT NULL은 기존 컬럼의 성질을 변경하는 것으로 인식한다 MODIFIY
ALTER TABLE DEPT_COPY
MODIFY DEPT_TITLE NOT NULL;  --NOT NULL은 MODIFY

---------------------------------
--DEPT_COPY에 추가한 제약 조건중 PK빼고 모두 삭제
ALTER TABLE DEPT_COPY DROP CONSTRAINT DEPT_TITLE_U;

ALTER TABLE DEPT_COPY DROP CONSTRAINT LOCATION_ID_CHK;

--NOT NULL만 제거시 MODIFY 사용
ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE CONSTRAINT SYS_C008448 NULL ;



--------------------------------------------------------------------------------------------------------------

--2. 컬럼 추가 / 수정 / 삭제 
--컬럼 추가 : ALTER TABLE 테이블명 ADD (컬럼명 데이터 타입 [DEFAULT '값'])
--컬럼 수정 : ALTER TABLE 테이블명 MODIFY 컬럼명 데이터타입; (데이터 타입 변경)
--                                                         컬럼명 DEFAULT'값' (기본값 변경)

--데이터 타입 수정 시 칼럼에 저장된 데이터 크기 미만으로 변경 할 수 없다

--컬럼 삭제 : ALTER TABLE 테이블명 DROP COLUMN ( 삭제할 컬럼명 )
--               ALTER TABLE 테이블명 DROP 삭제할 컬럼명 

--**테이블에 최소 1개 이상의 컬럼이 존재해야 하기 때문에 모든 컬럼 삭제 X
--테이블이랑 행과 열로 이루어진 데이터베이스의 가장 기본적인 객체.

--[추가]
--DEPT_COPY 컬럼에 CNAME VARCHAR2(20) 컬럼 추가
ALTER TABLE DEPT_COPY ADD (CNAME VARCHAR2(20));

SELECT * FROM DEPT_COPY;

--DEPT_COPY 테이블에 LNAME VARCHAR2(30) 기본값 '한국'컬럼
ALTER TABLE DEPT_COPY
ADD (LNAME VARCHAR2(30) DEFAULT '한국');

SELECT * FROM DEPT_COPY;  --> LNAME 추가 후 기본값 설정


--[수정]
--DEPT_COPY 테이블의 DEPT_ID 컬럼의 데이터 타입을 CHAR(2) - > VARCHAR2(3)으로 변경
ALTER TABLE DEPT_COPY
MODIFY DEPT_ID VARCHAR2(3);

--(수정 에러 상황)
--DEPT_TITLE 컬럼의 데이터 타입을 VARCHAR2(10)으로 변경
ALTER TABLE DEPT_COPY
MODIFY DEPT_TITLE VARCHAR(10);


--(기본값 수정)
--LNAME 한국을 대한민국으로 수정
ALTER TABLE DEPT_COPY
MODIFY LNAME DEFAULT '대한민국';

SELECT * FROM DEPT_COPY;

UPDATE DEPT_COPY SET LNAME = '대한민국';
UPDATE DEPT_COPY SET LNAME = DEFAULT;
ROLLBACK;


--[삭제]
--DEPT_COPY 테이블에 추가한 컬럼(CNAME , LNAME) 삭제
--ALTER TABLE 테이블명 DROP (삭제할 컬럼명) 
ALTER TABLE DEPT_COPY DROP (CNAME) ;
SELECT * FROM DEPT_COPY;

--ALTER TABLE 테이블명 DROP  COLUMN 삭제할 컬럼명; 
ALTER TABLE DEPT_COPY DROP COLUMN LNAME ;
SELECT * FROM DEPT_COPY;


--(컬럼 삭제 문제점)
-- DEPT_COPY 테이블의 모든 컬럼 삭제
SELECT * FROM DEPT_COPY; --컬럼 3개

ALTER TABLE DEPT_COPY DROP (DEPT_TITLE);
ALTER TABLE DEPT_COPY DROP (LOCATION_ID);

SELECT * FROM DEPT_COPY; --컬럼 1개
ALTER TABLE DEPT_COPY DROP (DEPT_ID);

ROLLBACK; -- 트랜잭션(DML을 이용한 데이터 변경사항)을 삭제하고 마지막 커밋 상태로 돌아감(TCL)

--DDL /DML을 혼용해서 사용할 경우 발생하는 문제점
--DML을 실행하여 트랜잭션에 변경사항이 저장된 상태에서 
--COMMIT / ROLLBACK 없이 DDL을 수행시
-- 수행과 동시에 COMMIT이 되버린다

--결론 : DML / DDL 혼용해서 사용하지 말자!!

SELECT * FROM DEPT_COPY; --컬럼 1개
INSERT INTO DEPT_COPY VALUES('J1'); 
ROLLBACK;

INSERT INTO DEPT_COPY VALUES('D0');
SELECT * FROM DEPT_COPY;

ALTER TABLE DEPT_COPY  MODIFY DEPT_ID VARCHAR2(4); --DDL 수행
ROLLBACK;

SELECT * FROM DEPT_COPY;--D0가 사라지지 않음


----------------------------------------------------------------------------------------------
--3. 테이블 삭제
--[작성명]
--DROP TABLE 테이블명 [CASCADE CONSTRAINTS];
--관계가 있을 경우 

CREATE TABLE TB1(
    TB1_PK NUMBER PRIMARY KEY,
    TB1_COL NUMBER
);

CREATE TABLE TB2(
        TB2_PK NUMBER PRIMARY KEY,
        TP2_COL NUMBER REFERENCES TB1 --TB1테이블의 PK값을 참조
);

--일반 삭제 (DEPT_COPY)
DROP TABLE DEPT_COPY; --Table DEPT_COPY이(가) 삭제되었습니다.

--**관계가 형성된 테이블중 부모 테이블 삭제**
DROP TABLE TB1; --ORA-02449: 외래 키에 의해 참조되는 고유/기본 키가 테이블에 있습니다

--해결 방법 1 : 자식 먼저 삭제하기 (참조하는 테이블이 없으면 삭제 가능)
DROP TABLE TB2;
DROP TABLE TB1;


--해결 방법 2 : CASCADE CONSTRAINT 옵션 사용 
--(제약조건까지 모두 삭제하겟다)
-- == FK 제약조건으로 인해 불가능하지만 제약조건을 없애버려 FK 관계를해재
DROP TABLE TB1 CASCADE CONSTRAINTS;--TKRWP TJDRHD
DROP TABLE TB2;


DROP TABLE DEPT_COPY;



-----------------------------------------------------------------
--4.컬럼 , 제약조건 , 테이블 이름 변경 (RENAME)
CREATE TABLE DEPT_COPY
AS SELECT *FROM DEPARTMENT;

SELECT * FROM DEPT_COPY;
--복사한 테이블에 PK 추가
ALTER TABLE DEPT_COPY ADD CONSTRAINT PK_DCOPY PRIMARY KEY(DEPT_ID);

--1) 컬럼명 변경   :  ALTER TABLE 테이블명 RENAME COLUMN 컬럼명 TO 변경명
ALTER TABLE DEPT_COPY RENAME COLUMN DEPT_TITLE TO DEPT_NAME;

--2) 제약 조건명 변경 :  ALTER TABLE 테이블명 RENAME CONSTRAINT 제약조건명 TO 변경명
ALTER TABLE DEPT_COPY RENAME CONSTRAINT PK_DCOPY TO DEPT_COPY_PK;

--3)테이블명 변경 : ALTER TABLE 테이블명 RENAME TO 변경명;
ALTER TABLE DEPT_COPY RENAME TO DCOPY;

SELECT * FROM DCOPY;