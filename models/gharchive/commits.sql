MODEL (
  name gharchive.commits,
  kind INCREMENTAL_BY_TIME_RANGE (
    time_column hour
  ),
  audits (
    not_null(columns := (hour, push_timestamp, sha, message, author_name, author_email, url))
  )
);

SELECT
  hour,
  event_timestamp as push_timestamp,
  ref AS pushed_ref,
  UNNEST(commits).sha AS sha,
  UNNEST(commits).message AS message,
  UNNEST(commits).author.name AS author_name,
  UNNEST(commits).author.email AS author_email,
  UNNEST(commits).url AS url,
  actor_login AS push_actor_login,
  (
    lower(message) like '%stupid%'
    or lower(message) like '%hmmm%'
  ) as has_funny_message -- keeping it PG-13 friendly
FROM gharchive.events
WHERE
  type = 'PushEvent'
