### 03b — Fixed-Width (Positional) Data

**Goal:** load data that has no delimiters — every field lives in a
fixed character range. Common in legacy exports (mainframes, EDI, some
banking formats).

##### Key ideas
- `POSITION(start:end)` addresses exact byte/character ranges instead
  of relying on a delimiter.
- `INTEGER EXTERNAL` = "this range contains digits stored as text;
  convert to a number." Contrast with plain `INTEGER`, which reads raw
  binary — almost never what you want for a text file.
- `CHAR` reads the range as-is (trailing spaces are trimmed by default).
- No `FIELDS TERMINATED BY` clause at all — position does the job that
  delimiters did in earlier levels.

##### Run it
```bash
cd 03-Advanced/fixed_width
sqlldr PARFILE=load_fixed_width.par
```

##### Try it yourself
Open `employees_fixed.dat` in an editor with a monospace font and count
columns — matching a layout spec to exact character positions is the
core skill for this format, and it's exactly what you'd do with a
real vendor file-layout document on the job.
