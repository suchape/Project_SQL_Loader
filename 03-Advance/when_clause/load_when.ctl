-- ============================================================
-- 03-Advanced/when_clause/load_when.ctl
-- WHEN filters rows at load time using a named field. 
-- Rows that don't match go to the DISCARDFILE (not the BADFILE -- they're not
-- malformed, they just didn't meet the business condition).
-- Here: only load rows whose status column is 'VALID'.
-- ============================================================
LOAD DATA
INFILE 'transactions.csv'
TRUNCATE
INTO TABLE transactions_valid
WHEN status = 'VALID'
FIELDS TERMINATED BY ','
TRAILING NULLCOLS
(
    tx_id,
    country,
    amount,
    status
)
