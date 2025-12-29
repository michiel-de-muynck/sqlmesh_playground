MODEL (
  name gharchive.funny_commits,
  kind FULL
);

SELECT
  message,
  url,
  push_timestamp
FROM gharchive.commits
WHERE has_funny_message
