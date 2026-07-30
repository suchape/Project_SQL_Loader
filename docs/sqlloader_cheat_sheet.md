### SQL*Loader Cheat Sheet

#### Command line
```bash
sqlldr userid=username/password@host:port/service_name 
       control=file.ctl log=file.log \
       bad=file.bad discard=file.dsc \
       errors=50 rows=64 skip=0 direct=false parallel=false
```

#### Control file skeleton
```
OPTIONS (SKIP=1)            -- optional, header rows / resume point
LOAD DATA
INFILE 'source.csv'
BADFILE 'source.bad'
DISCARDFILE 'source.dsc'
APPEND | INSERT | REPLACE | TRUNCATE
INTO TABLE target_table
WHEN column_name = 'value'  -- optional filter
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
    col1,
    col2   DATE "YYYY-MM-DD",
    col3   NULLIF col3=BLANKS,
    col4   CONSTANT 'X',
    col5   FILLER
)
```

#### Parameter File (PARFILE) `.par`
This additional file allows you to group all command‑line parameters into a single place, making the `sqlldr` invocation much simpler and more manageable. It also helps protect sensitive information by keeping the database connection string and password out of the visible command line.

```
USERID = 'username/password@host:port/service_name'
CONTROL = load_data_sample.ctl
LOG = load_data_sample.log
BAD = load_data_sample.bad
DISCARD = load_data_sample.dsc
```
Execution  `sqlldr`
```
 sqlldr PARFILE=load_data_sample.par  
```

#### Load modes
| Mode | Behavior |
|---|---|
| `INSERT` | Table must be empty, or the load fails |
| `APPEND` | Adds rows, leaves existing rows untouched |
| `REPLACE` | Deletes all rows via `DELETE`, then loads |
| `TRUNCATE` | Empties the table via `TRUNCATE`, then loads (faster than REPLACE) |

#### Field types you'll use constantly
| Syntax | Meaning |
|---|---|
| `POSITION(1:10)` | Fixed-width column, characters 1 through 10 |
| `INTEGER EXTERNAL` | Digits stored as text, converted to a number |
| `DATE "MASK"` | Parse using an explicit Oracle date format mask |
| `CHAR` | Plain text, trailing spaces trimmed |
| `FILLER` | Read the column but do not store it |
| `CONSTANT 'x'` | Every row gets this literal value, ignoring the file |
| `NULLIF col=BLANKS` | Empty string becomes real NULL |
| `TRAILING NULLCOLS` | Missing trailing fields become NULL instead of erroring |

#### Output files, at a glance
| File | Meaning |
|---|---|
| `.log` | Run summary — always check this first |
| `.bad` | Rows that failed to load (data/type/constraint errors) |
| `.dsc` | Rows intentionally skipped by a `WHEN` clause |


#### Useful command-line switches
| Switch | Use |
|---|---|
| `errors=0` | Stop at the first bad row (zero tolerance) |
| `errors=n` | Abort after n bad rows (default 50) |
| `skip=n` | Skip the first n physical rows |
| `rows=n` | Commit frequency for conventional path |
| `direct=true` | Use direct path loading |
| `parallel=true` | Allow multiple concurrent direct path sessions |
| `resumable=true` | Suspend (instead of abort) on space-related errors, giving you time to fix and continue |

#### Fast diagnosis checklist when a load "fails"
1. Open the `.log` — what's the exact ORA- error per rejected record?
2. Is the row in `.bad` (real error) or `.dsc` (WHEN condition, by design)?
3. Do the row counts reconcile? `rows in file == loaded + bad + discarded`
4. Is the delimiter/enclosure actually consistent for every row, or is
   one row missing a closing quote and throwing off everything after it?
