ARG VARIANT=3.12-bookworm
FROM mcr.microsoft.com/vscode/devcontainers/python:${VARIANT}

ENV PYTHONUNBUFFERED 1

# Install tools:
# - xdg-utils (needed for `duckdb -ui` to open the browser)
# - psql (send SQL queries to postgres directly, e.g. for the `make clean` command or debugging)
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends xdg-utils postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Install uv
COPY --from=ghcr.io/astral-sh/uv:0.9.18 /uv /uvx /bin/

WORKDIR /tmp/build_sqlmesh_notebook_env/

ADD pyproject.toml uv.lock ./

ENV UV_PROJECT_ENVIRONMENT=/opt/sqlmesh_venv

# Install Python libraries (sqlmesh and some libraries used in the notebooks)
# to venv /opt/sqlmesh_venv
RUN uv venv /opt/sqlmesh_venv --seed && uv sync --frozen

# chown the venv to vscode to avoid permission issues
RUN chown -R vscode:vscode /opt/sqlmesh_venv 

USER vscode

# Register the venv as a Jupyter kernel
RUN /opt/sqlmesh_venv/bin/python -m ipykernel install --user --name=sqlmesh_venv --display-name "sqlmesh_venv"

# Install the DuckDB CLI
RUN curl https://install.duckdb.org | sh
