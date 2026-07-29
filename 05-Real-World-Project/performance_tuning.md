### Performance & Production Notes

Real SQL*Loader jobs at scale live or die on a handful of decisions.
Here's the checklist worth internalizing:

#### 1. Staging table, always
Never load untrusted external files straight into a production table.
Land them in a loosely-typed staging table (like `sales_staging` in
this project), validate/transform with SQL you fully control, then
`MERGE` into production. If the source file is garbage, you find out
in staging — production stays clean.

#### 2. Choose conventional vs. direct path deliberately
See `03-Advanced/direct_path/README.md`. Rule of thumb: conventional
for anything under ~100k rows or when triggers/constraints must fire
per-row; direct path for large one-shot bulk loads where you've
already validated the data shape.

#### 3. Tune the commit interval (`ROWS=`)
Conventional path commits every `ROWS` records (default 64). Too small
= slow (commit overhead dominates). Too large = a failure mid-batch
rolls back more work and holds undo/redo longer. Start around
`ROWS=5000` for medium files and adjust based on your log's timing.

#### 4. Disable/defer what you can, safely
For very large direct-path loads: disable non-critical indexes and
triggers beforehand, load, then rebuild/re-enable and validate — much
faster than maintaining them row-by-row. Only do this when you can
guarantee data quality without those checks in the loop.

#### 5. Parallel direct path loads
`DIRECT=TRUE PARALLEL=TRUE` lets multiple `sqlldr` sessions load into
the same table/partition concurrently (each needs its own control/log/
bad/discard file names). Genuinely fast for huge files, but adds
operational complexity — only reach for it once single-session direct
path isn't fast enough.

#### 6. Always reconcile counts
Rows in source file (minus header) = rows loaded + rows in `.bad` +
rows in `.dsc`. Script this check. A load that "succeeds" with silently
dropped rows is worse than one that fails loudly.

#### 7. Idempotency
Design loads so re-running them after a partial failure doesn't
duplicate data — this project's `MERGE` step is idempotent (re-running
it against the same batch just re-applies the same UPSERT), which is
why staging + MERGE beats loading straight into production with
`APPEND`.
