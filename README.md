### Oracle SQL*Loader: Zero to Pro

A hands-on, runnable curriculum for learning **Oracle SQL*Loader** —
from your very first CSV load to a production-style
staging → validate → merge pipeline. Every level has real sample data,
a real `.ctl` control file, and a README explaining exactly what's new
and why it matters.

Built as a portfolio project to demonstrate Oracle database and
ETL/data-loading skills.

#### Why this project exists

SQL*Loader is one of those tools that's everywhere in enterprise Oracle
shops (data migrations, nightly batch feeds, vendor file ingestion) but
rarely gets taught step by step. This repo is that missing tutorial —
structured as a progression, not a wall of reference documentation.

#### Prerequisites

- Access to an Oracle database (Oracle XE is free and works fine —
  [Oracle Database Free](https://www.oracle.com/database/free/), or any
  Oracle instance/PDB you already have)
- Oracle Client tools installed, specifically `sqlldr` and `sqlplus` on
  your PATH
- A schema/user with `CREATE TABLE` privileges to practice in

Check your setup:
```bash
sqlldr help=y
sqlplus -v
```

#### Project structure

```
Project_SQL_Loader/
├── 01-Basics/                 Your first load: plain CSV, one table
├── 02-Intermediate/           Headers, quoted text, NULLs, load modes
├── 03-Advanced/
│   ├── multi_table/           One file loading into two tables
│   ├── fixed_width/           Positional (non-delimited) data
│   ├── when_clause/           Conditional loading, bad vs. discarded rows
│   └── direct_path/           Conventional vs. direct path performance
├── 04-Error-Handling/         Reading logs, deliberately messy data
├── 05-Real-World-Project/     Staging → validate → MERGE pipeline
└── docs/                      Cheat sheet + command-line reference
```

#### Learning path

Work through the folders in order — each one builds on the last:

| # | Folder | You'll learn |
|---|---|---|
| 1 | `01-Basics` | Control file anatomy, `APPEND`, date masks, bad/discard files |
| 2 | `02-Intermediate` | Skipping headers, quoted/embedded commas, `NULLIF`, `TRUNCATE` |
| 3 | `03-Advanced` | Multi-table loads, fixed-width data, `WHEN` filtering, direct path |
| 4 | `04-Error-Handling` | Reading `.log` files fluently, `ERRORS=`, reconciling row counts |
| 5 | `05-Real-World-Project` | The staging-table pattern real pipelines use, plus a `MERGE` |

Each folder has its own `README.md` with the exact commands to run and
what to verify afterward. Start here:

#### Quick reference

See [`docs/sqlloader_cheat_sheet.md`](docs/sqlloader_cheat_sheet.md)
for a one-page syntax reference and
[`docs/command_reference.md`](docs/command_reference.md) for
command-line options — useful once you've done the levels once and
just need a refresher.

#### Skills demonstrated

- Oracle SQL*Loader (conventional and direct path)
- Control file design: delimited, positional/fixed-width, and mixed formats
- Data quality handling: bad rows, discarded rows, NULL normalization
- ETL pattern: staging table → validation → `MERGE` into production
- Performance considerations: commit sizing, direct path, parallel loads
- Reading and reconciling `sqlldr` log output


#### License

MIT — see [LICENSE](LICENSE). Use this freely for learning or as a
template for your own portfolio project.
