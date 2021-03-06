--1번 문제
SELECT DEPARTMENT_NAME "학과 명",CATEGORY "계열"
FROM TB_DEPARTMENT;

--2번 문제
SELECT DEPARTMENT_NAME||'의 정원은 '||CAPACITY AS "학과별 정원"
FROM TB_DEPARTMENT;

--3번 문제
SELECT STUDENT_NAME
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE DEPARTMENT_NO = 001 AND ABSENCE_YN = 'Y' AND SUBSTR(STUDENT_SSN,8,1)=2;

--4번 문제
--A513079,A513090,A513091,A513110,A513119
SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE STUDENT_NO IN('A513079','A513090','A513091','A513110','A513119')
ORDER BY STUDENT_NO DESC;

--5번 문제 입학정원 20명 이상 30명 이하
SELECT DEPARTMENT_NAME,CAPACITY
FROM TB_DEPARTMENT
WHERE CAPACITY BETWEEN 20 AND 30;

--6번 문제 총장의 이름을 알아내라
SELECT PROFESSOR_NAME
FROM TB_PROFESSOR
WHERE DEPARTMENT_NO IS NULL;

--7번 문제 학과가 지정되지 않은 학생을 조회
SELECT *
FROM TB_STUDENT
WHERE DEPARTMENT_NO IS NULL;

--8번 문제 선수 과목이 있는지 확인하고 있다면 어떤 과목인지 조회
SELECT CLASS_NO
FROM TB_CLASS
WHERE PREATTENDING_CLASS_NO IS NOT NULL;

--9번 문제 어떤 계열들이 있는지 조회
SELECT DISTINCT( CATEGORY )
FROM TB_DEPARTMENT
ORDER BY CATEGORY;

--10번 문제 02학번이면서,전주 거주자이면서,휴학한 사람들은 제거한 학생 목록.
SELECT STUDENT_NO,STUDENT_NAME,STUDENT_SSN
FROM TB_STUDENT
WHERE 
    EXTRACT(YEAR FROM ENTRANCE_DATE)=2002 AND 
    STUDENT_ADDRESS LIKE '전주%' AND
    ABSENCE_YN = 'N';