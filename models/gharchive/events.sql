/*
Specifying columns explicitly is not nessary and generally to be avoided
in sqlmesh (it deduces column types automatically from SQL).
However, since the data source is READ_JSON("https://..."), sqlmesh cannot
deduce column types. Therefore we specify them explicitly.
This is not like dbt contracts, which checks the columns and data types.
Instead, sqlmesh creates/updates the underlying table with the specified
data types and (depending on the DWH) may error when inserting if you
specified wrong datatypes.
*/
MODEL (
  name gharchive.events,
  kind INCREMENTAL_BY_TIME_RANGE (
    time_column hour,
    batch_size 1
  ),
  columns (
    hour TIMESTAMPTZ,
    batch_end_dt TIMESTAMPTZ,
    batch_ingest_time TIMESTAMPTZ,
    id TEXT,
    type TEXT,
    actor_login TEXT,
    ref TEXT,
    commits STRUCT(sha TEXT, author STRUCT(email TEXT, "name" TEXT), message TEXT, "distinct" BOOLEAN, url TEXT)[]
  )
);

SELECT
  @start_dt AS hour,
  @end_dt AS batch_end_dt,
  CURRENT_TIMESTAMP AS batch_ingest_time,
  id,
  type,
  actor.login AS actor_login,
  payload.ref,
  payload.commits
/*
sqlmesh evaluates this sql several times,
* once to create the table. At this time, @runtime_stage is 'creating' and
  @start_dt is 1970-01-01 (not data at that time in gharchive.org!)
* once per "batch" to fill it. Then @runtime_stage is 'evaluating' and
  @start_dt/@end_dt get filled in appropriately
Therefore, we use @if to use a later date if @runtime_stage is 'evaluating'
*/
FROM READ_JSON(
  'https://data.gharchive.org/' || @IF(
    @runtime_stage = 'evaluating',
    STRFTIME(@start_dt AT TIME ZONE 'UTC', '%Y-%m-%d-%-H'),
    '2025-02-03-4'
  ) || '.json.gz',
  sample_size = -1
)