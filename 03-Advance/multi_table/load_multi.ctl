-- ============================================================
-- 03-advanced/multi_table/load_multi.ctl
-- One INFILE feeding TWO tables in a single pass.
-- Each row has customer columns AND order columns side by side;
-- SQL*Loader lets you POSITION back to column 1 for the second INTO TABLE.
-- ============================================================
LOAD DATA
INFILE 'customers_orders.csv'
BADFILE 'customers_orders.bad'
TRUNCATE
INTO TABLE customers
FIELDS TERMINATED BY ','
TRAILING NULLCOLS
(
    customer_id,
    customer_name,
    city,
    filler_order_id   FILLER,
    filler_amount      FILLER,
    filler_order_date  FILLER
)
INTO TABLE orders
TRUNCATE
FIELDS TERMINATED BY ','
TRAILING NULLCOLS
(
    customer_id   POSITION(1),
    filler_name   FILLER,
    filler_city   FILLER,
    order_id,
    amount,
    order_date  DATE "YYYY-MM-DD"
)
