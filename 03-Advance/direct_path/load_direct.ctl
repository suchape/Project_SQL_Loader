-- ============================================================
-- 03-Advanced/direct_path/load_direct.ctl
-- Same shape as 01-basics, but run with DIRECT=TRUE on the command
-- line. Direct path writes formatted data blocks straight above the
-- high-water mark, bypassing most of the conventional SQL insert
-- machinery (undo, redo can be minimized, buffer cache). It's much
-- faster for large one-shot loads, with tradeoffs -- see README.
-- ============================================================
LOAD DATA
INFILE 'employees_bulk.csv'
BADFILE 'employees_bulk.bad'
DISCARDFILE 'employees_bulk.dsc'
TRUNCATE
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
