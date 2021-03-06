--문제 1번 학생 이름과 주소지 별칭을 지정하고 정렬을 이름오름차순
SELECT STUDENT_NAME"학생 이름",STUDENT_ADDRESS 주소지
FROM TB_STUDENT
ORDER BY STUDENT_NAME;

--문제 2번 휴학중인 학생의 이름 주민번호 나이가 적은 순으로 화면에 출력
SELECT STUDENT_NAME,STUDENT_SSN
FROM TB_STUDENT
WHERE ABSENCE_YN = 'Y'
ORDER BY SUBSTR(STUDENT_SSN,1,6) DESC;

--문제 3번 주소지가 강원도/경기도 학생중 1900년대 학번을 가진 학생 이름 학번 주소
--      이름의 오름차순 , 별칭도 지정
SELECT STUDENT_NAME"학생이름",STUDENT_NO"학번",STUDENT_ADDRESS"거주지 주소"
FROM TB_STUDENT
WHERE STUDENT_ADDRESS LIKE '경기%' AND
EXTRACT(YEAR FROM ENTRANCE_DATE)<2000
ORDER BY STUDENT_NAME;

--문제 4번 법학과 교수중 나이가 많은 사람 부터 이름을 확인
SELECT P.PROFESSOR_NAME,P.PROFESSOR_SSN
FROM TB_PROFESSOR P
JOIN TB_DEPARTMENT D ON(P.DEPARTMENT_NO = D.DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '법학과'
ORDER BY SUBSTR(PROFESSOR_SSN,1,6) ;


--문제 5번 2004년 2학기에 C311810 과목을 수강한 학생들의 학점
--          학점이 높은 학생부터 표시 학점이 같으면 학번이 낮은 학생부터 조회
SELECT STUDENT_NO,TO_CHAR(POINT,'9.00')
FROM TB_GRADE
WHERE TERM_NO = '200402' AND 
CLASS_NO = 'C3118100'
ORDER BY POINT DESC , STUDENT_NO;


--문제 6번 학번,이름,학과를 학생이름 오른차순으로 정렬 출력
SELECT STUDENT_NO,STUDENT_NAME,DEPARTMENT_NAME
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
ORDER BY STUDENT_NAME DESC;


--문제 7번 과목이름 과목의 학과 이름
SELECT CLASS_NAME,DEPARTMENT_NAME
FROM TB_CLASS
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO);

--문제 8번 과목별 교수이름 조회
SELECT CLASS_NAME,PROFESSOR_NAME
FROM TB_CLASS_PROFESSOR
JOIN TB_CLASS USING(CLASS_NO)
JOIN TB_PROFESSOR USING(PROFESSOR_NO);

--문제 9번 8번의 결과에서 '인문사회' 계열에 속하는 교수이름
SELECT CLASS_NAME,PROFESSOR_NAME
FROM TB_CLASS
JOIN TB_CLASS_PROFESSOR USING(CLASS_NO)
JOIN TB_PROFESSOR P USING(PROFESSOR_NO)
JOIN TB_DEPARTMENT D ON(P.DEPARTMENT_NO=D.DEPARTMENT_NO)
WHERE CATEGORY ='인문사회';


--문제 10번 음학학과 학생들의 학번/이름/전체평점 소수점 한자리 까지만
SELECT S.STUDENT_NO"학번",S.STUDENT_NAME"학생 이름",ROUND(AVG(POINT), 1)"전체 평점"
FROM TB_STUDENT S
JOIN TB_GRADE G ON(S.STUDENT_NO=G.STUDENT_NO)
JOIN TB_DEPARTMENT D ON(S.DEPARTMENT_NO=D.DEPARTMENT_NO)
WHERE DEPARTMENT_NAME ='음악학과'
GROUP BY S.STUDENT_NO,S.STUDENT_NAME
ORDER BY "학번";


--문제 11번 A313047학생의 지도교수에게 내용을 전달하기 위한 학과/학생/지도교수의 이름을 조회
SELECT D.DEPARTMENT_NAME "학과이름  ", S.STUDENT_NAME "학생이름  ", P.PROFESSOR_NAME "지도교수이름  "
FROM TB_STUDENT S 
JOIN TB_DEPARTMENT D ON(S.DEPARTMENT_NO = D.DEPARTMENT_NO)
JOIN TB_PROFESSOR P ON(S.COACH_PROFESSOR_NO = P.PROFESSOR_NO)
WHERE S.STUDENT_NO = 'A313047';


--문제 12번 2007년에 인간관계론 과목을 수강한 학생을 찾아 학생이름과 수강학기를 조회
SELECT STUDENT_NAME , TERM_NO
FROM TB_STUDENT
JOIN TB_GRADE USING(STUDENT_NO)
JOIN TB_CLASS USING(CLASS_NO)
WHERE SUBSTR(TERM_NO,1,4)='2007' AND CLASS_NAME='인간관계론';


--문제 13번 예체능계열 과목중 담당 교수가 한명도 배정받지 못하는 과목/학과 이름 조회
SELECT CLASS_NAME,DEPARTMENT_NAME
FROM TB_CLASS
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
LEFT JOIN TB_CLASS_PROFESSOR USING(CLASS_NO)
WHERE CATEGORY = '예체능' AND PROFESSOR_NO IS NULL;


--문제 14번서반아어학과 학생들의 지도교수 조회 없을 경우 지도교수 미지정
SELECT STUDENT_NAME 학생이름,NVL(PROFESSOR_NAME,'지도교수 없음')지도교수
FROM TB_STUDENT S
JOIN TB_DEPARTMENT D ON(S.DEPARTMENT_NO=D.DEPARTMENT_NO)
LEFT JOIN TB_PROFESSOR P ON(S.COACH_PROFESSOR_NO=P.PROFESSOR_NO)
WHERE DEPARTMENT_NAME = '서반아어학과'
ORDER BY STUDENT_NO;

--문제 15번 휴학생이 아닌 학생중 평점이 4.0이상인 학생의 학번/이름/학과이름/평점
SELECT STUDENT_NO"학번",STUDENT_NAME"이름",DEPARTMENT_NAME"학과 이름",ROUND(AVG(POINT),8)"평점"
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
JOIN TB_GRADE USING(STUDENT_NO)
WHERE ABSENCE_YN = 'N'
GROUP BY STUDENT_NO,STUDENT_NAME,DEPARTMENT_NAME
HAVING ROUND(AVG(POINT),8)>=4.0
ORDER BY 1;

--문제 16번 환경조경학과 전공과목들의 과목별 평점
SELECT CLASS_NO,CLASS_NAME,ROUND(AVG(POINT),8)
FROM TB_DEPARTMENT
JOIN TB_CLASS USING(DEPARTMENT_NO)
JOIN TB_GRADE USING(CLASS_NO)
WHERE DEPARTMENT_NAME = '환경조경학과' AND CLASS_TYPE LIKE '전공%'
GROUP BY CLASS_NO,CLASS_NAME
ORDER BY CLASS_NO;


--문제 17번 최경희 학생과 같은과 학생들의 이름과 주소를 조회
SELECT STUDENT_NAME, STUDENT_ADDRESS 
FROM TB_STUDENT 
WHERE DEPARTMENT_NO = (
    SELECT DEPARTMENT_NO FROM TB_STUDENT 
    WHERE STUDENT_NAME = '최경희');
    
--문제 18번 국어국문학과에서 총평점이 가장 높은 학생의 이름과 학번을 표기
SELECT STUDENT_NO,STUDENT_NAME
FROM (
    SELECT STUDENT_NO,STUDENT_NAME
    FROM TB_STUDENT
    JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
    JOIN TB_GRADE USING(STUDENT_NO)
    WHERE DEPARTMENT_NAME='국어국문학과'
    GROUP BY STUDENT_NO,STUDENT_NAME
    ORDER BY AVG(POINT) DESC
)
WHERE ROWNUM = 1;

--문제 19번 '환경조경학과'가 속한 같은 계열 학과들의 학과별 전공 과목 평점
SELECT DEPARTMENT_NAME "계열 학과명" , ROUND(AVG(POINT),1)AS"전공평점"
FROM TB_DEPARTMENT
JOIN TB_CLASS USING(DEPARTMENT_NO)
JOIN TB_GRADE USING(CLASS_NO)
WHERE CATEGORY = (
    SELECT CATEGORY
    FROM TB_DEPARTMENT
    WHERE DEPARTMENT_NAME = '환경조경학과'
)
GROUP BY DEPARTMENT_NAME
ORDER BY DEPARTMENT_NAME;