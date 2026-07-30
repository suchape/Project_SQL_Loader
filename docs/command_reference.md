#### SQL*Loader Command-Line Reference (most-used options)

Full official reference: `sqlldr help=y` at the command line, or the
Oracle Database Utilities guide, "SQL*Loader" chapter, for your
specific Oracle version.

| Parameter | Example | Notes |
|---|---|---|
| `userid` | `userid=username/password@host:port/service_name` | Omit the password on shared systems and let it prompt instead |
| `control` | `control=load.ctl` | The `.ctl` file driving the load |
| `log` | `log=load.log` | Defaults to `<control-file-name>.log` if omitted |
| `bad` | `bad=load.bad` | Overrides the `BADFILE` named inside the control file |
| `discard` | `discard=load.dsc` | Overrides the `DISCARDFILE` named inside the control file |
| `data` | `data=load.dat` | Overrides the `INFILE` named inside the control file |
| `errors` | `errors=0` | Max tolerated bad records before aborting |
| `skip` | `skip=1` | Skip N physical records (also settable via `OPTIONS` in the .ctl) |
| `load` | `load=1000` | Load only the first N logical records — handy for a dry run on a huge file |
| `rows` | `rows=5000` | Commit interval, conventional path |
| `direct` | `direct=true` | Enables direct path load |
| `parallel` | `parallel=true` | Enables parallel direct path loads |
| `resumable` | `resumable=true` | Suspend instead of abort on resumable errors (e.g. tablespace full) |
| `silent` | `silent=header,feedback` | Suppress banner/progress noise, useful in cron/CI logs |

