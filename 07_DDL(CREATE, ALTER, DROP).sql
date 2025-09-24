
CREATE TABLE USER_TABLE (
    USER_NO INT PRIMARY KEY,                    -- 컬럼 레벨 PK
    USER_ID VARCHAR(20) UNIQUE,                 -- 컬럼 레벨 UNIQUE
    USER_PWD VARCHAR(30) NOT NULL,              -- 컬럼 레벨 NOT NULL
    GENDER VARCHAR(10) CHECK(GENDER IN ('남', '여')) -- 컬럼 레벨 CHECK
);

CREATE TABLE USER_TABLE (
    USER_NO INT,
    USER_ID VARCHAR(20),
    USER_PWD VARCHAR(30) NOT NULL,  -- NOT NULL은 컬럼 레벨만 가능
    GENDER VARCHAR(10),
    
    -- 👇 테이블 레벨 제약조건들
    CONSTRAINT PK_USER_NO PRIMARY KEY(USER_NO),
    CONSTRAINT UK_USER_ID UNIQUE(USER_ID),
    CONSTRAINT CK_GENDER CHECK(GENDER IN ('남', '여'))
);

/*
LIBRARY_MEMBER 테이블을 생성하세요.

컬럼 정보:
- MEMBER_NO: 회원번호 (숫자, 기본키)
- MEMBER_NAME: 회원이름 (최대 20자, 필수입력)
- EMAIL: 이메일 (최대 50자, 중복불가)
- PHONE: 전화번호 (최대 15자)
- AGE: 나이 (숫자, 7세 이상 100세 이하만 가능)
- JOIN_DATE: 가입일 (날짜시간, 기본값은 현재시간)

제약조건명 규칙:
- PK: PK_테이블명_컬럼명
- UK: UK_테이블명_컬럼명  
- CK: CK_테이블명_컬럼명
*/
USE delivery_app;

CREATE TABLE LIBRARY_MEMBER (
-- 다른 SQL 에서는 컬럼레벨로 제약조건을 작성할 때 CONSTRAINT 를 이용해서
-- 제약조건에 명칭을 설정할 수 있지만
-- MYSQL 은 제약조건 명칭을 MYSQL 자체에서 자동 생성해주기 때문에 명칭 작성을 컬럼레벨에서 할 수 없음
--  컬렴명칭   자료형(자료형크기)  제약조건           제약조건명칭            제약조건들설정
-- MEMBER_NO         INT          CONSTRAINT   PK_LIBRARY_MEMBER_MEMBER_NO      PRIMARY KEY
	MEMBER_NO INT PRIMARY KEY, -- CONSTRAINT PK_LIBRARY_MEMBER_MEMBER_NO 와 같은 명칭 자동생성됨
    MEMBER_NAME VARCHAR(20) NOT NULL,
    EMAIL VARCHAR(5) UNIQUE,  -- CONSTRAINT UK_LIBRARY_MEMBER_EMAIL 와 같은 제약조건 명칭 자동 생성되고 관리
    PHONE VARCHAR(15),
    AGE INT CONSTRAINT CK_LIBRARY_MEMBER_AGE CHECK(AGE >= 7 AND AGE <= 100),
    JOIN_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/*
MEMBER_NO, EMAIL 에는 제약조건 명칭 설정이 안되지만
단순히 PK, UNIQUE, FK, NOT NULL 과 같이 한 단어로 키 형태를 작성하는 경우 제약조건 명칭 설정이 불가능

AGE 에서는 제약조건 명칭이 설정되는 이유
CEHCK 처럼 제약조건이 상세할 경우에는 제약조건 명칭 설정이 가능
CHECK 만 개발자가 지정한 제약조건 명칭 설정이 가능
*/


-- 우리회사는 이메일을 최대 20글자 작성으로 설정 -> 21글자 유저가 회원가입이 안된다!!!! 연락
INSERT INTO LIBRARY_MEMBER (MEMBER_NO, MEMBER_NAME, EMAIL, PHONE, AGE)
VALUES (1, '김독서', 'kim@email.com', '010-1234-5678', 25);


-- Error Code: 1406. Data too long for column 'EMAIL' at row 1	0.000 sec
-- 컬럼에서 넣을 수 있는 크기에 비해 데이터 양이 많을 때 발생하는 문제

-- 방법 1번 : DROP 해서 테이블 새로 생성한다. -> 기존 데이터는...?? 회사 폐업 엔딩...

-- 방법 2번 : EMAIL 컬럼의 크기 변경. ALTER 수정 사용
-- 1. EMAIL 컬럼을 5자에서 50자로 변경
ALTER TABLE LIBRARY_MEMBER
MODIFY EMAIL VARCHAR(50) UNIQUE;
-- ALTER 로 컬럼 속성을 변경할 경우 컬럼명칭에 해당하는 정보를 하나 더 만들어놓은 후 해당하는 제약조건 동작
-- ALTER 에서 자세한 설명 진행..
/*
ALTER 로 컬럼에 해당하는 조건을 수정할 경우
Indexs 에 컬럼명_1 컬럼명_2 컬럼명_3 ... 과 같은 형식으로 추가가 됨


Indexs
EMAIL
EMAIL_2 와 같은 형태로 존재

EMAIL   의 경우 제약조건 VARCHAR(5) UNIQUE,
EMAIL_2 의 경우 제약조건 VARCHAR(50) UNIQUE,

컬럼이름   인덱스들
EMAIL       EMAIL, EMAIL_2 중에서 가장 최근에 생성된 명칭으로 연결
			하지만 새로 생성된 조건들이 마음에 들지 않아 되돌리고 싶은 경우
            EMAIL 과 같이 기존에 생성한 조건을 인덱스 명칭을 통해 되돌아 설정할 수 있음
            인덱스 = 제약조건명칭 동일
*/

select * from library_member;


-- 제약조건 위반 테스트 (에러가 발생해야 정상)
INSERT INTO LIBRARY_MEMBER VALUES (1, '박중복', 'park@email.com', '010-9999-8888', 30, DEFAULT); -- PK 중복
-- Error Code: 1062. Duplicate entry '1' for key 'library_member.PRIMARY'	0.000 sec
INSERT INTO LIBRARY_MEMBER VALUES (6, '이나이', 'lee@email.com', '010-7777-6666', 5, DEFAULT); -- 나이 제한 위반
-- Error Code: 3819. Check constraint 'CK_LIBRARY_MEMBER_AGE' is violated.	0.000 sec

INSERT INTO LIBRARY_MEMBER VALUES (2, '박중복', 'park@email.com', '010-9999-8888', 30, DEFAULT);


/*
온라인 쇼핑몰의 PRODUCT(상품) 테이블과 ORDER_ITEM(주문상품) 테이블을 생성하세요.

1) PRODUCT 테이블:
- PRODUCT_ID: 상품코드 (문자 10자, 기본키)
- PRODUCT_NAME: 상품명 (문자 100자, 필수입력)
- PRICE: 가격 (숫자, 0보다 큰 값만 가능)
- STOCK: 재고수량 (숫자, 0 이상만 가능, 기본값 0)
- STATUS: 판매상태 ('판매중', '품절', '단종' 중 하나만 가능, 기본값 '판매중')

2) ORDER_ITEM 테이블:
- ORDER_NO: 주문번호 (문자 20자)  
- PRODUCT_ID: 상품코드 (문자 10자)
- QUANTITY: 주문수량 (숫자, 1 이상만 가능)
- ORDER_DATE: 주문일시 (날짜시간, 기본값은 현재시간)

주의사항:
- ORDER_ITEM의 PRODUCT_ID는 PRODUCT 테이블의 PRODUCT_ID를 참조해야 함
- ORDER_ITEM은 (주문번호 + 상품코드) 조합으로 기본키 설정 (복합키)

키명칭
-- CONSTRAINT CK_PRODUCT_PRICE
-- CONSTRAINT CK_PRODUCT_STOCK

STATUS VARCHAR(20) DEFAULT '판매중' CONSTRAINT CK_PRODUCT_STATUS CHECK(STATUS IN ('판매중', '품절', '단종'))
-- CONSTRAINT CK_ORDER_ITEM_QUANTITY
*/

CREATE TABLE PRODUCT (
	PRODUCT_ID VARCHAR(10) PRIMARY KEY, -- AUTO_INCREMENT 정수만 가능 VARCHAR 사용 불가
	PRODUCT_NAME VARCHAR(100) NOT NULL,
    PRICE INT CONSTRAINT CK_PRODUCT_PRICE CHECK(PRICE > 0),
    STOCK INT DEFAULT 0 CHECK(STOCK >= 0), -- CONSTRAINT 제약조건 명칭은 필수가 아님
    STATUS VARCHAR(20) DEFAULT '판매중' CHECK(STATUS IN('판매중', '품절', '단종'))
);

CREATE TABLE ORDER_ITEM (
	ORDER_NO VARCHAR(20),
    PRODUCT_ID VARCHAR(10),
    QUANTITY INT CHECK(QUANTITY >= 1),
    ORDER_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO PRODUCT VALUES ('P001', '노트북', 1200000, 10, '판매중');
INSERT INTO PRODUCT VALUES ('P002', '마우스', 25000, 50, '판매중');
INSERT INTO PRODUCT VALUES ('P003', '키보드', 80000, 0, '품절');

INSERT INTO ORDER_ITEM VALUES ('ORD001', 'P001', 2, DEFAULT);
INSERT INTO ORDER_ITEM VALUES ('ORD001', 'P002', 1, DEFAULT);
INSERT INTO ORDER_ITEM VALUES ('ORD002', 'P002', 3, '2024-03-06 14:30:00');
INSERT INTO ORDER_ITEM VALUES ('ORD003', 'P999', 1, DEFAULT);
-- CREATE TABLE 할 때 FK(FOREIGN KEY) 를 작성하지 않아
-- 존재하지 않는 제품번호의 주문이 들어오는 문제가 발생
-- 제품이 존재하고, 제품번호에 따른 주문



-- 테이블 다시 생성
-- 테이블이 존재하는게 맞다면 삭제하겠어
-- 외래키가 설정되었을 경우 메인 테이블은
-- 메인을 기준으로 연결된 데이터가 자식 테이블에 존재할 경우
-- 자식 테이블을 삭제한 후 메인 테이블을 삭제할 수 있다.
-- > ORDER_ITEM 삭제한 후 PRODUCT 테이블을 삭제할 수 있다.
DROP TABLE IF EXISTS PRODUCT;
DROP TABLE IF EXISTS ORDER_ITEM;

-- 메인이 되는 테이블 생성
CREATE TABLE PRODUCT (
	PRODUCT_ID VARCHAR(10) PRIMARY KEY, -- AUTO_INCREMENT 정수만 가능 VARCHAR 사용 불가
	PRODUCT_NAME VARCHAR(100) NOT NULL,
    PRICE INT CONSTRAINT CK_PRODUCT_PRICE CHECK(PRICE > 0),
    STOCK INT DEFAULT 0 CHECK(STOCK >= 0), -- CONSTRAINT 제약조건 명칭은 필수가 아님
    STATUS VARCHAR(20) DEFAULT '판매중' CONSTRAINT CK_PRODUCT_STATUS CHECK(STATUS IN ('판매중', '품절', '단종'))
);

-- ORDER_ITEM 에서 
-- CONSTRAINT ABC FOREIGN KEY  (PRODUCT_ID)   references PRODUCT(PRODUCT_ID) 테이블 레벨로 존재하는 외래키를
-- 위 내용 참조하여 컬럼 레벨로 설정해서   ORDER_ITEM  테이블 생성
-- 상품이 있어야 주문 가능
-- MYSQL 에서 FOREIGN KEY 또한 테이블 컬럼 형태로 작성
CREATE TABLE ORDER_ITEM (
	ORDER_NO VARCHAR(20),
    PRODUCT_ID VARCHAR(10),
    QUANTITY INT CHECK(QUANTITY >= 1),
    ORDER_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    /*
    -- ORDER_ITEM 테이블 안에서 PRODUCT_ID 컬럼은 PRODUCT 테이블 내에 존재하는 컬럼 중 PRODUCT_ID 컬럼명칭과 연결할 것이다.
	-- 단순 참조용
	-- PRODUCT_ID VARCHAR(10) references PRODUCT(PRODUCT_ID), CONSTRAINT 제약조건명칭 자동 생성
	-- 외래키를 작성할 때는 반드시 FOREIGN KEY 라는 명칭이 필수로 컬럼 레벨이나 테이블 레벨에 무조건 들어가야함
    
    -- 외래키의 경우에는 보통 테이블 레벨 형태로 작성
    -- ORDER_ITEM 테이블 내 존재하는 PRODUCT_ID 는 PRODUCT 테이블에 PRODUCT_ID 를 참조할 것이다.
    -- 라는 조건의 내용을 ABC 라는 명칭 내에 저장하겠다 설정
    */
    CONSTRAINT 제약조건명칭 FOREIGN KEY (PRODUCT_ID) references PRODUCT(PRODUCT_ID)
);


INSERT INTO PRODUCT VALUES ('P001', '노트북', 1200000, 10, '판매중');
INSERT INTO PRODUCT VALUES ('P002', '마우스', 25000, 50, '판매중');
INSERT INTO PRODUCT VALUES ('P003', '키보드', 80000, 0, '품절');
-- 왜 0은 안되는거지?

INSERT INTO ORDER_ITEM VALUES ('ORD001', 'P001', 2, DEFAULT);
INSERT INTO ORDER_ITEM VALUES ('ORD001', 'P002', 1, DEFAULT);
INSERT INTO ORDER_ITEM VALUES ('ORD002', 'P002', 3, '2024-03-06 14:30:00');

-- CREATE TABLE 할 때 FK(FOREIGN KEY) 를 작성하지 않아
-- 존재하지 않는 제품번호의 주문이 들어오는 문제가 발생
-- 제품이 존재하고, 제품번호에 따른 주문
INSERT INTO ORDER_ITEM VALUES ('ORD003', 'P999', 1, DEFAULT);
-- PRODUCT 테이블에 존재하지 않은 상품번호로 주문이 들어와 외래키 조건에 위배되는 현상 발생 으로 주문 받지 않음
-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`delivery_app`.`order_item`, CONSTRAINT `ABC` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`))	0.015 sec

select * from product;
select * from order_item;

/*
대학교 성적 관리를 위한 테이블들을 생성하세요.

1) STUDENT 테이블:
- STUDENT_ID: 학번 (문자 10자, 기본키)
- STUDENT_NAME: 학생이름 (문자 30자, 필수입력)
- MAJOR: 전공 (문자 50자)
- YEAR: 학년 (숫자, 1~4학년만 가능)
- EMAIL: 이메일 (문자 100자, 중복불가)

2) SUBJECT 테이블:
- SUBJECT_ID: 과목코드 (문자 10자, 기본키)
- SUBJECT_NAME: 과목명 (문자 100자, 필수입력)
- CREDIT: 학점 (숫자, 1~4학점만 가능)

3) SCORE 테이블:
- STUDENT_ID: 학번 (문자 10자)
- SUBJECT_ID: 과목코드 (문자 10자)  
- SCORE: 점수 (숫자, 0~100점만 가능)
- SEMESTER: 학기 (문자 10자, 필수입력)
- SCORE_DATE: 성적입력일 (날짜시간, 기본값은 현재시간)

주의사항:
- SCORE 테이블의 STUDENT_ID는 STUDENT 테이블 참조(왜래키 사용)
- SCORE 테이블의 SUBJECT_ID는 SUBJECT 테이블 참조(왜래키 사용)  
- SCORE 테이블은 (학번 + 과목코드 + 학기) 조합으로 기본키 설정
- 같은 학생이 같은 과목을 같은 학기에 중복으로 수강할 수 없음
*/

DROP TABLE IF EXISTS STUDENT;
DROP TABLE IF EXISTS SUBJECT;
DROP TABLE IF EXISTS SCORE;

-- YEAR 과 같이 SQL 에서 사용하는 예약어를 SQL 에서는 컬럼명칭으로 사용 가능하나
-- 예약어는 되도록이면 컬럼명칭 사용 지양
CREATE TABLE STUDENT (
	STUDENT_ID VARCHAR(10) PRIMARY KEY,
    STUDENT_NAME VARCHAR(30) NOT NULL,
    MAJOR VARCHAR(50),
    YEAR INT CHECK(YEAR >= 1 AND YEAR <= 4),
    EMAIL VARCHAR(100) UNIQUE
);

CREATE TABLE SUBJECT (
	SUBJECT_ID VARCHAR(10) PRIMARY KEY,
    SUBJECT_NAME VARCHAR(100) NOT NULL,
	CREDIT INT CHECK(CREDIT IN(1,2,3,4))
);

CREATE TABLE SCORE (
	STUDENT_ID VARCHAR(10) PRIMARY KEY,
    SUBJECT_ID VARCHAR(10),
    SCORE INT CHECK(SCORE >= 0 AND SCORE <= 100),
    SEMESTER VARCHAR(10) NOT NULL,
    SCORE_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- 외래키
    -- 기본 문법
    -- 제약조건시작  제약조건명칭  외래키(제약조건을 걸 현재 테이블의 컬럼명칭)  참조하다  메인테이블(내에 존재하는 컬럼명칭)
    -- STUDENT 테이블과 SUBJECT 테이블은 SCORE 테이블과 SCORE 테이블 내 데이터가 사라지기 전까지
    -- 연결되어 있는 STUDENT 테이블과 SUBJECT 테이블은 삭제할 수 없다!
    CONSTRAINT FK_SCORE_STUDENT_ID FOREIGN KEY (STUDENT_ID) references STUDENT(STUDENT_ID),
    CONSTRAINT FK_SCORE_SUBJECT_ID FOREIGN KEY (SUBJECT_ID) references SUBJECT(SUBJECT_ID)
);

-- Error Code: 3813. Column check constraint 'score_chk_1' references other column.	0.000 sec
-- SCORE INT CHECK(CREDIT >= 0 AND CREDIT <= 100), --> SCORE 컬럼명 제약조건에서 관련없는 CREADIT 명칭을 작성했기 때문
-- > 같이 수정하면 에러 문제 해결 : SCORE INT CHECK(SCORE >= 0 AND SCORE <= 100),

INSERT INTO STUDENT VALUES ('2024001', '김대학', '컴퓨터공학과', 2, 'kim2024@univ.ac.kr');
INSERT INTO STUDENT VALUES ('2024002', '이공부', '경영학과', 1, 'lee2024@univ.ac.kr');

INSERT INTO SUBJECT VALUES ('CS101', '프로그래밍기초', 3);
INSERT INTO SUBJECT VALUES ('BM201', '경영학원론', 3);
INSERT INTO SUBJECT VALUES ('EN101', '대학영어', 2);

INSERT INTO SCORE VALUES ('2024001', 'CS101', 95, '2024-1학기', DEFAULT);
INSERT INTO SCORE VALUES ('2024001', 'EN101', 88, '2024-1학기', DEFAULT);
-- Error Code: 1062. Duplicate entry '2024001-EN101-2024-1학기' for key 'score.PRIMARY'	0.000 sec 에러로 데이터 삽입 불가
INSERT INTO SCORE VALUES ('2024002', 'BM201', 92, '2024-1학기', DEFAULT);

-- 제약조건 위반 테스트
INSERT INTO STUDENT VALUES ('2024003', '박중복', '수학과', 2, 'kim2024@univ.ac.kr');
-- 무엇이 위배되었는지 찾아보기 : Error Code: 1062. Duplicate entry 'kim2024@univ.ac.kr' for key 'student.EMAIL'	0.016 sec
-- EMAIL 중복 허용 불가
INSERT INTO SCORE VALUES ('2024001', 'CS101', 150, '2024-1학기', DEFAULT);
-- 무엇이 위배되었는지 찾아보기 : Error Code: 3819. Check constraint 'score_chk_1' is violated.	0.000 sec
-- SCORE 제약조건 0 ~ 100 점수로, 150점이 들어가려 했기 때문에 발생
INSERT INTO SCORE VALUES ('2024001', 'CS101', 90, '2024-1학기', DEFAULT);
-- 무엇이 위배되었는지 찾아보기 : Error Code: 1062. Duplicate entry '2024001' for key 'score.PRIMARY'	0.000 sec
-- 프라이머리 키 중복 에러

-- STUDENT 테이블에서 이메일에 해당하는 컬럼을 중복 불가하도록 설정. 빈칸 허용 금지 자료형 100까지 제한

-- ALTER MODIFY
ALTER TABLE STUDENT
MODIFY EMAIL VARCHAR(100) NOT NULL UNIQUE;

-- 중복된 데이터가 존재하는 상황에서 UNIQUE 를 사용할 경우 중복되는 데이터가 존재하기 때문에 컬럼 제약조건을 수정할 수 없다 거부
-- 기존 데이터가 제약조건에 부합하지 않을 경우 발생

-- 데이터를 수정한 다음에 제약조건을 다시 설정
-- 중복된데이터 SELECT 확인
select email, COUNT(*)
from student
WHERE email IS NOT NULL
GROUP BY email
HAVING COUNT(*) > 1;

-- 중복된 이메일에서 둘 중 한명의 이메일을 수정하거나

-- 모두 삭제

-- 데이터가 키 형태가 아닐 경우에는 안전모드 해지 후 가능

SET SQL_SAFE_UPTATES = 0;
-- Error Code : 1175. You are using safe upated mode and you tried to update a table without a WHERE that uses a KEY column.
DELETE
FROM student
WHERE email = 'kim2024@univ.ac.kr';
-- Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`delivery_app`.`score`, CONSTRAINT `FK_SCORE_STUDENT_ID` FOREIGN KEY (`STUDENT_ID`) REFERENCES `student` (`STUDENT_ID`))	0.015 sec
-- 특정 학생을 삭제하려 했지만 SCORE 테이블에 외래키를 참조하고 있어 함부로 삭제할 수 없다.

-- 두가지 방법
-- 1. 삭제하고자 하는 데이터의 하위 데이터에 존재하는 데이터 먼저 삭제 후
-- 	  부모데이터 삭제

-- 2. 외래키 제약 조건을 잠시 종료하고 삭제 (추천하지 않음)
-- 데이터 무결성 조건을 해지할 수 있으므로 실제 DB 서비스에서는 사용 금지
SET FOREIGN_KEY_CHECKS = 0;

-- 3. ON DELETE CASCADE
-- 부모 테이블에 존재하는 데이터 삭제 시 자식 테이블 또한 자동적으로 삭제될 수 있도록 설정 조건
-- 예를 들어, 배달 어플 - 더조은카페 - 조은카페메뉴
-- 더조은카페 폐업 시 카페메뉴까지 모두 없애야 하는 상황
-- ON DELETE CASCADE 가 만약에 걸려있다면 더조은카페 폐업과 동시에 메뉴까지 모두 삭제하는 설정


CREATE TABLE STUDENT (
	STUDENT_ID VARCHAR(10) PRIMARY KEY,
    STUDENT_NAME VARCHAR(30) NOT NULL,
    MAJOR VARCHAR(50),
    YEAR INT CHECK(YEAR >= 1 AND YEAR <= 4),
    EMAIL VARCHAR(100) UNIQUE
);

CREATE TABLE SUBJECT (
	SUBJECT_ID VARCHAR(10) PRIMARY KEY,
    SUBJECT_NAME VARCHAR(100) NOT NULL,
	CREDIT INT CHECK(CREDIT IN(1,2,3,4))
);

CREATE TABLE SCORE (
	STUDENT_ID VARCHAR(10) PRIMARY KEY,
    SUBJECT_ID VARCHAR(10),
    SCORE INT CHECK(SCORE >= 0 AND SCORE <= 100),
    SEMESTER VARCHAR(10) NOT NULL,
    SCORE_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_SCORE_STUDENT_ID FOREIGN KEY (STUDENT_ID) references STUDENT(STUDENT_ID)
    ON DELETE CASCADE,
    CONSTRAINT FK_SCORE_SUBJECT_ID FOREIGN KEY (SUBJECT_ID) references SUBJECT(SUBJECT_ID)
    ON DELETE SET NULL
);

