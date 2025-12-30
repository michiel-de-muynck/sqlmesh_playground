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

USER vscode
WORKDIR /tmp/sqlmesh_notebook_env/

ADD pyproject.toml uv.lock ./

ENV UV_PROJECT_ENVIRONMENT=/opt/venv

# Install Python libraries (sqlmesh and some libraries used in the notebooks)
# to venv /opt/venv
RUN uv sync --frozen

# Install the DuckDB CLI
RUN curl https://install.duckdb.org | sh
