-- ============================================================
-- 02-intermediate/load_orders.ctl
-- New concepts vs. level 01:
--   - Skipping a header row (SKIP 1)
--   - Fields enclosed by quotes that MAY contain commas
--   - Converting empty strings to NULL for a DATE column
--   - TRUNCATE load (wipe table, then load) instead of APPEND
-- ============================================================
OPTIONS (SKIP=1)
LOAD DATA
INFILE 'orders.csv'
BADFILE 'orders.bad'
DISCARDFILE 'orders.dsc'
TRUNCATE
INTO TABLE orders
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
DATE FORMAT 'YYYY-MM-DD'
TRAILING NULLCOLS
(
    order_id,
    customer_id,
    order_date  DATE,
    ship_date   DATE NULLIF ship_date=BLANKS,
    amount,
    status,
    notes
)
