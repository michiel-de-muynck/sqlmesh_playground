MODEL (
  name gharchive.commits_stats_total,
  kind FULL
);

SELECT
  COUNT(*) AS num_commits,
  COUNT(DISTINCT author_email) AS num_authors,
  AVG(LENGTH(message)) AS avg_commit_msg_len
FROM gharchive.commits