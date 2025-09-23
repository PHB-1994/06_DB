USE delivery_db;
-- 문제 1
-- CUSTOMERS 테이블에 새로운 고객을 추가하시오. (모든 컬럼 포함)
-- 고객명: 조민수, 이메일: minsoo.jo@gmail.com, 비밀번호: min123!, 전화번호: 010-2468-1357, 주소: 대전시 유성구 대학로 99
INSERT INTO customers(customer_name, email, password, phone, address)
		VALUES(null, '조민수', 'minsoo.jo@gmail.com', 'min123!', '010-2468-1357', '대전시 유성구 대학로 99',now());


-- 문제 2
-- CATEGORIES 테이블에 새로운 카테고리들을 한 번에 추가하시오.
-- Vietnamese (베트남 요리), Western (양식), Salad (샐러드)
INSERT INTO categories(category_name)
		VALUES('Vietnamese'),
			  ('Western'),
              ('Salad');


-- 문제 3
-- STORES 테이블에 새로운 매장을 추가하시오. (모든 컬럼 포함)
-- 매장명: 맘스터치 대학로점, 카테고리: Western(문제2에서 추가한 카테고리), 주소: 대전시 유성구 대학로 100, 전화번호: 042-123-4567
-- 설명: 수제버거 전문점, 최소주문금액: 12000, 배달비: 2500, 평점: 4.6, 운영시간: 매일 10:30 - 22:00
INSERT INTO stores(store_name, category_id, address, phone, description, min_order_amount, delivery_fee, rating, opening_hours)
		VALUES('맘스터치 대학로점', '9', '대전시 유성구 대학로 100', '042-123-4567', '수제버거 전문점', '12000', '2500', '4.6', '매일 10:30 - 22:00');


-- 문제 4
-- CUSTOMERS 테이블에 필수 컬럼만으로 고객들을 한 번에 추가하시오.
-- 고객1: 이수진, suejin@naver.com, sue9876, 서울시 영등포구 당산로 200
-- 고객2: 김태원, taewon88@gmail.com, tae4567, 부산시 부산진구 서면로 150
-- 고객3: 박소희, sohee@daum.net, hope123, 인천시 연수구 송도대로 300
INSERT INTO customers(customer_name, email, password, address)
			VALUES
            ('이수진', 'suejin@naver.com', 'sue9876', '서울시 영등포구 당산로 200'),
            ('김태원', 'taewon88@gmail.com', 'tae4567', '부산시 부산진구 서면로 150'),
            ('박소희', 'sohee@daum.net', 'hope123', '인천시 연수구 송도대로 300');


-- 문제 5
-- MENUS 테이블에 필수 컬럼만으로 메뉴들을 추가하시오. (store_id는 1번 매장 사용)
-- 치킨마요덮밥 8500원, 새우튀김 15000원, 김치찌개 7000원
INSERT INTO menus(store_id,menu_name, price)
			VALUES
            ('1', '치킨마요덮밥', '8500'),
            ('1', '새우튀김', '15000'),
            ('1', '김치찌개', '7000');


-- 문제 6
-- CUSTOMERS 테이블에 컬럼 순서를 바꿔서 고객 정보를 입력하시오.
-- 컬럼 순서: address, customer_name, phone, email, password
-- 데이터: 경기도 고양시 일산서구 주엽동 123, 홍지민, 010-9876-1234, jimin.hong@kakao.com, hong987
INSERT INTO customers(address, customer_name, phone, email, password)
			VALUES('경기도 고양시 일산서구 주엽동 123', '홍지민', '010-9876-1234', 'jimin.hong@kakao.com', 'hong987');


-- 문제 7
-- STORES 테이블에 컬럼 순서를 바꿔서 매장 정보를 입력하시오.
-- 컬럼 순서: delivery_fee, store_name, min_order_amount, category_id, address
-- 데이터: 3500, 네네치킨 일산점, 15000, 1(치킨 카테고리), 경기도 고양시 일산서구 주엽동 456
INSERT INTO stores(delivery_fee, store_name, min_order_amount, category_id, address)
			VALUES('3500', '네네치킨 일산점', '15000', '1', '경기도 고양시 일산서구 주엽동 456');


-- 문제 8
-- customer_id가 1번인 고객의 전화번호를 '010-1111-9999'로 변경하시오.
UPDATE customers
	SET phone = '010-1111-9999'
WHERE customer_id = 1;


-- 문제 9
-- 'BHC치킨 역삼점' 매장의 배달비를 2500원으로, 최소주문금액을 15000원으로 변경하시오.
UPDATE stores
	SET delivery_fee = '2500',
		min_order_amount = 15000
WHERE store_name = 'BHC치킨 역삼점';


-- 문제 10
-- menu_id가 1번인 메뉴(뿌링클)의 가격을 23000원으로 변경하고, 설명을 '리뉴얼된 뿌링클! 더욱 바삭해진 식감'으로 수정하시오.
UPDATE menus
	SET price = '23000',
		description = '리뉴얼된 뿌링클! 더욱 바삭해진 식감'
WHERE menu_id = 1;


-- 문제 11
-- 이메일이 'chulsoo.kim@naver.com'인 고객의 비밀번호를 'newpass123'으로, 주소를 '서울시 강남구 논현로 999'로 변경하시오.
UPDATE customers
	SET password = 'newpass123',
		address = '서울시 강남구 논현로 999'
WHERE email = 'chulsoo.kim@naver.com';


-- 문제 12
-- '전주현대옥 선릉점' 매장의 평점을 4.8로 변경하고, 설명을 '24시간 우린 사골국물이 일품인 국밥 전문점'으로 수정하시오.
UPDATE stores
	SET rating = '4.8',
		description = '24시간 우린 사골국물이 일품인 국밥 전문점'
WHERE store_name = '전주현대옥 선릉점';


-- 문제 13
-- order_id가 4번인 주문의 상태를 'Delivered'로 변경하고, 고객 요청사항을 NULL로 설정하시오.
UPDATE orders
	SET order_status = 'Delivered',
		customer_request = 'NULL'
WHERE order_id = 4;


-- 문제 14
-- 평점이 4.5 이하인 모든 매장의 배달비를 2000원으로 변경하시오.
UPDATE stores
	SET delivery_fee = '2000'
WHERE rating <= 4.5;


-- 문제 15
-- Korean 카테고리에 속한 모든 매장의 운영시간을 '매일 24시간'으로 변경하시오.
UPDATE stores
	SET opening_hours = '매일 24시간'
WHERE category_id = 2;

-- 가게에서 CHICKEN 카테고리에 속한 모든 매장의 운영 시간을 매일 12시간으로 변경
SELECT * FROM categories WHERE category_name = 'Chicken';

-- 매일 12시간 과 Chicken 은 html 에서 소비자가 변경하고자하여 선택하거나 작성한 데이터를 javascript 변수이름을 통해서
-- java 서버로 전달되고, java 에서는 javascript 로 전달받은 데이터를 java 내부에 설정한 변수이름으로 전달 받은 다음에
-- SQL 로 전달받은 데이터를 수정 변경하겠다 요청
UPDATE stores
	SET opening_hours = '매일 12시간'
WHERE category_id = (SELECT category_id FROM categories WHERE category_name = 'Chicken');


-- 문제 16
-- 새로운 주문을 ORDERS 테이블에 추가하시오.
-- 고객: customer_id 2번, 매장: store_id 1번, 주문상태: Pending, 총금액: 26000원
-- 배달주소: 서울시 서초구 서초대로 456, 고객요청: 양념 소스 추가 부탁드려요
INSERT INTO orders(customer_id, store_id, order_status, total_price, delivery_address, customer_request)
		VALUES('2', '1', 'Pending', '26000', '서울시 서초구 서초대로 456', '양념 소스 추가 부탁드려요');


-- 문제 17
-- 위에서 추가한 주문(가장 최근 주문)의 상태를 'Cooking'으로 변경하시오.
UPDATE ORDERS 
SET order_status = 'Cooking' 
WHERE order_id = 10;


-- 문제 18
-- 새로운 고객을 추가하고 해당 고객이 주문하는 시나리오를 완성하시오.
-- 고객: 신미래, future@email.com, future2024, 010-2024-2025, 경기도 성남시 분당구 판교로 500
-- 주문: 스타벅스 판교점에서 아이스 아메리카노 2잔, 총 13200원, 주문상태 Pending
INSERT INTO customers(customer_name, email, password, phone, address)
		VALUES('신미래', 'future@email.com', 'future2024', '010-2024-2025', '경기도 성남시 분당구 판교로 500');

-- 주문 추가 
INSERT INTO ORDERS (customer_id, store_id, order_status, total_price, delivery_address) 
VALUES (13, 7, 'Pending', 13200, '경기도 성남시 분당구 판교로 500');


-- 문제 19
-- '동대문엽기떡볶이 신림점' 매장의 모든 메뉴 가격을 10% 인상하시오. (가격 × 1.1로 계산)
-- menu_id 12 인 price = 14000
-- menu_id 14 인 price = 2000

UPDATE menus
	SET price = 14000
WHERE menu_id = 12;

UPDATE menus
	SET price = 2000
WHERE menu_id = 13;

SELECT store_id, store_name FROM stores WHERE store_name = '동대문엽기떡볶이 신림점';

UPDATE menus
	SET price = (price * 1.1)
WHERE store_id = (SELECT store_id FROM stores WHERE store_name = '동대문엽기떡볶이 신림점');


-- 문제 20
-- 전화번호가 등록되지 않은(NULL) 모든 고객의 전화번호를 '미등록'으로 변경하시오.
UPDATE customers
	SET phone = '미등록'
WHERE phone IS NULL;

-- ERROR 1062 : UNIQUE 는 NULL 값도 모든 컬럼에서 1개만 존재해야함
-- 빈 칸 마저도 특별하게 고유하게 단일로 존재해야하는 데이터!


-- 문제 21
-- 'gmail.com'이 포함된 이메일을 사용하는 고객들의 주소에 '[Gmail 사용자]' 표시를 추가하시오.
-- UPDATE 구문에 함수 이용해서 수정할 수 있다.
UPDATE customers
SET address = CONCAT('[Gmail 사용자] ',email)
WHERE email LIKE '%gmail.com%';


-- 문제 22
-- MENUS 테이블에서 설명(description)이 NULL인 메뉴들의 설명을 '설명 준비중'으로 변경하시오.
UPDATE MENUS 
SET description = '설명 준비중' 
WHERE description IS NULL;


-- 문제 23
-- ORDERS 테이블에서 고객 요청사항(customer_request)이 NULL인 주문들을 '특별 요청 없음'으로 변경하시오.
UPDATE orders
SET customer_request = '특별 요청 없음' 
WHERE customer_request IS NULL;


-- 문제 24
-- 가격이 20000원 이상인 모든 메뉴를 인기메뉴(is_popular = TRUE)로 변경하시오.
UPDATE MENUS 
SET is_popular = TRUE 
WHERE price >= 20000;


SET SQL_SAFE_UPDATES = 0;
SET SQL_SAFE_UPDATES = 1;
select * from stores;
select * from menus;
select * from orders;
select * from customers;
select * from categories;