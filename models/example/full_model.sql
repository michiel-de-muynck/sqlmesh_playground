MODEL (
  name sqlmesh_example.full_model,
  kind FULL,
  cron '@daily',
  grain item_id,
  audits ARRAY[assert_positive_order_ids]
);

SELECT
  item_id,
  COUNT(DISTINCT id) AS num_orders,
  'a' AS foo
FROM sqlmesh_example.incremental_model
GROUP BY
  item_id
ORDER BY
  item_id