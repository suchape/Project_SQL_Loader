### 03a — Multiple Tables From One File

**Goal:** a single denormalized input file (customer + order fields on
the same row) gets split into two normalized tables in one SQL*Loader
run — no staging table required.

##### Key ideas
- You can repeat `INTO TABLE ... ( ... )` as many times as you like in
  one control file.
- `FILLER` marks a source column that should be **read but not stored**
  in the *current* INTO TABLE clause (it's still consumed positionally).
- `POSITION(1)` resets the column pointer back to the start of the
  record for the next `INTO TABLE` block, since each block walks the
  row independently.
- `WHEN` can restrict which rows go into which table — useful when one
  file contains mixed row types (e.g. a "record type" flag column).

##### Key ideas
 Run it
```bash
cd 03-Advanced/multi_table
sqlldr PARFILE=load_multi_table.par
```

##### Verify
```sql
SELECT * FROM customers WHERE customer_id IN (201,202,203);
SELECT * FROM orders WHERE order_id IN (5001,5002,5003);
```

> **Want to route only some rows?** Add a `WHEN` clause under any
> `INTO TABLE` line, e.g. `WHEN city = 'Chicago'`, to load only matching
> rows into that table. Omit it (as this example does) to load every
> row into both tables unconditionally.
