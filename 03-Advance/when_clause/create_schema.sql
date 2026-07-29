-- ============================================================
-- 00-setup/create_schema.sql
-- Run this first as your SQL Terminal
-- ============================================================

-- Used in 03-advanced/when_clause
BEGIN EXECUTE IMMEDIATE 'DROP TABLE transactions_valid PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE transactions_valid (
    tx_id      VARCHAR2(10) PRIMARY KEY,
    country    VARCHAR2(5),
    amount     NUMBER(10,2),
    status     VARCHAR2(10)
);

COMMIT;
