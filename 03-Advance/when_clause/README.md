### 03c — Conditional Loading with WHEN

**Goal:** load only the rows that meet a business rule, and understand
the difference between **bad** rows and **discarded** rows.

#### Bad vs. Discarded — the distinction that trips people up
| | Meets column format? | Meets your WHEN condition? | Goes to |
|---|---|---|---|
| **Bad row** | ❌ No (e.g. text in a NUMBER column) | n/a | `BADFILE` |
| **Discarded row** | ✅ Yes | ❌ No | `DISCARDFILE` |

Both are "not loaded," but a bad row is a *data quality* problem while
a discarded row is *working as designed* — you told SQL*Loader you
didn't want it.

#### Key ideas
- `WHEN status = 'VALID'` — once a field is named in the column list,
  you can reference that name directly in `WHEN`; you don't have to
  fall back to raw character positions.
- Every discarded row's raw text lands in `.dsc`, so nothing is
  silently lost — you can re-run a second load against just the
  discard file with a different condition if needed.

#### Run it
```bash
cd 03-Advanced/when_clause
sqlldr PARFILE=load_when.par
```

#### Verify
```sql
SELECT * FROM transactions_valid ORDER BY tx_id;
-- TX004 (status=TEST) should be missing here and present in transactions.dsc
```

#### Try it yourself
Flip the condition to `WHEN status != 'VALID'` and re-run — everything
that previously loaded now lands in the discard file, and vice versa.
This is the fastest way to build intuition for how WHEN evaluates.

#### What WHEN can and can't express

`WHEN` looks like a SQL `WHERE` clause but is far more restrictive —
it only supports simple equality checks, chained with `AND`:

```
WHEN field_name = 'literal'  AND  field_name = 'literal'  ...
```

| Allowed | Not allowed |
|---|---|
| `=` and `!=` only | `<`, `>`, `<=`, `>=` |
| `AND` to chain multiple conditions | `OR` |
| Comparing a field to a quoted literal | `IN (...)`, `BETWEEN`, `LIKE` |
| Named field or `(start:end)` position | Comparing one field to another field |
| | Functions/expressions, e.g. `UPPER(status)` |

If your real filtering logic needs any of the "not allowed" items —
say, `WHERE status IN ('VALID','TEST')` or `WHERE amount > 100` — don't
fight `WHEN` for it. Load everything into a staging table (no `WHEN` at
all, or just a coarse one) and apply real SQL filtering afterward. This
is exactly the approach `05-real-world-project` uses: `WHEN` is a
gatekeeper for obviously-irrelevant rows, not a substitute for a
`WHERE` clause.