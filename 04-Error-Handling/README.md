### 04 — Error Handling: Reading Logs, Bad Files, and Discard Files

**Goal:** Learn to read the
`.log` file, the `.bad` file, and the `.dsc` file like a diagnostic
report instead of dreading them.

#### The three output files, in plain terms
| File | Contains | Why a row ends up here |
|---|---|---|
| `<name>.log` | A full run summary | Always generated; read this first |
| `<name>.bad` | Exact original rows that **failed to load** | Data type mismatch, constraint violation (PK/NOT NULL/CHECK), format mask mismatch |
| `<name>.dsc` | Exact original rows **intentionally skipped** | A `WHEN` clause condition wasn't met (see `03-advanced/when_clause`) |

#### Run it
```bash
cd 04-Error-Handling
sqlldr PARFILE=load_with_error.par
```

Expect the load to finish "successfully" from the shell's point of
view (exit code) even though 2 of 5 rows failed — **SQL*Loader does not
treat rejected rows as a fatal error by default.** This surprises a lot
of people the first time.

#### Read the log file
Open `bad_data.log` and find the section per record — for row 302
you'll see something like:
```
Record 2: Rejected - Error on table EMPLOYEES, column SALARY.
ORA-01722: invalid number
```
and for the duplicate key row:
```
Record 5: Rejected - Error on table EMPLOYEES, column EMPLOYEE_ID.
ORA-00001: unique constraint violated
```

#### Key command-line controls
| Option | What it does |
|---|---|
| `ERRORS=n` | Abort the whole load after `n` rejected rows (default 50) |
| `ERRORS=0` | Zero tolerance — stop at the very first bad row |
| `SKIP=n` | Skip the first `n` physical rows (headers, or resuming a partial load) |
| `ROWS=n` | Commit every `n` rows (conventional path) — smaller = safer, slower; larger = faster, riskier |

#### Try it yourself
1. Re-run with `errors=0` on the command line and watch the load abort
   at the very first bad record instead of continuing.
2. Fix `bad_data.csv` row by row, re-running after each fix, until
   `bad_data.bad` comes back empty. This "fix, re-run, inspect the log"
   loop is exactly the workflow you'll use with real vendor files.
3. Write a one-line SQL*Plus check: `SELECT COUNT(*) FROM employees
   WHERE employee_id BETWEEN 301 AND 304;` and reconcile the count
   against the log's "Rows successfully loaded" line — this
   reconciliation habit is what separates people who trust their loads
   from people who get burned by silent partial failures.
