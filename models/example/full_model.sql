/*
I had to change @daily to @hourly because otherwise this
file errors if you run it for the first time with an
--end timestamp that is not a full day.

I reported this issue on Github:
https://github.com/TobikoData/sqlmesh/issues/5236
*/
MODEL (
  name sqlmesh_example.full_model,
  kind FULL,
  cron '@hourly',
  grain item_id,
  audits [assert_positive_order_ids]
);

SELECT
  item_id,
  COUNT(DISTINCT id) AS num_orders,
FROM sqlmesh_example.incremental_model
GROUP BY
  item_id
ORDER BY
  item_id