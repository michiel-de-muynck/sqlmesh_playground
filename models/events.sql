MODEL (
  name gharchive.events,
  kind INCREMENTAL_BY_TIME_RANGE (
    time_column batch_start_dt,
    batch_size 1
  ),
  cron '@hourly',
  start '2025-08-15 20:00',
  interval_unit 'hour'
);

SELECT
  @start_dt AS batch_start_dt,
  @end_dt AS batch_end_dt,
  CURRENT_TIMESTAMP AS batch_ingest_time,
  id,
  type,
  actor.login as actor_login,
  payload.ref,
  payload.commits,
FROM READ_JSON(
  -- sqlmesh evaluates this sql several times,
  -- * once to create the table. At this time, @runtime_stage is 'creating' and @start_dt is 1970-01-01
  -- * once per "batch" to fill it. Then @runtime_stage is 'evaluating' and @start_dt/@end_dt get filled in appropriately
  'https://data.gharchive.org/' || @if(@runtime_stage = 'evaluating', STRFTIME(@start_dt at time zone 'UTC', '%Y-%m-%d-%-H'), '2025-02-03-4') || '.json.gz',
  sample_size = -1
)