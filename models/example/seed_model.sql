MODEL (
  name sqlmesh_example.seed_model,
  kind SEED (
    path '../../seeds/seed_data.csv'
  ),
  columns (
    id INT,
    item_id INT,
    ds TEXT
  ),
  grain [id, ds]
)