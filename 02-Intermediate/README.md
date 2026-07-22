### 02 — Intermediate: Headers, Quoted Text, NULLs, and Load Modes

**Goal:** load a more realistic CSV — it has a header row, a text field
that itself contains commas, and some blank values that must become
real SQL `NULL`s (not the string `"NULL"`).

##### New concepts
| Concept | Where |
|---|---|
| `OPTIONS (SKIP=1)` | skips the CSV header row (must be the first line of the control file, before `LOAD DATA`) |
| `OPTIONALLY ENCLOSED BY '"'` | lets `"Priority, handle with care"` be treated as ONE field even though it has a comma inside |
| `NULLIF ship_date=BLANKS` | turns an empty string into a real NULL instead of erroring |
| `TRUNCATE` | empties the table before loading — use instead of `APPEND` when the file is the full, authoritative snapshot |
| `DATE "YYYY-MM-DD"` | a different date mask than level 01, to show these are per-column |

##### Run it
```bash
cd 02-Intermediate
sqlldr PARFILE=load_orders.par
```

##### Verify
```sql
SELECT order_id, ship_date, status FROM orders ORDER BY order_id;
-- ship_date should be NULL for orders 5002 and 5005, not '01-JAN-00' or an error
```

##### Try it yourself
1. Remove `OPTIONS (SKIP=1)` and re-run — watch the header row itself
   fail to load and land in `orders.bad`.
2. Change `TRUNCATE` to `APPEND` and run twice — notice the primary key
   violation in `orders.bad` on the second run.
