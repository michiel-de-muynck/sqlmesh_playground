MODEL (
  name gharchive.commits_incremental,
  kind INCREMENTAL_BY_TIME_RANGE (
    time_column (hour, '%Y-%m-%d-%-H'),
    batch_size 1
  ),
  grain hour,
  cron '@hourly',
  start '2025-08-14 20:00',
  interval_unit 'hour'
);

SELECT
  STRFTIME(@start_date, '%Y-%m-%d-%-H') AS hour,
  @start_date AS start_date_raw,
  @start_ds AS start_ds_raw,
  CURRENT_TIMESTAMP AS ingest_time,
  *
FROM READ_JSON(
  'https://data.gharchive.org/' || GREATEST(STRFTIME(@start_date, '%Y-%m-%d-%-H'), '2015-01-01-1') || '.json.gz',
  sample_size = -1
)