-- ============================================================
-- 03-advanced/fixed_width/load_fixed.ctl
-- Fixed-width ("positional") data: no delimiters at all.
-- Every field occupies an exact character range, which is common
-- in legacy mainframe extracts and some bank/EDI feeds.
--
-- Layout (1-indexed, inclusive):
--   employee_id    1-3
--   first_name     4-13
--   last_name      14-28
--   email          29-57
--   salary         58-62
--   department_id  63-67
-- ============================================================
LOAD DATA
INFILE 'employees_fixed.dat'
BADFILE 'employees_fixed.bad'
TRUNCATE
INTO TABLE employees
(
    employee_id   POSITION(1:3)   INTEGER EXTERNAL,
    first_name    POSITION(4:13)  CHAR,
    last_name     POSITION(14:28) CHAR,
    email         POSITION(29:57) CHAR,    
    salary        POSITION(58:62) INTEGER EXTERNAL,
    department_id POSITION(63:67) INTEGER EXTERNAL
)
