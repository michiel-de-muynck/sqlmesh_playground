MODEL (
  name gharchive.commits,
  kind INCREMENTAL_BY_TIME_RANGE (
    time_column hour
  ),
  audits (
    not_null(columns := (hour, push_timestamp, sha, message, author_name, author_email, url)),
    unique_values(columns := (sha))
  )
);

WITH
with_duplicates AS (
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
),
-- A commit can appear in multiple push events, so we deduplicate here.
-- Note: this means that each data interval depends on more than just the same data interval
-- in the source table, so it's important to take the _first_ occurrence of each commit.
-- If we would take the last one, then adding a new batch to the source data would make
-- the commit be part of a different interval in this model, and since this model is
-- processed incrementally each interval separately (including deduplication!), such a
-- commit would end up in our model multiple times.
--
-- Note that audits are also run on each interval individually so they wouldn't catch this.
-- (see docs/known_issues.md).
deduplicated AS (
  SELECT *
  FROM with_duplicates
  QUALIFY ROW_NUMBER() OVER (PARTITION BY sha ORDER BY push_timestamp ASC) = 1
)
SELECT *
FROM deduplicated
