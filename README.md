# SQLMesh Playground

This repository is a self-contained SQLMesh project that you can run with one click in a
Github Codespace.

Click the button below to open this repository in a Gitpod:

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/michiel-de-muynck/sqlmesh_playground)

## Our data source: gharchive

The data comes from https://www.gharchive.org/, which contains a full backup
of all public Github events, commits, issues, PRs, etc.

The data can be downloaded in compressed jsons containing all events of one
hour of Github activity. For example, https://data.gharchive.org/2024-11-27-14.json.gz
contains all events from 2024-11-27 from 14:00-15:00.

For documentation regarding the various event types and contents of the
corresponding jsons, see
https://docs.github.com/en/rest/using-the-rest-api/github-event-types?apiVersion=2022-11-28

## Project structure

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

### How to run

Instead, you should do all `sqlmesh plan` and `sqlmesh run` commands with the flag
`--execution-time '2025-01-01 04:00'` (or a different time), as if the current time is
2025-01-01 04:00. Each hour of Github data is already ~100 MB, ~10 seconds to download.

### Where's the data

The configured DWH is DuckDB, for both data and sqlmesh state. See config.yaml.
This means you can easily "start over" by deleting `local.duckdb`. In production use
cases, you should use an OLTP database for state (e.g. postgres).

To look at data, you can use the DuckDB CLI or UI, or any other tools that can
interact with DuckDB. However, sqlmesh also has a useful command:
```
sqlmesh fetchdf "select * from gharchive.funny_commits"
```

However, this command does not display long strings (such as commit messages) well at
all, and there are no CLI arguments to change its formatting (yet). I vibe coded a hacky
workaround: I made a `sitecustomize.py` script, which if it is on your `PYTHONPATH`
and if the env var `NOCROP` is 1, alters Pandas global settings to sqlmesh display
dataframes without cutting off rows, colums or long strings. To use it:
```
PYTHONPATH=. NOCROP=1 sqlmesh fetchdf "select * from gharchive.funny_commits"
```

## Exercises

1. Plan & run the project as if it was 2025-01-01 04:00. Explore the project, look at
  some data.

2. Do a sqlmesh plan, as if it was 2025-01-01 05:00. Notice that sqlmesh only
  fetches data for the newest increment. NOTE: this does not currently work as I expect?

3. Make a change to the model `funny_commits`, e.g. changing the swear word.
  Do a `sqlmesh plan dev`, creating a "dev" environment. Notice it can reuse the data
  from prd.

4. "Deploy" your change to prd, by doing a sqlmesh plan to prd. Note that this can be
  a near-instant "virtual" update, only updating the views, no need to update data.
  To really see this, use execution time 06:00.
