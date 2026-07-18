-- ============================================================
-- 00-setup/create_schema.sql
-- Run this first as your SQL Terminal
-- ============================================================

BEGIN EXECUTE IMMEDIATE 'DROP TABLE employees PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;

/

CREATE TABLE employees (
    employee_id   NUMBER(6)      PRIMARY KEY,
    first_name    VARCHAR2(50),
    last_name     VARCHAR2(50),
    email         VARCHAR2(100),
    hire_date     DATE,
    salary        NUMBER(10,2),
    department_id NUMBER(4)
);



COMMIT;
