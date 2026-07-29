-- ============================================================
-- 04-Error-Handling/load_with_errors.ctl
-- Deliberately messy data to demonstrate the three main outcomes:
--   1. Row 301   -> loads cleanly
--   2. Row 302   -> BAD (non-numeric salary AND bad date format)
--   3. Row 303   -> loads (blank first_name and email become NULL --
--                   this is a WARNING you'll want to catch downstream,
--                   not a load failure)
--   4. Row 304   -> loads cleanly
--   5. Row 301 again -> BAD (PRIMARY KEY violation, duplicate employee_id)
-- ============================================================
LOAD DATA
INFILE 'bad_data.csv'
APPEND
INTO TABLE employees
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
    employee_id,
    first_name,
    last_name,
    email,
    hire_date   DATE "DD-MON-YYYY",
    salary,
    department_id
)
