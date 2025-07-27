# [Choice] Python version (use -bullseye variants on local arm64/Apple Silicon): 3, 3.10, 3.9, 3.8, 3.7, 3.6, 3-bullseye, 3.10-bullseye, 3.9-bullseye, 3.8-bullseye, 3.7-bullseye, 3.6-bullseye, 3-buster, 3.10-buster, 3.9-buster, 3.8-buster, 3.7-buster, 3.6-buster
ARG VARIANT=3.12-bookworm
FROM mcr.microsoft.com/vscode/devcontainers/python:${VARIANT}

ENV PYTHONUNBUFFERED 1

# Uncomment this to install node and the duckdb-async npm module
# [Choice] Node.js version: none, lts/*, 16, 14, 12, 10
# ARG NODE_VERSION="lts/*"
# RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi
# RUN npm install -g "duckdb-async@1.3.2"

USER vscode

RUN pip install "duckdb==1.3.2" "sqlmesh[web,github,postgres,lsp,duckdb]==0.204.0"

RUN curl https://install.duckdb.org | sh
