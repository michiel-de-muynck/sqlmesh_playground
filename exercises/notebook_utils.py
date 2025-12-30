import duckdb
import pandas as pd
from sqlalchemy import create_engine




def query_duckdb(query: str, attach_db: bool = True) -> pd.DataFrame:
    """
    Run a SQL query on DuckDB. If attach_db is True, attach our local.duckdb database.
    Normally you could use jupysql's %%sql magic to do this more easily, but that would
    keep the database attached, and then you can't run sqlmesh commands while it's
    attached. To make debugging/experimenting easier, we only attach it for the duration
    of the query.
    """
    # Set global Pandas display options
    pd.set_option('display.min_rows', 30)
    pd.set_option('display.max_rows', 30)
    pd.set_option('display.max_columns', 20)
    pd.set_option('display.max_colwidth', 500)

    with duckdb.connect() as con:
        if attach_db:
            con = con.execute(
                "ATTACH '/workspaces/sqlmesh_playground/local.duckdb' AS persistent;"
            )
        return con.sql(query).df()

def query_state_db(query: str) -> pd.DataFrame:
    """
    Run a SQL query on the sqlmesh state database.
    """
    engine = create_engine(
        "postgresql+psycopg2://postgres:postgres@db:5432/postgres"
    )

    return pd.read_sql(query, engine)
