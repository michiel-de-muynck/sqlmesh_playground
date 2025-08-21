MODEL (
  name gharchive.commits,
  kind FULL
);

-- select
--   ref as pushed_ref,
--   -- unnest(commits).sha,
--   -- unnest(commits).message,
--   -- unnest(commits).author.name as author_name,
--   -- unnest(commits).author.email as author_email,
--   -- unnest(commits).url,
--   actor_login as push_actor_login,
-- from gharchive.events
-- where type = 'PushEvent'

-- union ALL

select 'foo' as foo, 'baz' as push_actor_login