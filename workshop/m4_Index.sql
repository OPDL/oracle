CONNECT sh@TESTDB/sh

CREATE TABLE sh.MY_CUSTOMERS AS SELECT * FROM sh.CUSTOMERS NOLOGGING;
CREATE INDEX sh.CUSTOMERS_IXMULTI ON sh.MY_CUSTOMERS (CUST_GENDER, CUST_YEAR_OF_BIRTH, CUST_FIRST_NAME);
EXEC DBMS_STATS.GATHER_TABLE_STATS('SH', 'MY_CUSTOMERS', estimate_percent => 100, method_opt => 'for all columns size 1');

SET AUTOT TRACE EXP
SELECT CUST_ID FROM sh.MY_CUSTOMERS WHERE CUST_GENDER = 'M' AND CUST_YEAR_OF_BIRTH = 1945;
SELECT CUST_ID FROM sh.MY_CUSTOMERS WHERE CUST_GENDER = 'F' AND CUST_FIRST_NAME = 'Yvette';
SELECT * FROM sh.MY_CUSTOMERS WHERE CUST_YEAR_OF_BIRTH = 1951 AND CUST_FIRST_NAME = 'Yvette';

SET AUTOT OFF
DROP TABLE sh.MY_CUSTOMERS;


CONNECT sh@TESTDB/sh

CREATE TABLE sh.MY_CUSTOMERS AS SELECT * FROM sh.CUSTOMERS NOLOGGING; 
UPDATE sh.MY_CUSTOMERS SET CUST_VALID = 'I' WHERE CUST_VALID = 'A' AND MOD(CUST_ID,100) <> 0;

SELECT CUST_VALID, COUNT(*) FROM sh.MY_CUSTOMERS GROUP BY CUST_VALID;

CREATE INDEX sh.MY_CUSTOMERS_IXVALID ON sh.MY_CUSTOMERS (CUST_VALID);

SET AUTOT TRACE EXP STAT
SELECT * FROM sh.MY_CUSTOMERS WHERE CUST_VALID = 'I';
SET AUTOT TRACE EXP STAT
SELECT * FROM sh.MY_CUSTOMERS WHERE CUST_VALID = 'A';
SET AUTOT TRACE EXP STAT
SELECT * FROM sh.MY_CUSTOMERS WHERE CUST_VALID <> 'I';

DROP TABLE sh.MY_CUSTOMERS;



-- ---------------------------------------------------------------------------------
--
-- This is the main SQL statement used throughout the module
-- 
-- ---------------------------------------------------------------------------------

SELECT cs.department_code, cs.course_number,
    cs.course_title, cs.credits, g.grade_code, g.points
    FROM course_enrollments c
    INNER JOIN grades g
        ON c.grade_code = g.grade_code
    INNER JOIN course_offerings co
        ON c.course_offering_id = co.course_offering_id
    INNER JOIN courses cs
        ON co.department_code = cs.department_code
        AND co.course_number = cs.course_number
    WHERE student_id = '206960'
        AND co.term_code = 'FA2012';
		
-- ---------------------------------------------------------------------------------
--
-- This is the SQL statement against the small version of the course enrollments table
-- 
-- ---------------------------------------------------------------------------------

SELECT cs.department_code, cs.course_number,
    cs.course_title, cs.credits, g.grade_code, g.points
    FROM course_enrollments_small c
    INNER JOIN grades g
        ON c.grade_code = g.grade_code
    INNER JOIN course_offerings co
        ON c.course_offering_id = co.course_offering_id
    INNER JOIN courses cs
        ON co.department_code = cs.department_code
        AND co.course_number = cs.course_number
    WHERE student_id = '206960'
        AND co.term_code = 'FA2012';

	
-- ---------------------------------------------------------------------------------
--
-- Use the following two commands to create and drop the index on the studnet id column
-- to see the impact on the execution plan
--
-- ----------------------------------------------------------------------------------
	
-- CREATE INDEX IX_COURSE_ENROLL_STUDENT_ID ON course_enrollments (student_id);
-- DROP INDEX IX_COURSE_ENROLL_STUDENT_ID;