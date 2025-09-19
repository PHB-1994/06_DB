/******************************
SUBQUERY(서브쿼리)
하나의 SQL 문 안에 포함된 또 다른 SQL 문
메인쿼리(기존쿼리)를 위해 보조 역할을 하는 쿼리문
- SELECT, FROM, WHERE, HAVING 절에서 사용가능
******************************/

USE delivery_app;
SELECT * FROM stores;


-- =========================
-- 1. 기본 서브쿼리 (단일행)
-- =========================
-- 가장 비싼 메뉴 찾기
-- 1단계 : 최고 가격 찾기
SELECT MAX(price) FROM menus; -- 38900원

-- 2단계 : 그 가격인 메뉴 찾기
SELECT name, price
FROM menus
WHERE price = 38900;

-- 1단계 2단계를 조합해서 한 번에 비싼메뉴찾기를 진행해보자
SELECT name, price
FROM menus
WHERE price = (SELECT MAX(price) FROM menus);


/*
stores : id, name, category, address, phone, rating, delivery_fee
menus : id, store_id, name, description, price, is_popular
*/

-- 1단계 : 평균 메뉴들의 가격 조회
SELECT AVG(price) FROM menus; -- 15221.4286원

-- 2단계 : 메뉴들의 가격 조회
SELECT name, price
FROM menus
WHERE price > 15221.4286;

-- 1단계 2단계를 조합해서 평균보다 비싼 메뉴들만 조회
-- WHERE 절에 price 를 기준으로 평균보다 비싼 메뉴들만 조회하는 조건
SELECT name, price
FROM menus
WHERE price > (SELECT avg(price) FROM menus);


-- 평점이 가장 높은 매장 찾기
-- 1단계 : 최고 평점 찾기
-- 2단계 : 그 평점인 메장 찾기
-- 1단계 2단계를 조합하여 한 번에 평점 최고인 매장을 조회
SELECT max(rating) FROM stores; -- 4.9점

SELECT name
FROM stores
WHERE rating = 4.9;

SELECT name, rating
FROM stores
WHERE rating = (SELECT max(rating) FROM stores);


-- 배달비가 가장 비싼 매장 찾기 stores
-- 1단계 : 가게에서 최고로 비싼 배달비 가격을 조회
-- 2단계 : 가격이 최고로 비싼 배달비의 매장 명칭과 배달비, 카테고리 조회
-- 1단계 2단계를 조합하여 한 번에 가장 비싼 배딜비 가격을 조회하고, 매장의 명칭, 배달비, 카테고리 조회
SELECT max(delivery_fee) FROM stores; -- 5500원

SELECT name, delivery_fee, category
FROM stores
WHERE delivery_fee = 5500;

SELECT name, delivery_fee, category
FROM stores
WHERE delivery_fee = (SELECT max(delivery_fee) FROM stores);



/**********************************************************
           단일행 서브쿼리 실습문제 (1 ~ 10 문제)
***********************************************************/
-- 문제1: 가장 싼 메뉴 찾기
-- 1단계: 최저 가격 찾기
-- 2단계: 그 가격인 메뉴 찾기 (메뉴명, 가격)
-- 조합 : 1단계 2단계를 조합하여 한 번에 조회하기
SELECT min(price) FROM menus; -- 1500원

SELECT name, price
FROM menus
WHERE price = 1500;

SELECT name, price
FROM menus
WHERE price = (SELECT min(price) FROM menus);


-- 문제2: 평점이 가장 낮은 매장 찾기 (NULL 제외)
-- 1단계: 최저 평점 찾기
-- 2단계: 그 평점인 매장 찾기 (매장명, 평점, 카테고리)
-- 조합 : 1단계 2단계를 조합하여 한 번에 조회하기
SELECT min(rating) FROM stores WHERE rating IS NOT NULL; -- 4.2점

SELECT name, rating, category
FROM stores
WHERE rating = 4.2;

SELECT name, rating, category
FROM stores
WHERE rating = (SELECT min(rating) FROM stores WHERE rating IS NOT NULL);


-- 문제3: 배달비가 가장 저렴한 매장 찾기 (NULL 제외)
-- 1단계: 최저 배달비 찾기
-- 2단계: 그 배달비인 매장들 찾기 (매장명, 배달비, 주소)
-- 조합 : 1단계 2단계를 조합하여 한 번에 조회하기
SELECT min(delivery_fee) FROM stores WHERE delivery_fee IS NOT NULL; -- 2000원

SELECT name, delivery_fee, address
FROM stores
WHERE delivery_fee = 2000;

SELECT name, delivery_fee, address
FROM stores
WHERE delivery_fee = (SELECT min(delivery_fee) FROM stores WHERE delivery_fee IS NOT NULL);


-- 문제4: 평균 평점보다 높은 매장들 찾기
-- 1단계: 전체 매장 평균 평점 구하기
-- 2단계: 평균보다 높은 평점의 매장들 찾기 (매장명, 평점, 카테고리)
-- 조합 : 1단계 2단계를 조합하여 한 번에 조회하기
SELECT avg(rating) FROM stores; -- 4.66545점

SELECT name, rating, category
FROM stores
WHERE rating > 4.66545;

SELECT name, rating, category
FROM stores
WHERE rating > (SELECT avg(rating) FROM stores);


-- 문제5: 평균 배달비보다 저렴한 매장들 찾기 (NULL 제외)
-- 1단계: 전체 매장 평균 배달비 구하기
-- 2단계: 평균보다 저렴한 배달비의 매장들 찾기 (매장명, 배달비, 카테고리)
-- 조합 : 1단계 2단계를 조합하여 한 번에 조회하기
SELECT avg(delivery_fee) FROM stores WHERE delivery_fee IS NOT NULL; -- 3179.2453원

SELECT name, delivery_fee, category
FROM stores
WHERE delivery_fee < 3179.2453;

SELECT name, delivery_fee, category
FROM stores
WHERE delivery_fee < (SELECT avg(delivery_fee) FROM stores WHERE delivery_fee IS NOT NULL);


-- 문제6: 치킨집 중에서 평점이 가장 높은 곳
-- 1단계: 치킨집들의 최고 평점 찾기
-- 2단계: 치킨집 중 그 평점인 매장 찾기 (매장명, 평점, 주소)
-- 조합 : 1단계 2단계를 조합하여 한 번에 조회하기
SELECT max(rating) FROM stores WHERE category = '치킨'; -- 4.9점

SELECT name, rating, address
FROM stores
WHERE category = '치킨' AND rating = 4.9;

SELECT name, rating, address
FROM stores
WHERE rating = (SELECT max(rating) FROM stores WHERE category = '치킨');


-- 문제7: 치킨집 중에서 배달비가 가장 저렴한 곳 (NULL 제외)
-- 1단계: 치킨집들의 최저 배달비 찾기
-- 2단계: 치킨집 중 그 배달비인 매장 찾기 (매장명, 배달비)
-- 조합 : 1단계 2단계를 조합하여 한 번에 조회하기
SELECT min(delivery_fee) FROM stores WHERE category = '치킨' AND delivery_fee IS NOT NULL; -- 2000원

SELECT name, delivery_fee
FROM stores
WHERE category = '치킨' AND delivery_fee = 2000;

SELECT name, delivery_fee
FROM stores
WHERE delivery_fee = (SELECT min(delivery_fee) FROM stores WHERE category = '치킨' AND delivery_fee IS NOT NULL);


-- 문제8: 중식집 중에서 평점이 가장 높은 곳
-- 1단계: 중식집들의 최고 평점 찾기
-- 2단계: 중식집 중 그 평점인 매장 찾기 (매장명, 평점, 주소)
-- 조합 : 1단계 2단계를 조합하여 한 번에 조회하기
SELECT max(rating) FROM stores WHERE category = '중식'; -- 4.7점

SELECT name, rating, address
FROM stores
WHERE category = '중식' AND rating = 4.7;

SELECT name, rating, address
FROM stores
WHERE category = '중식' AND rating = (SELECT max(rating) FROM stores WHERE category = '중식');


-- 문제9: 피자집들의 평균 평점보다 높은 치킨집들
-- 1단계: 피자집들의 평균 평점 구하기
-- 2단계: 그보다 높은 평점의 치킨집들 찾기 (매장명, 평점)
-- 조합 : 1단계 2단계를 조합하여 한 번에 조회하기
SELECT avg(rating) FROM stores WHERE category = '피자'; -- 4.7점

SELECT name, rating
FROM stores
WHERE category = '치킨' AND rating > 4.70000;

SELECT name, rating
FROM stores
WHERE category = '치킨' AND rating > (SELECT avg(rating) FROM stores WHERE category = '피자');


-- 문제10: 한식집들의 평균 배달비보다 저렴한 일식집들 (NULL 제외)
-- 1단계: 한식집들의 평균 배달비 구하기
-- 2단계: 그보다 저렴한 배달비의 일식집들 찾기 (매장명, 배달비)
-- 조합 : 1단계 2단계를 조합하여 한 번에 조회하기
SELECT avg(delivery_fee) FROM stores WHERE category = '한식' AND delivery_fee IS NOT NULL; -- 3200원

SELECT name, delivery_fee
FROM stores
WHERE category = '일식' AND delivery_fee < 3200;

SELECT name, delivery_fee
FROM stores
WHERE category = '일식' AND delivery_fee < (SELECT avg(delivery_fee) FROM stores WHERE category = '한식' AND delivery_fee IS NOT NULL); 



-- ===================================================================
-- 2. 다중행 서브쿼리 (MULTI ROW SUBQUERY) N형 1열
-- IN / NOT IN, > ANY / < ANY, > ALL / < ALL, EXISTS / NOT EXISTS 사용
-- 주요 연산자 : IN, NOT IN, ANY, ALL, EXISTS
-- ===================================================================

-- 1. IN 연산자     - 가장 많이 사용되는 다중행 서브쿼리


-- 인기 메뉴가 있는 매장들 조회
-- 1단계 : 인기 메뉴가 있는 매장 ID 들 확인
SELECT DISTINCT store_id
FROM menus
WHERE is_popular = TRUE;

-- 2단계 : 인기있는 매장 id 들에 해당하는 매장 정보 찾기
SELECT s.name, s.category, s.rating, s.id, m.store_id
FROM stores s
JOIN menus m ON s.id = m.store_id
WHERE s.id IN(SELECT DISTINCT store_id FROM menus WHERE is_popular = TRUE);

SELECT s.name, s.category, s.rating, s.id, m.store_id
FROM stores s, menus m
WHERE s.id = m.id
AND s.id IN(SELECT DISTINCT store_id FROM menus WHERE is_popular = TRUE);


-- 2. NOT IN 연산자 - 

-- 인기 메뉴가 없는 매장들 조회
-- name, category, rating
-- 1단계 : 인기 메뉴가 있는 매장들 ID 확인
-- 2단계 : 1단계를 조합하여 그 ID 들에 해당하지 않는 매장들 가져오기
SELECT DISTINCT store_id
FROM menus
WHERE is_popular = TRUE;

SELECT name, category, rating
FROM stores
WHERE id NOT IN(SELECT DISTINCT store_id FROM menus WHERE is_popular = TRUE);


-- 치킨, 피자, 카테고리 매장들만 조회
-- 1단계 : 치킨, 피자 카테고리 중복없이 확인
-- 2단계 : WHERE category = '치킨' OR category = '피자' 이용해서 출력 확인
-- 1 + 2 단계를 조합하여 가게이름, 카테고리, 평점 조회
-- IN 사용
-- FROM stores
SELECT distinct name, category, rating
FROM stores
WHERE category IN('치킨','피자')
ORDER BY category;


-- 20000원 이상 메뉴를 파는 매장들을 조회

-- 1단계 : 20000원 이상 메뉴를 가진 id 들 확인
-- 2단계 : 1단계 결과를 조합하여 해당 매장들에 대한 정보 가져오기
-- 			name, category, rating
-- name 순으로 오름차순 정렬
SELECT  DISTINCT s.name, s.rating, m.price
FROM stores s, menus m
WHERE s.id = m.store_id AND m.price >= 20000
ORDER BY s.name;

SELECT DISTINCT s.name, s.category, s.rating, m.price
FROM stores s, menus m
WHERE s.id = m.store_id IN(SELECT  DISTINCT s.name, m.price FROM stores s, menus m WHERE s.id = m.store_id AND m.price >= 20000)
ORDER BY s.name;

select * from stores;
select * from menus;

/**********************************************************
           다중행 서브쿼리 실습문제 (1 ~ 10 문제)
           IN / NOT IN 연산자
***********************************************************/
-- 문제 1: 카테고리별 최고 평점 매장들 조회
-- 1단계: 카테고리별 최고 평점들 확인
SELECT DISTINCT category, max(rating)
FROM stores
GROUP BY category;

SELECT name, category, rating
FROM stores
WHERE category = (SELECT DISTINCT category, max(rating) FROM stores GROUP BY category);

-- 2단계: 1단계 결과를 조합하여 각 카테고리의 최고 평점 매장들 가져오기



-- 문제 2: 배달비가 가장 저렴한 매장들의 인기 메뉴들 조회
-- 1단계: 가장 저렴한 배달비 매장 ID들 확인
-- 2단계: 1단계 결과를 조합하여 해당 매장들의 인기 메뉴들 가져오기



-- 문제 3: 평점이 가장 높은 매장들의 모든 메뉴들 조회
-- 1단계: 가장 높은 평점 매장 ID들 확인
-- 2단계: 1단계 결과를 조합하여 해당 매장들의 모든 메뉴들 가져오기



-- 문제 4: 15000원 이상 메뉴가 없는 매장들 조회
-- 1단계: 15000원 이상 메뉴를 가진 매장 ID들 확인
-- 2단계: 1단계 결과에 해당하지 않는 매장들 가져오기



-- 문제 5: 메뉴 설명이 있는 메뉴를 파는 매장들 조회
-- 1단계: 메뉴 설명이 있는 메뉴를 가진 매장 ID들 확인
-- 2단계: 1단계 결과를 조합하여 해당 매장들 정보 가져오기



-- 문제 6: 메뉴 설명이 없는 메뉴만 있는 매장들 조회
-- 1단계: 메뉴 설명이 있는 메뉴를 가진 매장 ID들 확인
-- 2단계: 1단계 결과에 해당하지 않는 매장들 가져오기 (단, 메뉴가 있는 매장만)



-- 문제 7: 치킨 카테고리 매장들의 메뉴들 조회
-- 1단계: 치킨 카테고리 매장 ID들 확인
-- 2단계: 1단계 결과를 조합하여 해당 매장들의 메뉴들 가져오기



-- 문제 8: 피자 매장이 아닌 곳의 메뉴들만 조회
-- 1단계: 피자 매장 ID들 확인
-- 2단계: 1단계 결과에 해당하지 않는 매장들의 메뉴들 가져오기



-- 문제 9: 평균 가격보다 비싼 메뉴를 파는 매장들 조회
-- 1단계: 평균 가격보다 비싼 메뉴를 가진 매장 ID들 확인
-- 2단계: 1단계 결과를 조합하여 해당 매장들 정보 가져오기



-- 문제 10: 가장 비싼 메뉴를 파는 매장들 조회
-- 1단계: 가장 비싼 메뉴를 가진 매장 ID들 확인
SELECT max(price)
FROM menus; -- 38900원

SELECT store_id
FROM menus
WHERE price = 38900;

SELECT store_id
FROM menus
WHERE price = (SELECT max(price) FROM menus);

-- 2단계: 1단계 결과를 조합하여 해당 매장과 메뉴 정보 가져오기
-- 		가게 아이디, 메뉴이름, 메뉴가격
SELECT s.name, m.name, m.price
FROM menus m, stores s
WHERE  m.store_id = s.id
AND price = (SELECT max(price) FROM menus);

SELECT s.name, m.name, m.price
FROM menus m, stores s
WHERE s.id In(SELECT store_id
				FROM menus
				WHERE price = (SELECT max(price) FROM menus));
                

-- 4번 ~ 8번 난이도 중
-- 1번 2번 9번 10번 난이도 상





-- 3. ANY 연산자 - 


-- 4. ALL 연산자 - 












