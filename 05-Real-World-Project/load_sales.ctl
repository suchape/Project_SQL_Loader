-- ============================================================
-- 05-Real-World-Project/load_sales.ctl
-- Load into a STAGING table first, never straight into production.
-- Staging keeps everything as loosely-typed text/simple types so a
-- single malformed row (e.g. qty="BADQTY") doesn't blow up the whole
-- batch -- we clean and validate afterward, in SQL, on our own terms.
-- ============================================================
OPTIONS (SKIP=1)
LOAD DATA
INFILE 'sales_transactions.csv'
APPEND
INTO TABLE sales_staging
FIELDS TERMINATED BY ','
TRAILING NULLCOLS
(
    txn_id,
    store_code,
    product_sku,
    qty,
    unit_price,
    txn_date,
    load_batch  CONSTANT "BATCH_2024_Q1"
)
