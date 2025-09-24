
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
DROP TABLE LIBRARY_MEMBER;
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








