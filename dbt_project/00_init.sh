python -m venv .venv
source .venv/bin/activate
pip install "dbt-core==1.4.9" "dbt-postgres==1.4.9" "sqlmesh[web,dbt,postgres]==0.58.2"

dbt seed

# This command has already been run and created config.py
# sqlmesh init -t dbt
