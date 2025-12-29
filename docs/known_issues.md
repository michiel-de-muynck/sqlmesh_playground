# Known issues

While creating this demo SQLMesh project, I ran into several issues with SQLMesh: bugs,
annoyances, or things where I didn't fully understand why they weren't behaving the way
I expected them to. I wrote down those issues here.

## No stable UI

There is a command `sqlmesh ui` that starts the SQLMesh UI. However, this is deprecated.
When you run that command you get the warning:

> [WARNING] The UI is deprecated and will be removed in a future version. Please use the
> SQLMesh VSCode extension instead. Learn more at https://sqlmesh.readthedocs.io/en/stable/guides/vscode/

However, the recommended replacement, the VSCode extension, is still in preview and
buggy:

> The SQLMesh Visual Studio Code extension is in preview and undergoing active
> development. You may encounter bugs or API incompatibilities with the SQLMesh
> version you are running.

The VSCode extension has significantly fewer features and functionality, but worse, it
crashes frequently (see next point).

## SQLMesh VSCode extension crashes

When enabling the SQLMesh extension, everything works until I run a `sqlmesh` command
in the terminal. Any command, even just `sqlmesh --help`, makes the VSCode extension
crash and give error messages (Error: Client got disposed and can't be restarted).
Restarting the VSCode extension (F1 > SQLMesh: Restart Servers) or reloading the window
(F1 > Developer: Reload Windows) fixes it temporarily, until the next `sqlmesh` terminal
command.

Strangely, running `sqlmesh` commands via either a Jupyter notebook (using `!`) or via
`uvx` (`uvx sqlmesh`) does not cause this crash. I do not know what causes the issue,
but as a workaround, this playground aliases `sqlmesh` to `uvx sqlmesh`.

## Models with model kind "FULL" not always materialized

A model with kind "FULL" is the simplest type of model. It is similar to materialization
"table" in dbt. When refreshing, the whole table should be recreated in full. There
should be no incremental updates or other complex temporal logic.
So data intervals should at most determine _when_ a model gets recalculated (or skipped),
but otherwise should not have any effect on the data.

However, that is not the case. When creating, changing or restating a model with kind
FULL, and then doing a run with an interval that is either:

* before the model's start date, or
* smaller than the model's interval_unit

Then the run is successful without warnings, but the model is materialized without data
(0 rows).

I reported this bug as a Github issue:
https://github.com/TobikoData/sqlmesh/issues/5236

(update December 2025) In the latest version of sqlmesh, this situation also runs into
an error where sqlmesh does not create the underlying table but still tries to point a
view to it, which gives an error:
https://github.com/TobikoData/sqlmesh/issues/5612

## Poor interaction with DuckDB's READ_JSON

This project uses DuckDB's `READ_JSON` function to read (zipped) json's from online URLs
with the source data (Github events). This was the cause of a lot of frustration:

* When SQLMesh "runs" an incremental model, it first creates an empty table with the
  right data types, then fills it up with data for each interval. To create the empty
  table, SQLMesh runs the SQL for a data interval at 1970-01-01 with `limit 0`. Since
  there is no source data for 1970-01-01, this fails with an HTTP 404 error. We have to
  manually use `@if` logic to make SQLMesh do something else when creating a model:
  * Initially I just changed the date to a date for which there is data. However, there
    were several instances where interacting with SQLMesh was slow because it was
    actually fetching large json's, just to parse/visualize/plan/display lineage.
  * I ultimately settled for using a dummy SELECT statements with only nulls instead,
    but that still has some issues:
    * It requires specifying the columns explicitly (either via casting or via the
      [columns property](https://sqlmesh.readthedocs.io/en/stable/concepts/models/overview/#columns)).
      Unlike dbt's contracts, these columns are not checked. If the real data does not
      match these column specifications, the docs say you get undefined behavior.
    * If you change the URL, SQLMesh does not think the model changed.

To be fair, these issues are not bugs or flaws in SQLMesh itself. SQLMesh tries to parse
and understand your SQL queries to e.g. derive column names and data types, but that is
just not possible with DuckDB's READ_JSON. This model is doing ingestion, not transformation
(in dbt terms we're not doing the "T" in ETL), via non-standard SQL functions, so some
rough edges are expected.

## Error messages

## Failing tests error message

## `--end` vs `--execution-time`

## Release & commit frequency

While not a technical bug per se, it is quite concerning that since Fivetran acquired
dbt on 2025-10-13, the number of commits to sqlmesh fell off a cliff:

![alt text](img/sqlmesh_commits.png)

https://github.com/TobikoData/sqlmesh/graphs/commit-activity

Similarly, while SQLMesh famously released new versions very frequently, with multiple
releases a week, even sometimes multiple in one day, this also changed. In November 2025
there was 1 release (which only fixed 1 bug).

## Prod environment is treated as a special case

"Error: The start and end dates can't be set for a production plan without restatements."

## DuckDB lock

## `.sql` file extension for models

## Fetchdf annoyances

## DuckDB views

## Row-level security

## Ctrl-C is slow
