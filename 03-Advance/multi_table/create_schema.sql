-- ============================================================
-- 00-setup/create_schema.sql
-- Run this first as your SQL Terminal
-- We have already created orders table in 02-Intermediate/create_schema.sql, so we will not create it again here.
-- ============================================================

BEGIN EXECUTE IMMEDIATE 'DROP TABLE customers PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;



/
CREATE TABLE customers (
    customer_id   NUMBER(6) PRIMARY KEY,
    customer_name VARCHAR2(100),
    city          VARCHAR2(50)
);



COMMIT;
