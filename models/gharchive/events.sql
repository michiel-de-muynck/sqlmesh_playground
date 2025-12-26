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
FROM @IF(
  @runtime_stage = 'evaluating',
  -- 1. Real Source: Only runs when actually processing data
  READ_JSON(
    'https://data.gharchive.org/' || STRFTIME(@start_dt AT TIME ZONE 'UTC', '%Y-%m-%d-%-H') || '.json.gz',
    sample_size = -1
  ),
  -- 2. Dummy Source: Runs during creation/validation (No Network)
  (
    SELECT
      NULL AS id,
      NULL AS type,
      {'login': NULL} AS actor,                -- Mock struct for actor.login
      {'ref': NULL, 'commits': NULL} AS payload -- Mock struct for payload.ref/commits
    WHERE 1=0
  )
)