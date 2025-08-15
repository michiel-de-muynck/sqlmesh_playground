MODEL (
  name gharchive.commits,
  kind FULL,
  grain id
);

SELECT
  *
FROM READ_JSON('https://data.gharchive.org/2024-11-27-14.json.gz', sample_size = -1)
