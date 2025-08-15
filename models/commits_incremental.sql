MODEL (
  name gharchive.commits_incremental,
  kind INCREMENTAL_BY_TIME_RANGE (
    time_column (hour, '%Y-%m-%d-%-H'),
    batch_size 1
  ),
  cron '@hourly',
  start '2025-08-15 20:00',
  interval_unit 'hour'
);

SELECT
  STRFTIME(@end_date, '%Y-%m-%d-%-H') AS hour,
  @start_date AS start_date_raw,
  @end_date AS end_date_raw,
  @start_ds AS start_ds_raw,
  CURRENT_TIMESTAMP AS ingest_time,
  count(*) as cnt
FROM READ_JSON(
  'https://data.gharchive.org/' || GREATEST(STRFTIME(@start_date, '%Y-%m-%d-%-H'), '2025-08-15-20') || '.json.gz',
  sample_size = -1
)