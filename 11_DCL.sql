/*계정(사용자) 

*관리자 계정 : DB의 생성과 관리를 담당하는 계정
                    모든 권환과 '책임'을 가지는 계정 
                    EX ) SYS (최고관리자) , SYSTEM (SYS에서 권한 몇개 제외 )
    

*사용자 계정 : DB에 대하여 질의 , 갱신 , 보고서 작성등의
                    작업을 수행할 수 있는 계정으로 
                    업무에 필요한 '최소한'의 권한만은 소유하는 것을 원칙으로 한다
                    EX) KHG계정 , UPDOWN , WORKBOOK 등

*/

/* DCL(DATE CONTROL LANGUAGE) :계정에 DB,DB객체에 대한 적근 권한을 부여하고 회수하는 언어
    CONTROL은 제어를 의미한다
    
    GRANT  : 권한 부여
    REVOKE : 권한 회수
    
    * 권한의 종류
    
1) 시스템 권한 : DB 접속 , 객체 생성 권한

    CRETAE SESSION   : 데이터베이스 접속 권한
    CREATE TABLE     : 테이블 생성 권한
    CREATE VIEW      : 뷰 생성 권한
    CREATE SEQUENCE  : 시퀀스 생성 권한
    CREATE PROCEDURE : 함수(프로시져) 생성 권한
    CREATE USER      : 사용자(계정) 생성 권한
    DROP USER        : 사용자(계정) 삭제 권한
    DROP ANY TABLE   : 임의 테이블 삭제 권한
    
2) 객체 권한 :특정 객체를 '조작'할 수 있는 권한

    권한 종류         설정 객체
    SELECT              TABLE, VIEW, SEQUENCE
    INSERT              TABLE, VIEW
    UPDATE             TABLE, VIEW
    DELETE              TABLE, VIEW
    ALTER               TABLE, SEQUENCE
    REFERENCES       TABLE
    INDEX               TABLE
    EXECUTE            PROCEDURE
*/

--0 . SQL구문 작성 형식을 예전 (11G) 오라클 SQL 형식을 사용하도록 변경하겟다
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

-- 1. [SYS 관리자 계정] 사용자 계정 생성
CREATE USER khg_sample  IDENTIFIED BY sample1234;  
            --사용자 계정 명                      --비밀번호
            
-- 2. 생성된 계정에 접속하기 위한 접속 방법을 추가(왼쪽 상단 초록 + 버튼)
--ORA-01045: CREATE SESSION 권한을 가지고있지 않음

--3 . [SYS 관리자 계정] 생성된 샘플 계정에 DB접속 권한 부여
GRANT CREATE SESSION TO khg_sample;

--4 다시 접속 방법 추가  -> 성공

--5. [sample 계정] 테이블 생성 
CREATE TABLE TB_TEST(
    TEST_PK NUMBER PRIMARY KEY,
    TEST_CONTENT VARCHAR2(100)
    );
--오류발생 ORA-01031: 권한이 불충분합니다
-- > DB 접속 관한만 있고 , 테이블 생성 권한이 없음


-- 6 [SYS 관리자 계정] 테이블 생성 권한 부여 + 객체 생성 공간 할당
GRANT  CREATE TABLE TO khg_sample;

ALTER USER khg_sample DEFAULT TABLESPACE SYSTEM QUOTA UNLIMITED ON SYSTEM;

--7 [SAMPLE 사용자 계정 ] 다시 테이블 생성
CREATE TABLE TB_TEST(
    TEST_PK NUMBER PRIMARY KEY,
    TEST_CONTENT VARCHAR2(100)
    );
    
-----------------------------------------------------------------------------------------------------------------------

--쉽게 권한을 부여하기 위한 방법
-- ROLE(역할) : 권한을 묶음
--묶어둔 권한(ROLE)을 특정 계정에 부여 --> 해당 계정은 특정 권한을 가진 역할을 갖게된다
--ROLE을 사용하면 한번에 많은 권한을 부여하거나 회수할 수있다.

-- 1) CONNECT  : DB접속 권한 ( = CREATE SESSION)
--      담고있는 권한은 1개 이지만 의미적으로 쉽게 사용하기 위해 사용
-- [SYS 관리자 계정]
SELECT * FROM ROLE_SYS_PRIVS
WHERE ROLE = 'CONNECT';

--2) RESOURCE  : DB 사용을 위한 기본 객체 생성 권한 묶음 
SELECT * FROM ROLE_SYS_PRIVS
WHERE ROLE = 'RESOURCE';


--ROLE 을이용해 샘플 계정에 다시 건한 부여
-- [SYS 관리자 계정]
GRANT CONNECT , RESOURCE TO khg_sample;

---------------------------------------------------------------

--  객체 권한
-- > khg_sample 계정에서 khg 계정의 EMPLOYEE 테이블 조회 

--> 1. [샘플 계정] khg계정의 EMPLOYEE 테이블 조회
SELECT * FROM khg.EMPLOYEE; --> EMPLOYEE 테이블에 조회 권한이 없음

-->2 [이니셜 계정 ]  샘플 계정에 EMPLOYEE 조회권한 부여
GRANT SELECT ON EMPLOYEE TO khg_sample;

-->3 [샘플계정] 다시 EMPLOYEE 테이블 조회
SELECT * FROM khg.EMPLOYEE;

-->4 [이니셜계정 ] 부여 했던 select 권한을 회수
REVOKE SELECT ON EMPLOYEE FROM khg_sample;

--5번 [샘플계정 ] 다시 EMPLOYEE 조회
SELECT * FROM khg.EMPLOYEE;
