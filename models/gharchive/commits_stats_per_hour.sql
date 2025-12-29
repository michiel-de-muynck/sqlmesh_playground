MODEL (
  name gharchive.commits_stats_per_hour,
  kind INCREMENTAL_BY_TIME_RANGE (
    time_column hour
  )
);

SELECT
  hour,
  COUNT(*) AS num_commits,
  COUNT_IF(has_funny_message) AS num_funny_commits,
  num_funny_commits/num_commits AS funny_commit_ratio,
  COUNT(DISTINCT author_email) AS num_authors,
  AVG(LENGTH(message)) AS avg_commit_msg_len
FROM gharchive.commits
GROUP BY
  hour