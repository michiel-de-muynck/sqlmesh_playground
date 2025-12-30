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

ADD pyproject.toml uv.lock /tmp/sqlmesh-notebook-environment/

# Install Python libraries (sqlmesh and some libraries used in the notebooks) system-wide
RUN uv pip install --system /tmp/sqlmesh-notebook-environment/

# Do the rest of the config/installation as user vscode
USER vscode

# Install the DuckDB CLI
RUN curl https://install.duckdb.org | sh

# There is a weird issue that the sqlmesh extension crashes if using `sqlmesh` in the terminal.
# I actually don't know what is causing this.
# Using `uvx sqlmesh` does not have the same issue, so I use that as a workaround to get the extension working.
RUN echo 'alias sqlmesh="uvx sqlmesh[web,github,postgres,lsp,duckdb]==0.228.1"' >> /home/vscode/.bashrc
