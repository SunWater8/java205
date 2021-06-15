-- join & sub query
-- 20210615

-- 마당서점 sub query
select * from book;
select * from customer;
select * from orders;

--1 마당서점의고객이요구하는다음질문에대해SQL 문을작성하시오.

--(5) 박지성이 구매한 
--    도서의 출판사수

SELECT COUNT(DISTINCT PUBLISHER)
FROM CUSTOMER C, ORDERS O, BOOK B
WHERE C.CUSTID=O.CUSTID AND O.BOOKID=B.BOOKID
AND C.NAME='박지성'
;

-- 박지성이 구매한 도서 ID
SELECT DISTINCT O.BOOKID
FROM ORDERS O, CUSTOMER C
WHERE O.CUSTID=C.CUSTID AND C.NAME='박지성'
;

SELECT COUNT(DISTINCT PUBLISHER)
FROM BOOK
WHERE BOOKID IN (
    SELECT DISTINCT O.BOOKID
    FROM ORDERS O, CUSTOMER C
    WHERE O.CUSTID=C.CUSTID AND C.NAME='박지성'

)
;





--(6) 박지성이 구매한 도서의 이름, 가격, 정가와 판매가격의 차이

SELECT b.bookname, b.price, B.PRICE-o.saleprice AS PRICEGAP
FROM ORDERS O, CUSTOMER C, BOOK B
WHERE C.CUSTID=O.CUSTID AND O.BOOKID=B.BOOKID
AND C.NAME='박지성'
;

SELECT b.bookname, B.PRICE, B.PRICE-o.saleprice
FROM ORDERS O, BOOK B
WHERE O.BOOKID=B.BOOKID
AND CUSTID=(SELECT CUSTID FROM CUSTOMER WHERE NAME='박지성')
;
SELECT CUSTID FROM CUSTOMER WHERE NAME='박지성';








--(7) 박지성이 구매하지 않은 
--    도서의 이름

SELECT *
FROM ORDERS O, CUSTOMER C
WHERE O.CUSTID=C.CUSTID AND C.NAME='박지성'
;


SELECT BOOKNAME, BOOKID
FROM BOOK
WHERE BOOKID NOT IN (
    SELECT O.BOOKID
    FROM ORDERS O, CUSTOMER C
    WHERE O.CUSTID=C.CUSTID AND C.NAME='박지성'
)
;





--2 마당서점의운영자와경영자가요구하는다음질문에대해SQL 문을작성하시오.
--(8) 주문하지 않은 고객의 이름(부속질의사용)

SELECT C.NAME
FROM ORDERS O, CUSTOMER C
WHERE O.CUSTID(+)=C.CUSTID 
AND O.ORDERID IS NULL
;

SELECT NAME
FROM CUSTOMER
WHERE CUSTID NOT IN (SELECT DISTINCT CUSTID FROM ORDERS)
;

SELECT DISTINCT CUSTID FROM ORDERS ;






--(9) 주문 금액의 총액과 주문의 평균금액
SELECT SUM(SALEPRICE), AVG(SALEPRICE)
FROM ORDERS
;










--(10) 고객의 이름과 고객별 구매액
SELECT C.NAME, SUM(SALEPRICE)
FROM ORDERS O, CUSTOMER C
WHERE O.CUSTID=C.CUSTID
GROUP BY C.NAME
;





--(11) 고객의 이름과 고객이 구매한 도서 목록 

SELECT C.NAME, B.BOOKNAME
FROM BOOK B, ORDERS O, CUSTOMER C
WHERE B.BOOKID=O.BOOKID AND O.CUSTID=C.CUSTID
;







--(12) 도서의 가격(Book 테이블)과 판매가격(Orders 테이블)의
--     차이가 가장 많은 주문

SELECT MAX(B.PRICE-O.SALEPRICE)
FROM ORDERS O, BOOK B
WHERE O.BOOKID=B.BOOKID
;


SELECT B.BOOKNAME, B.PRICE-O.SALEPRICE
FROM ORDERS O, BOOK B
WHERE O.BOOKID=B.BOOKID
AND PRICE-SALEPRICE=(
    SELECT MAX(B.PRICE-O.SALEPRICE)
    FROM ORDERS O, BOOK B
    WHERE O.BOOKID=B.BOOKID
)
;






--(13) 도서의 판매액 평균 보다 
--     자신의 구매액평균이 더높은 고객의 이름

SELECT AVG(SALEPRICE) FROM ORDERS;


SELECT C.NAME, AVG(SALEPRICE)
FROM ORDERS O, CUSTOMER C
WHERE O.CUSTID=C.CUSTID
GROUP BY C.NAME
HAVING AVG(SALEPRICE)>(
    SELECT AVG(SALEPRICE) FROM ORDERS
)-- 평균 구매액
;




  
--3. 마당서점에서 다음의 심화된 질문에 대해 SQL 문을 작성하시오.
--(1) 박지성이 구매한 도서의 출판사와 같은 출판사에서 도서를 구매한 고객의 이름

SELECT B.PUBLISHER
FROM ORDERS O, CUSTOMER C, BOOK B
WHERE O.CUSTID=C.CUSTID AND O.BOOKID=B.BOOKID
AND C.NAME='박지성'
;


SELECT *
FROM ORDERS O, CUSTOMER C, BOOK B
WHERE O.CUSTID=C.CUSTID AND O.BOOKID=B.BOOKID

AND B.PUBLISHER IN (
    SELECT DISTINCT B.PUBLISHER
    FROM ORDERS O, CUSTOMER C, BOOK B
    WHERE O.CUSTID=C.CUSTID AND O.BOOKID=B.BOOKID
    AND C.NAME='박지성'
)

AND C.NAME!='박지성'

;





--(2) 두 개 이상의 서로 다른 출판사에서 도서를 구매한 고객의 이름

SELECT C.NAME, COUNT(DISTINCT PUBLISHER)
FROM ORDERS O, CUSTOMER C, BOOK B
WHERE O.CUSTID=C.CUSTID AND O.BOOKID=B.BOOKID
GROUP BY C.NAME
HAVING COUNT(DISTINCT PUBLISHER) >= 2
;