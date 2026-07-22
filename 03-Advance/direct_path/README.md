### 03d — Direct Path Loading & Performance

**Goal:** understand the difference between **conventional path** (what
you've used in every level so far) and **direct path** loading, and
when to reach for each.

#### Conventional vs. Direct Path
| | Conventional path (default) | Direct path |
|---|---|---|
| How it writes | Generates `INSERT` statements under the hood | Formats Oracle data blocks directly, written above the high-water mark |
| Triggers/constraints | Fully honored | Most triggers **disabled**, referential integrity checks deferred/skipped* |
| Indexes | Maintained row-by-row | Rebuilt/merged in bulk at the end |
| Speed | Slower | Much faster for large volumes |
| Concurrency | Table remains normally usable | Table (or partition) is locked more aggressively |
| Redo/Undo | Full | Can be minimized (`UNRECOVERABLE`/`NOLOGGING` scenarios) |

\* Because integrity checks are relaxed, **you are responsible** for
making sure the data is actually clean before a direct path load —
that's why levels 01–03c exist, so you build that habit first.

#### Run it — conventional
```bash
cd 03-Advanced/direct_path
sqlldr PARFILE=load_conventional_path.par
```

#### Run it — direct path
```sql
-- reset the table first
TRUNCATE TABLE employees;
```
```bash
sqlldr PARFILE=load_direct_path.par direct=true
```

#### What to compare in the two `.log` files
- **Elapsed time** — direct path should noticeably win, especially as
  row counts grow into the tens/hundreds of thousands.
- The log explicitly states `Path used: Conventional` vs
  `Path used: Direct` near the top — always double check this instead
  of trusting the command line alone.

#### When NOT to use direct path
- Small files (the setup/teardown overhead isn't worth it)
- Tables with complex triggers your load depends on
- When you need every constraint actively enforced during the load
  itself rather than validated afterward
