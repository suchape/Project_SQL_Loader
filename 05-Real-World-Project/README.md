### 05 — Real-World Mini Project: Staging → Validate → Merge

**Goal:** put everything from levels 01–04 together into the pattern
you'll actually use at a job: **land → validate → merge**, with a
reconciliation step and a written performance rationale — the kind of
artifact you can literally describe in an interview.

#### Scenario
A retail chain drops a daily `sales_transactions.csv` export from its
POS system. Some rows are dirty (bad quantity, missing price). We must
load what's usable, quarantine what isn't, and produce a clean
`sales_prod` table that downstream reporting can trust.

#### Pipeline
```
sales_transactions.csv
        │
        ▼   (load_sales.ctl)
sales_staging   <-- loosely typed, everything lands here, batch-tagged
        │
        ▼   (merge_to_prod.sql: validate + MERGE)
sales_prod      <-- clean, typed, safe for reporting
```

#### Run it end-to-end
```bash
cd 05-Real-World-Project

# 1. Load the raw file into staging
sqlldr PARFILE=load_sales.par

# 2. Validate + merge into production (Run below statements in this file in SQL Worksheet OR sqlplus)
merge_to_prod.sql
```

#### What to check afterward
1. `load_sales.log` — how many of the 62 data rows loaded to staging
   vs. landed in `.bad`/`.dsc`. (The file has one row with a
   non-numeric `qty` and one with a missing `unit_price` — both should
   still *load into staging* since staging columns accept text/NULL
   loosely; they get caught in step 2 instead.)
2. The `merge_to_prod.sql` output — it prints the specific rows that
   failed validation (bad qty / missing price) before quarantining
   them, then reports the final row count in `sales_prod`.
3. `SELECT * FROM sales_prod ORDER BY txn_id;` — confirm totals
   (`qty * unit_price`) computed correctly and dates parsed correctly.

#### Read next
`performance_tuning.md` in this folder — a checklist of the production
concerns (staging pattern, direct path, commit sizing, parallelism,
reconciliation, idempotency) worth being able to talk through fluently
if this project comes up in an interview.
