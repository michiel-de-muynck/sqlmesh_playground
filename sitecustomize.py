import os

if os.getenv("NOCROP") == "1":
    import pandas as pd
    pd.set_option("display.max_colwidth", None)
    pd.set_option("display.max_columns", None)
    pd.set_option("display.max_rows", None)
    pd.set_option("display.width", 0)

# set VERTICAL_DF to 1 to make sqlmesh fetchdf print DFs in something similar to
# DuckDB's "line mode"
if os.getenv("VERTICAL_DF") == "1":
    import sqlmesh.cli.main as sm_main
    import click

    cmd = sm_main.cli.commands.get("fetchdf")
    if cmd is not None:

        @click.argument("sql")
        @click.pass_context
        def _fetchdf_vertical(ctx, sql, *args, **kwargs):
            df = ctx.obj.fetchdf(sql)
            for _, row in df.iterrows():
                for col in df.columns:
                    print(f"{col}\t= {row[col]}")
                print("---")

        cmd.callback = _fetchdf_vertical
