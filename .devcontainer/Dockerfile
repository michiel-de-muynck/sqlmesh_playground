ARG VARIANT=3.12-bookworm
FROM mcr.microsoft.com/vscode/devcontainers/python:${VARIANT}

ENV PYTHONUNBUFFERED 1

# Install xdg-utils (needed for `duckdb -ui` to open the browser)
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends xdg-utils \
    && rm -rf /var/lib/apt/lists/*

# Install uv
COPY --from=ghcr.io/astral-sh/uv:0.9.18 /uv /uvx /bin/

# Uncomment this to install node and the duckdb-async npm module (not tested)
# [Choice] Node.js version: none, lts/*, 16, 14, 12, 10
# ARG NODE_VERSION="lts/*"
# RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi
# RUN npm install -g "duckdb-async@1.3.2"

USER vscode

# Workaround for weird issue
RUN UV_TOOL_BIN_DIR=/home/root/.local/sqlmesh_lsp_bin/ uv tool install "sqlmesh[web,github,postgres,lsp,duckdb]==0.228.1"

RUN uv pip install --no-warn-script-location "duckdb==1.4.3" "sqlmesh[web,github,postgres,lsp,duckdb]==0.228.1"

RUN curl https://install.duckdb.org | sh
