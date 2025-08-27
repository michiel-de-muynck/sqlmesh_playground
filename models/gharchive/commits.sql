MODEL (
  name gharchive.commits,
  kind INCREMENTAL_BY_TIME_RANGE (
    time_column hour
  )
);

SELECT
  hour,
  ref AS pushed_ref,
  UNNEST(commits).sha AS sha,
  UNNEST(commits).message AS message,
  UNNEST(commits).author.name AS author_name,
  UNNEST(commits).author.email AS author_email,
  UNNEST(commits).url AS url,
  actor_login AS push_actor_login
FROM gharchive.events
WHERE
  type = 'PushEvent'