# Project Structure

The project contains a model `gharchive.events` which is an incremental model that is
set up to read from gharchive. See comments in this model for details. It is a bit
unusual (not pure SQL, but using DuckDB's read_json to read these online jsons).

This model has a start date currently set to 2025-01-01 (set as a global model default
in config.yaml). If you just run this project, you will download and store terrabytes
of data, it will take hours/days and you will probably go out of memory or disk space.

There are a few other models, which are "regular" sqlmesh models, building from this
`events` model: the model `commits` filters only push events from `events` and unnests
these (a push can contain multiple commits). The other models build on this model, e.g.
`funny_commits` selects commits with a message containing the word "fuck".

## How to run

Instead, you should do all `sqlmesh plan` and `sqlmesh run` commands with the flag
`--execution-time '2025-01-01 04:00'` (or a different time), as if the current time is
2025-01-01 04:00. Each hour of Github data is already ~100 MB, ~10 seconds to download.

## Where's the output data

The configured DWH is DuckDB for data and Postgres for state. See config.yaml.
This means to "start over" you need to delete `local.duckdb` and wipe the postgres
database. I made a command `make clean` which lets you do just that.

To look at data, you can use the DuckDB CLI or UI, or any other tools that can
interact with DuckDB. However, sqlmesh also has a useful command:
```
sqlmesh fetchdf "select * from gharchive.funny_commits"
```

However, this command does not display long strings (such as commit messages) well at
all, and there are no CLI arguments to change its formatting (yet).

Another approach to view data is to use the DuckDB UI via `duckdb -ui`, make sure to
attach the `local.duckdb` database as alias `persistent`. I made a command `make ui`
that does both. The downside of this approach is that you cannot both have the UI open
and also make changes with `sqlmesh`: duckdb does not allow modifying while reading.
