
BEGIN EXECUTE IMMEDIATE 'DROP TABLE sales_staging PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE sales_prod PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

CREATE TABLE sales_staging (
    txn_id      VARCHAR2(20),
    store_code  VARCHAR2(10),
    product_sku VARCHAR2(20),
    qty         NUMBER,
    unit_price  NUMBER(10,2),
    txn_date    VARCHAR2(20),
    load_batch  VARCHAR2(20),
    load_ts     DATE DEFAULT SYSDATE
);

CREATE TABLE sales_prod (
    txn_id      VARCHAR2(20) PRIMARY KEY,
    store_code  VARCHAR2(10),
    product_sku VARCHAR2(20),
    qty         NUMBER,
    unit_price  NUMBER(10,2),
    total_amt   NUMBER(12,2),
    txn_date    DATE
);

COMMIT;
