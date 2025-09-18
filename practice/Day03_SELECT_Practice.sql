-- Q1. 문제: STUDENT 테이블에서 학생 이름의 길이가 3글자인 학생의 학번, 이름을 조회하시오.
-- 힌트: LENGTH(컬럼명) 함수 사용
-- WHERE 절에 LENGTH(STUDENT_NAME) = 3 조건 추가
SELECT STUDENT_NO, STUDENT_NAME
FROM student
WHERE LENGTH(STUDENT_NAME) = 9; -- 김 한글자가 3 byte 이므로 성 + 이름 3글자 모두 조회할 때는 9 byte 크기를 조회

/************
byte 길이
영어(대소문지)와 숫자   : 한 글자당 1 byte
특수 문자나 비영어 문자 : 한 글자당 2 ~ 4 byte
한글, 일본, 중국어와 같은 문자 : 한 글자당 3 byte
이모지 : 4 byte
************/


-- Q2. 문제: STUDENT 테이블에서 주민등록번호 앞 6자리를 생년월일로 하여
-- 학번, 이름, 생년월일을 조회하시오. (별칭: 생년월일)
-- 힌트: SUBSTRING(문자열, 시작위치, 길이) 사용
-- 주민번호 형태: YYMMDD-XXXXXXX, 앞 6자리 추출
SELECT STUDENT_NO, STUDENT_NAME, SUBSTRING(STUDENT_SSN,1,6) AS 생년월일
FROM student;


-- Q3. 문제: DEPARTMENT 테이블에서 학과명에 '학과'를 '전공'으로 바꾼 결과를
-- 학과번호, 기존학과명, 변경학과명으로 조회하시오.
-- 힌트: REPLACE(문자열, 찾을문자열, 바꿀문자열) 사용
SELECT DEPARTMENT_NO, DEPARTMENT_NAME AS 기존학과명, REPLACE(DEPARTMENT_NAME,'학과','전공') AS 변경확과명
FROM department;


-- Q4. 문제: STUDENT 테이블에서 주민등록번호에서 '-' 문자의 위치를 찾아
-- 성별구분번호(주민등록번호 뒷자리 첫 번째 숫자)를 추출하여
-- 학번, 이름, 성별구분번호를 조회하시오.
-- 힌트: LOCATE('-', 주민번호)로 '-' 위치 찾기
-- SUBSTRING(주민번호, LOCATE('-', 주민번호) + 1, 1)로 성별구분번호 추출
SELECT STUDENT_NO, STUDENT_NAME, SUBSTRING(STUDENT_SSN, LOCATE('-', STUDENT_SSN) + 1, 1) AS 성별구분번호 
FROM student;


-- Q5. 문제: GRADE 테이블에서 모든 학점을 소수점 첫째자리까지 반올림하여
-- 학기번호, 과목번호, 학번, 반올림학점으로 조회하시오.
-- 힌트: ROUND(숫자, 자릿수) 사용, 첫째자리는 1
SELECT TERM_NO, CLASS_NO, STUDENT_NO, ROUND(POINT, 1)
FROM grade;


-- Q6. 문제: STUDENT 테이블에서 학번의 마지막 숫자가 짝수인 학생들의 학번, 이름을 조회하시오.
-- 힌트: SUBSTRING(학번, -1, 1)로 마지막 글자 추출
-- MOD(숫자, 2) = 0으로 짝수 판별
SELECT STUDENT_NO, STUDENT_NAME
FROM student
WHERE MOD(SUBSTRING(STUDENT_NO, -1, 1), 2) = 0;


-- Q7. 문제: PROFESSOR 테이블에서 교수 이름의 성(첫 글자)과 이름 길이를 조회하시오.
-- 출력 형태: 교수번호, 교수명, 성, 이름길이
-- 힌트: SUBSTRING(이름, 1, 1)로 첫 글자 추출
-- LENGTH(이름)로 길이 계산
SELECT PROFESSOR_NO, PROFESSOR_NAME, SUBSTRING(PROFESSOR_NAME,1,1) AS 성, LENGTH(PROFESSOR_NAME) AS "이름 길이"
FROM professor;


-- Q8. 문제: STUDENT 테이블에서 주민등록번호를 이용해 성별을 구분하여
-- 학번, 이름, 성별(남/여)을 조회하시오.
-- (힌트: 성별구분번호가 1,3이면 '남', 2,4이면 '여')
-- 힌트: 서브쿼리나 조건문 없이 단순한 방법 사용
-- 성별구분번호를 먼저 확인해보고 직접 조건 작성
SELECT STUDENT_NO, STUDENT_NAME, SUBSTRING(STUDENT_SSN, 8, 1) AS 성별구분번호
FROM student;

-- ================================================================================== 남 여 표시는? ========================
SELECT *
FROM student;


-- Q9. 문제: CLASS 테이블에서 과목번호 길이를 확인하고 현재 형태를 조회하시오.
-- 출력: 과목번호, 과목번호길이, 과목명
-- 힌트: LENGTH() 함수로 현재 과목번호의 길이 확인
SELECT CLASS_NO, LENGTH(CLASS_NO) AS 과목번호길이, CLASS_NAME
FROM class;



-- Q10. 문제: DEPARTMENT 테이블에서 학과명의 첫 두 글자를 추출하여 조회하시오.
-- 출력: 학과번호, 학과명, 첫두글자
-- 힌트: SUBSTRING(학과명, 1, 2)로 첫 두글자 추출
SELECT DEPARTMENT_NO, DEPARTMENT_NAME, SUBSTRING(DEPARTMENT_NO, 1, 2)
FROM department;


-- Q11. 문제: 전체 학생 수를 조회하시오.
-- 출력: 전체학생수
-- 힌트: COUNT(*) 사용
SELECT COUNT(*) AS 전체학생수
FROM student;


-- Q12. 문제: 휴학생 수를 조회하시오.
-- 출력: 휴학생수
-- 힌트: WHERE ABSENCE_YN = 'Y' 조건 사용
SELECT COUNT(*) AS 휴학생수
FROM student
WHERE ABSENCE_YN = "Y";


-- Q13. 문제: 학과별 학생 수를 조회하시오.
-- 출력: 학과번호, 학과별학생수 (학생수 기준 내림차순 정렬)
-- 힌트: GROUP BY 학과번호, ORDER BY COUNT(*) DESC
SELECT DEPARTMENT_NO, COUNT(*) AS 학과별학생수
FROM student
GROUP BY DEPARTMENT_NO
ORDER BY COUNT(*) DESC;


-- Q14. 문제: 전체 학생의 성적에서 최고점, 최저점, 평균점수를 조회하시오.
-- 출력: 최고점, 최저점, 평균점수(소수점 2자리까지)
-- 힌트: MAX(), MIN(), ROUND(AVG(), 2) 함수 활용
SELECT MAX(POINT) AS 최고점, MIN(POINT) AS 최저점, ROUND(AVG(POINT),2) AS 평균점수
FROM grade;


-- Q15. 문제: 학과 분류(CATEGORY)별로 정원(CAPACITY)의 합계와 평균을 조회하시오.
-- 출력: 학과분류, 정원합계, 정원평균 (정원평균 기준 내림차순 정렬)
-- 힌트: GROUP BY CATEGORY, SUM(), AVG() 사용
SELECT CATEGORY, SUM(CAPACITY) AS 정원합계, AVG(CAPACITY) AS 정원평균
FROM department
GROUP BY CATEGORY
ORDER BY AVG(CAPACITY) DESC;


-- Q16. 문제: 2005년도에 입학한 학생들을 학과별로 그룹화하여 학과번호, 학생수를 조회하시오.
-- 힌트: WHERE YEAR(ENTRANCE_DATE) = 2005, GROUP BY DEPARTMENT_NO
SELECT DEPARTMENT_NO, COUNT(*)
FROM student
WHERE YEAR(ENTRANCE_DATE) = 2005
GROUP BY DEPARTMENT_NO;


-- Q17. 문제: 과목별 평균 성적을 조회하시오.
-- 출력: 과목번호, 평균성적 (평균성적 기준 내림차순 정렬)
-- 힌트: GROUP BY CLASS_NO, ORDER BY AVG(POINT) DESC
SELECT CLASS_NO, AVG(POINT) AS 평균성적
FROM grade
GROUP BY CLASS_NO
ORDER BY AVG(POINT) DESC;


-- Q18. 문제: 학기별, 과목별 수강 학생 수와 평균 성적을 조회하시오.
-- 출력: 학기번호, 과목번호, 수강학생수, 평균성적 (학기번호, 평균성적 기준 정렬)
-- 힌트: GROUP BY TERM_NO, CLASS_NO, ORDER BY TERM_NO, AVG(POINT)
SELECT TERM_NO, CLASS_NO, COUNT(*) AS 수강학생수, AVG(POINT) AS 평균성적
FROM grade
GROUP BY TERM_NO, CLASS_NO
ORDER BY TERM_NO, AVG(POINT);


-- Q19. 문제: CLASS_PROFESSOR 테이블에서 전체 교수가 담당하는 서로 다른 과목의 수를 조회하시오.
-- 힌트: COUNT(DISTINCT CLASS_NO) 사용
SELECT COUNT(DISTINCT CLASS_NO) AS 담당과목수
FROM CLASS_PROFESSOR;


-- Q20. 문제: 교수별로 지도하는 학생 수를 조회하시오.
-- 출력: 교수번호, 지도학생수 (지도학생수 기준 내림차순 정렬)
-- 힌트: WHERE COACH_PROFESSOR_NO IS NOT NULL
-- GROUP BY COACH_PROFESSOR_NO, ORDER BY COUNT(*) DESC
SELECT COACH_PROFESSOR_NO, COUNT(*) AS 지도학생수
FROM student
WHERE COACH_PROFESSOR_NO IS NOT NULL
GROUP BY COACH_PROFESSOR_NO
ORDER BY COUNT(*) DESC;