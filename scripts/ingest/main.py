from datetime import datetime, timedelta

import duckdb
import typer

app = typer.Typer()

@app.command()
def ingest_data(start: str, num_hours: int):
    """
    Run the ingestion, from the given start time (YYYY-MM-DD-HH, e.g. 2024-12-05-20)
    and ingest the given number of hours of github commits.
    """
    start_dt = datetime.strptime(start, "%Y-%m-%d-%H")

    for i in range(num_hours):
        hour_to_ingest = (start_dt + timedelta(hours=i)).strftime("%Y-%m-%d-%H")
        # ATTACH 'dbname=postgres user=postgres host=127.0.0.1' AS pg_db (TYPE postgres);
        print(duckdb.sql(
            f"""
            LOAD POSTGRES;

            CREATE TABLE ingest_data AS
            SELECT * FROM read_json(
                'https://data.gharchive.org/{hour_to_ingest}.json.gz',
                sample_size=-1
            );

            DESCRIBE SELECT * FROM ingest_data
            """
        ))


if __name__ == "__main__":
    app()
