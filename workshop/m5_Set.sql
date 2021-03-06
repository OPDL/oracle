CONNECT / AS SYSDBA
CREATE TABLE sh.MY_EMPLOYEES AS SELECT * FROM hr.EMPLOYEES;

CONNECT sh@TESTDB/sh

-- UNION vs UNION ALL
SET AUTOT TRACE EXP STAT
SELECT CUST_LAST_NAME AS LastName, CUST_FIRST_NAME AS FirstName
FROM sh.CUSTOMERS
WHERE CUST_CREDIT_LIMIT > 13000
UNION
SELECT LAST_NAME, FIRST_NAME
FROM sh.MY_EMPLOYEES
WHERE SALARY > 10000;

SELECT CUST_LAST_NAME AS LastName, CUST_FIRST_NAME AS FirstName
FROM sh.CUSTOMERS
WHERE CUST_CREDIT_LIMIT > 13000
UNION ALL
SELECT LAST_NAME, FIRST_NAME
FROM sh.MY_EMPLOYEES
WHERE SALARY > 10000;

-- INTERSECT vs JOIN
SELECT CUST_LAST_NAME AS LastName FROM sh.CUSTOMERS
INTERSECT
SELECT LAST_NAME FROM sh.MY_EMPLOYEES;

SELECT DISTINCT C.CUST_LAST_NAME AS LastName 
FROM sh.CUSTOMERS C INNER JOIN sh.MY_EMPLOYEES E ON C.CUST_LAST_NAME = E.LAST_NAME;

-- MINUS vs ANTI-JOIN
SELECT C.CUST_LAST_NAME AS LastName FROM sh.CUSTOMERS C 
MINUS
SELECT E.LAST_NAME FROM sh.MY_EMPLOYEES E;

SELECT DISTINCT C.CUST_LAST_NAME AS LastName
FROM sh.CUSTOMERS C 
WHERE C.CUST_LAST_NAME NOT IN (SELECT E.LAST_NAME FROM sh.MY_EMPLOYEES E);

DROP TABLE sh.MY_EMPLOYEES;
