--TCL ( TRANSACTION CONTROL LANGUAGE ) :트랜잭션 제어 언어.
--COMMIT (트랜잭션 종료 후 저장)
--ROLLBACK( 트랜잭션 취소)
--SAVEPOINT(임시저장)

--DATA MANIQULATION LANGUAGE : 데이터의 삽입 , 수정 , 삭제
-->트랜잭션은 DML과 관련 있다

--TRANSACTION
--- 데이터베이스의 논리적 연산 단위
--
--- 데이터 변경 사항을 묶어 하나의 트랜잭션에 담아 처리한다.
--	- INSERT / DELETE / UPDATE (DML)
--
--- INSERT 수행 ------------------------------------------------------------------------------> DB반영( X )
--- INSERT 수행 -------트랜잭션에 추가 ------> COMMIT ---------------------------> DB반영( O )
--- INSERT 10번 수행 -------트랜잭션에 10개 추가 ------> ROLLBACK---------->  DB반영 안 됨

--1)COMMIT : 메모리 버퍼(트랜잭션)에 임시 저장된 데이터 변경 사항을 DB에 반영
--2)ROLLBACK:메모리 버퍼(트랜잭션)에 임시 저장된 데이터 변경사항을 삭제 후 마지막 COMMIT상태로 돌아감
--3)SAVEPOINT : 메모리 버퍼에(트랜잭션)에 저장지점을 정의해 ROLLBACK수행 시 전체 작업을 삭제 하는것이 아니라
                                                                     --저장 지점 까지만 일부 ROLLBAKC


--[SAVEPOINT 사용법]

--SAVEPOINT 포인트명 1;
--SAVEPOINT 포인트명 2;
--ROLLBACK TO 포인트명 1; 포인트 1번 지점까지의 데이터 변경 사항 삭제

SELECT * FROM DEPARTMENT2;

--D0 , '경리부' , L2
INSERT INTO DEPARTMENT2 VALUES('D0','경리부','L2');

ROLLBACK;

SELECT * FROM DEPARTMENT2;

INSERT INTO DEPARTMENT2 VALUES('D0','경리부','L2');

COMMIT;

DELETE FROM DEPARTMENT2 WHERE DEPT_ID= 'D0';
--D0를 삭제 하면서 SAVEPOINT 생성;
SAVEPOINT SP1;

DELETE FROM DEPARTMENT2 WHERE DEPT_ID= 'D9';
SELECT * FROM DEPARTMENT2;
ROLLBACK;
SELECT * FROM DEPARTMENT2;
ROLLBACK TO SP1;