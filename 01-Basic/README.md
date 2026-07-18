### 01 - Basics: SQL Loader Scenario

**Goal:** load a plain CSV into a single table and understand the anatomy of a `.ctl` (control) file. Place all parameters into `.par` file.

##### Files
| File | Purpose |
|---|---|
| `creat_schema.sql` | Databse query to setup table |
| `employees.csv` | 5 sample rows, comma-delimited |
| `load_employees.ctl` | Control file describing how to map the file to the table |
| `load_employees.par` | File which includes all the neccessary parameters |

##### Concepts introduced under `load_employees.ctl` file
- `LOAD DATA` / `INFILE` / `INTO TABLE`
- `FIELDS TERMINATED BY ','`
- `TRAILING NULLCOLS` — rows with fewer trailing fields still load (missing = NULL)
- Column-level date masks: `hire_date DATE` declare format `DATE FORMAT 'DD-MON-YYYY'` which can be apply for all date fields
- `LOG` - `employeess.log` (All the logs capture here)
- Load mode `TRUNCATE` (Remove all existing records before insert). `APPEND` (adds rows without touching existing ones)

##### Under `load_employees.par` file
- `USERID` contains the connection string to the database. `'DB_User/YourDBPassword@//localhost:1521/FREEPDB1'`
- `FREEPDB1` if you are using Oracle Pluggable Database (PDB)
- `CONTROL = load_employees.ctl` name of teh control file
- `LOG = employees.log` name of the log file
- You can define `BADFILE` and `DISCARDFILE` file path as well.

##### Run it
```bash
cd 01-Basics
sqlldr PARFILE=load_employees.par
```

##### Verify
```sql
SELECT * FROM employees ORDER BY employee_id;
```

##### What to look at afterward
Open `employees.log` — SQL*Loader always reports how many rows were read,
loaded, rejected, and discarded. Get comfortable reading this file now;
you'll rely on it constantly at the advanced levels.
