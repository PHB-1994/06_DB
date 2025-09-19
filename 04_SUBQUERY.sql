/******************************
SUBQUERY(서브쿼리)
하나의 SQL 문 안에 포함된 또 다른 SQL 문
메인쿼리(기존쿼리)를 위해 보조 역할을 하는 쿼리문
- SELECT, FROM, WHERE, HAVING 절에서 사용가능
******************************/

USE delivery_app;
SELECT * FROM stores;


-- ============================
-- 1. 기본 서브쿼리 (단일행)
-- ============================
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
