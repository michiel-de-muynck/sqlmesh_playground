AUDIT (
  name assert_nonnegative_num_commits
);

SELECT
  *
FROM @this_model
WHERE
  num_commits < 0