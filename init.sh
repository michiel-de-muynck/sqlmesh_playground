python -m venv .venv
source .venv/bin/activate
pip install "dbt-core==1.4.9" "dbt-postgres==1.4.9" "sqlmesh[web,dbt,github,postgres]==0.56.4"
sqlmesh init -t dbt