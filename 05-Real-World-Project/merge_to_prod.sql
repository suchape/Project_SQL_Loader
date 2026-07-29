-- ============================================================
-- 05-Real-World-Project/merge_to_prod.sql
-- The second half of a "staging -> validate -> merge" pipeline.
-- Run this AFTER load_sales.ctl finishes, once per batch.
-- ============================================================

-- 1) Quarantine rows that can't be trusted as numbers/dates.
--    (In a real project you'd insert these into a dedicated
--    error-queue table with a reason code; kept simple here.)
COLUMN bad_rows_found NEW_VALUE bad_count
SELECT COUNT(*) AS bad_rows_found
FROM sales_staging
WHERE load_batch = 'BATCH_2024_Q1'
  AND ( NOT REGEXP_LIKE(qty, '^[0-9]+$')
        OR unit_price IS NULL
        OR NOT REGEXP_LIKE(unit_price, '^[0-9]+(\.[0-9]+)?$') );


PROMPT Rows failing validation in this batch:
SELECT txn_id, store_code, qty, unit_price
FROM sales_staging
WHERE load_batch = 'BATCH_2024_Q1'
  AND ( NOT REGEXP_LIKE(qty, '^[0-9]+$')
        OR unit_price IS NULL
        OR NOT REGEXP_LIKE(unit_price, '^[0-9]+(\.[0-9]+)?$') );



-- 2) MERGE only the clean rows into production, computing total_amt
--    and casting the date -- staging is the "cheap and honest" layer,
--    production only ever sees data you've decided is trustworthy.
MERGE INTO sales_prod p
USING (
    SELECT
        txn_id,
        store_code,
        product_sku,
        TO_NUMBER(qty)                    AS qty,
        TO_NUMBER(unit_price)              AS unit_price,
        TO_NUMBER(qty) * TO_NUMBER(unit_price) AS total_amt,
        TO_DATE(txn_date, 'YYYY-MM-DD')    AS txn_date
    FROM sales_staging
    WHERE load_batch = 'BATCH_2024_Q1'
      AND REGEXP_LIKE(qty, '^[0-9]+$')
      AND unit_price IS NOT NULL
      AND REGEXP_LIKE(unit_price, '^[0-9]+(\.[0-9]+)?$')
) s
ON (p.txn_id = s.txn_id)
WHEN NOT MATCHED THEN
  INSERT (txn_id, store_code, product_sku, qty, unit_price, total_amt, txn_date)
  VALUES (s.txn_id, s.store_code, s.product_sku, s.qty, s.unit_price, s.total_amt, s.txn_date)
WHEN MATCHED THEN
  UPDATE SET
    p.qty        = s.qty,
    p.unit_price = s.unit_price,
    p.total_amt  = s.total_amt,
    p.txn_date   = s.txn_date;

COMMIT;

PROMPT Rows now in sales_prod:
SELECT COUNT(*) FROM sales_prod;
PROMPT Count of Rows failing validation in this batch: &bad_count
