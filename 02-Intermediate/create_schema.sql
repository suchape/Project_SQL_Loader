-- ============================================================
-- 00-setup/create_schema.sql
-- Run this first as your SQL Terminal
-- ============================================================

BEGIN EXECUTE IMMEDIATE 'DROP TABLE orders PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;


/

CREATE TABLE orders (
    order_id     NUMBER(8)     PRIMARY KEY,
    customer_id  NUMBER(6),
    order_date   DATE,
    ship_date    DATE,
    amount       NUMBER(10,2),
    status       VARCHAR2(20),
    notes        VARCHAR2(200)
);



COMMIT;
