MODEL (
  name gharchive.funny_commits,
  kind FULL
);

SELECT
  message,
  url
FROM gharchive.commits
WHERE
  LOWER(message) LIKE '%fuck%'